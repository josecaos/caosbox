# Paso 5a — la GUI como vista (v2.3.0)

> Estado: **prototipo de una fila** listo para revisar. Todavía no se toca la GUI real.
> Todo lo de interfaz entra en **v2.3.x**; el cierre de 5a es `v2.3.3`. `CHANGELOG.md` sigue siendo tuyo.

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

* `Classes/CaosStepGrid.sc` — rejilla de una pista: celdas redondeadas, gap de grupo,
  pintar/borrar arrastrando, playhead, `refresh`. La geometría (ancho de celda,
  posición, hit-testing) está en métodos de clase para probarla headless.
* `Classes/CaosBoxGUI.sc` — registro de la vista; `CaosBox.gui.color(\red)` repinta
  lo registrado y `CaosBox.gui` es perezoso y compartido.
* `CaosBox.sc` — `CaosBox.gui`; `CaosBox.stop` apaga el playhead de la vista.
* `GUI/CaosBox-GUI_2.scd` — la fila de bass es la primera rejilla real. Se fueron los
  32 CheckBox y los knobs att/rel; la X de borrar pasó a `x = 962`.
* `CB/CaosBox-seq.scd` — cada step avisa `CaosBox.gui.playhead(index)` (convive con
  el LED de las filas viejas hasta migrarlas).

Captura del piloto dentro de la GUI real: `DevTest/img/pilot-real-rows.png`.

## 6. 5a-2: paleta, analizadores y granos estéreo (v2.3.1)

* **Paleta con roles** en `CaosBoxGUI`: `background`, `panel`, `text`, `muted`,
  `accent`, `accentText` (contraste por luminancia), `cellOff`, `border`,
  `playheadColor`. `color` repinta las rejillas y los `addColorListener`, así
  cualquier widget nuevo sigue el acento.
* **Analizadores flotantes**: `CaosBox.freqAnalyzer(true)` abre una ventana
  redimensionable con `FreqScopeView` + `ScopeView` (osciloscopio sobre el bus 0 vía
  `BusScopeSynth`); `false` los detiene y cierra. Se retiró el bloque embebido de
  `GUI_4` (y `~cbox_fbot`/`~cbox_f`). `FreqScopeView` delega `resize_` en su
  `ScopeView` interno, así que se crea sin encadenar para no perder la referencia.
* **Botón `Scopes`** en la fila de transporte (el play se achicó a 415 px), fuera de
  las filas de steps; usa la paleta y se repinta con el color global.
* **Granos estéreo**: el bus `\grains` pasa a 2 canales (64-65) y el granulador suma
  los dos canales antes de granular (`Mix(In.ar(inbus, 2))`). Así puede ser destino
  de ruteo sin perder un canal. Los índices históricos de los demás buses no cambian.
* `CaosBox.version = "2.3.1"`.

Decisiones para 5a-3 (ruteo por fila):

* Un selector por fila manda la pista a `master`, `reverb`, `delay`, `pitch`, `lpf`,
  `hpf`, `bpf` o `grains`.
* Es ruteo **por pista**, no por step: al elegir `\hpf` todos los steps de esa fila
  pasan por el HPF compartido. No es un envío: el filtro decide su salida con sus
  propios popups. Antes del primer play el nodo de FX todavía no existe.
* Melódicos: el bus se aplica en el próximo trigger. Percusión: hay que pasarle el
  bus a `func.play(target, bus)`; las funciones de `CaosGear` y de `defaults` lo
  aceptan, las que capturan `out` dentro del closure no cambian de ruta (documentar).
* Si más adelante se quiere ruteo **por step** (step 1 a master, step 4 a reverb), va
  como feature aparte: datos por step + menú contextual, no un popup por fila.

## 7. 5a-3: ruteo y las 13 filas (v2.3.2)

**Modelo y API**

* `CaosTrack` gana `out` (nombre de bus del engine) y `CaosInstrument.out_` para
  aplicar la salida en el próximo trigger. `CaosEngine.nameFor(index)` devuelve el
  nombre de un bus del layout.
* `CaosBox.route(track, bus)` acepta nombre (`\reverb`) o índice (`52`), resuelve y
  actualiza el instrumento; sin argumento devuelve la ruta actual. Sólo aplica a
  pistas melódicas: en percusión avisa que el ruteo es por step (snapshot).
* `CaosGear.prRegister` toma la salida del instrumento recién creado y la refleja en
  `track.out` + la vista: vale la última acción (API o `x.bass(out: ...)`).
* La API actualiza la GUI: `CaosBoxGUI.addRoute`/`routeChanged` mantienen los popups
  sincronizados en ambos sentidos.

**Builder de las 13 filas**

* `GUI/CaosBox-GUI_2.scd` es ahora el único builder: spec ordenado (kick, snare,
  hats, kick2, snare2, hats2, bass, bass2, pad, pad2, chords, chords2, lineIn),
  etiqueta minimalista, rejilla de 830 px, X de limpiar y, en melódicos, popup de
  ruteo (Master/Reverb/Delay/Pitch/LPF/HPF/BPF/Grains).
* En percusión el popup se reemplaza por un `per-step` apagado con tooltip: la salida
  se elige al evaluar el instrumento (`k.kick(out: ...)`) y el snapshot la conserva
  por step. No se pisa ese flujo.
* Se eliminaron los 416 CheckBox, los 14 knobs muertos, la fila de LEDs y las
  globales `~cbox_check*`/`~cbox_light*`; `CB/CaosBox-seq.scd` solo avisa el playhead.
* Los scopes toman el acento: `ScopeView.waveColors_([accent])` en FFT y osciloscopio,
  y se repintan con `CaosBox.gui.color(...)`.

**Percusión: qué poner en la columna**

Por ahora el `per-step` informa y deja el flujo intacto. El flam quedó anotado en
TODOs (después de terminar la GUI): **flam por step** (shift/click derecho en el step,
se dibuja una marca y se dispara dos veces con un retardo corto) antes que un flam por
pista, porque respeta el ruteo por step y da más expresividad. Alternativas para esa
columna mientras tanto: mute/solo por pista o probabilidad.

## 8. 5a-4: cierre de 5a (v2.3.3)

* **Ancho completo**: rejilla `60..890` (830 px, celdas ~21.6), popup de ruteo
  `895..990`, X `1000..1016`; se alinea con los paneles de abajo.
* **Un poco de aire**: pitch 22, rejilla 21 px (celdas 15), top 3; la última fila queda
  `267..288` y los paneles de FX empiezan en 290. El aire real (filas de 24-26 px)
  necesita el reflow de paneles de 5b.
* **Métrica sincronizada desde la API**: `CaosBox.stepDur(...)` mueve el botón
  (`0` = Fourths corriendo, `1` = Thirds corriendo) además del secuenciador.
* **Datos al modelo**: `CaosBox.tracks` y `CaosBox.voices` son alias del mismo objeto
  que `~cbox_tracks`/`~cbox_instruments`; `CaosBox.route` y el builder ya los usan.
* **BPM a la fila de transporte**: el numbox que estaba en `GUI_4` (sobre LineIn) se
  movió a la barra de abajo; el botón de play bajó a 325 px y el BPM ocupa `605..690`.
  Así las filas no quedan tapadas y el BPM sigue a mano.
* `CaosBox.version = "2.3.3"`. Resize y ventana más grande quedan para 5b.

## 9. 5b-1: ventana más grande y padding (sin bump aún)

* Ventana **1120×820** (antes 1024×680); el contenido de 1024 se centra con márgenes
  de 48 px. Cabe en la pantalla de 1920×1200 del setup.
* Filas: pitch 29, rejilla 27 (celdas 21), top 16; etiqueta x=53, rejilla x=108
  (838 px), ruteo x=951, X x=1056. Última fila `364..391`.
* Paneles de master/FX/filtros/granulador desplazados +48/+120; transporte +48/+130,
  con BPM ya en la barra inferior. No hay solapamientos: filas→paneles 19 px,
  paneles→transporte 13 px, márgenes laterales 48 px.
* Render completo verificado con un `CaosEngine` de prueba inyectado en GUI_3/GUI_4
  (sin servidor): márgenes, gaps y etiquetas sin solapes.
* Pendiente **5b-2**: repartir el ancho extra entre las columnas de paneles (más
  padding interno), activar `resizable` y reflow en `onResize`. Versión a decidir
  con el cierre de 5b.

## 10. 5b-2: paneles repartidos y padding interno (sin bump aún)

* Ventana **1120×860** (antes 820). Cuatro columnas con márgenes 16 y gutters 12:
  master `16..296`, FX `308..638`, filtros `650..870`, granulador/automatización
  `882..1104`.
* Los paneles pasan de 342 a **382 px** de alto (`410..792`), con las posiciones
  verticales escaladas: faders más largos y más aire entre controles.
* Filas alineadas a los márgenes nuevos: etiqueta `16..76`, rejilla `80..988`
  (908 px, celdas ~24), ruteo `994..1080`, X `1088..1104`; última fila `364..391`.
* Transporte reflowado: Beat `16..291`, play `301..640`, BPM `650..735`,
  Scopes `745..835`, record `845..990`, history `1000..1104`; labels y=805,
  botones 820..845.
* Verificación con render completo (motor falso): márgenes de 16, gutters de 12 sin
  solapes (solo el pixel de antialias en el borde), filas→paneles 19 px,
  paneles→transporte 13 px. Captura `DevTest/img/gui-5b.png`.
* Pendiente **5b-3**: `resizable` + `onResize` real y tema de sliders/faders/popups.

## 11. Tema global, botones unificados y transporte

* `CaosBoxGUI.themeLegacy(~cbox_w.asView)` recorre la vista una vez y guarda **142
  entradas**: 19 NumberBox, 24 botones, 64 etiquetas, 15 popups y 20 sliders/Slider2D.
* **Botones unificados** (play incluido): en estado inactivo `state 0` usan fondo
  `panel` y texto `accent`; en estado activo (`state > 0`) fondo `accent` y texto
  **negro**. Se conservan labels y el valor del botón.
* **NumberBox**: fondo `panel`, texto `accent`, edición `accentText`.
* **Etiquetas y popups**: todas las `StaticText` y los `PopUpMenu` usan fondo `panel`
  y texto `muted`; ya no queda texto blanco en la ventana y la diferencia entre
  títulos y etiquetas es de bajo contraste.
* **Sliders y granulador**: `knobColor_(accent)` en todos los `Slider` y en el
  `Slider2D` del granulador; el fondo/groove queda como estaba. El handle completo
  se colorea con `QPalette.button_(accent)` (el `knobColor` de SC sólo pinta la marca).
* **Transporte alineado a columnas**: BPM `650..750` (100 px) y Scopes `760..870`
  (110 px) cubren la columna de filtros `650..870`; Record `882..990` (108) y
  History `1000..1104` (104) cubren la del granulador `882..1104`. El BPM tiene
  altura 25, igual que el botón de Scopes, y números accent.
* Prueba headless: en estado inactivo no queda verde puro; con los botones en estado
  activo el fondo es accent y el texto negro; `\red` repinta todo y el BPM sigue
  visible. Capturas `gui-5b.png`, `gui-5b-active.png` y `gui-5b-red.png`.

## 12. 5b-3: resize fluido y scopes (v2.3.5)

* Ventana **resizable** (`Window.new(..., true)`). `CaosBoxGUI.makeResizable` guarda
  los rects de las 1120×860 de diseño y `prFluidResize` escala posición y tamaño de
  todos los hijos con la ventana. Los fonts no escalan; el layout mantiene
  proporciones.
* Probado a 1400×1000 (grid `100,221,1135,31`) y 1000×760 (grid `71,168,811,24`),
  sin solapes.
* **Scopes**: se abandonó `resize_(5)` y ahora la ventana tiene
  `prLayoutAnalyzers` explícito (labels + FFT + osciloscopio) en `onResize`.
  Verificado: de 600×430 a 900×600, FFT `8,26,884,266` y scope `8,318,884,266`.
  Los dos canales del osciloscopio usan `waveColors_([accent, accent])`.
* **Sliders**: `knobColor` de SC sólo pinta la marca; para colorear el handle
  completo se usa también `QPalette.button_(accent)`. Los 20 sliders y el `Slider2D`
  del granulador llevan el acento.
* `CaosBox.version = "2.3.5"`.

## 13. Siguiente

1. **Flam por step** (TODO): marca en la rejilla + segundo disparo.
2. **5c**: rejilla con interacción avanzada (mute/solo, acentos, scroll, teclado).
3. Retirar los alias `~cbox_tracks`/`~cbox_instruments` en 3.0.0.

## 14. Verificación actual

* Clases compilan; 14 `.scd` parsean; suite **286 aserciones, 0 fallos**.
* Render headless de la GUI real (sin servidor): 13 rejillas registradas, 7 popups de
  ruteo con items correctos, valores 0/1/4 al cambiar de ruta, etiquetas y X en su
  lugar, playhead correcto; captura `DevTest/img/tracks-13.png`.
* Métrica: `CaosBox.stepDur(1/3)` deja el botón en 1 y `0.25` en 0; alias
  `CaosBox.tracks === ~cbox_tracks` y `CaosBox.voices === ~cbox_instruments`.
* Transporte renderizado offscreen: play 301..640, BPM `650..750`, Scopes
  `760..870`, Record `882..990`, History `1000..1104`; captura
  `DevTest/img/transport-bpm.png`.
* Layout 5b completo renderizado offscreen con motor falso; capturas
  `DevTest/img/gui-5b.png` (verde) y `DevTest/img/gui-5b-red.png` (`\red`), 1120×860
  a 2x. Gaps de 12 px entre columnas y 16 px de margen, con solo el borde de
  antialias tocando el gap.
* Tema: **142 entradas** (19 NumberBox, 24 botones, 64 etiquetas, 15 popups,
  20 sliders). Sin texto blanco en etiquetas ni verde puro en estado inactivo; con
  botones activos el fondo es accent y el texto negro; `\red` repinta todo. BPM
  100×25 con número accent y scope con los dos canales en accent.
* Analizadores: la ventana se construye/cierra headless (600x430) y los `waveColors`
  de FFT y osciloscopio toman el acento (probado con `\orange`).
* Resize 5b: main window 1120×860→1400×1000→1000×760 con grid/faders/transporte
  escalados; analyzer 600×430→900×600 con FFT y scope reposicionados sin cortarse.
  Captura `DevTest/img/gui-5b-resized.png`.
* SynthDef del granulador estéreo se construye headless sin errores.
