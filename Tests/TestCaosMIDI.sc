// CaosBox v2.7.0 - Tests for the MIDI foundation
//
// Headless: no MIDIClient, no hardware. El wrapper de salida usa un backend
// falso, y el selector de endpoints se prueba con MIDIEndPoint reales.

TestCaosMIDI : UnitTest {

	var <out;
	var <backend;

	setUp {

		backend = CaosTestMIDIBackend.new;
		out = CaosMIDIOut.new(backend, 2);

	}

	tearDown {

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
