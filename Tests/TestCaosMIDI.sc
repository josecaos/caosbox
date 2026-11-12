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
