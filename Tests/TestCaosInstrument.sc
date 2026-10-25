// CaosBox v2.1.1 - Tests for the instrument (voice) model
//
// Headless on purpose: no Server, no GUI. El instrumento habla OSC contra un
// output inyectable, y aqui usamos un grabador de mensajes.
//
// Desde el IDE: TestCaosInstrument.run

TestCaosInstrument : UnitTest {

	var <instrument;
	var <spy;
	var <playable;

	setUp {

		spy = CaosTestOutput.new;
		playable = CaosTestPlayable.new;
		instrument = nil;

	}

	tearDown {

		spy = nil;
		playable = nil;
		instrument = nil;

	}

	prSynth { |notes = #[48, 50, 52], params, mode = \free, retrigger = false, oneShot = false|

		^CaosInstrument.synth(\pad, \amb, \ambuno, 50,
			params ? (att: 0.1), notes, mode, spy, retrigger, \seq, oneShot);

	}

	prFunction {

		^CaosInstrument.percussion(\kick, \kick, playable);

	}

	// ------------------------------------------------------------------
	// construccion
	// ------------------------------------------------------------------

	test_synthDefaults {

		instrument = this.prSynth;

		this.assertEquals(instrument.name, \pad);
		this.assertEquals(instrument.track, \amb);
		this.assertEquals(instrument.kind, \synth);
		this.assertEquals(instrument.defName, \ambuno);
		this.assertEquals(instrument.out, 50);
		this.assertEquals(instrument.mode, \free);
		this.assertEquals(instrument.output, spy);
		this.assert(instrument.isPlaying.not, "no voice before trigger");

	}

	test_synthNeedsADefName {

		this.assertException({ CaosInstrument.synth(\x, \x, nil) }, Error,
			"a synth instrument without defName must throw");

	}

	test_functionNeedsAFunc {

		this.assertException({ CaosInstrument.percussion(\x, \x, nil) }, Error,
			"a function instrument without func must throw");

	}

	test_unknownKindIsRejected {

		this.assertException({ CaosInstrument.new(\x, \x, \bogus) }, Error,
			"an unknown kind must throw");

	}

	test_unknownModeIsRejected {

		this.assertException({ CaosInstrument.synth(\x, \x, \ambuno, 50, nil, nil, \bogus) },
			Error, "an unknown mode must throw");

	}

	// ------------------------------------------------------------------
	// linea de notas
	// ------------------------------------------------------------------

	test_noteStreamIterates {

		instrument = this.prSynth;

		this.assertEquals(instrument.nextNote, 48, "first note");
		this.assertEquals(instrument.nextNote, 50, "second note");
		this.assertEquals(instrument.nextNote, 52, "third note");
		this.assertEquals(instrument.nextNote, 48, "wraps around");

	}

	test_freeAdvancesWithTheClock {

		instrument = this.prSynth;

		instrument.advance;
		this.assertEquals(instrument.note, 48, "advance moves the note");

		instrument.advance;
		this.assertEquals(instrument.note, 50);

	}

	test_trigAdvancesOnlyOnTrigger {

		instrument = this.prSynth(mode: \trig);

		instrument.advance;
		this.assert(instrument.note.isNil, "advance is a no-op in \\trig");

		instrument.trigger;
		this.assertEquals(instrument.note, 48, "trigger takes the next note");

		instrument.trigger;
		this.assertEquals(instrument.note, 50);

	}

	test_notesAcceptAScalar {

		instrument = CaosInstrument.synth(\x, \x, \ambuno, 50, nil, 60, \free, spy);

		this.assertEquals(instrument.notes, [60], "a single note becomes an array");

	}

	// ------------------------------------------------------------------
	// disparo (kind: \synth)
	// ------------------------------------------------------------------

	test_triggerSendsSNew {

		var msg;

		instrument = this.prSynth;
		instrument.advance;
		instrument.trigger;

		this.assertEquals(spy.synths.size, 1, "one /s_new");

		msg = spy.lastMessage;

		this.assertEquals(msg[0], '/s_new');
		this.assertEquals(msg[1], \ambuno);
		this.assertEquals(msg[2], instrument.nodeID, "the node id is allocated");
		this.assertEquals(msg[3], 0, "add action");
		this.assertEquals(msg[4], 0, "group");
		this.assertEquals(msg[msg.indexOf(\out) + 1], 50, "out bus");
		this.assertEquals(msg[msg.indexOf(\gate) + 1], 1, "gate open");
		this.assertEquals(msg[msg.indexOf(\note) + 1], 48, "the current note");
		this.assertEquals(msg[msg.indexOf(\att) + 1], 0.1, "params travel with the voice");

	}

	test_legatoReusesTheSameVoice {

		var firstID;

		instrument = this.prSynth;
		instrument.advance;
		instrument.trigger;
		firstID = instrument.nodeID;

		instrument.advance;
		instrument.trigger;

		this.assertEquals(spy.synths.size, 1, "legato creates the voice only once");
		this.assertEquals(instrument.nodeID, firstID, "the same node keeps singing");
		this.assertEquals(spy.lastMessage[0], '/n_set', "the second trigger updates it");

	}

	test_legatoAdvanceUpdatesTheSoundingVoice {

		var msg;

		instrument = this.prSynth;
		instrument.advance;
		instrument.trigger;
		spy.reset;

		instrument.advance;// 50

		msg = spy.lastMessage;

		this.assertEquals(spy.messages.size, 1, "advance writes to the voice");
		this.assertEquals(msg[0], '/n_set');
		this.assertEquals(msg[1], instrument.nodeID);
		this.assertEquals(msg[2], \note);
		this.assertEquals(msg[3], 50, "the new note is sung");

	}

	test_retriggerReleasesThePreviousVoice {

		var firstID;

		instrument = this.prSynth(retrigger: true);
		instrument.advance;
		instrument.trigger;
		firstID = instrument.nodeID;

		instrument.advance;
		instrument.trigger;

		this.assertEquals(spy.messages.size, 3, "s_new, release, s_new");
		this.assertEquals(spy.messages[1][0], '/n_set');
		this.assertEquals(spy.messages[1][1], firstID, "the old node is released");
		this.assertEquals(spy.messages[1][2], \gate);
		this.assertEquals(spy.messages[1][3], 0);
		this.assert(instrument.nodeID != firstID, "a new voice gets a new node id");

	}

	test_retriggerAdvanceOnlyMovesTheNote {

		instrument = this.prSynth(retrigger: true);
		instrument.advance;
		instrument.trigger;
		spy.reset;

		instrument.advance;

		this.assertEquals(spy.messages.size, 0, "a one-shot voice is not rewritten");
		this.assertEquals(instrument.note, 50, "the next note is ready");

	}

	test_oneShotDoesNotReleaseThePreviousVoice {

		var firstID;

		instrument = this.prSynth(retrigger: true, oneShot: true);
		instrument.advance;
		instrument.trigger;
		firstID = instrument.nodeID;

		spy.reset;
		instrument.advance;
		instrument.trigger;

		this.assertEquals(spy.messages.size, 1, "only the new voice is created");
		this.assertEquals(spy.messages[0][0], '/s_new');
		this.assertEquals(spy.messages[0][1], \ambuno, "the same synthdef");
		this.assert(instrument.nodeID != firstID, "a new node id is allocated");

	}

	test_oneShotForcesRetrigger {

		instrument = CaosInstrument.synth(\x, \x, \ambuno, 50, nil, nil, \free, spy, false, \seq, true);

		this.assert(instrument.retrigger, "a one-shot voice is always retriggered");

	}

	test_oneShotSetOnlyStoresParams {

		instrument = this.prSynth(retrigger: true, oneShot: true);
		instrument.advance;
		instrument.trigger;
		spy.reset;

		instrument.set(\att, 0.7);

		this.assertEquals(spy.messages.size, 0,
			"a one-shot voice must not be poked with /n_set");
		this.assertEquals(instrument.params.at(\att), 0.7,
			"the param is stored for the next trigger");

	}

	test_oneShotReleaseDoesNotPokeTheNode {

		instrument = this.prSynth(retrigger: true, oneShot: true);
		instrument.advance;
		instrument.trigger;
		spy.reset;

		instrument.release;

		this.assertEquals(spy.messages.size, 0, "nothing to release in a one-shot voice");
		this.assert(instrument.nodeID.isNil, "the dead node is forgotten");

	}

	test_setSendsNSetToTheVoice {

		instrument = this.prSynth;
		instrument.advance;
		instrument.trigger;
		spy.reset;

		instrument.set(\att, 0.5);

		this.assertEquals(instrument.params.at(\att), 0.5, "the param is stored");
		this.assertEquals(spy.messages.size, 1);
		this.assertEquals(spy.messages[0][0], '/n_set');
		this.assertEquals(spy.messages[0][1], instrument.nodeID);
		this.assertEquals(spy.messages[0][2], \att);
		this.assertEquals(spy.messages[0][3], 0.5);

	}

	test_setBeforeTriggerOnlyStores {

		instrument = this.prSynth;
		instrument.set(\rel, 2);

		this.assertEquals(spy.messages.size, 0, "no voice to set yet");
		this.assertEquals(instrument.params.at(\rel), 2);

	}

	test_setNeedsKeyValuePairs {

		instrument = this.prSynth;

		this.assertException({ instrument.set(\att) }, Error,
			"an odd number of arguments must throw");

	}

	test_releaseSendsGateZero {

		var node;

		instrument = this.prSynth;
		instrument.advance;
		instrument.trigger;
		node = instrument.nodeID;
		spy.reset;

		instrument.release;

		this.assertEquals(spy.messages.size, 1);
		this.assertEquals(spy.messages[0], ['/n_set', node, \gate, 0]);
		this.assert(instrument.isPlaying.not, "the voice is no longer playing");

	}

	test_freeSendsNFree {

		var node;

		instrument = this.prSynth;
		instrument.advance;
		instrument.trigger;
		node = instrument.nodeID;
		spy.reset;

		instrument.free;

		this.assertEquals(spy.messages.size, 1);
		this.assertEquals(spy.messages[0], ['/n_free', node]);
		this.assert(instrument.nodeID.isNil, "the node reference is cleared");

	}

	test_noNotesDoesNotSendNote {

		var msg;

		instrument = CaosInstrument.synth(\x, \x, \ambuno, 50, nil, nil, \free, spy);
		instrument.trigger;

		msg = spy.lastMessage;

		this.assert(msg.indexOf(\note).isNil, "no note argument without notes");

	}

	// ------------------------------------------------------------------
	// disparo (kind: \function)
	// ------------------------------------------------------------------

	test_functionKindPlaysTheFunc {

		instrument = this.prFunction;

		instrument.trigger;
		instrument.trigger;

		this.assertEquals(playable.plays, 2, "the function is played per trigger");
		this.assert(instrument.nodeID.isNil, "percussion has no persistent voice");

	}

	test_functionKindIgnoresNotesAndParams {

		instrument = this.prFunction;
		instrument.advance;
		instrument.set(\att, 0.2);

		this.assert(instrument.note.isNil, "percussion does not advance notes");
		this.assertEquals(instrument.params.at(\att), 0.2, "params are still stored");

	}

	// ------------------------------------------------------------------
	// grupo destino
	// ------------------------------------------------------------------

	test_targetIsUsedForTheVoice {

		var msg;

		instrument = CaosInstrument.synth(\pad, \amb, \ambuno, 50, nil, nil,
			\free, spy, target: 42);
		instrument.trigger;

		msg = spy.lastMessage;

		this.assertEquals(msg[4], 42, "the voice is created inside the given group");

	}

	test_functionTriggerPassesTheTarget {

		instrument = CaosInstrument.percussion(\kick, \kick, playable, 42);
		instrument.trigger;

		this.assertEquals(playable.plays, 1, "the function is played");
		this.assertEquals(playable.lastTarget, 42, "inside the given group");

	}

}

// ----------------------------------------------------------------------
// Helpers de test (compilan con el repo, solo se usan aqui)
// ----------------------------------------------------------------------

// Output que recibe OSC en lugar de un Server
CaosTestOutput {

	var <messages;
	var nodeCounter;

	*new { |firstID = 2000| ^super.new.init(firstID) }

	init { |firstID|

		messages = List.new;
		nodeCounter = firstID;
		^this;

	}

	nextNodeID {

		nodeCounter = nodeCounter + 1;
		^nodeCounter;

	}

	sendBundle { |latency, msg|

		messages = messages.add(msg);
		^this;

	}

	reset {

		messages = List.new;
		^this;

	}

	lastMessage { ^messages.last }

	synths { ^messages.select { |msg| msg[0] == '/s_new' } }

}

// Funcion jugable falsa: cuenta disparos y guarda el grupo destino
CaosTestPlayable {

	var <plays;
	var <lastTarget;

	*new { ^super.new.init }

	init {

		plays = 0;
		lastTarget = nil;
		^this;

	}

	play { |target|

		plays = plays + 1;
		lastTarget = target;
		^this;

	}

}
