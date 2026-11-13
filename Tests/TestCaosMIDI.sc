// CaosBox v2.7.0 - Tests for the MIDI foundation
//
// Headless: no MIDIClient, no hardware. El wrapper de salida usa un backend
// falso, y el selector de endpoints se prueba con MIDIEndPoint reales.

TestCaosMIDI : UnitTest {

	var <out;
	var <backend;
	var <savedTracks;
	var <savedVoices;

	setUp {

		savedTracks = ~cbox_tracks;
		savedVoices = ~cbox_instruments;
		backend = CaosTestMIDIBackend.new;
		out = CaosMIDIOut.new(backend, 2);

	}

	tearDown {

		CaosMIDI.masterSyncs.clear;
		~cbox_tracks = savedTracks;
		~cbox_instruments = savedVoices;
		out = nil;
		backend = nil;

	}

	test_noteOnAndOffUseTheChannelAndVelocity {

		out.noteOn(60, 100);
		out.noteOff(60, 64);

		this.assertEquals(backend.messages[0], [\noteOn, 2, 60, 100]);
		this.assertEquals(backend.messages[1], [\noteOff, 2, 60, 64]);

	}

	test_ccProgramAndBend {

		out.cc(74, 127);
		out.program(12);
		out.bend(8192);

		this.assertEquals(backend.messages[0], [\control, 2, 74, 127]);
		this.assertEquals(backend.messages[1], [\program, 2, 12]);
		this.assertEquals(backend.messages[2], [\bend, 2, 8192]);

	}

	test_valuesAreClipped {

		out.noteOn(300, -10);
		out.cc(200, 999);
		out.bend(20000);

		this.assertEquals(backend.messages[0], [\noteOn, 2, 127, 0]);
		this.assertEquals(backend.messages[1], [\control, 2, 127, 127]);
		this.assertEquals(backend.messages[2], [\bend, 2, 16383]);

	}

	test_allNotesOff {

		out.allNotesOff;

		this.assertEquals(backend.messages[0], [\allNotesOff, 2]);

	}

	test_clockAndTransportMessages {

		out.midiClock;
		out.start;
		out.continue;
		out.stop;

		this.assertEquals(backend.messages[0], [\midiClock]);
		this.assertEquals(backend.messages[1], [\start]);
		this.assertEquals(backend.messages[2], [\continue]);
		this.assertEquals(backend.messages[3], [\stop]);

	}

	test_trackOutSendsPercussionNotesAndNoteOff {

		var sink = CaosTestMIDISink.new;
		var playable = CaosTestPlayable.new;
		var track = CaosTrack.new(\kick, \snapshot, 4, { playable });
		var tap;

		track.putStep(0, true);
		tap = CaosMIDITrackOut.new(track, sink, 36, 100);

		track.step(0);
		this.assertEquals(sink.messages[0], [\noteOn, 36, 100]);

		track.step(0);
		this.assertEquals(sink.messages[1], [\noteOff, 36]);
		this.assertEquals(sink.messages[2], [\noteOn, 36, 100]);

		tap.panic;
		this.assertEquals(sink.messages.last, [\noteOff, 36]);

	}

	test_trackOutUsesTheCurrentMelodicNote {

		var sink = CaosTestMIDISink.new;
		var voice = CaosTestNoteVoice.new(60);
		var track = CaosTrack.new(\bass, \live, 4);
		var tap;

		track.setInstrument(voice);
		track.putStep(0, true);
		tap = CaosMIDITrackOut.new(track, sink, nil, 90);

		track.step(0);

		this.assertEquals(sink.messages[0], [\noteOn, 60, 90]);

	}

	test_trackOutKeepsSendingWhenAudioIsMuted {

		var sink = CaosTestMIDISink.new;
		var track = CaosTrack.new(\kick, \snapshot, 4, { CaosTestPlayable.new });
		var tap;

		track.putStep(0, true);
		track.muted_(true);
		tap = CaosMIDITrackOut.new(track, sink, 36, 100);

		track.step(0);

		this.assertEquals(sink.messages[0], [\noteOn, 36, 100],
			"MIDI continues while the audio track is muted");

	}

	test_trackOutClearsTheTriggerCallback {

		var sink = CaosTestMIDISink.new;
		var track = CaosTrack.new(\kick, \snapshot, 4, { CaosTestPlayable.new });
		var tap;

		tap = CaosMIDITrackOut.new(track, sink, 36);
		tap.free;

		this.assert(track.onCommand.isNil, "free releases the track callback");

	}

	// ------------------------------------------------------------------
	// teclado
	// ------------------------------------------------------------------

	test_trackInPlaysAndReleasesTheVoice {

		var voice = CaosTestMidiVoice.new(\bass);
		var track = CaosTrack.new(\bass, \live, 4);
		var tap;

		track.setInstrument(voice);
		tap = CaosMIDITrackIn.new(track);

		tap.noteOn(60, 100);
		tap.noteOff(60);

		this.assertEquals(voice.calls[0], [\noteOn, 60, 100]);
		this.assertEquals(voice.calls[1], [\noteOff, 60]);

	}

	test_trackInIsMonophonicAndFallsBack {

		var voice = CaosTestMidiVoice.new(\bass);
		var track = CaosTrack.new(\bass, \live, 4);
		var tap;

		track.setInstrument(voice);
		tap = CaosMIDITrackIn.new(track);

		tap.noteOn(60, 100);
		tap.noteOn(64, 90);
		tap.noteOff(64);

		this.assertEquals(voice.calls[2], [\noteOff, 64],
			"al soltar la tecla que manda se libera esa nota");
		this.assertEquals(voice.calls[3], [\noteOn, 60, 100],
			"vuelve la tecla que seguia apretada");

	}

	test_trackInRespectsAudioMute {

		var voice = CaosTestMidiVoice.new(\bass);
		var track = CaosTrack.new(\bass, \live, 4);
		var tap;

		track.setInstrument(voice);
		tap = CaosMIDITrackIn.new(track);

		track.muted_(true);
		tap.noteOn(60, 100);

		this.assert(voice.calls.isEmpty, "el mute de la pista apaga el teclado");

		track.muted_(false);
		tap.noteOff(60);
		tap.noteOn(62, 80);

		this.assertEquals(voice.calls[0], [\noteOn, 62, 80],
			"al desmutear vuelve a sonar");

	}

	test_trackInZeroVelocityIsNoteOff {

		var voice = CaosTestMidiVoice.new(\bass);
		var track = CaosTrack.new(\bass, \live, 4);
		var tap;

		track.setInstrument(voice);
		tap = CaosMIDITrackIn.new(track);

		tap.noteOn(60, 100);
		tap.noteOn(60, 0);

		this.assertEquals(voice.calls[1], [\noteOff, 60]);

	}

	test_trackInReleaseAllAndFree {

		var voice = CaosTestMidiVoice.new(\bass);
		var track = CaosTrack.new(\bass, \live, 4);
		var tap;

		track.setInstrument(voice);
		tap = CaosMIDITrackIn.new(track);
		tap.install(0, 0);

		tap.noteOn(60, 100);
		tap.releaseAll;

		this.assert(tap.sounding.isNil, "panic suelta la nota del teclado");
		this.assertEquals(voice.calls.last, [\noteOff, 60]);

		tap.free;

		this.assert(tap.heldNotes.isEmpty, "free limpia el estado mono");

	}

	test_trackInActivatesThePendingInstrumentOnTheNextNote {

		var first = CaosTestMidiVoice.new(\bass2);
		var second = CaosTestMidiVoice.new(\bass2);
		var track = CaosTrack.new(\bass2, \live, 4);
		var tap;

		track.setInstrument(first);
		track.setInstrument(second);
		tap = CaosMIDITrackIn.new(track);

		this.assert(track.pendingInstrument === second,
			"el instrumento nuevo queda pendiente");
		this.assert(track.instrument === first, "la voz vieja sigue activa");

		tap.noteOn(60, 100);

		this.assert(track.instrument === second,
			"la tecla activa la voz pendiente");
		this.assert(track.pendingInstrument.isNil);
		this.assertEquals(second.calls[0], [\noteOn, 60, 100]);

	}

	test_trackInDoesNotSwapWhileAKeyIsHeld {

		var first = CaosTestMidiVoice.new(\bass2);
		var second = CaosTestMidiVoice.new(\bass2);
		var track = CaosTrack.new(\bass2, \live, 4);
		var tap;

		track.setInstrument(first);
		tap = CaosMIDITrackIn.new(track);
		tap.noteOn(60, 100);

		track.setInstrument(second);
		this.assert(track.instrument === first,
			"el sostenido sigue en la voz vieja");

		tap.noteOff(60);
		this.assert(track.instrument === first,
			"el noteOff tampoco hace el swap");
		this.assert(track.pendingInstrument === second);

		tap.noteOn(62, 100);
		this.assert(track.instrument === second,
			"la siguiente nota usa la voz nueva");

	}

	test_clockSendsTransport {

		var sink = CaosTestMIDIClockOut.new;
		var clock = CaosTestClock.new;
		var sync = CaosMIDIClock.new(sink, clock);

		sync.sendStart;
		sync.sendContinue;
		sync.sendStop;

		this.assertEquals(sink.messages[0], [\start]);
		this.assertEquals(sink.messages[1], [\continue]);
		this.assertEquals(sink.messages[2], [\stop]);

	}

	test_clockSchedulesTicksInAbsoluteBeats {

		var sink = CaosTestMIDIClockOut.new;
		var clock = CaosTestClock.new;
		var sync = CaosMIDIClock.new(sink, clock);

		sync.start;

		this.assertEquals(clock.pending.size, 1, "agenda el primer tick");
		this.assertEquals(clock.pending[0][0], 0, "arranca en el beat actual");

		clock.fire;
		this.assertEquals(sink.messages[0], [\midiClock]);
		this.assertEquals(clock.pending[0][0], 1 / 24,
			"el siguiente tick queda a 1/24 de beat");

		sync.stop;
		clock.fire;// el callback viejo ya no debe mandar nada
		this.assertEquals(sink.messages.size, 1, "stop corta los ticks");

	}

	test_clockFreeSendsStop {

		var sink = CaosTestMIDIClockOut.new;
		var clock = CaosTestClock.new;
		var sync = CaosMIDIClock.new(sink, clock);

		sync.start;
		sync.free;

		this.assertEquals(sink.messages.last, [\stop],
			"al soltar el clock se avisa Stop al equipo");

	}

	test_masterSyncTransportBroadcast {

		var sink = CaosTestMIDIClockOut.new;
		var clock = CaosTestClock.new;
		var sync = CaosMIDIClock.new(sink, clock);

		CaosMIDI.masterSyncs.put(\test, sync);

		CaosMIDI.startMasterSyncs(false);
		CaosMIDI.startMasterSyncs(true);
		CaosMIDI.stopMasterSyncs;

		this.assertEquals(sink.messages[0], [\start]);
		this.assertEquals(sink.messages[1], [\continue]);
		this.assertEquals(sink.messages[2], [\stop]);

	}

	test_masterSyncResumeWithoutStartSendsStart {

		var sink = CaosTestMIDIClockOut.new;
		var clock = CaosTestClock.new;
		var sync = CaosMIDIClock.new(sink, clock);

		CaosMIDI.masterSyncs.put(\test, sync);
		CaosMIDI.startMasterSyncs(true);

		this.assertEquals(sink.messages[0], [\start],
			"un resume sin Start previo arranca con Start");
		this.assert(sync.hasStarted, "el tap queda marcado como iniciado");

	}

	test_resolveTrackAcceptsSymbolsTracksAndInstruments {

		var track = CaosTrack.new(\bass2, \live, 4);
		var instrument = CaosInstrument.synth(\bass2, \bass2, \bajodos, 50, (),
			nil, \free, nil, true, \seq, true);
		var padTrack = CaosTrack.new(\amb, \live, 4);
		var pad = CaosInstrument.synth(\pad, \amb, \ambuno, 50, (),
			nil, \free, nil, true, \seq, true);

		~cbox_tracks = Dictionary[\bass2 -> track, \amb -> padTrack];
		~cbox_instruments = Dictionary[\bass2 -> instrument, \amb -> pad];

		this.assertEquals(CaosMIDI.prResolveTrack(\bass2), track,
			"un simbolo resuelve la pista");
		this.assertEquals(CaosMIDI.prResolveTrack(track), track,
			"un CaosTrack se acepta directo");
		this.assertEquals(CaosMIDI.prResolveTrack(instrument), track,
			"un CaosInstrument resuelve su pista");
		this.assertEquals(CaosMIDI.prResolveTrack(\pad), padTrack,
			"un nombre de instrumento resuelve su pista");
		this.assert(CaosMIDI.prResolveTrack(\missing).isNil,
			"una pista desconocida devuelve nil");

	}

	test_endpointSelection {

		var kick = MIDIEndPoint("Xsession", "in", 10);
		var bass = MIDIEndPoint("BassStation", "out", 20);

		this.assertEquals(CaosMIDI.prFind([kick, bass], "Xsession"), kick);
		this.assertEquals(CaosMIDI.prFind([kick, bass], 20), bass);
		this.assertEquals(CaosMIDI.prFind([kick, bass], 0), kick);
		this.assertEquals(CaosMIDI.prFind([kick, bass], 1), bass);
		this.assertEquals(CaosMIDI.prFind([kick, bass], 2), nil);
		this.assertEquals(CaosMIDI.prFind([kick, bass], "missing"), nil);

	}

}

// Backend MIDI falso: recibe las mismas llamadas que MIDIOut
CaosTestMIDIBackend {

	var <messages;

	*new { ^super.new.init }

	init {

		messages = List.new;
		^this;

	}

	noteOn {|chan, note, velocity| messages.add([\noteOn, chan, note, velocity]); ^this }
	noteOff {|chan, note, velocity| messages.add([\noteOff, chan, note, velocity]); ^this }
	control {|chan, controller, value| messages.add([\control, chan, controller, value]); ^this }
	program {|chan, value| messages.add([\program, chan, value]); ^this }
	bend {|chan, value| messages.add([\bend, chan, value]); ^this }
	allNotesOff {|chan| messages.add([\allNotesOff, chan]); ^this }
	midiClock { messages.add([\midiClock]); ^this }
	start { messages.add([\start]); ^this }
	stop { messages.add([\stop]); ^this }
	continue { messages.add([\continue]); ^this }

}


// Salida MIDI falsa para probar el tap por track
CaosTestMIDISink {

	var <messages;

	*new { ^super.new.init }

	init {

		messages = List.new;
		^this;

	}

	noteOn {|note, velocity| messages.add([\noteOn, note, velocity]); ^this }
	noteOff {|note| messages.add([\noteOff, note]); ^this }

}

// Voz melódica falsa con nota actual
CaosTestNoteVoice {

	var <note;
	var <advances;
	var <triggers;

	*new {|note| ^super.new.init(note) }

	init {|argNote|

		note = argNote;
		advances = 0;
		triggers = 0;
		^this;

	}

	advance { advances = advances + 1; ^this }
	trigger { triggers = triggers + 1; ^this }
	release { ^this }
	free { ^this }

}

// Voz falsa para el tap de teclado: guarda noteOn/noteOff
CaosTestMidiVoice {

	var <name;
	var <calls;

	*new {|name = \bass| ^super.new.init(name) }

	init {|argName|

		name = argName;
		calls = List.new;
		^this;

	}

	noteOn {|note, velocity| calls.add([\noteOn, note, velocity]); ^this }
	noteOff {|note| calls.add([\noteOff, note]); ^this }
	advance { ^this }
	trigger { ^this }
	release { ^this }
	free { ^this }

}

// Reloj falso: guarda los schedAbs y los dispara a mano
CaosTestClock {

	var <beats = 0;
	var <pending;

	*new { ^super.new.init }

	init {

		pending = List.new;
		^this;

	}

	schedAbs {|beat, func| pending.add([beat, func]); ^this }

	fire {

		var item = pending.removeAt(0);

		item !? { item[1].value };
		^this;

	}

}

// Salida falsa para el clock: solo registra los mensajes
CaosTestMIDIClockOut {

	var <messages;

	*new { ^super.new.init }

	init {

		messages = List.new;
		^this;

	}

	midiClock { messages.add([\midiClock]); ^this }
	start { messages.add([\start]); ^this }
	stop { messages.add([\stop]); ^this }
	continue { messages.add([\continue]); ^this }

}
