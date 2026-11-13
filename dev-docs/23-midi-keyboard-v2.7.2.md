# Teclado MIDI (v2.7.2)

## 1. Objetivo

Tocar la voz de una pista melódica desde un teclado MIDI sin detener la
secuencia. La pista sigue sonando igual, el teclado es un ataque más sobre la
misma voz y no hace falta hardware especial para probarlo.

## 2. API

```supercollider
CaosMIDI.attachIn(\bass, "USB X-Session", 0);
CaosMIDI.attachIn(\bass, 3);   // índice de CaosMIDI.inputs
CaosMIDI.detachIn(\bass);
```

- Sólo pistas `\live` con voz creada; percusión queda para otra fase.
- Un tap por pista: adjuntar otra entrada reemplaza la anterior.
- `channel` nil = omni.
- La entrada tiene que estar conectada. El bootstrap de CaosBox ya hace
  `connectAll`; si no, `CaosMIDI.connect(device)` antes de adjuntar.
- `attachIn` devuelve un `CaosMIDITrackIn`.

## 3. Comportamiento

- **Mono con prioridad a la última tecla.** Se guarda el orden de pulsación; al
  soltar la que manda vuelve la anterior; al soltar la última se limpia el
  estado.
- **La secuencia no se congela.** `advance` sigue moviendo la línea en cada
  step; el próximo step usa la nota de la secuencia. El teclado sirve igual con
  la secuencia parada o sin steps activos, porque dispara la voz directo.
- **Mute/solo de la pista** apagan el teclado, igual que el resto del audio de
  esa pista.
- **Velocity** escala `amp`, `amp1` y `amp2` sólo en esa nota; los `params` del
  instrumento no se modifican.
- **Panic** (`CaosBox.stop`) suelta las teclas; `free` libera los `MIDIdef` y
  `CaosBox.close` limpia todo.

## 4. Envelopes one-shot

Las voces melódicas actuales usan `Env.perc`, así que `noteOff` no corta la
cola: cada trigger crea una voz nueva y el envelope se libera solo. Sostener
una tecla no sostiene el audio, lo vuelve a atacar si la secuencia tiene gates.

Para sustain real habría que agregar SynthDefs con envelope gateado para el
teclado; es una fase aparte. El `noteOff` igual es necesario para el estado
mono y para las voces gateadas futuras.

## 5. Implementación

- `CaosInstrument`
  - `liveNote`, `liveVelocity`, `liveTrigger`.
  - `noteOn(note, velocity)`, `noteOff(note)`, `isHeld`.
  - `prTriggerSynth` usa la nota del teclado cuando `liveTrigger` está activo y
    no consume el `noteOrder` stream.
  - `prVoicePairs(factor)` / `prScaledAmp`: escala las amplitudes sin tocar
    `params`.
- `CaosMIDITrackIn`
  - `heldNotes`, `sounding`.
  - `install(srcID, channel)`: dos `MIDIdef` (noteOn/noteOff).
  - `noteOn` / `noteOff` / `releaseAll` / `free`.
  - Respeta `track.isAudible`; la voz se resuelve en cada evento contra
    `track.instrument`, así sobrevive a un cambio de timbre.
- `CaosMIDI`
  - `trackIns`, `attachIn`, `detachIn`.
  - `panic` incluye `releaseAll` de los taps.
  - `free` libera los taps.

## 6. Tests

- `TestCaosInstrument`: nota del teclado, velocity sobre `amp1`/`amp2`,
  `noteOff` one-shot sin `/n_set`, `noteOff` gateado, otra tecla no suelta la
  actual, la línea sigue avanzando y `\trig` no consume el stream.
- `TestCaosMIDI`: toca y suelta la voz, mono con vuelta a la tecla anterior,
  mute de la pista, velocity 0 como noteOff, `releaseAll` e `install`/`free`
  headless.
- Suite completa: **583 aserciones, 0 fallos**.
- Smoke de hardware: controlador MIDI con el bajo y los melódicos, incluida una
  canción de prueba. Percusión todavía no (es la fase siguiente).

## 7. Uso típico

```supercollider
CaosBox.environment;
CaosMIDI.devices;

CaosMIDI.attachIn(\bass, "USB X-Session", 0);
CaosBox.play;

// tocar el teclado: el bajo responde aunque no haya steps activos
CaosMIDI.detachIn(\bass);
```

## 8. Pendiente

- MIDI thru: que el teclado mande también al `attachOut` de la pista (TD-3 y
  compañía).
- Percusión por notas (nota → step) y pads.
- Sustain real con envelopes gateados.
- Pedal de sustain, bend y aftertouch.
- Polifonía.

## 9. Notas

- El teclado no dispara `onCommand`, así que en esta fase no manda al MIDI out
  del track.
- `MIDIIn` ya convierte noteOn velocity 0 en noteOff; el tap lo cubre también
  por si esa opción está apagada.
- Si se adjunta otra entrada a la misma pista, la anterior se libera.
