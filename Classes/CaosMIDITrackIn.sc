// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.7.2 - MIDI keyboard input tap
//
// Escucha una entrada MIDI y toca la voz de una pista melodica en modo
// monofonico: la ultima tecla manda y, al soltarla, vuelve la anterior.
// La secuencia no se congela: su linea sigue avanzando y el teclado es un
// disparo mas sobre la misma voz.
//
// No conoce la GUI ni el reloj. `install` conecta los MIDIdef; la logica de
// notas queda separada para poder testearla sin hardware.

CaosMIDITrackIn {

	var <track;
	var <heldNotes;   // pares [nota, velocity] en orden de pulsacion
	var <sounding;    // nota que mando el teclado, o nil
	var noteOnDef, noteOffDef;

	*new { |track|

		^super.new.init(track);

	}

	init { |argTrack|

		track = argTrack;
		heldNotes = List.new;
		sounding = nil;

		^this;

	}

	// Conecta los MIDIdef al dispositivo (uid) y canal. `channel` nil = omni.
	install { |srcID, channel|

		var key = ('cbox_in_' ++ track.name).asSymbol;

		noteOnDef = MIDIdef.noteOn((key ++ '_on').asSymbol, { |vel, num|
			this.noteOn(num, vel);
		}, nil, channel, srcID);

		noteOffDef = MIDIdef.noteOff((key ++ '_off').asSymbol, { |vel, num|
			this.noteOff(num);
		}, nil, channel, srcID);

		^this;

	}

	// MIDIIn ya convierte noteOn velocity 0 en noteOff; si esa opcion esta
	// apagada, lo cubrimos aca.
	noteOn { |noteNumber, velocity = 100|

		var num = noteNumber.asInteger.clip(0, 127);
		var voice;

		if(velocity == 0, { ^this.noteOff(num) });

		heldNotes.removeAllSuchThat { |pair| pair[0] == num };
		heldNotes.add([num, velocity.asInteger.clip(1, 127)]);

		voice = this.prVoice;
		if(track.isAudible and: { voice.notNil }, {
			sounding = num;
			voice.noteOn(num, velocity);
		});

		^this;

	}

	noteOff { |noteNumber|

		var num = noteNumber.asInteger.clip(0, 127);
		var voice;

		heldNotes.removeAllSuchThat { |pair| pair[0] == num };

		if(sounding == num, {
			voice = this.prVoice;
			voice !? { |it| it.noteOff(num) };

			if(heldNotes.notEmpty and: { track.isAudible }, {
				sounding = heldNotes.last[0];
				voice !? { |it| it.noteOn(sounding, heldNotes.last[1]) };
			}, {
				sounding = nil;
			});
		});

		^this;

	}

	// Suelta todo lo que el teclado dejo sonando (panic / detach).
	releaseAll {

		heldNotes.clear;

		if(sounding.notNil, {
			this.prVoice !? { |voice| voice.noteOff(sounding) };
			sounding = nil;
		});

		^this;

	}

	free {

		this.releaseAll;

		noteOnDef !? { |def| def.free };
		noteOffDef !? { |def| def.free };
		noteOnDef = nil;
		noteOffDef = nil;

		^this;

	}

	prVoice {

		^track !? { track.instrument };

	}

	printOn { |stream|

		stream << "CaosMIDITrackIn(" << (track !? { track.name }) << ")";

	}

}
