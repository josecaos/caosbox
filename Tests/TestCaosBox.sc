// CaosBox v2.5.1 - Tests for class-level automation controls
//
// Headless: no server, no GUI. Se comprueba que el contrato de pausa alcance
// tambien las automatizaciones que no tienen boton en la GUI (filtros).

TestCaosBox : UnitTest {

	var <automationNames;

	setUp {

		automationNames = #[\autor, \autod, \autop, \autog, \autolpf, \autohpf, \autobpf];

		// Tdefs de prueba con los mismos nombres que usa CaosBox
		automationNames.do {|name|
			Tdef(name, { inf.do { 1.wait } }).play;
		};

	}

	tearDown {

		automationNames.do {|name| Tdef(name).stop };

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
