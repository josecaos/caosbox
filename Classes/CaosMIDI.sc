// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.7.0 - MIDI infrastructure
//
// Capa de dispositivos y lifecycle. No conoce tracks ni GUI. Los mapeos y las
// voces MIDI viven en otras capas; el mapa XSession actual sigue en
// CB/CaosBox-midi.scd durante esta primera etapa.

CaosMIDI {

	classvar <outputPorts;
	classvar <trackOuts;
	classvar <trackIns;
	classvar <masterSyncs;
	classvar monitorFuncs;
	classvar <monitorOn = false;

	*initClass {

		outputPorts = IdentityDictionary.new;
		trackOuts = IdentityDictionary.new;
		trackIns = IdentityDictionary.new;
		masterSyncs = Dictionary.new;

	}

	// Inicializa el cliente. Por defecto no conecta nada: la seleccion es
	// manual. `autoConnect: true` existe para el bootstrap legacy de XSession.
	*start {|autoConnect = false|

		if(MIDIClient.initialized.not, {
			try {
				MIDIClient.init(verbose: false);
			} {|error|
				("CaosMIDI: MIDI unavailable: " ++ error.errorString).warn;
				^this;
			};
		});

		if(autoConnect == true, { this.connectAll });

		^this;

	}

	*inputs {

		^if(MIDIClient.initialized, { MIDIClient.externalSources }, { [] });

	}

	*destinations {

		^if(MIDIClient.initialized, { MIDIClient.externalDestinations }, { [] });

	}

	*devices {

		^(inputs: this.inputs, destinations: this.destinations);

	}

	*connectAll {

		if(MIDIClient.initialized.not, { this.start(false) });

		try {
			MIDIIn.connectAll(verbose: false);
		} {|error|
			("CaosMIDI.connectAll: " ++ error.errorString).warn;
		};

		^this;

	}

	// Conecta una entrada por endpoint, nombre o uid. `inport` permite tener
	// mas de un dispositivo conectado a la vez.
	*connect {|device, inport = 0|

		var source;

		if(MIDIClient.initialized.not, { this.start(false) });

		source = this.prFind(this.inputs, device);

		if(source.isNil, {
			("CaosMIDI.connect: input not found " ++ device).warn;
			^nil;
		});

		try {
			MIDIIn.connect(inport.asInteger, source);
		} {|error|
			("CaosMIDI.connect: " ++ error.errorString).warn;
			^nil;
		};

		^source;

	}

	// Seleccion exclusiva: desconecta todo y conecta solo este dispositivo.
	*connectOnly {|device, inport = 0|

		this.disconnectAll;
		^this.connect(device, inport);

	}

	*disconnectAll {

		if(MIDIClient.initialized, { MIDIIn.disconnectAll });

		^this;

	}

	// Devuelve un wrapper de salida cacheado por endpoint + canal. En Linux
	// crea la conexion ALSA/JACK automaticamente; en otras plataformas usa el
	// uid directo de `newByName`.
	*out {|device, channel = 0, autoConnect = true|

		var dest, raw, key, port, destIndex;

		if(MIDIClient.initialized.not, { this.start(false) });

		dest = this.prFind(this.destinations, device);

		if(dest.isNil, {
			("CaosMIDI.out: output not found " ++ device).warn;
			^nil;
		});

		key = (dest.uid.asString ++ ":" ++ channel.asInteger).asSymbol;

		port = outputPorts[key];
		if(port.notNil, { ^port });

		destIndex = this.destinations.detectIndex {|ep| ep.uid == dest.uid };

		try {
			if(thisProcess.platform.name == \linux
				and: { destIndex.notNil }
				and: { MIDIClient.myoutports.notNil }
				and: { destIndex < MIDIClient.myoutports }, {
				// En Linux usar el puerto de SC y conectarlo; el uid directo
				// no siempre crea la conexion visible en ALSA/JACK.
				raw = MIDIOut.new(destIndex, 0);
			}, {
				raw = MIDIOut.newByName(dest.device, dest.name, false);
			});
		} {|error|
			("CaosMIDI.out: " ++ error.errorString).warn;
			^nil;
		};

		if(raw.isNil, {
			("CaosMIDI.out: could not open " ++ dest).warn;
			^nil;
		});

		if(autoConnect == true and: { thisProcess.platform.name == \linux }, {
			if(destIndex.notNil, {
				try {
					raw.connect(destIndex);
				} {|error|
					("CaosMIDI.out: could not connect output: " ++ error.errorString).warn;
				};
			});
		});

		port = CaosMIDIOut.new(raw, channel, dest);
		outputPorts[key] = port;

		^port;

	}

	// Engancha una salida MIDI a una pista. La voz de audio sigue sonando.
	// En percusion `note` es obligatorio; en melodicos se usa la nota actual
	// de CaosInstrument. El primer argumento puede ser el simbolo de la pista,
	// un CaosTrack o un CaosInstrument (se resuelve a su pista).
	*attachOut {|track, device, channel = 0, note, velocity = 100|

		var tr, port, trackOut;

		tr = this.prResolveTrack(track);

		if(tr.isNil, {
			("CaosMIDI.attachOut: unknown track " ++ track).warn;
			^nil;
		});

		if(tr.mode == \snapshot and: { note.isNil }, {
			("CaosMIDI.attachOut: percussion tracks need note: for " ++ tr.name).warn;
			^nil;
		});

		port = this.out(device, channel);
		if(port.isNil, { ^nil });

		trackOuts[tr] !? {|old| old.free };

		trackOut = CaosMIDITrackOut.new(tr, port, note, velocity);
		trackOuts[tr] = trackOut;

		^trackOut;

	}

	*detachOut {|track|

		var tr, trackOut;

		tr = this.prResolveTrack(track);
		trackOut = trackOuts.removeAt(tr);
		trackOut !? {|t| t.free };

		^trackOut;

	}

	// Engancha un teclado MIDI a una pista melodica. La entrada tiene que
	// estar conectada: el bootstrap de CaosBox ya hace connectAll; si no,
	// usar CaosMIDI.connect antes. `channel` nil = omni.
	*attachIn {|track, device, channel = 0|

		var tr, src, tap;

		tr = this.prResolveTrack(track);

		if(tr.isNil, {
			("CaosMIDI.attachIn: unknown track " ++ track).warn;
			^nil;
		});

		if(tr.mode != \live, {
			("CaosMIDI.attachIn: percussion input is not supported yet for " ++ tr.name).warn;
			^nil;
		});

		if(tr.instrument.isNil, {
			("CaosMIDI.attachIn: track has no voice yet " ++ tr.name).warn;
			^nil;
		});

		if(MIDIClient.initialized.not, { this.start(false) });

		src = this.prFind(this.inputs, device);
		if(src.isNil, {
			("CaosMIDI.attachIn: input not found " ++ device).warn;
			^nil;
		});

		trackIns[tr] !? {|old| old.free };

		tap = CaosMIDITrackIn.new(tr);
		tap.install(src.uid, if(channel.isNil, { nil }, { channel.asInteger.clip(0, 15) }));
		trackIns[tr] = tap;

		^tap;

	}

	*detachIn {|track|

		var tr, tap;

		tr = this.prResolveTrack(track);
		tap = trackIns.removeAt(tr);
		tap !? {|t| t.free };

		^tap;

	}

	// Engancha un clock maestro a una salida. El tap manda 24 ppqn sobre
	// TempoClock.default y el transporte lo maneja CaosBox.
	*attachMasterSync {|device|

		var dest, out, sync;

		if(MIDIClient.initialized.not, { this.start(false) });

		dest = this.prFind(this.destinations, device);
		if(dest.isNil, {
			("CaosMIDI.attachMasterSync: output not found " ++ device).warn;
			^nil;
		});

		sync = masterSyncs[dest.uid];
		if(sync.notNil, { ^sync });

		out = this.out(dest, 0);
		if(out.isNil, { ^nil });

		sync = CaosMIDIClock.new(out);
		sync.start;
		masterSyncs.put(dest.uid, sync);

		// si la caja ya esta sonando, el equipo externo arranca ahora
		if(~cbox_seq.notNil and: { ~cbox_seq.isPlaying }, { sync.sendStart });

		^sync;

	}

	*detachMasterSync {|device|

		var dest, sync;

		if(MIDIClient.initialized.not, { ^nil });

		dest = this.prFind(this.destinations, device);
		if(dest.isNil, {
			("CaosMIDI.detachMasterSync: output not found " ++ device).warn;
			^nil;
		});

		sync = masterSyncs.removeAt(dest.uid);
		sync !? {|s| s.free };

		^sync;

	}

	// Start (o Continue si la caja venia pausada) para todos los maestros.
	// Si el tap nunca recibio un Start/Continue, resume con Start: un
	// Continue sin Start previo puede dejar el equipo parado.
	*startMasterSyncs {|resume = false|

		masterSyncs.do {|sync|
			if(resume and: { sync.hasStarted }, {
				sync.sendContinue;
			}, {
				sync.sendStart;
			});
		};

		^this;

	}

	*stopMasterSyncs {

		masterSyncs.do {|sync| sync.sendStop };

		^this;

	}

	*panic {

		trackIns.do {|tap| tap !? {|t| t.releaseAll } };
		trackOuts.do {|trackOut| trackOut !? {|t| t.panic } };
		outputPorts.do {|port| port !? {|p| p.allNotesOff } };
		^this;

	}

	*monitor {|on = true|

		this.prStopMonitor;

		if(on.asBoolean, {
			monitorFuncs = [
				MIDIFunc.noteOn({|vel, num, chan, src|
					this.prMonitorPost("noteOn", num, vel, chan, src);
				}),
				MIDIFunc.noteOff({|vel, num, chan, src|
					this.prMonitorPost("noteOff", num, vel, chan, src);
				}),
				MIDIFunc.cc({|val, num, chan, src|
					this.prMonitorPost("cc", num, val, chan, src);
				}),
				MIDIFunc.program({|val, chan, src|
					this.prMonitorPost("program", val, nil, chan, src);
				}),
				MIDIFunc.bend({|val, chan, src|
					this.prMonitorPost("bend", val, nil, chan, src);
				})
			];
			monitorOn = true;
		});

		^this;

	}

	*monitorOff {

		^this.monitor(false);

	}

	*free {

		this.monitor(false);
		masterSyncs.do {|sync| sync !? {|s| s.free } };
		masterSyncs = Dictionary.new;
		trackIns.do {|tap| tap !? {|t| t.free } };
		trackIns = IdentityDictionary.new;
		trackOuts.do {|trackOut| trackOut !? {|t| t.free } };
		trackOuts = IdentityDictionary.new;
		this.panic;
		this.disconnectAll;
		outputPorts = IdentityDictionary.new;

		^this;

	}

	// --- internos -----------------------------------------------------

	*prStopMonitor {

		monitorFuncs !? {|funcs| funcs.do(_.free) };
		monitorFuncs = nil;
		monitorOn = false;

		^this;

	}

	*prMonitorPost {|kind, num, val, chan, src|

		("CaosMIDI monitor: % num=% val=% chan=% src=%"
			.format(kind, num, val, chan, src)).postln;

		^this;

	}

	// Acepta simbolo de pista, nombre de instrumento, CaosTrack o
	// CaosInstrument; devuelve el CaosTrack. Un instrumento se resuelve por
	// su campo `track`; un simbolo que no es pista se busca por nombre de voz.
	*prResolveTrack {|track|

		var tr, voice;

		if(track.isKindOf(CaosInstrument), { track = track.track });

		if(track.isKindOf(Symbol), {
			tr = CaosBox.tracks !? {|tracks| tracks[track] };
			if(tr.isNil, {
				voice = CaosBox.voices !? {|voices|
					voices.values.detect {|v| v.notNil and: { v.name == track } };
				};
				if(voice.notNil, {
					tr = CaosBox.tracks !? {|tracks| tracks[voice.track] };
				});
			});
		}, {
			tr = track;
		});

		^if(tr.isKindOf(CaosTrack), { tr }, { nil });

	}

	*prFind {|endpoints, device|

		if(device.isKindOf(MIDIEndPoint), { ^device });

		// Comodidad: un entero dentro del rango es indice de la lista.
		if(device.isInteger and: { device >= 0 } and: { device < endpoints.size }, {
			^endpoints[device];
		});

		^endpoints.detect {|endpoint|
			endpoint.device == device
			or: { endpoint.name == device }
			or: { endpoint.uid == device }
			or: { endpoint.device.asString == device.asString }
			or: { endpoint.name.asString == device.asString }
		};

	}

}
