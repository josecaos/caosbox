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

		CaosTrack.clearSolos;
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

	test_flamStoresAmountAndRepeats {

		track = this.prSnapshot(\snare);

		track.flam(4, 0.25, 2);
		this.assertEquals(track.flamAt(4)[\amount], 0.25);
		this.assertEquals(track.flamAt(4)[\repeats], 2);

	}

	test_flamAcceptsArraysAndRemoval {

		track = this.prSnapshot(\snare);

		track.flam([0, 4, 8], 0.5, 1);
		this.assert(track.flamAt(0).notNil);
		this.assert(track.flamAt(4).notNil);
		this.assert(track.flamAt(8).notNil);

		track.removeFlam([4, 8]);
		this.assert(track.flamAt(0).notNil);
		this.assert(track.flamAt(4).isNil);
		this.assert(track.flamAt(8).isNil);

	}

	test_flamChangeCallback {

		var changes = 0;

		track = this.prSnapshot(\snare);
		track.onFlamChange = {|track, index, value| changes = changes + 1 };

		track.flam(0, 0.5, 1);
		track.removeFlam(0);

		this.assertEquals(changes, 2,
			"flam and removeFlam notify the view");

	}

	test_flamOnlyForSnapshotTracks {

		track = CaosTrack.new(\bass, \live);

		track.flam(0, 0.5, 1);
		this.assert(track.flamAt(0).isNil,
			"melodic tracks do not accept flams");

	}

	test_flamValidatesItsRange {

		track = this.prSnapshot(\snare);

		track.flam(0, 1.5, 1);
		track.flam(1, 0.5, 0);
		track.flam(2, 0.5, 5);
		this.assert(track.flamAt(0).isNil);
		this.assert(track.flamAt(1).isNil);
		this.assert(track.flamAt(2).isNil);

	}

	// ------------------------------------------------------------------
	// repeater
	// ------------------------------------------------------------------

	test_repeaterStoresAndRemoves {

		track = this.prSnapshot(\kick);

		track.repeater([0, 4], 4, 1/2);

		this.assertEquals(track.repeaterAt(0)[\repetitions], 4);
		this.assertEquals(track.repeaterAt(0)[\metric], 0.5);
		this.assertEquals(track.repeaterAt(4)[\metric], 0.5);

		track.removeRepeater([0, 4]);

		this.assert(track.repeaterAt(0).isNil, "removeRepeater clears the mark");
		this.assert(track.repeaterAt(4).isNil, "all selected steps are cleared");

	}

	test_repeaterIntervalsEndAtTheWindow {

		var intervals = CaosTrack.repeaterIntervals(4, 1/2, 0.25);

		this.assertEquals(intervals.size, 4);
		this.assertEquals(intervals.last, 0.125,
			"the last hit lands at the end of the window");
		this.assertEquals(intervals[0], 0.03125,
			"the hits are evenly distributed");

	}

	test_repeaterValidatesItsArguments {

		track = this.prSnapshot(\kick);

		track.repeater(0, 4, 0.37);
		track.repeater(1, 17, 1);
		track.repeater(2, -1, 1);

		this.assert(track.repeaterAt(0).isNil);
		this.assert(track.repeaterAt(1).isNil);
		this.assert(track.repeaterAt(2).isNil);

	}

	test_flamAndRepeaterAreExclusive {

		track = this.prSnapshot(\kick);

		track.flam(0, 0.5, 1);
		track.repeater(0, 4, 1/2);

		this.assert(track.flamAt(0).isNil,
			"repeater removes the flam of that step");
		this.assert(track.repeaterAt(0).notNil);

		track.flam(0, 0.5, 1);

		this.assert(track.repeaterAt(0).isNil,
			"flam removes the repeater of that step");
		this.assert(track.flamAt(0).notNil);

	}

	test_repeaterSurvivesSnapshotAndRestore {

		var snapshot;

		track = this.prSnapshot(\kick);
		track.putStep(0, true);
		track.repeater(0, 3, 1/3);

		snapshot = track.snapshotPattern;
		track.removeRepeater(0);
		track.restorePattern(snapshot);

		this.assertEquals(track.repeaterAt(0)[\repetitions], 3,
			"the repeater is part of the pattern history");
		this.assertEquals(track.repeaterAt(0)[\metric], 1/3);

	}

	test_clearingAStepClearsItsRepeater {

		track = this.prSnapshot(\kick);
		track.putStep(0, true);
		track.repeater(0, 4, 1);

		track.putStep(0, false);

		this.assert(track.repeaterAt(0).isNil,
			"clearing a step also clears its repeater");

	}

	// ------------------------------------------------------------------
	// trigger callback
	// ------------------------------------------------------------------

	test_onTriggerFiresOnlyForAudibleSteps {

		var voice = CaosTestVoice.new(\voice);
		var calls = 0;

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);
		track.onTrigger = {|t, index, value, triggeredVoice| calls = calls + 1 };
		track.putStep(0, true);

		track.step(0);
		this.assertEquals(calls, 1, "an active step notifies the trigger");

		track.step(1);
		this.assertEquals(calls, 1, "an off step does not notify");

		track.probability_(0.0);
		track.step(0);
		this.assertEquals(calls, 1, "a skipped probability does not notify");

	}

	test_onCommandSurvivesAudioMute {

		var voice = CaosTestVoice.new(\voice);
		var commands = 0;
		var triggers = 0;

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);
		track.onCommand = {|t, i, value, v| commands = commands + 1 };
		track.onTrigger = {|t, i, value, v| triggers = triggers + 1 };
		track.putStep(0, true);
		track.muted_(true);

		track.step(0);

		this.assertEquals(commands, 1,
			"the MIDI command survives an audio mute");
		this.assertEquals(triggers, 0,
			"the audio trigger is still muted");

	}

	test_onCommandStillRespectsProbability {

		var voice = CaosTestVoice.new(\voice);
		var commands = 0;

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);
		track.onCommand = {|t, i, value, v| commands = commands + 1 };
		track.putStep(0, true);
		track.probability_(0.0);

		track.step(0);

		this.assertEquals(commands, 0,
			"probability zero also skips the MIDI command");

	}

	test_onTriggerFiresForPercussionOnlyWhenItPlays {

		var playable = CaosTestPlayable.new;
		var calls = 0;

		track = CaosTrack.new(\kick, \snapshot, 4, { playable });
		track.onTrigger = {|t, index, value, voice| calls = calls + 1 };
		track.putStep(0, true);

		track.step(0);
		this.assertEquals(calls, 1, "a played percussion step notifies");

		track.step(1);
		this.assertEquals(calls, 1, "an empty percussion step does not notify");

	}

	// ------------------------------------------------------------------
	// playback probability
	// ------------------------------------------------------------------

	test_probabilityDefaultsToOneAndResets {

		track = CaosTrack.new(\bass);

		this.assertEquals(track.probability, 1.0,
			"a new track always plays its active steps");

		track.probability_(0.25);
		this.assertEquals(track.probability, 0.25, "the chance is stored");

		track.probability_(nil);
		this.assertEquals(track.probability, 1.0,
			"nil returns to the default chance");

	}

	test_probabilityZeroStillAdvancesTheMelodicLine {

		var voice = CaosTestVoice.new(\voice);

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);
		track.putStep(0, true);
		track.probability_(0.0);

		track.step(0);
		track.step(0);

		this.assertEquals(voice.advances, 2,
			"the line advances even when the step does not trigger");
		this.assertEquals(voice.triggers, 0,
			"probability zero never triggers");

	}

	test_probabilityZeroSilencesPercussion {

		var playable = CaosTestPlayable.new;

		track = CaosTrack.new(\kick, \snapshot, 4, { playable });
		track.putStep(0, true);
		track.probability_(0.0);

		track.step(0);

		this.assertEquals(playable.plays, 0,
			"probability zero does not play the percussion step");

	}

	test_probabilityOneAlwaysTriggers {

		var voice = CaosTestVoice.new(\voice);

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);
		track.putStep(0, true);
		track.probability_(1.0);

		track.step(0);
		track.step(0);

		this.assertEquals(voice.triggers, 2,
			"probability one always triggers");

	}

	test_probabilityDoesNotTouchThePattern {

		track = CaosTrack.new(\bass);
		track.setIndices([0, 4, 8]);

		track.probability_(0.5);

		this.assertEquals(track.indices, [0, 4, 8],
			"changing the chance does not edit the pattern");

	}

	// ------------------------------------------------------------------
	// pattern history
	// ------------------------------------------------------------------

	test_snapshotPatternPreservesStepsAndFlams {

		var snapshot;

		track = this.prSnapshot(\kick);

		currentValue = \a;
		track.putStep(0, true);
		currentValue = \b;
		track.putStep(2, true);
		track.flam(2, 0.25, 2);

		snapshot = track.snapshotPattern;
		track.clear;
		currentValue = \c;
		track.putStep(1, true);

		track.restorePattern(snapshot);

		this.assertEquals(track.indices, [0, 2],
			"the active steps come back in their original positions");
		this.assertEquals(track.at(0), \a,
			"the step keeps the value it had at snapshot time");
		this.assertEquals(track.at(2), \b,
			"another step keeps its own value");
		this.assertEquals(track.flamAt(2)[\amount], 0.25,
			"the flam is restored too");

	}

	test_snapshotPatternIsACopy {

		var snapshot;

		track = this.prSnapshot(\kick);
		currentValue = \a;
		track.putStep(0, true);

		snapshot = track.snapshotPattern;
		track.clear;

		this.assertEquals(snapshot[\steps][0], \a,
			"clearing the track does not mutate the snapshot");
		this.assertEquals(snapshot[\flams][0], nil,
			"the flam array is copied as well");

	}

	test_restorePatternNotifiesTheView {

		var snapshot;
		var stepChanges = 0;
		var flamChanges = 0;

		track = this.prSnapshot(\kick);
		currentValue = \a;
		track.putStep(0, true);
		snapshot = track.snapshotPattern;

		track.onChange = {|changed, index, value| stepChanges = stepChanges + 1 };
		track.onFlamChange = {|changed, index, value| flamChanges = flamChanges + 1 };

		track.restorePattern(snapshot);

		this.assertEquals(stepChanges, track.size,
			"the view gets one step notification per position");
		this.assertEquals(flamChanges, track.size,
			"the view gets one flam notification per position");

	}

	test_restorePatternRejectsASizeMismatch {

		var snapshot = this.prSnapshot(\kick).snapshotPattern;
		var other = CaosTrack.new(\snare, \snapshot, 8, { \fn });

		other.setIndices([1]);
		other.restorePattern(snapshot);

		this.assertEquals(other.indices, [1],
			"a snapshot from another size does not touch the track");

	}

	// ------------------------------------------------------------------
	// mute / solo
	// ------------------------------------------------------------------

	test_randomIndicesRespectsBoundaries {

		this.assertEquals(CaosTrack.randomIndices(8, 0), [],
			"density 0 leaves every step off");
		this.assertEquals(CaosTrack.randomIndices(8, 1), (0 .. 7),
			"density 1 turns every step on");

	}

	test_randomIndicesAreValidAndUnique {

		var indices = CaosTrack.randomIndices(32, 0.5);

		this.assert(indices.every {|index|
			index.isInteger and: { index >= 0 } and: { index < 32 }
		}, "every index is inside the track");
		this.assertEquals(indices.asSet.size, indices.size,
			"the generator does not repeat indices");

	}

	test_muteAndSoloDefaultOff {

		track = CaosTrack.new(\bass);

		this.assert(track.muted.not, "a new track is not muted");
		this.assert(track.solo.not, "a new track is not soloed");
		this.assert(track.isAudible, "a new track is audible");

	}

	test_mutedTrackIsNotAudible {

		track = CaosTrack.new(\bass);

		track.muted_(true);
		this.assert(track.muted, "mute is stored");
		this.assert(track.isAudible.not, "a muted track is not audible");

		track.muted_(false);
		this.assert(track.muted.not, "mute can be lifted");
		this.assert(track.isAudible, "the track is audible again");

	}

	test_soloSilencesOtherTracksAndAllowsSeveral {

		var first = CaosTrack.new(\kick, \snapshot, 4, { \fn });
		var second = CaosTrack.new(\snare, \snapshot, 4, { \fn });
		var third = CaosTrack.new(\bass);

		first.solo_(true);
		this.assert(first.isAudible, "the soloed track is audible");
		this.assert(second.isAudible.not, "another track is silenced");
		this.assert(third.isAudible.not, "every other track is silenced");

		second.solo_(true);
		this.assert(first.isAudible and: { second.isAudible },
			"several solos can coexist");
		this.assert(third.isAudible.not, "the non soloed track stays silent");

		second.solo_(false);
		this.assert(first.isAudible, "the remaining solo keeps playing");
		this.assert(second.isAudible.not, "lifting one solo silences that track");
		this.assert(third.isAudible.not, "the rest stay silent while a solo exists");

		first.solo_(false);
		this.assert(third.isAudible, "without solos every track is audible");

	}

	test_clearSolosResetsTheFlags {

		var first = CaosTrack.new(\kick, \snapshot, 4, { \fn });
		var second = CaosTrack.new(\snare, \snapshot, 4, { \fn });

		first.solo_(true);
		second.solo_(true);

		CaosTrack.clearSolos;

		this.assert(first.solo.not, "clearSolos clears the first flag");
		this.assert(second.solo.not, "clearSolos clears the second flag");
		this.assert(first.isAudible and: { second.isAudible },
			"every track is audible again");

	}

	test_muteWinsOverSolo {

		var soloed = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		soloed.solo_(true);
		soloed.muted_(true);

		this.assert(soloed.solo, "the track keeps its solo flag");
		this.assert(soloed.muted, "the track keeps its mute flag");
		this.assert(soloed.isAudible.not, "mute wins over solo");

	}

	test_mutedLiveStepAdvancesWithoutTriggering {

		var voice = CaosTestVoice.new(\voice);

		track = CaosTrack.new(\bass, \live, 4);
		track.setInstrument(voice);
		track.putStep(0, true);
		track.muted_(true);

		track.step(0);
		this.assertEquals(voice.advances, 1,
			"a muted melodic track still advances its line");
		this.assertEquals(voice.triggers, 0,
			"a muted melodic track does not trigger");

		track.muted_(false);
		track.step(0);
		this.assertEquals(voice.advances, 2, "the line keeps advancing");
		this.assertEquals(voice.triggers, 1, "the trigger comes back after unmute");

	}

	test_mutedPercussionDoesNotPlay {

		var playable = CaosTestPlayable.new;

		track = CaosTrack.new(\kick, \snapshot, 4, { playable });
		track.putStep(0, true);
		track.muted_(true);

		track.step(0);
		this.assertEquals(playable.plays, 0,
			"a muted percussion step is not played");

		track.muted_(false);
		track.step(0);
		this.assertEquals(playable.plays, 1,
			"the percussion step plays after unmute");

	}

	test_soloStepPlaysOnlyTheSoloedTrack {

		var playableA = CaosTestPlayable.new;
		var playableB = CaosTestPlayable.new;
		var first = CaosTrack.new(\kick, \snapshot, 4, { playableA });
		var second = CaosTrack.new(\snare, \snapshot, 4, { playableB });

		first.putStep(0, true);
		second.putStep(0, true);
		first.solo_(true);

		first.step(0);
		second.step(0);

		this.assertEquals(playableA.plays, 1, "the soloed track plays");
		this.assertEquals(playableB.plays, 0, "the other track stays silent");

		first.solo_(false);
		second.step(0);
		this.assertEquals(playableB.plays, 1,
			"the other track plays again when the solo is lifted");

	}

	test_nilResetsMuteAndSolo {

		track = CaosTrack.new(\bass);

		track.muted_(true);
		track.muted_(nil);
		track.solo_(true);
		track.solo_(nil);

		this.assert(track.muted.not, "nil lifts mute");
		this.assert(track.solo.not, "nil lifts solo");
		this.assert(track.isAudible, "the track is audible again");

	}

	test_clearingAStepClearsItsFlam {

		track = this.prSnapshot(\snare);

		track.putStep(4, true);
		track.flam(4, 0.5, 1);
		track.putStep(4, false);

		this.assert(track.at(4).isNil);
		this.assert(track.flamAt(4).isNil,
			"clearing a step also clears its flam");

	}

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
