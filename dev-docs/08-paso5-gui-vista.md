# Paso 5a — la GUI como vista (v2.3.0)

> Estado: **prototipo de una fila** listo para revisar. Todavía no se toca la GUI real.
> Todo lo de interfaz entra en **v2.3.0**; `CaosBox.version` sigue en `2.2.0` hasta cerrar
> la fase. `CHANGELOG.md` sigue siendo tuyo.

## 1. Alcance

La GUI actual funciona, pero es la parte menos "v2" del proyecto:

* 4 archivos `GUI/*.scd` = **798 líneas** y **452 referencias a `~cbox_*`**.
* **13 filas** (6 percusión + 7 melódicas) × 32 steps = **416 CheckBox**, 14 knobs,
  8 faders de FX, popups de ruteo; todo con `Rect` absolutos en una ventana 1024×680.
* Cada fila repite ~25 líneas; los 13 nombres de pista existen en tres lugares
  (`~cbox_tracks`, `vars.scd` y las filas del GUI) y MIDI agrega una cuarta copia.
* Los tracks ya son modelo (`CaosTrack`, `CaosInstrument`, `CaosSequencer`,
  `CaosEngine`); falta que la vista los consuma en vez de duplicarlos.

Se parte el trabajo en pasos chicos:

* **5a (este paso):** spec de pistas + builder de filas + rejilla nueva + transporte
  sincronizado + resize del bloque de pistas y del transporte. Knobs afuera.
* **5b:** reflow de paneles de FX/filtros/granulador, MIDI declarativo (`mapCC`),
  specs de parámetros en el modelo.
* **5c:** interacción avanzada de la rejilla (mute/solo, acentos, scroll, teclado).

## 2. Decisiones de arquitectura

1. **Spec ordenado de pistas.** Una lista (label, tipo, color, modo, knobs sí/no, bus)
   como única fuente para filas, MIDI y automatización. `~cbox_tracks` es un
   `Dictionary` y no garantiza orden, así que el orden de las filas va en el spec.
2. **Registro de vista.** `CaosBox.gui` (diccionario pista → widgets) y alias
   `~cbox_check*` para no romper nada. `CaosBox.sc`, `auto`, `midi` y `seq` hablan con
   el registro, no con widgets sueltos.
3. **Datos al modelo.** `~cbox_tracks` → `CaosBox.tracks`;
   `~cbox_instruments` → `CaosBox.voices`; `~cbox_b/t/h...` y `~cbox_randtimes` con
   alias de compatibilidad. Comportamiento idéntico al original.
4. **Modelo → vista.** `onChange` de `CaosTrack` y `onTempoChange` de `CaosSequencer`
   ya existen; se suman avisos de transporte/stepDur/random/playhead. La API pública
   conserva su semántica.
5. **Rejilla con `UserView`** (1 widget por pista). Reemplaza los 32 CheckBox:
   arrastrar para pintar/borrar, colores por familia, huecos cada 4 pasos, números de
   grupo, playhead dibujado **en la fila**. Consecuencia: la fila de LEDs de arriba y
   `~cbox_lightsteps` ya no hacen falta.
6. **MultiSliderView: descartado como base, presente en el prototipo.** Da arrastre
   gratis, pero sus celdas son de tamaño fijo (`thumbSize`, 12 px) salvo
   `elasticMode_` + `thumbSize_`, no permite color por paso ni huecos de grupo, y su
   estilo es el del widget. Es una opción válida para "salir rápido", no para la vista
   que querés.
7. **Resize = geometría calculada + `onResize`.** Se mantiene el look; el bloque de
   pistas y el transporte se recalculan desde variables (márgenes, alto de fila,
   spacing). Los paneles de FX se reflowan en 5b.
8. **Knobs att/rel afuera en 5a.** Los 14 knobs llaman a `~cbox_param`, que no existe
   en ningún archivo (están muertos) y, como los melódicos son `oneShot`, sólo
   afectarían la próxima nota. Vuelven en la fase de timbre con `paramSpecs` en
   `CaosInstrument`/`CaosGear` y `CaosBox.param(track, key, val)`.

## 3. Deprecación de `~cbox_*`

No todas las globales son iguales; el plan es por familia:

| Familia | Qué se hace |
|---|---|
| Widgets (`~cbox_bot`, `~cbox_numclock`, faders, `~cbox_check*`, LEDs) | Se retiran con la reescritura; `CaosBox.gui` ocupa su lugar |
| Datos (`~cbox_tracks`, `~cbox_instruments`, `~cbox_b/t/h...`, `~cbox_randtimes`) | Se promueven a `CaosBox.*` con alias (mismo objeto, cero cambios de comportamiento) |
| Nodos de audio (`~cbox_mast*`, `~cbox_grains`) | Pasan a `CaosBox.engine`/`CaosBox.nodes` |
| Config (`~cbox_autoreverb*`, `~cbox_div*`, `~cbox_url`, `~cbox_fecha`) | Quedan por ahora; migran después |

Los alias se mantienen durante la 2.3.x y se retiran en **3.0.0**. No se emiten
warnings en runtime (se leen en cada paso y harían ruido).

## 4. Prototipo (aprobado: UserView)

`DevTest/gui-stepgrid-prototype.scd` — una sola fila (`CaosTrack(\bass)`) con tres
vistas del mismo modelo:

1. los 32 CheckBox actuales (referencia, no resizable);
2. rejilla `UserView` (propuesta): arrastre, playhead, grupos, números;
3. `MultiSliderView` (comparación): arrastre gratis, playhead por `index_`.

Capturas headless (generadas con `Image.fromWindow` en modo offscreen):

* `DevTest/img/stepgrid-wide.png` (1024 px)
* `DevTest/img/stepgrid-narrow.png` (820 px, mismo layout recalculado)

Verificación de las capturas: 10/10 pasos activos en la rejilla y en el
MultiSlider, playhead en el paso 13, y las celdas de la rejilla se reposicionan al
angostar la ventana.

## 5. Primera fila integrada (5a-1)

Aprobada la muestra, la primera fila real ya usa la rejilla nueva:

* `Classes/CaosBoxGUI.sc` — registro de la vista y paleta. `CaosBox.gui.color(\red)`
  acepta símbolo, `Color` o array `[r, g, b(, a)]`, y repinta todas las rejillas
  registradas. `CaosBox.gui` es perezoso y compartido (`CaosBox.gui === CaosBox.gui`).
* `Classes/CaosStepGrid.sc` — rejilla de una pista: celdas redondeadas, gap de grupo,
  pintar/borrar arrastrando, playhead, `refresh`. La geometría (ancho de celda,
  posición, hit-testing) está en métodos de clase para probarla headless.
* `CaosBox.sc` — `CaosBox.gui`; `CaosBox.stop` apaga el playhead de la vista.
* `GUI/CaosBox-GUI_2.scd` — la fila de bass es la primera rejilla real. Se fueron los
  32 CheckBox y los knobs att/rel; la X de borrar pasó a `x = 962`.
* `CB/CaosBox-seq.scd` — cada step avisa `CaosBox.gui.playhead(index)` (convive con
  el LED de las filas viejas hasta migrarlas).

Prueba en la app: arrastrar sobre la fila Bass pinta/borra; la X limpia la pista;
`CaosBox.gui.color(\red)` (o `\orange`, `Color.blue`, `[0.9,0.4,0.2]`) cambia el
acento de la GUI en caliente; el playhead recorre la fila al reproducir. Captura del
piloto dentro de la GUI real: `DevTest/img/pilot-real-rows.png`.

Lo que sigue en 5a:

1. Spec ordenado de las 13 pistas + builder de filas (label + rejilla + X).
2. Migrar las 12 filas restantes; sacar `~cbox_check*` y la fila de LEDs.
3. Transporte sincronizado desde el modelo (play/pause, métrica, random, BPM).
4. Resize del bloque de pistas + transporte (los paneles de FX van en 5b).
5. Promover datos a `CaosBox.tracks`/`CaosBox.voices` + alias; retirar `~cbox_param`.

## 6. Plan del resto de 5a

1. `Classes/CaosStepGrid.sc`: el widget de rejilla (dibujo, hit-testing, mouse,
   refresh, playhead). Geometría pura en métodos testeables.
2. Builder de filas desde el spec (label + rejilla + borrar), registrado en
   `CaosBox.gui`, con alias.
3. Transporte: play/pause/stop, métrica, random y BPM escuchando al modelo
   (`CaosSequencer`, `CaosTrack`).
4. Resize: `onResize` del bloque de pistas + transporte; mínimo de ventana.
5. Migración de datos: `CaosBox.tracks` / `CaosBox.voices` + alias.
6. `CB/CaosBox-seq.scd`: el step deja de tocar LEDs y avisa a la vista.
7. Tests headless de la geometría del grid y del spec; prueba visual en la app.

## 7. Verificación actual

* Clases compilan; 14 `.scd` parsean; suite **275 aserciones, 0 fallos**
  (`TestCaosBoxGUI` + `TestCaosStepGrid` suman 23).
* Prototipo y fila real evaluados headless con `QT_QPA_PLATFORM=offscreen`: celdas
  activas 10/10, playhead, pintado con mouse y cambio de color verificados por
  píxeles.
