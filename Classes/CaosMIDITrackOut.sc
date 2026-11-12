// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.7.1 - MIDI output tap for one track
//
// Se engancha a CaosTrack.onTrigger y manda la nota del step a un
// CaosMIDIOut. No reemplaza la voz de audio: se suma a ella.

CaosMIDITrackOut {

	var <track;
	var <out;
	var <noteNumber;
	var <velocity;
	var <lastNote;
	var triggerFunc;

	*new {|track, out, noteNumber, velocity = 100|

		^super.new.init(track, out, noteNumber, velocity);

	}

	init {|argTrack, argOut, argNoteNumber, argVelocity|

		track = argTrack;
		out = argOut;
		noteNumber = argNoteNumber;
		velocity = argVelocity.asInteger.clip(0, 127);
		lastNote = nil;
		triggerFunc = {|t, index, value, voice|
			this.prTriggered(t, index, value, voice);
		};
		track.onCommand = triggerFunc;

		^this;

	}

	prTriggered {|t, index, value, voice|

		var note = noteNumber ? (voice !? {|v| v.note });

		if(note.isNumber, {
			lastNote !? {|old| out.noteOff(old) };
			out.noteOn(note.asInteger, velocity);
			lastNote = note.asInteger;
		});

		^this;

	}

	panic {

		lastNote !? {|note| out.noteOff(note) };
		lastNote = nil;

		^this;

	}

	free {

		this.panic;
		if(track.onCommand === triggerFunc, { track.onCommand = nil });

		^this;

	}

	printOn {|stream|

		stream << "CaosMIDITrackOut(" << track.name << " -> "
		<< out.endpoint << ", note " << noteNumber << ")";

	}

}
