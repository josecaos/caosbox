// CaosBox v2.5.1 - Tests for class-level automation controls
//
// Headless: no server, no GUI. Se comprueba que el contrato de pausa alcance
// tambien las automatizaciones que no tienen boton en la GUI (filtros).

TestCaosBox : UnitTest {

	var <automationNames;
	var <savedTracks;

	setUp {

		savedTracks = ~cbox_tracks;
		automationNames = #[\autor, \autod, \autop, \autog, \autolpf, \autohpf, \autobpf];

		// Tdefs de prueba con los mismos nombres que usa CaosBox
		automationNames.do {|name|
			Tdef(name, { inf.do { 1.wait } }).play;
		};

	}

	tearDown {

		automationNames.do {|name| Tdef(name).stop };
		CaosTrack.clearSolos;
		CaosBox.prClearRandPatterns;
		~cbox_tracks = savedTracks;

	}

	test_muteAndSoloApi {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];

		this.assert(CaosBox.mute(\kick, true), "mute returns the new state");
		this.assert(track.muted, "mute reaches the track");
		this.assert(CaosBox.mute(\kick, false).not, "mute can be lifted");
		this.assert(track.muted.not, "the track follows the API");

		this.assert(CaosBox.solo(\kick, true), "solo returns the new state");
		this.assert(track.solo, "solo reaches the track");
		this.assert(CaosBox.solo(\kick, false).not, "solo can be lifted");
		this.assert(track.solo.not, "the track follows the solo API");

	}

	test_randPatternIsDestructiveAndOneShot {

		var track = CaosTrack.new(\kick, \snapshot, 8, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];

		this.assertEquals(CaosBox.randPattern(\kick, density: 1), track,
			"randPattern returns the track");
		this.assertEquals(track.indices, (0 .. 7),
			"density 1 fills every step");

		this.assertEquals(CaosBox.randPattern(\kick, density: 0), track,
			"the one-shot can run again");
		this.assert(track.isEmpty, "density 0 empties the track");

	}

	test_randPatternWorksOnMelodicGates {

		var track = CaosTrack.new(\bass, \live, 4);

		~cbox_tracks = Dictionary[\bass -> track];
		CaosBox.randPattern(\bass, density: 1);

		this.assertEquals(track.indices, (0 .. 3),
			"a melodic track receives random gates");
		this.assertEquals(track.at(0), true,
			"live steps store the gate, not an instrument");

	}

	test_randPatternClearsFlams {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		track.putStep(0, true);
		track.flam(0, 0.5, 1);

		CaosBox.randPattern(\kick, density: 0);

		this.assert(track.flamAt(0).isNil,
			"replacing the pattern also clears its flams");

	}

	test_randPatternValidatesItsArguments {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		track.setIndices([0]);

		CaosBox.randPattern(\kick, density: 1.5);
		CaosBox.randPattern(\kick, density: 0.5, every: 0);
		CaosBox.randPattern(\kick, density: 0.5, every: 2.5);

		this.assertEquals(track.indices, [0],
			"invalid arguments leave the pattern untouched");

	}

	test_randPatternEveryRefreshesAtLoopBoundaries {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		CaosBox.randPattern(\kick, density: 1, every: 2);

		this.assertEquals(track.indices, (0 .. 3),
			"the first pattern is applied immediately");

		track.clear;
		CaosBox.prRandPatternLoop(nil);
		this.assert(track.isEmpty, "the first loop only counts");

		CaosBox.prRandPatternLoop(nil);
		this.assertEquals(track.indices, (0 .. 3),
			"the second loop regenerates the pattern");

	}

	test_stopRandPatternStopsTheEvolution {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		CaosBox.randPattern(\kick, density: 1, every: 1);
		CaosBox.stopRandPattern(\kick);
		track.clear;

		CaosBox.prRandPatternLoop(nil);

		this.assert(track.isEmpty, "a stopped pattern is not regenerated");

	}

	test_restorePatternReturnsToThePreviousPattern {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		track.setIndices([0, 2]);
		track.flam(2, 0.5, 1);

		CaosBox.randPattern(\kick, density: 0);
		this.assert(track.isEmpty, "randPattern replaced the old pattern");

		CaosBox.restorePattern(\kick);

		this.assertEquals(track.indices, [0, 2],
			"restorePattern brings back the previous steps");
		this.assertEquals(track.flamAt(2)[\amount], 0.5,
			"restorePattern brings back the previous flams");

	}

	test_restorePatternKeepsTheOriginalThroughPeriodicLoops {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		track.setIndices([0]);

		CaosBox.randPattern(\kick, density: 0, every: 1);
		CaosBox.prRandPatternLoop(nil);

		CaosBox.restorePattern(\kick);

		this.assertEquals(track.indices, [0],
			"periodic regenerations do not overwrite the saved pattern");

	}

	test_restorePatternStopsThePeriodicEvolution {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		CaosBox.randPattern(\kick, density: 1, every: 1);
		CaosBox.restorePattern(\kick);

		this.assert(track.isEmpty,
			"restorePattern brings back the original empty pattern");

		CaosBox.prRandPatternLoop(nil);

		this.assert(track.isEmpty,
			"the loop does not regenerate a restored pattern");

	}

	test_restorePatternWithoutHistoryIsSafe {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });

		~cbox_tracks = Dictionary[\kick -> track];
		track.setIndices([1]);

		CaosBox.restorePattern(\kick);

		this.assertEquals(track.indices, [1],
			"without history the current pattern is untouched");

	}

	test_pauseAutomationsPausesAllIncludingFilters {

		automationNames.do {|name|
			this.assert(Tdef(name).isPlaying, name.asString ++ " should be running before pause");
		};

		CaosBox.prPauseAutomations;

		automationNames.do {|name|
			this.assert(Tdef(name).isPlaying.not, name.asString ++ " should be paused");
		};

	}

}
