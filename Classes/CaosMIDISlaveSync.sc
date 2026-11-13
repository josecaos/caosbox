// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.7.4 - MIDI clock slave tap
//
// Escucha el clock de un equipo externo (24 ppqn) y ajusta TempoClock para
// que la secuencia de CaosBox lo siga. Tambien sigue Start/Stop/Continue:
// Start reinicia y arranca, Stop pausa conservando el paso y Continue reanuda.
//
// El tempo se estima promediando una ventana de intervalos, se actualiza una
// vez por beat y se suaviza para no reaccionar al jitter de cada tick.

CaosMIDISlaveSync {

	classvar <window = 24;// intervalos (un beat) para estimar el tempo
	classvar <minBpm = 20;
	classvar <maxBpm = 300;

	var <seq;
	var <clock;
	var timeFunc;
	var <transport;
	var <intervals;
	var <lastTime;
	var <lastBpm;
	var tickCount = 0;
	var midiClockDef, startDef, stopDef, continueDef;

	*new {|seq, clock, timeFunc, transport|

		^super.new.init(seq, clock, timeFunc, transport);

	}

	init {|argSeq, argClock, argTimeFunc, argTransport|

		seq = argSeq;
		clock = argClock ? TempoClock.default;
		timeFunc = argTimeFunc ? { Main.elapsedTime };
		transport = argTransport ? CaosBox;
		intervals = List.new;

		^this;

	}

	// Conecta los MIDIdef al dispositivo (uid) de la fuente de clock.
	install {|srcID|

		midiClockDef = MIDIdef.midiClock(\cbox_slave_clock, {|src|
			this.handleClock;
		}, srcID);

		startDef = MIDIdef.start(\cbox_slave_start, {|src|
			this.handleStart;
		}, srcID);

		stopDef = MIDIdef.stop(\cbox_slave_stop, {|src|
			this.handleStop;
		}, srcID);

		continueDef = MIDIdef.continue(\cbox_slave_continue, {|src|
			this.handleContinue;
		}, srcID);

		^this;

	}

	free {

		midiClockDef !? {|def| def.free };
		startDef !? {|def| def.free };
		stopDef !? {|def| def.free };
		continueDef !? {|def| def.free };

		midiClockDef = nil;
		startDef = nil;
		stopDef = nil;
		continueDef = nil;

		^this;

	}

	// --- clock -----------------------------------------------------------

	handleClock {

		var now = timeFunc.value;
		var dt;

		if(lastTime.notNil, {
			dt = now - lastTime;

			if(dt >= 0.5, {
				// hueco largo: no mezclar el intervalo con el anterior
				this.prResetMeasurement;
			}, {
				if(dt > 0.001, {
					intervals.add(dt);
					tickCount = tickCount + 1;
				});
			});
		});

		lastTime = now;

		if(tickCount >= window, {
			this.prUpdateTempo;
			tickCount = 0;
		});

		^this;

	}

	// --- transporte ------------------------------------------------------

	handleStart {

		this.prResetMeasurement;
		transport.stop;
		transport.play;

		^this;

	}

	handleStop {

		this.prResetMeasurement;
		transport.pause;

		^this;

	}

	handleContinue {

		this.prResetMeasurement;
		transport.play;

		^this;

	}

	// --- internos --------------------------------------------------------

	prResetMeasurement {

		intervals = List.new;
		lastTime = nil;
		tickCount = 0;

		^this;

	}

	prUpdateTempo {

		var avg, bpm, smoothed;

		if(intervals.size < window, { ^this });

		avg = intervals.copyRange(intervals.size - window, intervals.size - 1).sum / window;
		bpm = 60 / (avg * 24);

		if(bpm < minBpm or: { bpm > maxBpm }, {
			this.prResetMeasurement;
			^this;
		});

		smoothed = if(lastBpm.isNil, {
			bpm
		}, {
			lastBpm + ((bpm - lastBpm) * 0.25)
		});

		lastBpm = smoothed;

		// la GUI muestra enteros; TempoClock usa el valor fino
		seq.bpm = smoothed.round;
		clock.tempo = smoothed / 60;

		// ventana movil: los proximos 24 intervalos son todos nuevos
		intervals = intervals.copyRange(intervals.size - window, intervals.size - 1).asList;

		^this;

	}

	printOn {|stream|

		stream << "CaosMIDISlaveSync(" << (seq !? { seq.bpm }) << " bpm)";

	}

}
