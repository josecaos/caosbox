# Paso 4 (1/2) — `CaosSequencer`: un solo dueño del tiempo

> **Versión:** v2.1.5 · **Rama:** `dev-v2.0`
> **Estado:** clase + tests headless en el árbol. Cableado pendiente.
> **Riesgo en runtime:** nulo todavía — nadie la usa aún.

---

## 1. El problema

El tiempo vivía repartido en globals y en la GUI:

* `~cbox_indice` (0..31) se avanzaba y se envolvía dentro del `Tdef`, sin dueño.
* `~cbox_tiempos` (0.25 o 1/3 de beat) era leído por el secuenciador **y** por las
  automatizaciones; la GUI lo escribía directo desde el botón "Thirds/Fourths".
* `~cbox_clock` era una función que reescribía `TempoClock.tempo`, compartida entre la API,
  el numbox de BPM y el botón de tiempo aleatorio.
* El `Tdef(\secuencias)` creaba master/aux/filtros **dentro del loop**: si se reiniciaba el
  `Tdef` (no `pause`), se duplicaban los synths.
* `Tdef(\randtime)` competía con el tempo principal y no tenía un "dueño" que lo apagara.

## 2. La clase

`Classes/CaosSequencer.sc` — el transporte y el tiempo en un solo objeto.

| Miembro | Qué hace |
|---|---|
| `size` | pasos por ciclo (32) |
| `index` | paso actual (0..size-1) |
| `stepDur` | duración del step **en beats** (0.25 = semicorchea) |
| `bpm` / `bpm_` | fija el tempo del `TempoClock` (`bpm/60`) |
| `randomTime` / `randomTime_` | modo de tiempo aleatorio; al apagarlo vuelve el BPM |
| `randtimes` | lista de BPM para el modo aleatorio |
| `tdef` | el `Tdef(\secuencias)` interno (sigue con el mismo nombre) |
| `play` / `pause` / `stop` | transporte: `pause` conserva el índice, `stop` lo vuelve a 0 |
| `prepare` | crea las voces fijas (master, fx, filtros) **una sola vez** |
| `jumpTo(i)` / `nextIndex` | mover el índice / calcular el siguiente (con wrap) |

`*new` recibe dos bloques:

```supercollider
CaosSequencer.new(
    step:    { |index| ... },   // qué hacer en cada paso (LED + pistas)
    prepare: { |seq| ... },     // crear master/fx/filtros (una vez)
    size: 32, bpm: 126, stepDur: 0.25, randtimes: [...]
)
```

Así la clase no conoce ni la GUI ni las pistas: se puede probar headless.

## 3. Semántica del transporte

* `play` en parado → el `Tdef` corre desde el principio (`index = 0`).
* `pause` → conserva el índice; `play` reanuda desde ahí.
* `stop` → vuelve a 0 la próxima vez.
* `randomTime = true` → cada step fija el tempo con un BPM de `randtimes`;
  `randomTime = false` → restaura `bpm/60`.
* `prepare` es idempotente: aunque el `Tdef` se reinicie, master/fx no se duplican.

## 4. Tests

`Tests/TestCaosSequencer.sc` — 13 tests, **28 aserciones**:

* defaults y configuración (size/bpm/stepDur/randtimes);
* `bpm_` fija `TempoClock.default.tempo` (90 → 1.5);
* apagar `randomTime` restaura el tempo principal;
* `nextIndex` envuelve y `jumpTo` normaliza el índice;
* `stop` resetea el índice;
* `prepare` corre una sola vez (y es seguro sin bloque);
* `onTempoChange` avisa cada cambio de tempo (BPM principal y sorteado en
  random time).

Total de la suite: **252 aserciones, 0 fallos**.

## 5. Cableado aplicado (2/2)

* `CB/CaosBox-seq.scd`: solo crea `~cbox_seq = CaosSequencer.new(step: …, prepare: …)`.
  El `step` hace el LED y `~cbox_tracks.do { |t| t.step(index) }`; el `prepare` crea
  master/fx/filtros/granulador en los buses y grupos del engine (una sola vez). Fuera
  `Tdef(\secuencias)` y `Tdef(\randtime)` del archivo.
* `CaosBox`:
  * `play` / `pause` / `stop` hablan con `~cbox_seq` (y sincronizan el botón).
    `pause` conserva el paso; `stop` vuelve a 0.
  * `bpm` fija el numbox y el sequencer; `stepDur` fija la duración; `randomTime`
    actualiza `randtimes` y el modo; `toggleMetric` alterna el botón.
  * `prPauseAutomations` pausa `autor/autod/autop/autog` y apaga sus botones.
  * `close` detiene el sequencer antes de liberar el engine.
* `GUI.scd`: play/pause (`CaosBox.pause/play`), “Regular/Random Time”
  (`CaosBox.randomTime`), “Fourths/Thirds” (`CaosBox.stepDur`). Los dos botones de
  modo muestran el modo que se aplica **al apretar** (no el que está corriendo) y
  recuperan los colores por estado de v1.0 (verde, texto blanco/negro).
* `GUI_4`: el numbox de BPM llama `CaosBox.bpm`.
* `CB/CaosBox-vars.scd`: fuera `~cbox_indice`, `~cbox_tiempos` y `~cbox_clock`.
* `CB/CaosBox-auto.scd`: las automatizaciones esperan `(~cbox_seq.stepDur * ~cbox_divX)`.
  Los valores son multiplicadores de velocidad (1 normal, 0.5 fast, 2 slow, 4 slowest).

## 6. Verificación

* Class library compila; 14 `.scd` parsean.
* Suite: **252 aserciones, 0 fallos**.
* Smoke test headless del transporte: 13 steps en 0.3 s, `pause` no avanza, `play`
  reanuda, `stop` deja `index = 0`.

## 7. Siguiente

1. **Paso 5**: GUI como vista (filas generadas del modelo, MIDI/automatización por registro).
2. **Paso 6**: API/docs (`.schelp` de `CaosInstrument`/`CaosSequencer`, README v2.1.5).
3. Detalles: `Tdef.defaultQuant` (arranque en la rejilla) y etiquetas del `PLAY/PAUSE`.

## 8. Ajustes tras la primera prueba en la app (v2.2.0)

Tres cosas que solo se ven con sonido y GUI:

1. **randomTime no movía el numbox de BPM.** El tempo sorteado se aplicaba al reloj,
   pero la vista no se enteraba. Se agregó `CaosSequencer.onTempoChange` (callback)
   que se dispara en `prApplyTempo` y también en la rama aleatoria de `prWait`, con el
   BPM efectivo. `CB/CaosBox-seq.scd` lo conecta al numbox con `.defer` (el aviso llega
   desde el hilo del reloj) y `!?` para que la API funcione sin GUI.
2. **Etiquetas de modo al revés y sin color.** En métrica y en random la etiqueta
   vuelve a decir el modo que se aplica al apretar (el `action` recibe el valor nuevo):
   métrica state 0 = “Thirds” / state 1 = “Fourths”; random state 0 = “Random Time” /
   state 1 = “Regular Time”. Se restauran los colores de v1.0: fondo
   `Color.green(0.35)` con texto blanco/negro. (El commit “New colors for interface”
   los había dejado en `Color(alpha:)`, que además es casi invisible en Wayland.)
   `CaosBox.randomTime` sigue sincronizando el botón: random encendido deja “Regular
   Time” a la vista, listo para apagarlo.
3. **Velocidad de automatizaciones de FX invertida.** La espera era `stepDur / div`;
   con `fast = 0.5` eso *alargaba* la espera. Ahora es `stepDur * div`: normal 1,
   fast 0.5, slow 2, slowest 4. Se documentó en `CB/CaosBox-vars.scd` y en la cabecera
   de `CB/CaosBox-auto.scd`.

Verificación final: compila, 14 `.scd` parsean, **252 aserciones, 0 fallos**, y smoke
headless de `onTempoChange` (120 en modo normal; 60/90 sorteado; 120 al apagarlo).
