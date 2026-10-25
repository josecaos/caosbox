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

## 6. Siguiente

1. **SynthDefs**: que `\master`, `\aux1..3`, filtros y granulador reciban su bus de entrada
   por parámetro (`In.ar(in)`) en vez de `In.ar([52,53])`.
2. **Cableado**: `CaosBox.environment` crea el engine, y los Synths de master/fx/filtros se
   crean en sus grupos.
3. **GUI**: los popups de ruteo y las etiquetas ("Reverb: 52") se generan del mapa.
4. **Despacho**: el `Tdef(\secuencias)` recorre `~cbox_tracks` en vez de 13 ramas.
