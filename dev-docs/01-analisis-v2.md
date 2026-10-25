# CaosBox v2.0 — Análisis y plan de refactor

> Documento de trabajo · rama `dev-v2.0`
> Snapshot del código al commit `8f66dc7` ("Bugfix: Method name is mispelled .enviroment")
> Los números de línea corresponden a ese estado; se irán actualizando al avanzar.
>
> Objetivo: dejar constancia del estado actual, los hallazgos, y el plan por pasos.
> Este archivo se va llenando conforme avanza la actualización.

---

## 0. Resumen ejecutivo

CaosBox es un secuenciador/procesador de livecoding para SuperCollider. Su identidad es el
**DSL de comandos**: `CaosGear.new.bass(...)`, `CaosBox.setSteps(...)`, `k.toTrack(...)`,
más una GUI con 13 pistas de 32 pasos y una sección de FX/automatización.

La implementación actual funciona por **estado global (`~cbox_*`) y efectos top-level en
archivos `.scd`** que se cargan en un orden específico. La GUI no es una vista: **es el
modelo**. Eso es el nudo de casi todo lo demás.

Veredicto: el sonido y la idea están bien; la estructura no. La refactorización se hará por
pasos pequeños, **conservando la API pública**, con la app funcionando en cada paso.

Datos medidos:

| Métrica | Valor |
|---|---|
| Globals `~cbox_*` distintas | 225 |
| Usos de `~cbox_w` (solo GUI) | 168 |
| Archivos de clase compilados | 329 (compila sin errores) |
| Pistas secuenciadas | 13 |
| SynthDefs | 17 |
| Tdefs | 16 |

---

## 1. Cómo está armado hoy

### 1.1 Arranque

```
CaosBox.environment(gui)                  // clase fachada, classvars server y url
  └─ verifica dependencia (CaosPercLib)
  └─ ~cbox_url = carpeta del proyecto
  └─ init: server.options.memSize / maxNodes
       └─ server.waitForBoot { carga CB/CaosBox-load.scd }
            └─ carga en orden (lista literal en CaosBox.sc:15-27):
               midi → vars → signal → synths → defaults → auto → GUI 1 → GUI 2 → GUI 3 → GUI 4 → seq
```

* El orden es mágico y frágil: `vars` declara, `signal/synths` definen SynthDefs (leyendo
  globals ya definidos), `defaults` instancia instrumentos y arranca las líneas melódicas,
  `GUI` reemplaza globals por widgets, y `seq` define el reloj.
* `environment(false)` **no es headless**: solo evita el `front` de la ventana. Los archivos
  de GUI se cargan igual y los widgets existen (invisibles). Sin ellos, la secuencia
  melódica no funciona.

### 1.2 Estado global

Todo el estado vive en 225 globals del Environment de sclang, en cuatro familias:

1. **Instrumentos percusivos**: `~cbox_b`, `~cbox_t`, `~cbox_h`, `~cbox_b2`, `~cbox_t2`, `~cbox_h2`
   (funciones que hacen `Out.ar`).
2. **Instrumentos melódicos vivos**: `~cbox_bass`, `~cbox_bass2`, `~cbox_amb`, `~cbox_amb2`,
   `~cbox_chord`, `~cbox_chord2`, `~cbox_entrada` (instancias de `Synth` creadas bajo demanda).
3. **Nodos de master/FX**: `~cbox_mast`, `~cbox_mastrev`, `~cbox_mastdel`, `~cbox_mastpit`,
   `~cbox_mastlowf`, `~cbox_masthighf`, `~cbox_mastbandf`, `~cbox_grains`.
4. **Modelo de steps**: hoy son **arrays paralelos**:
   * `~cbox_bombo` … `~cbox_in_seq`: 32 slots con la función/synth del step (o `nil`).
   * `~cbox_checkbombo` … `~cbox_checkin`: 32 `CheckBox` de la GUI (la fuente de verdad real).
   * `~cbox_steps`: `Dictionary(track -> [checkboxes, stepArray, instrumento])`; el tercer
     slot se captura como `nil` al construirse y nunca se actualiza → **código muerto**.

### 1.3 Secuenciador

`Tdef(\secuencias)` (CB/CaosBox-seq.scd) hace cinco cosas en un solo `loop`:

1. Bootea `\master`, `\aux1..3`, `\lowfilt`, `\highfilt`, `\bandfilt`, `\granulador` (una vez).
2. Mueve el LED de steps (con un `switch(~cbox_indice, ~cbox_indice, …)` que es un no-op).
3. Reproduce percusión: `~cbox_bombo[i].play` (y 5 más).
4. Para melódicos: si el checkbox está encendido, guarda el synth en `~cbox_*_seq`, ajusta
   gate/att/rel con knobs de la GUI, y llama `~cbox_sintetizadores.value(...)` (crea synth).
5. `~cbox_tiempos.wait` y `~cbox_indice += 1` (global 0..31, sin reset al reanudar).

Los pasos 2-4 corren dentro de `.defer(0.01)` individuales (siete por ciclo).

### 1.4 Instrumentos percusivos

Son funciones guardadas en globals (`~cbox_b = { |out=50, att, rel| Out.ar(out, CaosKick.ar(...)) }`).
Al marcar un checkbox, la acción **copia la función actual al slot** (`~cbox_bombo.put(i, ~cbox_b)`).
Cambiar `~cbox_b` después no afecta los steps ya marcados. Es el modo **snapshot** (sin nombre).

### 1.5 Instrumentos melódicos

`CaosGear.bass / bass2 / pad / pad2 / chords / chords2 / lineIn` **no secuencian steps**:
definen un `Tdef` con nombre fijo (`\bass`, `\pad`, `\acordes`, …) que cada `~cbox_tiempos`
genera una nota con `Prand`/`Pseq` y hace `Synth.set(\note, ...)`.
El step solo abre/cierra gate (y dispara la creación del synth).

Consecuencias:

* Hay **dos secuenciadores**: el de steps (gates) y el Tdef interno del instrumento (notas).
  No están en fase; comparten solo la duración `~cbox_tiempos`.
* Los Tdefs tienen nombre fijo: dos bajos no pueden coexistir; el segundo reemplaza al primero.
* `CaosGear.loQueSea(...)` devuelve un `String` y escribe globals: no hay instancia ni voz.

### 1.6 Ruteo (números mágicos)

| Bus | Uso |
|---|---|
| `[50,51]` | entrada de `\master` (todos los instrumentos y FX salen aquí) |
| `[52,53]` | entrada de `\aux1` (reverb) |
| `[54,55]` | entrada de `\aux2` (delay) |
| `[56,57]` | entrada de `\aux3` (pitch) |
| `[58,59]` | entrada de `\lowfilt` |
| `[60,61]` | entrada de `\highfilt` |
| `[62,63]` | entrada de `\bandfilt` |
| `64` | entrada del granulador |

Los números están repetidos en los SynthDefs, en los defaults de `CaosGear` (`out=50`), en
`~cbox_sintetizadores` (`node=1100/1101`) y en los popups de la GUI. No hay una sola fuente.

### 1.7 GUI

Cuatro archivos `.scd` con código top-level: crean `~cbox_w` y una retícula de widgets con
coordenadas absolutas. Los widgets se guardan en globals y el resto del sistema los lee.

### 1.8 Clases

* `CaosBox`: fachada de clase (classvars `server`, `url` + métodos `*`). Su `init` es de
  instancia y solo lo usa `environment`.
* `CaosGear : CaosBox`: herencia falsa. `CaosGear` no usa nada de `CaosBox` salvo los
  classvars; `*new` hace `^super.new` (sin `init`); los métodos de instrumento escriben
  globals y devuelven un `String` `instance_id`.
* `toTrack` / `offTrack`: dos `switch` idénticos de 13 ramas `String -> Symbol`.

---

## 2. Invariantes a conservar

1. **API pública**: `CaosBox.setSteps`, `.clearSteps`, `.randSteps`, `.stepsArray`, `.bpm`,
   `.play`, `.stop`, `.fx`, `.autoFx`, `.record`, `.history`, y los métodos de `CaosGear`
   (`bass`, `kick`, `toTrack`, …). Firmas y semántica visibles para el livecoder.
2. **Sensación de livecoding**: marcar steps en caliente, cambiar instrumentos y que el
   siguiente step use lo nuevo, `toTrack`/`offTrack` desde el intérprete.
3. **Sonido**: CaosPercLib + SynthDefs finos. No se reescribe el DSP.
4. **Tdefs como scheduler** de SC: válido; el problema es qué vive dentro, no el Tdef.
5. **Una sola instancia** de la app por proceso (hoy garantizada por `~cbox_url`).

---

## 3. Hallazgos

### 3.1 Estructurales

**A1. La GUI es el modelo.** `Tdef(\secuencias)` lee `~cbox_checkbajo[i].value`; `setSteps`
y `clearSteps` hacen `valueAction_` sobre los checkboxes. Consecuencia: no hay forma de
secuenciar sin widgets, ni de testear la lógica sin GUI, ni de tener otra vista (TUI, MIDI).

**A2. La inicialización es un script, no una API.** El orden de carga es parte del contrato.
Configurar = recargar archivos (`autoFx` recarga `auto.scd`; `~cbox_custom` se lee al cargar
`synths.scd` y nunca más, por lo que `bassCustom` no funciona sin recargar).

**A3. Dos relojes y un índice huérfano.** `TempoClock` (beats) gobierna todos los Tdefs;
`~cbox_tiempos` (fracción de beat) define "step". `\randtime` cambia el tempo global cada
step y arrastra a los Tdefs melódicos. `~cbox_indice` no se resetea al reanudar: pausa/stop
desfasa LED, gate y reloj. `Tdef.defaultQuant = 1` no arregla el reinicio.

**A4. Ruteo sin fuente única.** Ver 1.6. Elegir salida desde la GUI es un `set(\out, n)` con
números literales; los pares estéreo se asumen; el granulador recibe de `In.ar(64)` fijo.

**A5. No hay modelo de voz.** No existe un objeto "instrumento" a quien preguntar parámetros
o ciclo de vida. Cambiar un timbre = setear un global o `Synth.set` desde la GUI. Los
`~cbox_*_seq` son espejos redundantes del synth actual (se escriben y se leen como handle).

**A6. Dos mecanismos de secuencia sin fase.** Steps (gate) + Tdef libre (notas). El "snapshot
vs live" del CHANGELOG ya existe, pero implícito y accidental (percusión copia la función;
melódicos leen el global vivo).

**A7. Duplicación.** El bloque "switch seqType + streams + loop + set" aparece 7 veces en
`CaosGear`; el bloque "32 checkboxes + botón X + knobs" 13 veces en la GUI; `~cbox_sintetizadores`
y los métodos de `CaosGear` son dos caminos para crear un instrumento.

**A8. El nombre miente.** `CB/CaosBox-defaults.scd` no son defaults: es registro de
instrumentos + fábrica de percusión + arranque de líneas melódicas.

### 3.2 Bugs silenciosos

Severidad: **C** = rompe audio/GUI al ejecutarse, **S** = la función no hace nada (silencio
de comportamiento), **A** = audible al arreglarlo (requiere revisión de oído).

| # | Sev | Archivo:línea | Síntoma |
|---|---|---|---|
| B2 | S | `CB/CaosBox-auto.scd:48` | `\aux3.set(\rate, …)` pero `\aux3` declara `\pitch` (signal.scd:33) → la automatización de pitch no hace nada. |
| B3 | S | `CB/CaosBox-auto.scd:31` | `\feedback` vs `\delfeed` (signal.scd:23) → feedback del delay no se automatiza. |
| B4 | A | `CB/CaosBox-synths.scd:33,37` | `var tipo='M'` / `var type='M'` hardcodeados: el arg `\chord` se ignora → siempre suena 'M'. **No es parche de una línea**: `CaosChords.signal` resuelve el acorde en build-time y un control no puede cambiarlo. Requiere variantes de SynthDef o `Select` numérico → Paso 2. |
| B5 | A | `CB/CaosBox-synths.scd:25` | `var onda='sin'` hardcodeado: el arg `\waveform` de `pad` se ignora. **Mismo caso que B4** (`CaosPad.signal` elige el oscilador en build-time) → Paso 2. |
| B6 | S | `CB/CaosBox-signal.scd:24-28` + `GUI/CaosBox-GUI_3.scd:149-150` | `deltype`/`delind` son variables locales, no args del SynthDef; el botón CombC/CombL no cambia nada. |
| B7 | C | `GUI/CaosBox-GUI_3.scd:90` | El NumberBox del limiter setea `\limit` con `~cbox_num.value` (el de Amp). |
| B8 | S | `CaosBox.sc:547` | `*fx(\pitch)` consulta `Tdef(\autoz)` (typo, es `\autop`) → no detecta la automatización activa. |
| B9 | S | `CB/CaosBox-vars.scd:22` | `~cbox_clock` arranca como *número* (`~cbox_clock = TempoClock.tempo = 126/60`), no como función; "Regular Time" (GUI.scd:268) queda como no-op hasta llamar `.bpm`. |
| B10 | C | `CB/CaosBox-vars.scd` (faltan) | No existen `~cbox_autohpffreq/band` ni `~cbox_autobpffreq/band`; `Tdef(\autohpf/\autobpf)` fallaría al arrancar sin pasar por `autoFx`. |
| B11 | S | `CaosBox.sc:161` | `if(random == true or: { random == false })` es siempre cierto; la rama de error es inalcanzable. |
| B12 | S | `CaosBox.sc:140-146` | `*stop` pausa solo `Tdef(\secuencias)`; los Tdefs melódicos siguen haciendo `set` con gate abierto → "pausa" no calla. La GUI, en cambio, pausa todo (divergencia API/GUI). |
| B13 | C | `CaosBox.sc:298-326` | `*setSteps` muta el array del usuario y trunca con `indexOfGreaterThan(31)` (corta todo lo posterior al primer índice >31); no valida negativos. |
| B14 | - | `CaosBox.sc:260-280` | `*stepsArray` usa `collect` mutando el array; funciona por accidente. |
| B15 | S | `GUI/CaosBox-GUI.scd:276-293` | `var bool = true` hace inalcanzable la rama `resume`; el botón siempre hace `.play`. |
| B16 | - | `CB/CaosBox-vars.scd:80-94` | `~cbox_steps` guarda `[checkboxes, steps, instrumento]` con el tercer slot en `nil` (capturado antes de existir). Código muerto. |
| B17 | C | `README.md:16,28`, `DevTest/test-methods.scd:2,9` | El rename `.enviroment → .environment` deja llamadas rotas; `x.metric` no existe (es `toggleMetric`); el ejemplo del README tiene un paréntesis sin cerrar. |
| B18 | - | `GUI/CaosBox-GUI_4.scd:168` | `onClose` hace `CaosBox.close` + `Main.recompile`; `*close` usa `Tdef.removeAll` (borra Tdefs de otros proyectos). |

Verificación (2026-08-14):

* **B1 descartado**: `postcln` sí existe en el core (`Object:postcln`; `String:postcln`
  imprime con prefijo `//`). No es bug.
* **Ruteo de auxiliares revisado**: `Pan2.ar(estereo, [1,-1])` + `Out` genera dos `Out`;
  como `Out` **suma** al bus, el par estéreo se reconstruye correctamente. No es bug, aunque
  es frágil y se simplificará en el Paso 3.
* **B4/B5 no son parches**: dependen de SynthDefs variantes (ver tabla).

### 3.3 Deuda menor

* Nombres inconsistentes: `\bajouno`/`bass`, `\ambuno`/`pad`, `\acordes`/`chords`,
  `instance_id` `String` en vez de `Symbol`.
* `CaosGear.kick2Custom` sin `ugenFunc` no informa nada; las variantes `*Custom` dependen de
  `~cbox_custom` leído al cargar la clase (ver A2).
* `CB/CaosBox-funcs.scd` contiene versiones "deprecated" de los métodos de `CaosBox`
  (`~cbox_clear_steps`, `~cbox_set_steps`, `~cbox_rand_steps`, `~cbox_pat_arr`) que ya no
  se usan desde las clases (`CaosBox.setSteps` etc.). Candidatas a borrar.
* `~cbox_numr/numroom/numd/...` y sus faders duplican el mismo valor: cada fader y su
  NumberBox se sincronizan a mano.
* Mensajes de error inexactos (delay: dice 0..6 pero valida 0..4).
* `DevTest/` es un cajón de pruebas manuales sin estructura; hay métodos obsoletos.

---

## 4. Plan previo (fases 0-5 del CHANGELOG) vs plan propuesto

El plan previo propone Engine → Voice → Sequence → GUI → API. La dirección es correcta,
pero:

* `CaosEngine` (ya escrito, staged) es **código muerto**: no lo usa la app, sus tests pasan
  sin tocar el flujo real, y "desacoplar ruteo" no se resuelve con grupos si los buses
  siguen literales dentro de los SynthDefs.
* El cuello de botella es **A1 (GUI = modelo)**. Mientras exista, ni Voice ni Sequence son
  testeables y se corre el riesgo de tener dos sistemas vivos a la vez (justo lo que pasó
  con `CaosEngine.sc`).
* "Fase 1 no rompe API" es cierto, pero tampoco *cambia* nada observable: no da valor
  incremental.

Propuesta: mover el modelo de steps **antes** que el engine, porque es lo que desbloquea la
testeabilidad, y encadenar engine/buses justo después.

---

## 5. Plan por pasos

Regla general: cada paso deja la app funcional, conserva la API, y termina con verificación
(compilación + tests headless + oído).

### Paso 0a — Parches aplicados (esperando commit)

Estado: aplicados en el árbol de trabajo; class library compila. Pendiente: commit de
josecaos y validación de oído.

| Bug | Archivo | Cambio |
|---|---|---|
| B2 | `CB/CaosBox-auto.scd:48` | `\rate` → `\pitch` |
| B3 | `CB/CaosBox-auto.scd:31` | `\feedback` → `\delfeed` |
| B6 | `CB/CaosBox-signal.scd:23-30` | `delind` pasa a argumento; `CombC`/`CombL` con `Select.ar` |
| B7 | `GUI/CaosBox-GUI_3.scd:90` | el limiter usa `~cbox_num4.value` |
| B8 | `CaosBox.sc:555` | `Tdef(\autoz)` → `\autop` |
| B9 | `CB/CaosBox-vars.scd:22-23` + `GUI_4:161` | `~cbox_clock` es función desde el inicio; el display (126) coincide con el tempo real |
| B10 | `CB/CaosBox-vars.scd:42-45` | arrays de automatización HPF/BPF |
| B11 | `CaosBox.sc:169` | `randomTime` valida `Boolean` |
| B17 | `CaosBox.sc`, `README.md`, `DevTest/test-methods.scd` | alias `.enviroment` y docs al día |
| — | `DevTest/test-methods.scd` | `~set_steps`/`~clear_steps` (inexistentes) → `CaosBox.setSteps/clearSteps` |

Aplazados:

* **B4, B5** (acorde y waveform): no son parches; requieren SynthDefs variantes → Paso 2.
* **B12, B13, B15** (stop, setSteps, botón play): se resuelven en el Paso 1.

**Criterio de aceptación 0a**: la app arranca y suena igual, salvo que ahora sí funcionan
la automatización de pitch (B2), la del feedback del delay (B3) y el selector CombC/CombL
(B6). Eso pide revisión de oído.

### Paso 1 — El step deja de ser un CheckBox

Introducir `CaosTrack` (clase SC) como dueño del patrón de 32 pasos, con dos modos:

* `\snapshot`: el slot guarda el valor resuelto al marcar (percusión: la función actual).
* `\live`: el slot guarda el gate; el instrumento se resuelve al disparar (melódicos).

`~cbox_tracks` reemplaza a `~cbox_steps`; la GUI se vuelve vista (escribe en el track y se
sincroniza por notificación); `Tdef(\secuencias)` lee del track. API intacta.
Tests headless de la clase, sin server ni GUI.

**Criterio de aceptación**:
1. `CaosBox.setSteps/clearSteps/randSteps` misma firma y mismo efecto observable.
2. Marcar/desmarcar en la GUI funciona igual; botones X igual; `toTrack/offTrack` igual.
3. El secuenciador no toca arrays de steps ni widgets.
4. `TestCaosTrack` pasa sin server (headless).
5. `setSteps` no muta el array del usuario ni trunca mal (B13).
6. Suena igual (oído).

### Paso 2 — Voz (`CaosInstrument`)

`CaosGear` devuelve instancias reales (no `String`), con synthdef, tipo (función/synth),
bus de salida, gate/trigger, params. `toTrack` deja de ser un `switch` de strings; dos bajos
pueden coexistir. El efecto "crear synth al marcar" sale de la GUI y vive en la voz.

### Paso 3 — Engine y ruteo

`CaosEngine` (remplazando el actual) dueño de server, orden de ejecución, **mapa de buses**
y SynthDefs: `\reverb -> 52` en una sola fuente; los popups de la GUI se generan del mapa.
Tabla de despacho de tracks (percusión/gate) para que el secuenciador no tenga 13 ramas.

### Paso 4 — Reloj (`CaosSequencer`)

Un solo dueño del índice, duración, pausa/reanudar y `\randtime`; los Tdefs melódicos se
disparan desde el secuenciador (o se les da su propio reloj explícito). Arregla A3 y B12.

### Paso 5 — GUI como vista

Filas generadas desde el modelo; registro de widgets para MIDI y automatización;
se borran las globals de UI (`~cbox_w` deja de cruzarse con el motor).

### Paso 6 — API, docs y tests

`.schelp` de clase, README nuevo, CHANGELOG por versión, suite estable (UnitTest para
modelo y engine, tests de integración con server).

---

## 6. Decisiones tomadas

1. **Conservar la API pública** hasta el Paso 6. Los cambios de estructura van por debajo.
2. **Commits en inglés, los hace josecaos.** El agente propone mensajes.
3. **Orden**: Paso 0a primero (bugs), luego Paso 1. Cada paso en commits pequeños.
4. **Verificación**: compilación de class library + tests headless (sin GUI) + validación
   de sonido/GUI por josecaos.
5. **Destino de `Classes/CaosEngine.sc` + `Tests/TestCaosEngine.sc`** (staged): se reutilizan
   como base del Paso 3, o se guardan en rama aparte. *Pendiente de decidir.*
6. **Paso 1 cerrado** (ver §7): `mode` explícito, `onChange`, borrar arrays espejo, quitar
   `~cbox_steps`, tests en `Tests/TestCaosTrack.sc`.

---

## 7. Diseño del Paso 1 (cerrado)

Contrato propuesto para `CaosTrack`:

```supercollider
CaosTrack.new(name, kind: \snapshot, size: 32, source: nil)

// lectura
at(i)              // valor del slot (función / true / nil)
size
count              // slots activos
asArray            // copia del patrón

// escritura (normaliza índices fuera de rango y no muta la entrada)
put(i, value)      // valor literal
putStep(i, on)     // on=true -> resuelve source.value (snapshot) o true (live)
clear(indices)     // nil = todos
setIndices(array, clearFirst: true)
on / off

// notificación a la vista
onChange = { |track, index, value| ... }
```

Decisiones cerradas con josecaos (2026-08-14):

1. `mode` **explícito** (`\snapshot`/`\live`), no inferido de `source`.
2. Notificación a la vista con **`onChange`** en el track; la fachada no toca widgets.
3. **Sí** se delegan `setSteps/clearSteps/randSteps` al track y **se borran** los arrays
   espejo en el mismo paso (quedan en el historial de git).
4. El efecto "crear synth al marcar step" **se queda en la GUI** durante el Paso 1 y se
   muda a la voz en el Paso 2.
5. Tests en `Tests/TestCaosTrack.sc`, estilo `test_...` como el del engine.
6. `~cbox_steps` **se elimina**; el nombre nuevo es `~cbox_tracks`.

Plan de commits del Paso 1:

1. `CaosTrack` + `TestCaosTrack` (clase aún sin usar; revisable aislada).
2. Percusión (6 tracks): vars + GUI + seq.
3. Melódicos (7 tracks): vars + GUI + seq + defaults; se borran los arrays espejo.
4. Limpieza: `~cbox_steps` y funciones deprecated de `funcs.scd`.

---

## 8. Anexos

### 8.1 Mapa de pistas

| Track | Perfil | Step | Instrumento | SynthDef / función |
|---|---|---|---|---|
| `\kick` | snapshot | función | `~cbox_b` | `CaosKick` |
| `\snare` | snapshot | función | `~cbox_t` | `CaosSnare` |
| `\hihats` | snapshot | función | `~cbox_h` | `CaosHats` |
| `\kick2` | snapshot | función | `~cbox_b2` | `CaosKick2` |
| `\snare2` | snapshot | función | `~cbox_t2` | `CaosSnare2` |
| `\hihats2` | snapshot | función | `~cbox_h2` | `CaosHats2` |
| `\bass` | live | gate | `~cbox_bass` | `\bajouno` |
| `\bass2` | live | gate | `~cbox_bass2` | `\bajodos` |
| `\amb` | live | gate | `~cbox_amb` | `\ambuno` |
| `\amb2` | live | gate | `~cbox_amb2` | `\ambdos` |
| `\chords` | live | gate | `~cbox_chord` | `\acordesuno` |
| `\chords2` | live | gate | `~cbox_chord2` | `\acordesdos` |
| `\in` | live | gate | `~cbox_entrada` | `\entrada` |

### 8.2 Tdefs

`\secuencias` (reloj de steps), `\randtime` (tempo aleatorio),
`\autor`, `\autod`, `\autop`, `\autog`, `\autolpf`, `\autohpf`, `\autobpf` (automatización),
`\bass`, `\bass2`, `\pad`, `\pad2`, `\acordes`, `\acordes2`, `\entrada` (líneas melódicas).

### 8.3 Comandos de verificación

```bash
# 1) HOME aislado con symlink al repo (no toca la config real de SC)
mkdir -p /tmp/sc_home/.local/share/SuperCollider/Extensions
ln -sfn "$PWD" /tmp/sc_home/.local/share/SuperCollider/Extensions/caosbox
ln -sfn ../caosperclib /tmp/sc_home/.local/share/SuperCollider/Extensions/caosperclib

# 2) compilar el class library (valida las clases del repo)
printf 'Post << "OK\n"; 0.exit;\n' > /tmp/check.scd
HOME=/tmp/sc_home sclang /tmp/check.scd

# 3) correr los tests del modelo (sin server ni GUI)
cat > /tmp/run_tests.scd <<'SCD'
(
var r;
UnitTest.reportPasses = false;
r = Routine {
	TestCaosTrack.run;
	("FAILURES: " ++ UnitTest.failures.size).postln;
	("PASSES: " ++ UnitTest.passes.size).postln;
	if(UnitTest.failures.size > 0) { 1.exit };
	0.exit;
};
r.play(AppClock);
)
SCD
HOME=/tmp/sc_home sclang /tmp/run_tests.scd
```

Desde el IDE: `TestCaosTrack.run` (o `UnitTest.gui`).

Notas:

* La GUI necesita display (Qt); los tests del modelo corren sin GUI y sin server.
* `~/.local/share/SuperCollider/Extensions/caosbox` es symlink a este repo, así que las
  clases nuevas se compilan al iniciar sclang. Con `HOME` aislado hay que replicar el symlink.
* Ojo: los valores por defecto de argumentos en SC no admiten classvars
  (`size = defaultSize` no compila); se resuelven dentro de `init`.

---

## 9. Bitácora

| Fecha | Paso | Nota |
|---|---|---|
| 2026-08-14 | análisis | Lectura completa del repo; compilación OK; este documento. |
| 2026-08-14 | verificación | B1 descartado (`postcln` es del core); ruteo estéreo de aux verificada (`Out` suma); B4/B5 movidos al Paso 2. |
| 2026-08-14 | 0a | Parches B2, B3, B6, B7, B8, B9, B10, B11, B17 aplicados; class library compila. Pendiente: commit y validación de oído. |
| 2026-08-14 | 0a | Commit `7fa2580` (josecaos). |
| 2026-08-14 | 1.1 | `Classes/CaosTrack.sc` + `Tests/TestCaosTrack.sc`; 41 aserciones en verde, headless (sin server ni GUI). |
| 2026-08-14 | 1.1 | Commit `baea79a`; detalle en `dev-docs/02-fix-1-modelo-steps.md`. |
| 2026-08-14 | 1.2 | Cableado: `~cbox_tracks` (13), API delegando, seq y GUI leyendo/escribiendo el modelo; se borran 13 arrays y `~cbox_steps`. 41 tests + smoke test verdes; 12/12 `.scd` parsean. Pendiente commit y prueba en la app. |
