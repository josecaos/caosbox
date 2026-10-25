// CaosBox v2.1.1 - Tests for CaosGear instrument construction
//
// Headless: no Server, no GUI, no audio. Solo se verifica como se arma el
// instrumento (pista, SynthDef, params, modo de voz) y su registro.
//
// Desde el IDE: TestCaosGear.run

TestCaosGear : UnitTest {

	var <savedTracks;
	var <savedInstruments;
	var <savedPercussion;
	var <gear;

	setUp {

		// guardamos el estado de la app para no pisarlo si corre
		savedTracks = ~cbox_tracks;
		savedInstruments = ~cbox_instruments;
		savedPercussion = [~cbox_b, ~cbox_b2, ~cbox_t, ~cbox_t2, ~cbox_h, ~cbox_h2];

		~cbox_instruments = Dictionary.new;
		~cbox_tracks = Dictionary[
			\kick -> CaosTrack.new(\kick, \snapshot, 32, { ~cbox_b }),
			\kick2 -> CaosTrack.new(\kick2, \snapshot, 32, { ~cbox_b2 }),
			\snare -> CaosTrack.new(\snare, \snapshot, 32, { ~cbox_t }),
			\snare2 -> CaosTrack.new(\snare2, \snapshot, 32, { ~cbox_t2 }),
			\hihats -> CaosTrack.new(\hihats, \snapshot, 32, { ~cbox_h }),
			\hihats2 -> CaosTrack.new(\hihats2, \snapshot, 32, { ~cbox_h2 }),
			\bass -> CaosTrack.new(\bass, \live, 32),
			\bass2 -> CaosTrack.new(\bass2, \live, 32),
			\amb -> CaosTrack.new(\amb, \live, 32),
			\amb2 -> CaosTrack.new(\amb2, \live, 32),
			\chords -> CaosTrack.new(\chords, \live, 32),
			\chords2 -> CaosTrack.new(\chords2, \live, 32),
			\in -> CaosTrack.new(\in, \live, 32)
		];

		gear = CaosGear.new;

	}

	tearDown {

		~cbox_tracks = savedTracks;
		~cbox_instruments = savedInstruments;
		~cbox_b = savedPercussion[0];
		~cbox_b2 = savedPercussion[1];
		~cbox_t = savedPercussion[2];
		~cbox_t2 = savedPercussion[3];
		~cbox_h = savedPercussion[4];
		~cbox_h2 = savedPercussion[5];

	}

	// ------------------------------------------------------------------
	// bajo: la voz debe liberarse (doneAction 2, no pause)
	// ------------------------------------------------------------------

	test_bassBuildsAVoiceOnItsTrack {

		var instrument = gear.bass(50, [48, 50, 52], 'seq');

		this.assertEquals(instrument.kind, \synth);
		this.assertEquals(instrument.defName, \bajouno);
		this.assertEquals(instrument.track, \bass);
		this.assertEquals(instrument.notes, [48, 50, 52]);
		this.assertEquals(instrument.out, 50);
		this.assert(instrument.retrigger, "bass retriggers per step");
		this.assert(instrument.oneShot, "CaosPercLib envelopes are one-shot");

		this.assertEquals(~cbox_tracks[\bass].instrument, instrument,
			"the voice is active on the track");
		this.assertEquals(~cbox_instruments[\bass], instrument,
			"the voice is registered");

	}

	test_bassFreesItsVoiceOnGateRelease {

		var instrument = gear.bass(50, [48], 'seq');

		this.assertEquals(instrument.params.at(\doneAction), 2,
			"doneAction 2 frees the node (1 would pause and leak)");

	}

	test_bass2AlsoFreesItsVoice {

		var instrument = gear.bass2(50, [48], 'seq');

		this.assertEquals(instrument.params.at(\doneAction), 2);
		this.assertEquals(instrument.track, \bass2);
		this.assertEquals(instrument.defName, \bajodos);

	}

	// ------------------------------------------------------------------
	// melódicos: legato vs retrigger
	// ------------------------------------------------------------------

	test_padIsAOneShotVoice {

		var instrument = gear.pad(50, [48, 50], 'seq');

		this.assertEquals(instrument.track, \amb);
		this.assertEquals(instrument.defName, \ambuno);
		this.assert(instrument.oneShot,
			"CaosPercLib pads use Env.perc: one-shot voices");

	}

	test_pad2IsAOneShotVoice {

		var instrument = gear.pad2(50, [48], 'seq');

		this.assertEquals(instrument.track, \amb2);
		this.assertEquals(instrument.defName, \ambdos);
		this.assert(instrument.oneShot);

	}

	test_chordsAreOneShotVoices {

		var chords = gear.chords(50, [48], 'seq');
		var chords2 = gear.chords2(50, [48], 'seq');

		this.assert(chords.retrigger, "chords retrigger per step");
		this.assert(chords.oneShot);
		this.assert(chords2.oneShot);
		this.assertEquals(chords2.track, \chords2);

	}

	test_lineInIsAOneShotVoice {

		var instrument = gear.lineIn(50);

		this.assertEquals(instrument.track, \in);
		this.assertEquals(instrument.defName, \entrada);
		this.assert(instrument.oneShot, "the perc envelope frees itself");

	}

	// ------------------------------------------------------------------
	// orden de notas y reemplazo
	// ------------------------------------------------------------------

	test_noteOrderFollowsSeqType {

		this.assertEquals(gear.bass(50, [48, 50], 'seq').noteOrder, \seq);
		this.assertEquals(gear.bass(50, [48, 50], 'rand').noteOrder, \rand);

	}

	test_unknownSeqTypeFallsBackToSeq {

		this.assertEquals(gear.bass(50, [48, 50], 'nope').noteOrder, \seq);

	}

	test_replacementWaitsForTheNextTrigger {

		var first = gear.pad(50, [48], 'seq');
		var second = gear.pad(50, [50], 'seq');

		this.assertEquals(~cbox_tracks[\amb].instrument, first,
			"the sounding voice stays");
		this.assertEquals(~cbox_tracks[\amb].pendingInstrument, second,
			"the new voice waits for the trigger");

	}

	// ------------------------------------------------------------------
	// percusión: handle + snapshot por step
	// ------------------------------------------------------------------

	test_kickBuildsAFunctionVoice {

		var instrument = gear.kick();

		this.assertEquals(instrument.kind, \function);
		this.assertEquals(instrument.track, \kick);
		this.assert(instrument.func.notNil, "the playable function is kept");
		this.assertEquals(gear.instrument, instrument, "the gear keeps its handle");
		this.assertEquals(~cbox_instruments[\kick], instrument, "it is registered");

	}

	test_toTrackUsesTheVoiceTrack {

		gear.kick();
		gear.toTrack([0, 4], true);
		this.assertEquals(~cbox_tracks[\kick].indices, [0, 4], "kick goes to its track");

		gear.snare();
		gear.toTrack([3]);
		this.assertEquals(~cbox_tracks[\snare].indices, [3], "snare goes to its track");
		this.assertEquals(~cbox_tracks[\kick].indices, [0, 4], "kick is untouched");

	}

	test_percussionStepsSnapshotTheFunction {

		var first;

		gear.kick();
		gear.toTrack([0], true);
		first = ~cbox_tracks[\kick].at(0);

		gear.kick(62, 0.01, 0.2);// nueva función, mismo instrumento

		this.assert(first.isFunction, "the step holds a function");
		this.assertEquals(~cbox_tracks[\kick].at(0), first,
			"the step keeps the function captured when it was set");

	}

	test_offTrackWithoutStepsClearsTheWholeTrack {

		gear.kick();
		gear.toTrack([0, 4, 8], true);

		gear.offTrack;

		this.assert(~cbox_tracks[\kick].isEmpty,
			"offTrack with no argument clears the whole lane");

	}

	test_toTrackWithoutAnInstrumentInforms {

		var answer = CaosGear.new.toTrack([0]);

		this.assert(answer.isString, "it returns a message instead of breaking");
		this.assert(~cbox_tracks[\kick].isEmpty, "nothing is touched");

	}

	// ------------------------------------------------------------------
	// lo que no cambió
	// ------------------------------------------------------------------

	test_melodyStillReturnsTheTransposedArray {

		this.assertEquals(gear.melody([0, 3, 7], 60), [60, 63, 67]);

	}

}
