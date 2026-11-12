# MIDI foundation (v2.7.0)

> Primera capa de MIDI: dispositivos, conexión y salida. Sin tracks todavía.

## 1. Alcance

* `CaosMIDI`: infraestructura de MIDI.
* `CaosMIDIOut`: wrapper de salida con canal y validación.
* `CaosMIDI.start`: inicializa el cliente y no conecta por defecto.
* El bootstrap legacy de `CB/CaosBox-midi.scd` usa
  `CaosMIDI.start(autoConnect: true)` para mantener XSession como hasta ahora.
* Si MIDI no está disponible, avisa y sigue; no bloquea el arranque.
* Monitor de consola y `panic` básicos.

No incluye todavía:

* tracks enviando MIDI;
* teclado MIDI;
* mapeo configurable/learn;
* clock;
* persistencia.

## 2. API

```supercollider
CaosMIDI.start;                    // init, selección manual
CaosMIDI.connect("Xsession");
CaosMIDI.connectAll;

CaosMIDI.devices;                  // inputs + destinations
m = CaosMIDI.out("BassStation", 1);
m.noteOn(48, 100);
m.noteOff(48);

CaosMIDI.panic;
CaosMIDI.monitor(true);
CaosMIDI.free;
```

## 3. Decisiones

1. `autoConnect` queda en `false` por defecto: evita pisar controladores.
2. El arranque actual pasa por `CaosMIDI.start(autoConnect: true)` sólo como
   compatibilidad temporal con el mapa XSession.
3. `CaosMIDIOut` no hereda de `MIDIOut`; lo envuelve. Así se puede inyectar un
   backend falso en tests.
4. Los enteros se interpretan como **índice de la lista** correspondiente
   (inputs o destinations); también se aceptan endpoint, nombre y uid.
5. `panic` recorre los outputs cacheados y manda all-notes-off.
6. El monitor es de consola; no hay GUI todavía.
7. `CaosBox.close` llama a `CaosMIDI.free`.

## 4. Implementación

* `Classes/CaosMIDI.sc`
* `Classes/CaosMIDIOut.sc`
* `CB/CaosBox-midi.scd` registra el mapa y usa
  `{ CaosMIDI.start(autoConnect: true) }.defer(0.1)` para no bloquear la
  bienvenida.
* `CaosBox.close` libera MIDI.
* Tests de `CaosMIDIOut` con backend falso; `TestCaosMIDI`.

## 5. Tests

* Suite completa: **515 aserciones, 0 fallos**.
* Arranque sin hardware: `CaosMIDI.start(false)` avisa y sigue; inputs/outputs
  quedan vacíos.
* Hardware real: el usuario confirmó que `CaosMIDI.out("CH345", 0)` hace sonar
  la TD-3 sin conexión manual: en Linux crea el puerto y la conexión ALSA/JACK
  automáticamente. `Tests/test-midi.scd` conserva las pruebas de puerto/uid
  para diagnóstico.
* `Tests/test-midi.scd` deja el monitor de entrada diez segundos para mover
  perillas/teclas.
* En Linux `CaosMIDI.out` llama a `MIDIOut.connect` y deja la conexión ALSA/JACK
  hecha; ya no hace falta el patch manual para la salida.

## 6. Siguiente

* Out por track (tap de trigger + note map para percusión).
* Entrada de teclado con velocity.
* Mapeo/learn/persistencia.
* Clock.
