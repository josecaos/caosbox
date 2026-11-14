// CaosBox v2.3.1 - Tests for the GUI registry and palette
//
// Headless: no widgets, no server. Se prueba la paleta y el contrato de
// CaosBox.gui (color por Color, simbolo o array).

TestCaosBoxGUI : UnitTest {

	var <gui;
	var <savedTracks;

	setUp {

		gui = CaosBoxGUI.new;
		savedTracks = ~cbox_tracks;

	}

	tearDown {

		gui.randomColor(false);
		~cbox_tracks = savedTracks;
		CaosTrack.clearSolos;
		CaosBox.prClearRandPatterns;

	}

	test_defaults {

		this.assert(
			CaosBoxGUI.colorAliases.values.any {|color| color == gui.accent },
			"el acento por defecto sale de la paleta");

		this.assert(gui.stepGrids.isEmpty, "sin step grids registrados");
		this.assert(gui.background.notNil);
		this.assert(gui.panel.notNil, "panel de la paleta");
		this.assert(gui.text.notNil, "texto de la paleta");
		this.assert(gui.muted.notNil, "texto apagado");
		this.assert(gui.accentText.notNil, "contraste del acento");
		this.assertEquals(gui.playheadColor, gui.accent.blend(Color.white, 0.7));

	}

	test_accentTextContrasts {

		gui.color(\green);// verde claro
		this.assertEquals(gui.accentText.asArray, [0.05, 0.05, 0.05, 1.0],
			"sobre un acento claro el texto va oscuro");

		gui.color(\red);
		this.assertEquals(gui.accentText.asArray, [0.95, 0.96, 0.95, 1.0],
			"sobre un acento oscuro el texto va claro");

	}

	test_colorListenersAreNotified {

		var hits = 0;

		gui.addColorListener({|registry| hits = hits + 1 });
		gui.color(\orange);

		this.assertEquals(hits, 1, "los widgets registrados se repintan");

	}

	test_colorWithSymbol {

		gui.color(\red);

		this.assertEquals(gui.accent, CaosBoxGUI.colorAliases[\red]);

	}

	test_colorWithColor {

		gui.color(Color(0.1, 0.2, 0.3));

		this.assertEquals(gui.accent.asArray, [0.1, 0.2, 0.3, 1.0]);

	}

	test_colorWithArray {

		gui.color([0.4, 0.5, 0.6]);

		this.assertEquals(gui.accent.asArray, [0.4, 0.5, 0.6, 1.0]);

	}

	test_unknownColorKeepsTheAccent {

		var before = gui.accent;

		gui.color(\notAColor);

		this.assertEquals(gui.accent, before, "un color invalido no rompe la vista");

	}

	test_colorWithoutArgumentCanChain {

		this.assert(gui.color === gui,
			"color() sin argumento devuelve la vista y permite encadenar");

	}

	test_randomColorStepIsAColorAndAWait {

		var allowedBeats = #[0.5, 1, 2, 4];

		8.do {
			var step = CaosBoxGUI.randomColorStep;

			this.assert(
				CaosBoxGUI.colorAliases[step[\color]].notNil,
				"el color del paso existe en la paleta");

			this.assert(
				allowedBeats.includes(step[\beats]),
				"la espera es musical: 0.5, 1, 2 o 4 beats");
		};

	}

	test_colorRandomStartsAndStops {

		this.assert(gui.colorRandomTask.isNil,
			"el easter egg arranca apagado");

		gui.randomColor(true);

		this.assert(gui.colorRandomTask.notNil,
			"randomColor(true) crea el Task");

		this.assert(gui.colorRandomTask.clock === TempoClock.default,
			"espera en beats del mismo reloj que la secuencia");

		this.assert(gui.colorRandomTask.isPlaying,
			"el Task queda corriendo");

		gui.randomColor(false);

		this.assert(gui.colorRandomTask.isNil,
			"randomColor(false) lo detiene y libera");

		gui.randomColor(false);// idempotente, como un transporte

		this.assert(gui.colorRandomTask.isNil,
			"apagarlo dos veces no rompe nada");

		gui.random(true);// alias corto de la API original

		this.assert(gui.colorRandomTask.notNil,
			"el alias random tambien arranca el ciclo");

		gui.random(false);

	}

	test_playheadColorFollowsTheAccent {

		gui.color(\orange);

		this.assertEquals(gui.playheadColor,
			CaosBoxGUI.colorAliases[\orange].blend(Color.white, 0.7));

	}

	test_routeChangedRefreshesThePopup {

		var popup = CaosTestStateButton.new;

		gui.addRoute(\bass, popup, [\master, \delay]);
		gui.routeChanged(\bass, \delay);
		0.01.wait;

		this.assertEquals(popup.value, 1,
			"la ruta de pista actualiza el popup");

	}

	test_fxRouteChangedRefreshesThePopup {

		var popup = CaosTestStateButton.new;

		gui.addFxRoute(\pitch, popup, [\master, \delay, \reverb]);
		gui.fxRouteChanged(\pitch, \reverb);
		0.01.wait;

		this.assertEquals(popup.value, 2,
			"la ruta de FX actualiza el popup");

	}

	test_muteAndSoloViewsAreRegistered {

		var mute = CaosTestStateButton.new;
		var solo = CaosTestStateButton.new;

		gui.addMuteView(\kick, mute);
		gui.addSoloView(\kick, solo);

		this.assertEquals(gui.muteViews[\kick], mute, "the mute view is indexed");
		this.assertEquals(gui.soloViews[\kick], solo, "the solo view is indexed");

	}

	test_trackStateChangedRefreshesMuteAndSolo {

		var track = CaosTrack.new(\kick, \snapshot, 4, { nil });
		var mute = CaosTestStateButton.new;
		var solo = CaosTestStateButton.new;

		~cbox_tracks = Dictionary[\kick -> track];
		gui.addMuteView(\kick, mute);
		gui.addSoloView(\kick, solo);

		track.muted_(true);
		track.solo_(true);
		gui.trackStateChanged(\kick);
		0.01.wait;

		this.assertEquals(mute.value, 1, "the mute button follows the model");
		this.assertEquals(solo.value, 1, "the solo button follows the model");

		track.muted_(false);
		track.solo_(false);
		gui.trackStateChanged(\kick);
		0.01.wait;

		this.assertEquals(mute.value, 0, "the mute button clears");
		this.assertEquals(solo.value, 0, "the solo button clears");

	}

	test_trackPatternChangedRefreshesTheRandomView {

		var track = CaosTrack.new(\kick, \snapshot, 4, { \fn });
		var random = CaosTestStateButton.new;

		~cbox_tracks = Dictionary[\kick -> track];
		gui.addRandomView(\kick, random);

		CaosBox.randPattern(\kick, density: 0.5);
		gui.trackPatternChanged(\kick);
		0.01.wait;

		this.assertEquals(random.value, 1,
			"the R button turns on when there is history");

		CaosBox.restorePattern(\kick);
		gui.trackPatternChanged(\kick);
		0.01.wait;

		this.assertEquals(random.value, 0,
			"the R button turns off after restore");

	}

	test_trackProbabilityChangedRefreshesTheView {

		var track = CaosTrack.new(\bass, \live, 4);
		var box = CaosTestStateButton.new;

		~cbox_tracks = Dictionary[\bass -> track];
		gui.addProbabilityView(\bass, box);

		CaosBox.trackProbability(\bass, 0.85);
		gui.trackProbabilityChanged(\bass);
		0.01.wait;

		this.assertEquals(box.value, 85,
			"the view receives the playback chance as a percentage");

	}

	test_caosBoxGuiIsTheSameRegistry {

		this.assert(CaosBox.gui === CaosBox.gui,
			"CaosBox.gui devuelve siempre el mismo registro");

	}

}


// Boton falso: solo guarda el valor, sin Qt ni ventana.
CaosTestStateButton {

	var <value;

	value_ {|state|
		value = state;
		^this;
	}

}
