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
