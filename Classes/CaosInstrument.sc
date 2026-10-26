// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.1.1 - Instrument (voice) model
//
// Un instrumento es la voz de una pista: sabe como sonar (un SynthDef o una
// funcion), por donde sale, con que parametros y, si es melodico, como avanza
// su linea de notas. No conoce la GUI, ni los steps, ni el reloj: recibe ordenes
// (advance / trigger / set / release / free) y habla OSC.
//
//   kind:  \synth    voz persistente creada con /s_new (melodicos)
//          \function funcion jugable con .play (percusion, snapshot por step)
//   mode:  \free     la nota avanza con el reloj; el secuenciador llama advance
//                    en cada step (como los Tdef de hoy)
//          \trig     la nota avanza al dispararse
//   retrigger: false (legato) una sola voz que cambia de nota sin reatacar
//              true  una voz nueva por disparo (attack por step)
//
// La percusion es siempre \function: cada disparo crea su sonido y no hay voz
// persistente que mantener, asi que el legato no le aplica.
//
// El instrumento no agenda nada: quien decide cuando avanzar y cuando disparar
// es el secuenciador. Eso es lo que elimina los Tdef sueltos y el bug del pad.

CaosInstrument {

	classvar <defaultOut = 50;
	classvar <kinds = #[\synth, \function];
	classvar <modes = #[\free, \trig];

	var <name;
	var <track;
	var <kind;
	var <defName;
	var <func;
	var <out;
	var <params;
	var <mode;
	var <retrigger;
	var <noteOrder;
	var <oneShot;
	var <notes;
	var <output;
	var <target;
	var <nodeID;
	var <note;
	var stream;

	*new { |name, track, kind = \synth, defName, func, out, params, notes, mode = \free, output, retrigger = false, noteOrder = \seq, oneShot = false, target|

		^super.new.init(name, track, kind, defName, func, out, params, notes, mode, output, retrigger, noteOrder, oneShot, target);

	}

	// atajo: percusion (funcion jugable, sin sintesis persistente)
	*percussion { |name, track, func, target|

		^this.new(name, track, \function, func: func, target: target);

	}

	// atajo: melodico (SynthDef persistente con linea de notas)
	*synth { |name, track, defName, out, params, notes, mode = \free, output, retrigger = false, noteOrder = \seq, oneShot = false, target|

		^this.new(name, track, \synth, defName: defName, out: out,
			params: params, notes: notes, mode: mode, output: output,
			retrigger: retrigger, noteOrder: noteOrder, oneShot: oneShot, target: target);

	}

	init { |argName, argTrack, argKind, argDefName, argFunc, argOut, argParams, argNotes, argMode, argOutput, argRetrigger, argNoteOrder, argOneShot, argTarget|

		name = argName.asSymbol;
		track = argTrack.asSymbol;
		kind = argKind;
		defName = argDefName;
		func = argFunc;
		out = argOut ? defaultOut;
		params = argParams ? Event.new;
		mode = argMode;
		retrigger = argRetrigger;
		noteOrder = argNoteOrder;
		oneShot = argOneShot;
		target = argTarget;
		output = argOutput ? Server.default;

		if(kinds.includes(kind).not, {
			Error("CaosInstrument(%): unknown kind %, use one of %".format(name, kind, kinds)).throw;
		});
		if(kind == \synth and: { defName.isNil }, {
			Error("CaosInstrument(%): \\synth instruments need a defName".format(name)).throw;
		});
		if(kind == \function and: { func.isNil }, {
			Error("CaosInstrument(%): \\function instruments need a func".format(name)).throw;
		});
		if(modes.includes(mode).not, {
			Error("CaosInstrument(%): unknown mode %, use one of %".format(name, mode, modes)).throw;
		});
		if(#[\seq, \rand].includes(noteOrder).not, {
			Error("CaosInstrument(%): unknown noteOrder %, use \\seq or \\rand".format(name, noteOrder)).throw;
		});
		if(oneShot and: { retrigger.not }, {
			// una voz one-shot no tiene sentido legato: cada trigger es una voz nueva
			retrigger = true;
		});

		this.notes_(argNotes);

		^this;

	}

	// --- notas ---------------------------------------------------------

	notes_ { |array|

		notes = if(array.isNil, { nil }, { array.asArray });
		stream = if(notes.notNil and: { notes.notEmpty }, {
			if(noteOrder == \rand, {
				Prand(notes, inf).asStream
			}, {
				Pseq(notes, inf).asStream
			})
		}, {
			nil
		});
		note = nil;

		^this;

	}

	// avanza la nota: el secuenciador la llama en cada step para los \free
	advance {

		if(mode == \free) {
			note = this.nextNote;
			// en legato la voz persistente canta la nota nueva sin reatacar
			if(retrigger.not) { this.prSetNoteOnVoice };
		};

		^this;

	}

	nextNote {

		if(stream.isNil) { ^note };

		^stream.next;

	}

	// --- ciclo de vida -------------------------------------------------

	trigger {

		if(kind == \function, { ^this.prTriggerFunction });

		^this.prTriggerSynth;

	}

	set { |...args|

		if(args.size.odd, {
			Error("CaosInstrument:set expects key/value pairs").throw;
		});

		args.pairsDo { |key, value| params.put(key, value) };

		// una voz one-shot muere sola: no se le manda /n_set; los params
		// nuevos entran en el siguiente trigger
		if(nodeID.notNil and: { oneShot.not }, {
			output.sendBundle(nil, ['/n_set', nodeID] ++ args);
		});

		^this;

	}

	out_ { |value|

		out = value;

		^this;

	}

	release {

		// one-shot: el envelope libera la voz; no hay nodo vivo que soltar
		if(oneShot, { nodeID = nil; ^this });

		if(nodeID.notNil, {
			output.sendBundle(nil, ['/n_set', nodeID, \gate, 0]);
			nodeID = nil;
		});

		^this;

	}

	free {

		if(oneShot, { nodeID = nil; ^this });

		if(nodeID.notNil, {
			output.sendBundle(nil, ['/n_free', nodeID]);
			nodeID = nil;
		});

		^this;

	}

	isPlaying { ^nodeID.notNil }

	// --- internals -----------------------------------------------------

	prTriggerFunction {

		// dentro del grupo de instrumentos, si el engine lo dio
		if(target.notNil, { func.play(target) }, { func.play });

		^this;

	}

	prTriggerSynth {

		if(mode == \trig) { note = this.nextNote };
		if(note.isNil) { note = this.nextNote };

		if(retrigger) {
			// las voces one-shot (envolventes percusivas) se liberan solas:
			// no hay que mandarles gate 0 a un nodo que ya murio
			if(oneShot.not) { this.release };
			nodeID = output.nextNodeID;
			output.sendBundle(nil, this.prNewMsg);
		} {
			// legato: una sola voz; si ya canta, solo actualiza nota y params
			if(nodeID.isNil, {
				nodeID = output.nextNodeID;
				output.sendBundle(nil, this.prNewMsg);
			}, {
				output.sendBundle(nil, ['/n_set', nodeID] ++ this.prVoicePairs);
			});
		};

		^this;

	}

	prSetNoteOnVoice {

		if(oneShot.not and: { nodeID.notNil } and: { note.notNil }, {
			output.sendBundle(nil, ['/n_set', nodeID, \note, note]);
		});

		^this;

	}

	// [\note, n, <params...>] — lo que se actualiza en una voz que ya canta
	prVoicePairs {

		var pairs = [];

		if(note.notNil, { pairs = pairs ++ [\note, note] });
		if(params.size > 0, {
			params.keysValuesDo { |key, value| pairs = pairs ++ [key, value] };
		});

		^pairs;

	}

	prNewMsg {

		var pairs = [\out, out, \gate, 1] ++ this.prVoicePairs;

		^(['/s_new', defName, nodeID, 0, target ? 0] ++ pairs);

	}

	printOn { |aStream|

		aStream << "CaosInstrument(" << name << ", " << kind << ", " << track << ")";

	}

}
