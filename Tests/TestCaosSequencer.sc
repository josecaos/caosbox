// CaosBox v2.1.5 - Tests for the sequencer (Layer 3)
//
// Headless: no server, no GUI. Se prueba el estado del transporte y del tiempo;
// el loop real (Tdef) se valida a oido en la app.
//
// Desde el IDE: TestCaosSequencer.run

TestCaosSequencer : UnitTest {

	var <seq;
	var <stepCalls;
	var <prepareCalls;
	var <savedTempo;

	setUp {

		savedTempo = TempoClock.default.tempo;

		stepCalls = List.new;
		prepareCalls = 0;

		seq = CaosSequencer.new(
			{ |index| stepCalls.add(index) },
			{ |sequencer| prepareCalls = prepareCalls + 1 },
			size: 8, bpm: 120, stepDur: 0.25, randtimes: [40, 80],
			tdefName: \testSecuencias
		);

	}

	tearDown {

		Tdef(\testSecuencias).stop;
		TempoClock.default.tempo = savedTempo;

	}

	// ------------------------------------------------------------------
	// construccion
	// ------------------------------------------------------------------

	test_defaults {

		var plain = CaosSequencer.new({ }, nil, tdefName: \testSecuenciasDefaults);

		this.assertEquals(plain.size, 32);
		this.assertEquals(plain.bpm, 126);
		this.assertEquals(plain.stepDur, 0.25);
		this.assertEquals(plain.index, 0);
		this.assertEquals(plain.randtimes, CaosSequencer.defaultRandTimes);
		this.assert(plain.randomTime.not, "random time is off by default");
		this.assert(plain.isRunning.not, "not running before play");

		Tdef(\testSecuenciasDefaults).stop;

	}

	test_customSettings {

		this.assertEquals(seq.size, 8);
		this.assertEquals(seq.bpm, 120);
		this.assertEquals(seq.stepDur, 0.25);
		this.assertEquals(seq.randtimes, [40, 80]);
		this.assertEquals(seq.index, 0);
		this.assert(seq.randomTime.not);

	}

	// ------------------------------------------------------------------
	// tiempo
	// ------------------------------------------------------------------

	test_bpmSetsTheClockTempo {

		seq.bpm = 90;

		this.assertEquals(TempoClock.default.tempo, 1.5,
			"90 bpm = 1.5 beats per second");

	}

	test_tempoChangeNotifiesTheView {

		var seen = List.new;

		seq.onTempoChange = {|value| seen.add(value) };

		seq.bpm = 100;

		this.assertEquals(seen.size, 1, "one notification per change");
		this.assertEquals(seen.last, 100, "the view hears the new bpm");

		// en random time el aviso lleva el bpm sorteado, no el principal
		seen.clear;
		seq.stepDur = 0.001;
		seq.randomTime = true;
		seq.prWait;

		this.assert([40, 80].includes(seen.last),
			"the view hears the random bpm");

	}

	test_randomTimeRestoresTheMainTempo {

		seq.bpm = 120;
		seq.randomTime = true;

		TempoClock.default.tempo = 3.0;// como si estuviera en modo random
		seq.randomTime = false;

		this.assertEquals(TempoClock.default.tempo, 2.0,
			"leaving random time restores the main bpm");

	}

	test_stepDurIsSettable {

		seq.stepDur = 1/3;

		this.assertEquals(seq.stepDur, 1/3);

	}

	// ------------------------------------------------------------------
	// indice
	// ------------------------------------------------------------------

	test_nextIndexWrapsAround {

		seq.jumpTo(7);// ultimo step de 8
		this.assertEquals(seq.nextIndex, 0, "wraps to the first step");

		seq.jumpTo(0);
		this.assertEquals(seq.nextIndex, 1, "advances");

	}

	test_jumpToWrapsTheIndex {

		seq.jumpTo(10);// 10 % 8
		this.assertEquals(seq.index, 2);

	}

	test_stopResetsTheIndex {

		seq.jumpTo(5);
		seq.stop;

		this.assertEquals(seq.index, 0, "stop goes back to the top");
		this.assert(seq.isRunning.not, "not running after stop");

	}

	test_resumeKeepsTheStep {

		seq.jumpTo(5);
		seq.pause;
		seq.prPrepareStart;

		this.assertEquals(seq.index, 5,
			"resuming after pause does not restart the sequence");

	}

	test_cleanStartGoesBackToTheTop {

		seq.jumpTo(5);
		seq.stop;
		seq.prPrepareStart;

		this.assertEquals(seq.index, 0,
			"a clean start (after stop) begins at the top");

	}

	// ------------------------------------------------------------------
	// preparacion de voces fijas
	// ------------------------------------------------------------------

	test_prepareRunsOnlyOnce {

		seq.prepare;
		seq.prepare;

		this.assertEquals(prepareCalls, 1,
			"master/fx voices are created a single time");

	}

	test_prepareWithoutAFunctionIsSafe {

		var plain = CaosSequencer.new({ }, nil, tdefName: \testSecuenciasNoPrepare);

		plain.prepare;
		plain.prepare;

		this.assert(plain.prepared, "prepared is set even with no prepare func");

		Tdef(\testSecuenciasNoPrepare).stop;

	}

}
