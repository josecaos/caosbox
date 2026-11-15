# Delay: rangos, suavizado y modo metrico

## Sintomas

- Al automatizar `deltime` aparecian chasquidos; a veces el delay se volvia
  inestable y saturaba.
- El GUI, la API y el mapeo MIDI no coincidian:

  - la API permitia `deltime` hasta 4, pero `CombC` tenia `maxdelaytime: 1`;
  - el fader de feedback multiplicaba por 4, pero el number box volvia a
    multiplicar por 4 al editar;
  - el mapeo MIDI mandaba 0..1 para `delfeed`, mientras el GUI mostraba
    0..4.

- El boton `CombC / CombL` no se notaba. A tiempo de delay entero, ambos UGens
  leian exactamente la misma muestra; la diferencia solo aparecia con tiempos
  fraccionarios o modulados. Con los tiempos de la automatizacion
  (`0.01, 0.02, ...`), que son multiplos exactos de muestras a 44.1/48 kHz,
  el switch elegia dos señales identicas.

## Rangos

`CaosBox` expone:

```supercollider
CaosBox.delayTimeMin;   // 0.005
CaosBox.delayTimeMax;   // 8.0
CaosBox.delayDecayMax;  // 4.0
```

`delfeed` es **decay time en segundos**, no un coeficiente de feedback.
El buffer de 8 s alcanza figuras largas a tempos normales; a 20 BPM un 1/1
dura 12 s y se recorta a 8 s.

## SynthDef `\aux2`

- Un solo `CombC`, sin `CombL` ni `XFade2`.
- `deltime` y `delfeed` pasan por `Lag` (80 ms). Asi los cambios de tiempo
  no producen clicks; el delay hace un pequeño glissando.
- `deltime` se limita a 0.005..8; `delfeed` a 0..4.
- El modo libre/metrico se resuelve en sclang; al Synth solo llega el tiempo
  en segundos.

## Modo metrico

El boton de division cicla por:

```text
1/1, 1/2, 1/4, 1/4T, 1/8, 1/8T, 1/16, 1/16T, 1/32, 1/32T, Free
```

El default es `1/4`. Free queda al final. En modo metrico el `NumberBox`
muestra el nombre de la figura; en Free muestra segundos y el fader vuelve a
mandar.

El tiempo se calcula una vez por step del secuenciador:

```text
segundos = (60 / TempoClock.default.tempo) * beats
```

No hay calculo por muestra ni UGens nuevos. Si cambia el BPM, el random time o
el clock externo, el siguiente step reajusta el delay.

## Automatizacion

En Free, `~cbox_autodelaytime` sigue significando segundos.

En metrico, cada valor de la automatizacion se cuantiza a la figura mas cercana
segun el BPM actual. Asi la automatizacion sigue funcionando sin romper la
cuadricula. La comunicacion directa de figuras desde la API queda pendiente.

## GUI, API, automatizacion y MIDI

- GUI:
  - el boton elige figura o Free;
  - el NumberBox muestra figura en metrico y segundos en Free;
  - el fader de tiempo queda deshabilitado en metrico.
- `CaosBox.fx('delay', time, decay)`:
  - valida 0..8 s y 0..4 s;
  - en Free manda el tiempo; en metrico cuantiza a la figura mas cercana;
  - manda el cambio al Synth, no solo al GUI.
- `autoFx('delay', ...)`: cuantiza el tiempo en metrico y actualiza el decay.
- MIDI CC11 y CC14: tiempo 0..8 y decay 0..4; CC11 cuantiza en metrico.

## Pruebas

- Rangos, default 1/4 y 1/4T.
- Cuantizacion a la figura mas cercana.
- API de delay en Free: fader normalizado y envio al Synth.
- Suite completa: 684 aserciones, 0 fallos.
