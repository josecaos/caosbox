// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.7.0 - MIDI output wrapper
//
// Envuelve un MIDIOut de SuperCollider con canal, validacion de rangos y una
// API estable para tracks, teclado y mapeos. El backend es inyectable para
// poder testear sin hardware.

CaosMIDIOut {

	var <output;
	var <channel;
	var <endpoint;

	*new {|output, channel = 0, endpoint|

		^super.newCopyArgs(output, channel.asInteger.clip(0, 15), endpoint);

	}

	noteOn {|note = 60, velocity = 100|

		output.noteOn(channel, note.asInteger.clip(0, 127),
			velocity.asInteger.clip(0, 127));
		^this;

	}

	noteOff {|note = 60, velocity = 64|

		output.noteOff(channel, note.asInteger.clip(0, 127),
			velocity.asInteger.clip(0, 127));
		^this;

	}

	cc {|controller = 7, value = 64|

		output.control(channel, controller.asInteger.clip(0, 127),
			value.asInteger.clip(0, 127));
		^this;

	}

	program {|value = 0|

		output.program(channel, value.asInteger.clip(0, 127));
		^this;

	}

	bend {|value = 8192|

		output.bend(channel, value.asInteger.clip(0, 16383));
		^this;

	}

	allNotesOff {

		output.allNotesOff(channel);
		^this;

	}

	// --- reloj y transporte (system real-time, sin canal) ---------------

	midiClock { output.midiClock; ^this }
	start { output.start; ^this }
	stop { output.stop; ^this }
	continue { output.continue; ^this }

	// Linux: crea la conexion ALSA/JACK desde el puerto de SuperCollider.
	connect {|device = 0|

		if(thisProcess.platform.name == \linux, { output.connect(device) });
		^this;

	}

	disconnect {|device = 0|

		if(thisProcess.platform.name == \linux, { output.disconnect(device) });
		^this;

	}

	printOn {|stream|

		stream << "CaosMIDIOut(" << endpoint << ", channel " << channel << ")";

	}

}
