# Repeater por step (v2.6.8)

> API y tests cerrados.

## 1. Qué es

Un ratchet por step: el step marcado repite el sonido actual varias veces dentro
de una fracción de su duración. No es un toggle de pista y no frena el
secuenciador. Después del repeat, el secuenciador sigue normal.

```supercollider
CaosBox.repeater(\kick, [0, 4], repetitions: 4, metric: 1);
CaosBox.repeater(\bass, [8], repetitions: 2, metric: 1/2);
```

- `repetitions`: golpes **extra**. No cuenta el original. Rango `0..16`; `0`
  borra la marca.
- `metric`: fracción del step donde se reparten. Lista cerrada:
  `1, 1/2, 1/3, 1/4, 1/8`.
- `inf` no existe en este modelo porque la ventana es finita.

## 2. Tiempo

Sea `S = stepDur` (beats) y `E = repetitions`:

```text
ventana = metric * S
intervalo = ventana / E
```

Los extras caen en `intervalo, 2*intervalo... E*intervalo`. El último cae **al
final de la ventana**, como quedó decidido para que se mezcle con el próximo
step. El original está en `0`.

Ejemplo: `S = 0.25`, `E = 4`, `metric = 1/2`:

```text
0, 0.03125, 0.0625, 0.09375, 0.125 beats
```

## 3. API

```supercollider
CaosBox.repeater(\kick, [0, 4], repetitions: 4, metric: 1/2);
CaosBox.removeRepeater(\kick, [0, 4]);
CaosBox.repeaterAt(\kick, 0); // (repetitions: 4, metric: 0.5)
```

- Devuelve el `CaosTrack`.
- Acepta un índice o un array.
- Métrica inválida o repeticiones fuera de rango avisan y no tocan la pista.
- Flam y repeater son **excluyentes**: marcar uno borra el otro en ese step.
- `snapshotPattern` y `restorePattern` incluyen `repeaters`.
- `clear`, `setIndices` y `randPattern` borran los repeaters de los steps
  reemplazados.

## 4. Implementación

* `CaosTrack.repeaters`: array paralelo a `steps` y `flams`.
* `CaosTrack.repeaterMetrics`: lista de fracciones válidas.
* `CaosTrack.repeaterIntervals`: cálculo puro, testeable.
* `CaosTrack.step(index, stepDur)`: agenda los extras con
  `TempoClock.default.sched`; el original sigue disparando normal.
* `CaosBox.repeater`, `removeRepeater` y `repeaterAt`.
* `CB/CaosBox-seq.scd` pasa el `stepDur` actual del secuenciador.
* `CaosInstrument.retriggerCurrent`: repite nota y `defName` actuales sin avanzar
  la nota ni el `defStream`. Fuerza una voz nueva también en legato.
* Percusión: cada extra vuelve a llamar al mismo `value.play` con su `target`.
* Melódicos: cada extra llama a `retriggerCurrent`.
* La probabilidad se evalúa una sola vez; las repeticiones no vuelven a tirar la
  chance.
* Mute/solo se comprueban en cada golpe agendado.

## 5. Tests

- `TestCaosTrack`: guardar/quitar, intervalos, métricas inválidas, exclusividad
  con flam, snapshot/restore y limpieza al borrar el step.
- `TestCaosInstrument`: `retriggerCurrent` conserva nota y def, fuerza voz nueva
  y no avanza la secuencia de acordes.
- `TestCaosBox`: API, validación y consulta.
- Integración manual: percusión y synth repitieron 5 golpes con
  `repetitions: 4`.
- Suite completa: **500 aserciones, 0 fallos**.

## 6. GUI pendiente

- **Ctrl-click** sobre un step para marcar/desmarcar repeater.
- Tres círculos de 2, 4 y 6 px en la esquina superior derecha, en el mismo lugar
  del punto de flam.
- Flam y repeater comparten el indicador porque son excluyentes.
- La lista de métricas puede mostrarse como un menú de fracciones; el API sigue
  aceptando la fracción directamente, no un índice lineal.
