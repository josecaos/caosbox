# MIDI out por track (v2.7.1)

## 1. Objetivo

Enviar la secuencia de una pista a un sinte externo **sin quitar** la voz de
audio de CaosBox. La pista suena por los dos caminos.

## 2. API

```supercollider
CaosMIDI.attachOut(\kick, "CH345", 0, note: 36);
CaosMIDI.attachOut(\bass, "CH345", 0);
CaosMIDI.detachOut(\kick);
```

- `note:` es obligatorio en percusión y opcional en melódicos.
- Melódicos usan `CaosInstrument.note` actual.
- `velocity` default 100, por tap.
- Cada track tiene un solo tap; adjuntar otro reemplaza el anterior.
- `panic` al `CaosBox.stop` y `free` al `close`.

## 3. Flujo

1. `CaosTrack.step` dispara la voz de audio.
2. Sólo si realmente disparó, llama `onTrigger`.
3. `CaosMIDITrackOut` toma la nota:
   - percusión: `noteNumber`;
   - melódico: `voice.note`.
4. Si había una nota anterior, manda `noteOff`.
5. Manda `noteOn` con velocity.
6. El próximo trigger repite el ciclo; `panic` cierra la última nota.

No se dispara con probabilidad fallida ni steps apagados. **Sí** sigue el
comando cuando el audio está muteado o soleado: el tap escucha `onCommand`, no
el trigger de audio. Las repeticiones del repeater no generan notas MIDI extra
en esta primera versión.

## 4. Implementación

* `CaosTrack.onTrigger` y `prTriggered`.
* `CaosMIDITrackOut`: escucha el callback, guarda `lastNote`, manda noteOn/off.
* `CaosMIDI.attachOut`/`detachOut`: resuelven track, crean/reutilizan el
  `CaosMIDIOut` y registran el tap.
* `CaosMIDI.panic` incluye los taps.
* `CaosMIDI.free` los libera.
* `CaosBox.stop` llama a `CaosMIDI.panic`.
* Tests con un sink MIDI falso; no requieren hardware.

## 5. Tests

* `TestCaosTrack`: `onTrigger` sólo en audio audible; `onCommand` sobrevive al
  mute de audio y sigue respetando la probabilidad.
* `TestCaosMIDI`: note map de percusión, noteOff en el próximo trigger,
  nota melódica, MIDI bajo mute de audio y liberación del callback.
* Suite completa: **530 aserciones, 0 fallos**.

## 6. Pendiente

* MIDI para las repeticiones del repeater.
* Velocidad por step o por instrumento.
* Note length configurable; por ahora noteOff en el próximo trigger.
* Teclado MIDI, mapeo/learn y clock siguen en las próximas fases.
