# MIDI clock maestro (v2.7.3)

## 1. Objetivo

Que CaosBox mande el reloj a un equipo externo y lo mantenga en tempo con la
caja, respetando el BPM y el tiempo aleatorio. El TD-3 (o cualquier equipo que
siga MIDI clock) queda sincronizado con la secuencia.

## 2. API

```supercollider
CaosMIDI.attachMasterSync("CH345");
CaosMIDI.detachMasterSync("CH345");
```

- `attachMasterSync` devuelve un `CaosMIDIClock`; adjuntar la misma salida dos
  veces devuelve el mismo tap.
- El dispositivo puede ser endpoint, índice de `CaosMIDI.destinations`, nombre
  o uid.
- La salida se abre y conecta con `CaosMIDI.out`, igual que el resto de la capa
  MIDI.
- `detachMasterSync` detiene los ticks y manda Stop.

## 3. Comportamiento

- **24 ppqn** sobre `TempoClock.default`: sigue el BPM y el modo de tiempo
  aleatorio sin cálculos de segundos.
- **Clock continuo** mientras el tap está adjunto. Aunque la caja esté parada,
  el equipo externo mantiene el pulso; el transporte lo manejan Start/Stop.
- **Transporte**
  - `CaosBox.play` manda Start, o Continue si venía de una pausa.
  - `CaosBox.pause` y `CaosBox.stop` mandan Stop.
  - Al adjuntar mientras la caja ya está sonando, manda Start.
  - Si el tap nunca mandó Start/Continue (por ejemplo, se adjuntó en pausa),
    al reanudar manda Start en lugar de Continue para no dejarlo parado.
- **Varios destinos**: se pueden adjuntar varias salidas; todas reciben el
  mismo reloj y transporte.
- **Cierre**: `CaosMIDI.free` y `CaosBox.close` detienen los taps y mandan Stop.

## 4. Scheduler

Los ticks se agendan en **beats absolutos** con
`TempoClock.default.schedAbs`, separados por `1/24` de beat. Cada callback manda
`midiClock` y agenda el siguiente; así no se acumula drift por waits relativos.

Queda el jitter normal de sclang (unos milisegundos), porque el reloj sale del
lenguaje, no de un proceso de audio. Para el TD-3 suele alcanzar; no es
sample-accurate.

El `CaosMIDIClock` usa una generación interna: al detener o reiniciar, los
callbacks viejos se ignoran aunque lleguen a dispararse.

## 5. Implementación

- `CaosMIDIOut`: `midiClock`, `start`, `stop`, `continue`.
- `CaosMIDIClock`: `out`, `clock`, `start`/`stop` de ticks, `sendStart`/
  `sendStop`/`sendContinue`, `free`, scheduler absoluto.
- `CaosMIDI`: `masterSyncs`, `attachMasterSync`, `detachMasterSync`,
  `startMasterSyncs`, `stopMasterSyncs`; `free` limpia los taps.
- `CaosBox.play`/`pause`/`stop`: leen `~cbox_seq.paused` para elegir
  Start o Continue y mandan el transporte.

## 6. Tests

- Wrapper: `midiClock`, `start`, `stop`, `continue` en el backend falso.
- `CaosMIDIClock`: transporte, agenda del primer tick, distancia de `1/24`,
  corte al detener, Stop al liberar.
- Transporte a varios taps: Start, Continue y Stop.
- `CaosBox.play`/`pause`/`play`: Start, Stop y Continue en el tap falso.
- Resume sin Start previo: el tap manda Start y queda marcado como iniciado.
- Smoke con `TempoClock.default`: ~49 ticks en 1 s a 120 BPM, ~96 a 240 BPM,
  0 ticks después de detener, y Stop al liberar.
- Suite completa: **619 aserciones, 0 fallos**.

## 7. Uso típico

```supercollider
CaosBox.environment;
CaosMIDI.devices;

CaosMIDI.attachMasterSync("CH345");
CaosBox.play;

CaosBox.stop;
CaosMIDI.detachMasterSync("CH345");
```

## 8. Pendiente

- **Slave sync**: que CaosBox siga el clock de un equipo externo
  (`attachSlaveSync` / `detachSlaveSync`). Toca el dueño de `TempoClock`, el
  transporte y `randomTime`; va en su propia fase.
- Song position pointer al reanudar.
- MMC y swing/divisiones de clock.
- Evaluar si hace falta compensar latencia del equipo externo.

## 9. Notas

- El clock no manda notas ni cambios de programa; solo reloj y transporte.
- Si MIDI no está disponible, `attachMasterSync` avisa y devuelve `nil`.
- El clock sigue corriendo durante `CaosBox.pause`; el equipo externo queda
  detenido hasta el próximo Continue.
- No se tocó el CHANGELOG: se arma aparte con el usuario.
