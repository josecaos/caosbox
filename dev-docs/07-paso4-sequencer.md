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

`Tests/TestCaosSequencer.sc` — 9 tests, **23 aserciones**:

* defaults y configuración (size/bpm/stepDur/randtimes);
* `bpm_` fija `TempoClock.default.tempo` (90 → 1.5);
* apagar `randomTime` restaura el tempo principal;
* `nextIndex` envuelve y `jumpTo` normaliza el índice;
* `stop` resetea el índice;
* `prepare` corre una sola vez (y es seguro sin bloque).

Total de la suite: **247 aserciones, 0 fallos**.

## 5. Cableado pendiente (2/2)

1. `CB/CaosBox-seq.scd`: crear `~cbox_seq = CaosSequencer.new(step: …, prepare: …)` con el
   LED y `~cbox_tracks.do { |t| t.step(index) }` en `step`, y las 8 voces fijas en
   `prepare`. Fuera `Tdef(\secuencias)` y `Tdef(\randtime)` del archivo.
2. `GUI/CaosBox-GUI.scd`: “Thirds/Fourths” → `~cbox_seq.stepDur`; “Random/Regular Time” →
   `~cbox_seq.randomTime`; play/stop → `play`/`pause` (y fuera los Tdef de melodías, que ya
   no existen).
3. `GUI_4`: el numbox de BPM → `~cbox_seq.bpm`.
4. `CaosBox.*play/stop/bpm`: hablar con `~cbox_seq` (y mantener el GUI en sincronía).
5. `CB/CaosBox-vars.scd`: retirar `~cbox_indice`, `~cbox_clock` y `~cbox_tiempos`; las
   automatizaciones (`CB/CaosBox-auto.scd`) pasan a leer `~cbox_seq.stepDur`.
