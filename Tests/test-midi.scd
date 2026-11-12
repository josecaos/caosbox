// CaosBox v2.7.0 - MIDI smoke test (hardware)
//
// Este test necesita un dispositivo MIDI real. No es UnitTest porque depende
// de ALSA/JACK y de escuchar el sonido.
//
// Antes de correrlo:
//   1. Conectá el sinte externo.
//   2. Ajustá deviceName, channel y note.
//
// En Linux `CaosMIDI.out` crea la conexión ALSA/JACK automáticamente. Los otros
// dos caminos sirven para comparar el puerto y el uid directo; si usás esos,
// revisá el patchbay.
//
// El test deja el monitor de entrada prendido para mover perillas/teclas.

(
var deviceName = "CH345"; //TD-3
var channel = 0;
var note = 60;
var velocity = 100;
var close = 64;
var destinations, deviceIndex, m, byPort, byName;

CaosMIDI.start(false);
destinations = CaosMIDI.destinations;
deviceIndex = destinations.detectIndex {|ep| ep.device == deviceName };

if(deviceIndex.isNil, {
    ("MIDI smoke: no destination named " ++ deviceName).warn;
    0.exit;
});

("MIDI smoke: device=" ++ deviceName ++ " index=" ++ deviceIndex).postln;
("MIDI smoke: myoutports=" ++ MIDIClient.myoutports).postln;
("MIDI smoke: connect SuperCollider out" ++ deviceIndex ++ " -> " ++ deviceName).postln;

m = CaosMIDI.out(deviceName, channel);
byPort = MIDIOut.new(deviceIndex, 0);
byName = MIDIOut.newByName(deviceName, destinations[deviceIndex].name);

Routine {
    "MIDI smoke: 1) CaosMIDI.out".postln;
    m.noteOn(note, velocity);
    0.35.wait;
    m.noteOff(note, close);
    1.wait;

    "MIDI smoke: 2) MIDIOut by port".postln;
    byPort.noteOn(channel, note, velocity);
    0.35.wait;
    byPort.noteOff(channel, note, close);
    1.wait;

    "MIDI smoke: 3) MIDIOut by uid".postln;
    byName.noteOn(channel, note, velocity);
    0.35.wait;
    byName.noteOff(channel, note, close);
    1.wait;

    "MIDI smoke: input monitor on; move knobs/keys now".postln;
    CaosMIDI.monitor(true);
    10.wait;
    CaosMIDI.monitor(false);

    "MIDI smoke: done".postln;
}.play(AppClock);
)
