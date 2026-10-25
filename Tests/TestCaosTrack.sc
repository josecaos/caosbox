// CaosBox v2.0 - Tests for the step model (CaosTrack)
//
// Headless on purpose: no Server, no GUI, no CaosBox environment.
// From the IDE:            TestCaosTrack.run
// From a script:           see dev-docs/01-analisis-v2.md (section 8.3)

TestCaosTrack : UnitTest {

	var currentValue;
	var track;

	setUp {

		currentValue = nil;
		track = nil;

	}

	tearDown {

		currentValue = nil;
		track = nil;

	}

	prSnapshot { |name = \kick|

		^CaosTrack.new(name, \snapshot, 32, { currentValue });

	}

	// ------------------------------------------------------------------
	// construction
	// ------------------------------------------------------------------

	test_defaultsToLiveAnd32Steps {

		track = CaosTrack.new(\bass);

		this.assertEquals(track.name, \bass, "name is kept");
		this.assertEquals(track.mode, \live, "default mode is live");
		this.assertEquals(track.size, 32, "default size is 32");
		this.assertEquals(track.count, 0, "a new track is empty");
		this.assert(track.at(0).isNil, "steps start empty");
		this.assert(track.isEmpty, "isEmpty is true");

	}

	test_sizeIsConfigurable {

		track = CaosTrack.new(\small, \live, 8);

		this.assertEquals(track.size, 8, "size is kept");

		track.putStep(7, true);
		this.assertEquals(track.at(7), true, "last step of an 8 step track");
		this.assert(track.at(8).isNil, "one past the end is nil");

	}

	test_snapshotNeedsASource {

		this.assertException({ CaosTrack.new(\kick, \snapshot) }, Error,
			"a snapshot track without source must throw");

	}

	test_unknownModeIsRejected {

		this.assertException({ CaosTrack.new(\x, \bogus) }, Error,
			"an unknown mode must throw");

	}

	// ------------------------------------------------------------------
	// modes
	// ------------------------------------------------------------------

	test_liveStoresOnlyTheGate {

		track = CaosTrack.new(\bass, \live);

		track.putStep(3, true);
		this.assertEquals(track.at(3), true, "live steps store true");
		this.assertEquals(track.count, 1, "one active step");

		track.putStep(3, false);
		this.assert(track.at(3).isNil, "false clears the step");
		this.assert(track.isEmpty, "clearing the only step empties the track");

	}

	test_snapshotResolvesTheSourceWhenSet {

		track = this.prSnapshot(\kick);

		currentValue = \old;
		track.putStep(0, true);

		currentValue = \new;
		track.putStep(1, true);

		this.assertEquals(track.at(0), \old,
			"a set step keeps the value it got at assignment");
		this.assertEquals(track.at(1), \new,
			"later steps use the new source value");

	}

	test_snapshotStoresAnyValue {

		var fn = { "hi" };

		track = CaosTrack.new(\kick, \snapshot, 32, { fn });
		track.putStep(0, true);

		this.assertEquals(track.at(0), fn,
			"the source value itself (a function) is stored");

	}

	test_snapshotWithAnEmptySourceIsOff {

		track = this.prSnapshot(\kick);

		track.putStep(0, true);

		this.assert(track.at(0).isNil, "a nil source value leaves the step off");
		this.assert(track.isEmpty, "the step does not count as active");

	}

	// ------------------------------------------------------------------
	// writing
	// ------------------------------------------------------------------

	test_putStepAcceptsNumbers {

		track = CaosTrack.new(\bass);

		track.putStep(1, 1);
		this.assertEquals(track.at(1), true, "1 turns the step on");

		track.putStep(1, 0);
		this.assert(track.at(1).isNil, "0 turns the step off");

	}

	test_putAndAtIgnoreInvalidIndices {

		track = CaosTrack.new(\bass);

		track.put(99, true);
		track.put(-1, true);

		this.assertEquals(track.count, 0, "puts outside the range are ignored");
		this.assert(track.at(99).isNil, "at past the end is nil");
		this.assert(track.at(-1).isNil, "at a negative index is nil");

	}

	test_clearSubsetAndAll {

		track = CaosTrack.new(\bass);

		track.setIndices([1, 2, 3]);
		track.clear([2]);

		this.assertEquals(track.indices, [1, 3], "only step 2 is cleared");

		track.clear;

		this.assert(track.isEmpty, "clear with no argument clears everything");

	}

	test_setIndicesReplacesOrAdds {

		track = CaosTrack.new(\bass);

		track.setIndices([5]);
		track.setIndices([1, 2]);

		this.assertEquals(track.indices, [1, 2],
			"clearFirst defaults to true, so the pattern is replaced");

		track.setIndices([7], false);

		this.assertEquals(track.indices, [1, 2, 7],
			"clearFirst false only adds steps");

	}

	test_setIndicesFiltersAndKeepsTheInput {

		var input = [1, 99, -3, 2];

		track = CaosTrack.new(\bass);
		track.setIndices(input);

		this.assertEquals(track.indices, [1, 2], "invalid indices are dropped");
		this.assertEquals(input, [1, 99, -3, 2],
			"the caller's array is never mutated");

	}

	test_toggle {

		track = CaosTrack.new(\bass);

		track.toggle(2);
		this.assertEquals(track.at(2), true, "toggle turns an empty step on");

		track.toggle(2);
		this.assert(track.at(2).isNil, "toggle turns a set step off");

	}

	test_countAndIndices {

		track = CaosTrack.new(\bass);

		track.setIndices([0, 4, 8]);

		this.assertEquals(track.count, 3, "count reports active steps");
		this.assertEquals(track.indices, [0, 4, 8], "indices are in order");

	}

	// ------------------------------------------------------------------
	// view notification
	// ------------------------------------------------------------------

	test_onChangeNotifiesTheView {

		var calls = List.new;

		track = CaosTrack.new(\kick, \snapshot, 32, { \fn });
		track.onChange = { |aTrack, index, value|
			calls.add([aTrack, index, value]);
		};

		track.putStep(4, true);

		this.assertEquals(calls.size, 1, "one notification per write");
		this.assertEquals(calls[0][0], track, "the track is passed");
		this.assertEquals(calls[0][1], 4, "the index is passed");
		this.assertEquals(calls[0][2], \fn, "the stored value is passed");

	}

	test_clearNotifiesEveryClearedStep {

		var calls = List.new;

		track = CaosTrack.new(\bass, \live, 4);
		track.setIndices([0, 1, 2, 3]);
		track.onChange = { |aTrack, index, value| calls.add(index) };

		track.clear;

		this.assertEquals(calls.size, 4, "one notification per cleared step");

	}

	test_asArrayReturnsACopy {

		track = CaosTrack.new(\bass);

		track.putStep(0, true);
		track.asArray[0] = \mutated;

		this.assertEquals(track.at(0), true,
			"mutating the returned array does not touch the track");

	}

	// ------------------------------------------------------------------
	// voz de la pista
	// ------------------------------------------------------------------

	test_firstInstrumentIsActiveAtOnce {

		var voice = CaosTestVoice.new(\first);

		track = CaosTrack.new(\bass, \live);
		track.setInstrument(voice);

		this.assertEquals(track.instrument, voice, "the first instrument is active");
		this.assert(track.pendingInstrument.isNil, "nothing is left pending");

	}

	test_replacementWaitsForTheNextTrigger {

		var old = CaosTestVoice.new(\old);
		var new = CaosTestVoice.new(\new);

		track = CaosTrack.new(\bass, \live);
		track.setInstrument(old);
		track.setInstrument(new);

		this.assertEquals(track.instrument, old, "the old voice keeps singing");
		this.assertEquals(track.pendingInstrument, new, "the new one waits");

		track.trigger;

		this.assertEquals(old.releases, 1, "the old voice is released at the swap");
		this.assertEquals(track.instrument, new, "the new voice takes over");
		this.assert(track.pendingInstrument.isNil, "pending is cleared");

	}

	test_stepAdvancesAndTriggersOnlyOnActiveSteps {

		var voice = CaosTestVoice.new(\voice);

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);

		track.step(1);// step apagado
		this.assertEquals(voice.advances, 1, "advance happens every step");
		this.assertEquals(voice.triggers, 0, "an off step does not trigger");

		track.putStep(1, true);
		track.step(1);
		this.assertEquals(voice.advances, 2, "advance keeps running");
		this.assertEquals(voice.triggers, 1, "an active step triggers the voice");

	}

	test_releaseInstrumentReleasesEverything {

		var active = CaosTestVoice.new(\active);
		var pending = CaosTestVoice.new(\pending);

		track = CaosTrack.new(\bass, \live);
		track.setInstrument(active);
		track.setInstrument(pending);
		track.releaseInstrument;

		this.assertEquals(active.releases, 1, "the active voice is released");
		this.assertEquals(pending.releases, 1, "the pending voice is released too");
		this.assert(track.instrument.isNil, "the track is left without a voice");

	}

	test_stepPlaysTheStoredFunctionWhenThereIsNoVoice {

		var playable = CaosTestPlayable.new;

		track = CaosTrack.new(\kick, \snapshot, 4, { playable });
		track.target = 42;
		track.putStep(0, true);

		track.step(0);
		this.assertEquals(playable.plays, 1, "the step plays the stored function");
		this.assertEquals(playable.lastTarget, 42, "inside the track's target group");

		track.step(1);
		this.assertEquals(playable.plays, 1, "an off step plays nothing");

	}

}

// Voz falsa: permite probar la pista sin audio ni server
CaosTestVoice {

	var <name;
	var <advances;
	var <triggers;
	var <releases;

	*new { |name| ^super.new.init(name) }

	init { |argName|

		name = argName;
		advances = 0;
		triggers = 0;
		releases = 0;
		^this;

	}

	advance { advances = advances + 1; ^this }

	trigger { triggers = triggers + 1; ^this }

	release { releases = releases + 1; ^this }

	free { ^this }

}
