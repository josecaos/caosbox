// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.7.3 - MIDI clock master tap
//
// Manda 24 ppqn por una salida y sigue TempoClock.default, asi que respeta
// el BPM y el tiempo aleatorio de la caja. Los ticks se agendan en beats
// absolutos (1/24) para no acumular drift; el transporte Start/Stop/Continue
// va aparte.
//
// El clock puede quedar corriendo mientras el equipo externo esta parado:
// Start/Stop/Continue son los que manejan su transporte.

CaosMIDIClock {

	classvar <ticksPerBeat = 24;

	var <out;
	var <clock;
	var <running = false;
	var <hasStarted = false;
	var nextBeat = 0;
	var generation = 0;

	*new {|out, clock|

		^super.new.init(out, clock);

	}

	init {|argOut, argClock|

		out = argOut;
		clock = argClock ? TempoClock.default;
		nextBeat = clock.beats;

		^this;

	}

	tickBeats { ^1 / ticksPerBeat }

	// arranca / detiene los ticks; no manda transporte
	start {

		if(running, { ^this });

		running = true;
		generation = generation + 1;
		nextBeat = clock.beats;
		this.prSchedule;

		^this;

	}

	stop {

		running = false;
		generation = generation + 1;

		^this;

	}

	// deja de mandar clock y avisa Stop al equipo externo
	free {

		this.stop;
		out.stop;

		^this;

	}

	// --- transporte -----------------------------------------------------

	sendStart { hasStarted = true; out.start; ^this }
	sendStop { out.stop; ^this }
	sendContinue { hasStarted = true; out.continue; ^this }

	// --- internos -------------------------------------------------------

	prSchedule {

		var gen = generation;

		clock.schedAbs(nextBeat, {
			if(running and: { gen == generation }, {
				out.midiClock;
				nextBeat = nextBeat + this.tickBeats;
				this.prSchedule;
			});
			nil;
		});

		^this;

	}

	printOn {|stream|

		stream << "CaosMIDIClock(" << (out !? { out.endpoint }) << ")";

	}

}
