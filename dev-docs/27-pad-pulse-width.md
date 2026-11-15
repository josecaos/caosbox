# Pad `pulse`: ancho de pulso en 0

## Sintoma

Un pad declarado con `waveform: \pulse` quedaba mudo. Tambien quedaba mudo
despues de:

```supercollider
q = p.pad(\master);
q.updateTimbre(waveform: \pulse);
```

Con `\sin` y `\tri` funcionaba. No era un problema de `\pad` contra `\amb`:
la voz se registra en la pista `\amb` y `CaosMIDI.prResolveTrack(\pad)` la
resuelve correctamente.

## Causa

`CaosPad.signal` (CaosPercLib) usa el argumento `phase` para los tres
osciladores:

```supercollider
sig = osc[waveindex].ar(Mix([note.midicps, (note+semi).midicps]), phase, amp);
```

Pero en SuperCollider 3.14 `Pulse` no tiene argumento de fase: su firma es
`Pulse.ar(freq, width, mul, add)`. El tercer argumento de `CaosPad` es `amp`,
asi que `Pulse` recibe:

- `freq`: la mezcla de notas,
- `width`: el valor de `iphase`,
- `mul`: `amp`.

Con `iphase: 0` (el default de `pad`) el ancho de pulso es 0: la onda queda
plana y el pad no suena. El codigo de `CaosPad` intenta evitarlo con
`if(phase == 0, { phase = 0.25 })`, pero `phase` es un control de SynthDef,
no un numero; la condicion se compila como UGen y la asignacion no se ejecuta.

Comprobacion offline con `scsynth -N`: `ambuno_pulse` con `iphase: 0` da
amplitud maxima 0; con `iphase: 0.25` da 0.262. `ambuno_sin` da 0.421.

## Arreglo

Se normaliza el ancho solo para el pad pulse:

- `CaosGear.padPulseWidth(value)`: devuelve `0.25` cuando el valor es 0;
  conserva cualquier valor explicito.
- `CaosInstrument` corrige el parametro `iphase` al construir una voz con el
  SynthDef `\ambuno_pulse` y al cambiar a ese timbre con `updateTimbre`.
- `CaosGear.updateTimbre`: atajo que delega en el ultimo instrumento creado.
  Antes `p.updateTimbre(...)` sobre un `CaosGear` lanzaba
  `MessageNotUnderstood`; ahora actualiza el instrumento y devuelve el gear.

Uso recomendado:

```supercollider
q = p.pad(\master);
q.updateTimbre(waveform: \pulse); // q.params[\iphase] queda en 0.25
```

Tambien se puede pasar un ancho propio:

```supercollider
q = p.pad(\master, iphase: 0.1);
q.updateTimbre(waveform: \pulse); // conserva 0.1
```

## Chords y chords2

Se revisaron `CaosChords` y `CaosGuitChords`:

- `chords` usa `LFPulse.ar(freq, iphase, width, amp)`: ahi `iphase` si es fase
  y `width` es independiente; el default `iphase: 0.025` es valido.
- `chords2` usa `SinOsc`, `LFTri` y `Saw`; no hay ancho de pulso que pueda
  quedar en 0.
- Las variantes `acordesuno_*` y `acordesdos_*` renderizadas offline tuvieron
  amplitud no nula.
- El silencio de `chords`/`chords2` venia del mismo error de uso:
  `p.updateTimbre(...)` sobre el `CaosGear` en vez del instrumento devuelto.
  El nuevo atajo de `CaosGear` cubre ese caso.

## Pruebas

- `TestCaosGear`: ancho audible al crear pad pulse; delegado de `updateTimbre`
  para pad, `chords` y `chords2`.
- `TestCaosInstrument`: construccion pulse con `iphase: 0`, `updateTimbre` a
  pulse y conservacion de un ancho explicito; el mensaje OSC lleva
  `iphase, 0.25`.

Resultado: 658 aserciones, 0 fallos.
