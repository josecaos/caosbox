// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.1.5 - Sequencer: un solo dueno del tiempo
//
// El sequencer posee el indice (0..size-1), la duracion del step (en beats), el
// BPM, el modo de tiempo aleatorio y el Tdef(\secuencias). El GUI y la API le
// hablan a el; las pistas solo reciben su step.
//
// La senal de vida sigue siendo un Tdef (idiomatico en SC), pero ahora es un
// detalle interno: nadie mas lee ~cbox_indice ni ~cbox_tiempos.

CaosSequencer {

	classvar <defaultSize = 32;
	classvar <defaultBpm = 126;
	classvar <defaultStepDur = 0.25;
	classvar <defaultRandTimes = #[47, 62, 94, 141, 188];

	var <size;
	var <index = 0;
	var <stepDur;
	var <bpm;
	var <randomTime = false;
	var <randtimes;
	var <running = false;
	var <paused = false;
	var <prepared = false;
	var <tdef;
	var stepFunc, prepareFunc;
	var <>onTempoChange;// aviso a la vista (numbox de BPM)

	*new { |step, prepare, size = 32, bpm = 126, stepDur = 0.25, randtimes, tdefName = \secuencias|

		^super.new.init(step, prepare, size, bpm, stepDur, randtimes, tdefName);

	}

	init { |argStep, argPrepare, argSize, argBpm, argStepDur, argRandtimes, argTdefName|

		stepFunc = argStep;
		prepareFunc = argPrepare;
		size = argSize ? defaultSize;
		bpm = argBpm ? defaultBpm;
		stepDur = argStepDur ? defaultStepDur;
		randtimes = argRandtimes ? defaultRandTimes;

		tdef = Tdef(argTdefName, { this.prRun });

		this.prApplyTempo;

		^this;

	}

	// --- estado / transporte -------------------------------------------

	isPlaying { ^tdef.isPlaying }
	isRunning { ^running }

	play {

		if(tdef.isPlaying, { ^this });

		this.prPrepareStart;// desde 0 si es arranque limpio, o donde iba
		this.prepare;
		tdef.play;
		running = true;
		paused = false;

		^this;

	}

	// pausa conservando el indice; play reanuda desde ahi
	pause {

		tdef.pause;
		running = false;
		paused = true;

		^this;

	}

	// stop vuelve al principio la proxima vez que se arranque
	stop {

		tdef.stop;
		running = false;
		paused = false;
		index = 0;

		^this;

	}

	// regla del transporte: reanudar conserva el paso, arrancar limpio no
	prPrepareStart {

		if(paused.not, { index = 0 });

		^this;

	}

	// crea las voces fijas (master, fx, filtros) una sola vez
	prepare {

		if(prepared.not, {
			prepareFunc !? { |func| func.value(this) };
			prepared = true;
		});

		^this;

	}

	jumpTo { |newIndex|

		index = newIndex.asInteger % size;

		^this;

	}

	// --- tiempo ---------------------------------------------------------

	bpm_ { |val|

		bpm = val;
		this.prApplyTempo;

		^this;

	}

	stepDur_ { |val|

		stepDur = val;

		^this;

	}

	// al apagar el tiempo aleatorio vuelve el BPM principal
	randomTime_ { |bool|

		randomTime = bool ? false;

		if(randomTime.not) { this.prApplyTempo };

		^this;

	}

	randtimes_ { |array|

		randtimes = array.asArray;

		^this;

	}

	nextIndex { ^(index + 1) % size }

	// --- internos -------------------------------------------------------

	prApplyTempo {

		TempoClock.tempo = bpm / 60;
		this.prNotifyTempo(bpm);

		^this;

	}

	prNotifyTempo {|value|

		if(onTempoChange.notNil, { onTempoChange.value(value) });

		^this;

	}

	prWait {

		var randomBpm;

		if(randomTime, {
			randomBpm = randtimes.choose;
			TempoClock.tempo = randomBpm / 60;
			this.prNotifyTempo(randomBpm);
		}, {
			this.prApplyTempo;
		});

		stepDur.wait;

		^this;

	}

	prRun {

		// el indice avanza antes de esperar: si el Tdef se reinicia al
		// reanudar, continua con el step siguiente en vez de repetir el actual
		loop {
			stepFunc.value(index);
			index = (index + 1) % size;
			this.prWait;
		}

	}

	printOn { |stream|

		stream << "CaosSequencer(" << size << " steps, " << bpm << " bpm)";

	}

}
