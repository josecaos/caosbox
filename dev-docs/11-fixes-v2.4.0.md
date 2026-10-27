# Fixes v2.4.0 (rama dev)

> Trabajo de la sesión posteriores al tag v2.4.0: MIDI, close, B4/B5 y docs.
> Todo validado sin servidor de audio; falta la prueba de oído.

## 1. MIDI: de `MIDIIn.control` a `MIDIFunc.cc`

`CB/CaosBox-midi.scd` se reescribió con **un `MIDIFunc.cc` por CC** y un helper
`~cbox_midi_apply`. Se mantiene el mapa histórico del **M-Audio Xsession Pro**:

| CC | Destino | Parámetro |
|---|---|---|
| 12 | master | vol |
| 26 / 25 / 24 | master | below / relaxTime / limit |
| 29 / 28 / 27 | reverb | mix / room / damp |
| 11 / 14 | delay | deltime / delfeed |
| 36 / 35 / 34 | pitch | pitch / pitchDispersion / timeDispersion |
| 33 / 32 / 31 | LPF / BPF / HPF | cutfreq |
| 20 / 17 | granulator | trigger / size |
| 15 | granulator | reverse (size+trigger) |

* **Bug corregido**: CC 11 mandaba `\delaytime`; el SynthDef usa `\deltime`.
* Cada callback actualiza el nodo sólo si existe y la vista con `.defer`.
* `~cbox_midi_funcs` guarda los `MIDIFunc`; `~cbox_midi_free` los libera.
* `CaosBox.close` llama a `~cbox_midi_free` antes de liberar el engine.
* Pendiente: migrar los destinos de `~cbox_*fader` al registro `CaosBox.gui`.

## 2. B18: `close` ya no borra Tdefs ajenos

`CaosBox.close` reemplazó `Tdef.removeAll` por una lista explícita:
`\secuencias`, `\autor`, `\autod`, `\autop`, `\autog`, `\autolpf`, `\autohpf`,
`\autobpf`. El resto de Tdefs del usuario queda intacto.

## 3. B4/B5: acorde y waveform eligen variante

`CB/CaosBox-synths.scd` genera variantes con un loop:

* **pad**: `ambuno_sin`, `ambuno_tri`, `ambuno_pulse` (+ `\ambuno` como alias
  histórico de sin).
* **chords**: `acordesuno_<acorde>` para `M, m, M7, m7, Mmaj7, mmaj7, 5dim7, 5aug7`
  (+ `\acordesuno` alias de M).
* **chords2**: `acordesdos_<acorde>` para `M, m, M7, m7, Mmaj7, mmaj7, M9, M9m,
  m9, m9m` (+ `\acordesdos` alias de M).

`CaosGear.pad(waveform: ...)` y `CaosGear.chords(chordsArray: [...])` validan el
valor y eligen el SynthDef al **crear la voz**. Si el valor no existe, avisan y
caen en `sin`/primer acorde.

Limitación documentada: `set(\chord, ...)` o `set(\waveform, ...)` no cambia el
SynthDef ya creado. Para cambiar el timbre hay que recrear el instrumento
(`CaosGear.new.pad(...)` / `.chords(...)`); una selección dinámica con `Select`
queda para la fase de timbre.

## 4. Docs

Se agregaron `.schelp` iniciales en `HelpSource/Classes/` para:
`CaosBox`, `CaosGear`, `CaosTrack`, `CaosInstrument`, `CaosEngine`,
`CaosSequencer`, `CaosStepGrid`, `CaosBoxGUI`.

Siguen pendientes: tests con server/audio, completar los `.schelp` con ejemplos
más largos, limpiar `DevTest/legacy`, y actualizar README/API al cierre de 2.4.0.

## Verificación

* Compila; 14 `.scd` parsean.
* Suite headless: **288 aserciones, 0 fallos** (se sumaron tests de variantes
  `waveform`/`chordsArray`).
* `CB/CaosBox-synths.scd` construye las variantes sin servidor.
* MIDI: sin dispositivo en el sandbox; validado por sintaxis y revisión del mapa.
