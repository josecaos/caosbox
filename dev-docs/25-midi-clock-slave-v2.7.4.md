# MIDI clock esclavo (v2.7.4)

## 1. Objetivo

Que CaosBox siga el clock de un equipo externo: tempo y transporte. La caja deja
de mandar el tempo y pasa a obedecer los 24 ppqn y los mensajes Start/Stop/
Continue del maestro.

## 2. API

```supercollider
CaosMIDI.attachSlaveSync("USB MIDI Interface");
CaosMIDI.detachSlaveSync;
```

- Una sola fuente de clock; adjuntar otra reemplaza la anterior.
- El dispositivo puede ser endpoint, índice de `CaosMIDI.inputs`, nombre o uid.
- La entrada tiene que estar conectada; el bootstrap de CaosBox ya hace
  `connectAll`.
- `attachSlaveSync` devuelve un `CaosMIDISlaveSync`.

## 3. Tempo

- Se miden los intervalos entre ticks de `midiClock`.
- Ventana de **24 intervalos** (un beat); el tempo se actualiza una vez por beat.
- `bpm = 60 / (promedio * 24)`, limitado a 20–300 BPM.
- Suavizado exponencial (25% del valor nuevo) para no saltar con el jitter.
- `TempoClock.tempo` usa el valor fino; la GUI y `CaosSequencer.bpm` usan el
  entero redondeado.
- Si hay un hueco de más de 0.5 s, se reinicia la medición y no se mezcla ese
  intervalo con los anteriores.

## 4. Transporte

- **Start**: `CaosBox.stop` y después `CaosBox.play`. Reinicia en el paso 0 y
  manda Start a los clocks maestros si la caja también es maestra.
- **Stop**: `CaosBox.pause`. Conserva el paso para que Continue pueda reanudar.
- **Continue**: `CaosBox.play`. Reanuda desde el paso actual y manda Continue a
  los maestros.
- Start/Stop/Continue reinician la medición de tempo para no arrastrar
  intervalos del hueco.

## 5. Convivencia con la caja

- `CaosSequencer.externalClock = true` mientras el slave está adjunto:
  - `prApplyTempo` no escribe `TempoClock.tempo`;
  - `bpm` y `onTempoChange` siguen funcionando (la GUI muestra el tempo externo);
  - `randomTime` se ignora en `prWait`.
- Al adjuntar se guarda el estado de `randomTime` y se apaga (con su botón).
- Al soltar se restaura `randomTime`, se apaga `externalClock` y se reaplica el
  BPM guardado.
- `CaosMIDI.free` y `CaosBox.close` también sueltan el slave.

## 6. Implementación

- `CaosMIDISlaveSync`
  - `install(srcID)`: `MIDIdef.midiClock`, `MIDIdef.start`, `MIDIdef.stop`,
    `MIDIdef.continue`.
  - `handleClock`, `handleStart`, `handleStop`, `handleContinue`.
  - medidor con ventana móvil, suavizado y límites.
- `CaosMIDI`: `slaveSync`, `attachSlaveSync`, `detachSlaveSync`; `free` lo
  suelta.
- `CaosSequencer`: `externalClock` y los ajustes en `prApplyTempo`/`prWait`.
- El transporte es inyectable (`transport`), así los tests no tocan la GUI ni el
  secuenciador real.

## 7. Tests

- Estimación: 25 ticks sintéticos a 126 BPM dan `TempoClock` ≈ 2.1 y
  `seq.bpm` 126.
- Transporte: Start → stop/play; Stop → pause; Continue → play.
- `CaosSequencer.externalClock`: con el flag prendido el BPM no pisa el
  `TempoClock`; al apagarlo vuelve a mandar la caja.
- Suite completa: **627 aserciones, 0 fallos**.

## 8. Pendiente

- Probar con hardware real que mande clock (DAW, MPC, otro secuenciador). El
  TD-3 como maestro no está confirmado.
- Song position pointer al reanudar.
- MMC y swing/divisiones de clock.
- Evaluar si conviene seguir también el tempo con la caja parada o solo al
  arrancar.

## 9. Notas

- El slave no manda clock; solo escucha. Se puede combinar con
  `attachMasterSync` si se quiere repetir el clock externo, pero el transporte
  puede rebotar si hay un lazo MIDI.
- Con `randomTime` encendido antes de adjuntar, se apaga mientras dura el slave
  y se restaura al soltar.
- No se tocó el CHANGELOG.
