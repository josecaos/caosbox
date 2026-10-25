# Paso 2 — Instrumentos (voz) · `CaosInstrument`

> **Versión:** v2.1.1 · **Rama:** `dev-v2.0`
> **Estado:** 2a (clase + tests) y 2b (cableado melódico) en el árbol de trabajo.
> Pendiente: commit y el 2c (percusión).
> **Riesgo en runtime:** la app cambia de motor en las pistas melódicas; el sonido debería
> ser el mismo o mejor (sin fugas ni Tdefs sueltos).

---

## 1. El problema

El mismo instrumento se construía en **tres lugares**: el método de `CaosGear` (globals +
`Tdef`), el `switch` de `~cbox_sintetizadores` (creaba `Synth`s) y la acción de la GUI
(creaba `Synth`s al marcar). Síntomas:

* El pad "no iteraba": la nota la ponía un `Tdef` que corría en paralelo al secuenciador,
  mientras el synth que sonaba era otro (el creado en el step anterior). Cada step activo
  creaba un `Synth` y nunca lo liberaba → drones acumulados.
* Dos bajos no podían coexistir (Tdef y global con nombre fijo).
* Nada de esto se podía probar sin audio.

## 2. `CaosInstrument`

`Classes/CaosInstrument.sc` — una voz que sabe sonar y hablar OSC; no conoce GUI, steps ni
reloj.

| Miembro | Qué es |
|---|---|
| `kind` | `\synth` (voz persistente vía `/s_new`) o `\function` (percusión: `func.play`) |
| `mode` | `\free` (la nota avanza con el reloj; la llama `advance`) o `\trig` (avanza al disparar) |
| `retrigger` | `false` = **legato** (una voz que cambia de nota sin reatacar) · `true` = ataque por disparo |
| `notes` + `noteOrder` | array de notas y orden `\seq` / `\rand` (equivale al viejo `seqType`) |
| `params` | diccionario de parámetros fijos del SynthDef |
| `out` | bus de salida |
| `output` | quien recibe el OSC: `Server` o un grabador en tests |
| `trigger` / `set` / `release` / `free` | ciclo de vida |

Comportamiento:

* **oneShot** (`kind: \synth` + `oneShot: true`): cada trigger crea una voz nueva; el
  envelope (`Env.perc`) la libera solo y el instrumento no le manda `/n_set` ni `gate 0`
  después. Es el modo de **todos** los instrumentos de CaosPercLib (bass, pads, chords,
  lineIn), porque `CaosEnv.envKR` usa `Env.perc`.
* **retrigger** (para SynthDefs sostenidos): al disparar libera la voz anterior con `gate 0`
  y crea otra.
* **legato** (para SynthDefs con `Env.asr`): una sola voz que cambia de nota. Requiere un
  SynthDef que sostenga; con `Env.perc` no aplica.
* La percusión es `\function` y siempre dispara un sonido nuevo: tampoco aplica legato.

## 3. La voz en la pista (`CaosTrack`)

Se agregó a `CaosTrack`:

| Miembro | Qué hace |
|---|---|
| `instrument` / `pendingInstrument` | voz activa y reemplazo en espera |
| `setInstrument` | la primera voz entra al instante; un reemplazo queda pendiente |
| `advance` | avanza la línea de notas del instrumento activo |
| `trigger` | activa el pendiente (liberando el anterior) y dispara |
| `step(index)` | un step del secuenciador: `advance` + `trigger` si el step está encendido |
| `releaseInstrument` | suelta todo (útil para stop) |

Esto implementa la decisión: **re-evaluar un instrumento cambia en el siguiente trigger**
del track. La voz vieja se libera ahí mismo.

## 4. Cableado (2b)

| Archivo | Cambio |
|---|---|
| `CaosGear.sc` | `bass`, `bass2`, `pad`, `pad2`, `chords`, `chords2`, `lineIn` construyen un `CaosInstrument`, lo registran en `~cbox_instruments` y en su track. Sin Tdefs ni globals. Todos en `oneShot: true` (CaosPercLib usa `Env.perc`); `retrigger:`/`oneShot:` quedan disponibles para SynthDefs propios. |
| `CaosGear.sc` (percusión) | `kick`, `kick2`, `snare`, `snare2`, `hihats`, `hihats2` + variantes `*Custom` devuelven un `CaosInstrument` (`\function`) y lo registran; los steps siguen guardando la **función** capturada (snapshot, compat con `~cbox_b` y CodePads). |
| `CaosGear.sc` (`toTrack`) | usa `instrument.track` en vez del `switch` de 13 strings; sin instrumento informa en lugar de romper. `offTrack` sin argumentos limpia la pista completa; `toTrack()` sigue encendiendo el step 0. |
| `CB/CaosBox-vars.scd` | `~cbox_instruments = Dictionary.new` |
| `CB/CaosBox-defaults.scd` | se elimina `~cbox_sintetizadores` (el switch que creaba synths) |
| `CB/CaosBox-seq.scd` | las 7 pistas melódicas son `~cbox_tracks[track].step(~cbox_indice)` |
| `GUI/CaosBox-GUI_2.scd` | los checkboxes solo escriben el modelo; los knobs llaman `~cbox_param.value(track, key, valor)`, que hace `instrument.set` si la voz existe |
| `GUI/CaosBox-GUI_3.scd` | igual para `lineIn` |

`CaosGear.bassCustom` queda como aviso (los UGens custom no se pueden pasar a un SynthDef en
runtime); el resto de la API no cambia. `toTrack`/`offTrack` siguen usando `instance_id`
(se simplifica en 2c).

## 5. El bug del pad

Con el cableado:

1. La nota la avanza el **secuenciador** (`track.step`), no un Tdef aparte.
2. La voz es una sola (legato) o una nueva por trigger (retrigger), pero **siempre la misma
   que recibe la nota**.
3. No hay synths huérfanos: la voz anterior se libera.

Smoke test headless (sin audio), con `p.pad(50, [48,50,52])`:

```
step 0 → note 48, node 1000, playing
step 0 → legato: mismo node, note 50
re-evaluar pad → pending, la vieja sigue
step 0 → swap: la vieja se libera, nueva note 60, node 1001
```

### 5.1 Regresión detectada en la prueba de audio: fuga de nodos

Al dejar correr solo `.bass`, el server empezó a tirar:

```
FAILURE IN SERVER /s_new too many nodes
FAILURE IN SERVER /n_set Node 5094 not found
```

**Causa:** `\bajouno` y `\bajodos` declaraban `doneAction=1` (`pauseSelf`: pausa el
synth **sin liberarlo**). El modo retrigger libera la voz anterior con `gate 0`, pero al
terminar el release el nodo quedaba pausado y vivo: un nodo nuevo por step activo hasta
topar `maxNodes` (4096). Los `/n_set ... not found` son la consecuencia (los `/s_new`
fallidos nunca crearon esos nodos).

**Arreglos aplicados:**

1. `CB/CaosBox-synths.scd`: `doneAction=2` (`freeSelf`) en `\bajouno` y `\bajodos`.
2. `CaosGear.bass`/`bass2`: pasan `doneAction: 2` explícito en `params`.
3. `CaosInstrument` gana `oneShot`: las voces con envolvente percusiva (`\entrada`) se
   liberan solas, así que no reciben `gate 0` ni `/n_set` (evita "Node not found" y nodos
   fantasma). `lineIn` lo usa.

**Regla para SynthDefs melódicos:** si no son one-shot, deben liberar el nodo al recibir
`gate 0` (`doneAction: 2`). Si no, cada trigger deja un nodo colgado.

Después del arreglo hay que **reiniciar el server** (o `s.freeAll`) para limpiar los nodos
acumulados antes de volver a probar.

### 5.2 Segunda regresión: el pad y los `/n_set` a un nodo muerto

Al sumar `.pad` apareció `FAILURE IN SERVER /n_set Node 2581 not found` repetido.
`CaosEnv.envKR` usa `Env.perc` (one-shot): la voz del pad suena `att+rel` y **se libera
sola**, aunque el gate siga en 1. Como el instrumento estaba en legato, seguía mandando
`/n_set \note` a un nodo que ya no existía (y el pad solo sonaba una vez).

Arreglo: **todos los instrumentos melódicos de CaosPercLib van en `oneShot: true`**:

* `trigger` crea siempre una voz nueva con la nota vigente;
* `advance` solo mueve la nota interna (no manda `/n_set`);
* `set` (knobs) solo guarda params para el siguiente trigger;
* `release`/`free` no tocan el nodo: lo libera el envelope.

`legato` queda en la clase para SynthDefs sostenidos (`Env.asr`), pero no aplica a
CaosPercLib.

## 6. Tests

| Suite | Tests | Aserciones |
|---|---|---|
| `TestCaosTrack` | 22 | 55 |
| `TestCaosInstrument` | 26 | 77 |
| `TestCaosGear` | 16 | 45 |
| **Total** | | **177, 0 fallos** |

Todo headless: `CaosInstrument` habla contra un output inyectable (`CaosTestOutput`), así que
se verifican los mensajes OSC sin server ni GUI. Además: class library compila y las 12
`.scd` parsean.

## 7. Limitaciones conocidas

* Los knobs aplican al instrumento **si ya existe**; si mueves el knob antes de crear el
  instrumento, ese valor no se hereda (crea primero, ajusta después). En one-shot, el knob
  entra en el siguiente trigger: no cambia un golpe que ya está sonando.
* Con `Env.perc` (todos los instrumentos actuales) no hay legato posible: cada disparo es
  una voz con ataque y caída. Para pads sostenidos haría falta un SynthDef con `Env.asr`
  (pendiente, si se quiere).
* `chordsArray` y `waveform` siguen sin efecto: los SynthDefs los ignoran (el acorde y el
  oscilador se eligen en build-time). Es deuda de CaosPercLib/SynthDefs, no del modelo.
* `lineIn`/`chords2` aceptaban `out` como array (bus aleatorio por step); ahora se usa el
  primer elemento.
* `CodePads/CaosBox_liveCodePad-default.scd` sigue escrito para globals (`~cbox_bass`, …):
  es documentación viva que hay que actualizar.
* `bassCustom` ya no puede inyectar un UGen custom; avisa y delega en `bass`.

## 8. 2c aplicado: percusión

* `kick`, `kick2`, `snare`, `snare2`, `hihats`, `hihats2` (+ variantes `*Custom`) devuelven
  un `CaosInstrument` (`kind: \function`) y lo registran en `~cbox_instruments`. Los steps
  siguen guardando la **función** capturada en el snapshot (compatibilidad con `~cbox_b` y
  con el flujo de CodePads).
* `toTrack`/`offTrack` ya no son un `switch` de 13 strings: usan `instrument.track`. Si el
  `CaosGear` no creó instrumento, informan en vez de romper.
* `offTrack` sin argumentos ahora **limpia la pista completa** (antes apagaba el step 0).
  `toTrack()` sigue encendiendo el step 0.
* `CaosGear` guarda su `instrument`; `instance_id` se conserva para los mensajes.

## 9. Changelog sugerido (v2.1.1)

```markdown
### v2.1.1
- New Classes:
    - CaosInstrument
        - Voice model: \synth (persistent) and \function (percussion)
        - \free / \trig note advance, legato or retrigger, one-shot voices
        - Speaks OSC through an injectable output
    - TestCaosInstrument, TestCaosGear
        - 35 headless tests (no Server, no GUI)
- Melodic instruments now live in ~cbox_instruments and are owned by their track
- Removed ~cbox_sintetizadores, the melodic Tdefs and their globals
- Fixed: pad did not iterate its note array and leaked one Synth per active step
- Fixed: bass/bass2 used doneAction 1 (pause) and leaked a node per trigger
- Fixed: melodic voices were poked with /n_set after their one-shot envelope freed them
- One-shot voices (all CaosPercLib instruments) never receive gate/release messages
- Percussion instruments are now CaosInstrument handles (\function kind)
- toTrack/offTrack use the instrument's track: the 13-branch string switch is gone
- offTrack with no argument clears the whole lane
- Knobs update the instrument instead of being read by the sequencer
```
