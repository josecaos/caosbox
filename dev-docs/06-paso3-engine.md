# Paso 3 (1/3) — `CaosEngine`: server, buses y grupos

> **Versión:** v2.1.2 · **Rama:** `dev-v2.0`
> **Estado:** commit 1 en el árbol de trabajo (clase + tests headless).
> **Riesgo en runtime:** nulo todavía — nada usa el engine aún.

---

## 1. Qué resuelve

* Un solo dueño del **server** (opciones, boot, orden de ejecución).
* Un **mapa de buses con nombre** en vez de números mágicos repartidos por SynthDefs,
  GUI y defaults: los instrumentos piden `\master`, `\reverb`, `\lpf`, …
* Un lugar donde colgar los **grupos ordenados**: instrumentos → fx → master.

## 2. API

| Miembro | Qué hace |
|---|---|
| `bus(name)` | devuelve el `Bus` con ese nombre |
| `busIndex(name)` | su índice |
| `busNames` | nombres en orden de layout |
| `resolveOut(out)` | `\reverb` → 52 · un `Bus` → su índice · un número → tal cual |
| `makeGroups` / `freeGroups` | crea/libera los tres grupos (`/g_new` addToTail, `/n_free`) |
| `groupID(name)` | id del grupo; sin grupos devuelve el grupo raíz (1) |
| `boot(onReady)` | opciones (`memSize`, `maxNodes`), espera boot, crea grupos |
| `isReady` | hay grupos y el server corre |

Layout (conserva los buses históricos):

| Nombre | Índice | Canales |
|---|---|---|
| `\master` | 50 | 2 (donde escriben los instrumentos) |
| `\reverb` | 52 | 2 |
| `\delay` | 54 | 2 |
| `\pitch` | 56 | 2 |
| `\lpf` | 58 | 2 |
| `\hpf` | 60 | 2 |
| `\bpf` | 62 | 2 |
| `\grains` | 64 | 1 |

## 3. Compatibilidad

`resolveOut` acepta **símbolo, `Bus` o número**, así que:

```supercollider
b.bass(50, notas, \seq);        // sigue funcionando
b.bass(\reverb, notas, \seq);   // nombre
b.bass(engine.bus(\reverb));    // Bus
```

Los buses se crean con `Bus.new(\audio, index, canales, server)` (índices fijos, igual que
hoy). Cuando los SynthDefs reciban su bus de entrada por parámetro se podrá pasar a
`Bus.audio` (allocator del server) sin cambiar la API pública.

## 4. Grupos

`makeGroups` manda tres `/g_new` al final del grupo por defecto (1), en orden:
`instruments`, `fx`, `master`. El orden de creación es el orden de ejecución. `freeGroups`
manda `/n_free` y olvida los ids; `groupID` cae al grupo raíz si no hay grupos.

Todo se prueba con un **output inyectable** (grabador de mensajes), sin server ni audio.

## 5. Tests

| Suite | Aserciones |
|---|---|
| `TestCaosTrack` | 55 |
| `TestCaosInstrument` | 77 |
| `TestCaosGear` | 45 |
| `TestCaosEngine` | **41** (nuevo) |
| **Total** | **218, 0 fallos** |

`TestCaosEngine` cubre: layout e índices, canales, `bus`/`busIndex`, `resolveOut`
(nombre/`Bus`/número/desconocido), `startBus` configurable, y los mensajes de grupos
(orden, addToTail, target, liberación, doble `makeGroups`).

## 6. Commit 2 — SynthDefs y cableado (en el árbol)

* `CB/CaosBox-signal.scd`: cada procesador recibe su bus de entrada por parámetro
  (`inbus`) y su salida (`out`): `\master`, `\aux1..3`, `\lowfilt`, `\highfilt`,
  `\bandfilt`, `\granulador`. Los defaults siguen siendo los índices históricos, así que
  sin engine el sonido es el mismo de siempre.
* `CaosBox`: classvar `engine`; `init` crea el `CaosEngine` y arranca con `engine.boot`
  (opciones, grupos, y después carga los `.scd`). `CaosBox.resolveOut` resuelve nombres y,
  si no hay engine, deja pasar el valor (compatibilidad y tests).
* `Tdef(\secuencias)`: el master se crea dentro del grupo `master`; aux, filtros y
  granulador dentro de `fx`; cada Synth recibe `\inbus` y `\out` resueltos del mapa.
* `CaosGear`: los instrumentos melódicos resuelven su `out` con `CaosBox.resolveOut`, así
  que `b.bass(\reverb, …)` y `p.pad(\lpf, …)` funcionan. La percusión sigue aceptando
  números o arrays (su función captura el bus en `Out.ar`).
* `GUI/CaosBox-GUI_4.scd`: los popups de ruteo usan `CaosBox.engine.busIndex(...)`.
* `CaosBox.close` libera los grupos del engine.

Pendiente de validación de audio por josecaos (el comportamiento debe ser idéntico).

## 7. Commit 3 — despacho genérico y grupos de voces (en el árbol)

* `CaosTrack:step(index)` es la única entrada para las 13 pistas:
  * **con voz** (melódicos): `advance` de la línea y `trigger` si el step está encendido;
  * **sin voz** (percusión): toca la función guardada en el step, dentro del grupo
    `target` de la pista (CaosGear lo fija al grupo `instruments` del engine).
* `Tdef(\secuencias)` quedó en una línea:
  `~cbox_tracks.do { |track| track.step(~cbox_indice) }` — fuera las 13 ramas.
* `CaosInstrument` gana `target`: las voces melódicas se crean con `/s_new` dentro del
  grupo `instruments`; la percusión hace `func.play(target)`.
* Tests nuevos: `step` despacha según haya voz o función, y el grupo destino viaja en los
  mensajes (voz y `play`).

Total: **224 aserciones, 0 fallos**.

## 8. Siguiente

1. **GUI**: etiquetas ("Reverb: 52", "LowPassFilter: 58", …) desde el engine.
2. **Percusión**: aceptar nombres de bus en `out` (hoy números o arrays).
3. **Paso 4**: reloj único (`CaosSequencer`): índice, duración, pausa/reanudar y
   `\randtime`; hoy pausa/stop desfasa el índice y `Tdef(\secuencias)` mezcla el boot del
   master con el reloj.
