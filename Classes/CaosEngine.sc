// CaosBox v2.1.2 - Engine: server, execution order and bus map
//
// Un solo dueno del server, del orden de ejecucion y de los buses. Los
// instrumentos piden su salida por nombre (\master, \reverb, \lpf, ...) y el
// engine la resuelve a un indice de bus. Un numero sigue funcionando, y un Bus
// tambien, para no romper codigo existente.
//
// El layout conserva los buses historicos (50..64) para no romper los SynthDefs
// actuales; cuando los SynthDefs reciban su bus por parametro se puede pasar a
// Bus.audio (allocator del server) sin cambiar la API.

CaosEngine {

	classvar <layout;
	classvar <defaultRoot = 1;// grupo por defecto del server

	var <server, <output;
	var <buses, <busNames;
	var <groups;
	var <startBus;
	var <>memSize = 66666;
	var <>maxNodes = 4096;

	*initClass {
		layout = [
			[\master, 2],  // 50-51: entrada del master (donde escriben los instrumentos)
			[\reverb, 2],  // 52-53
			[\delay, 2],   // 54-55
			[\pitch, 2],   // 56-57
			[\lpf, 2],     // 58-59
			[\hpf, 2],     // 60-61
			[\bpf, 2],     // 62-63
			[\grains, 2]   // 64-65: el granulador tambien acepta estereo
		];
	}

	*new { |server, output, startBus = 50|
		^super.new.init(server, output, startBus);
	}

	init { |argServer, argOutput, argStartBus|

		server = argServer ? Server.default;
		output = argOutput ? server;
		startBus = argStartBus;
		buses = IdentityDictionary.new;
		busNames = List.new;

		this.makeBuses;

		^this;

	}

	// --- buses ---------------------------------------------------------

	makeBuses {

		var index = startBus;

		layout.do { |pair|
			var name = pair[0], channels = pair[1];
			buses.put(name, Bus.new(\audio, index, channels, server));
			busNames.add(name);
			index = index + channels;
		};

		^this;

	}

	// indice de bus -> nombre (nil si no es un bus del layout)
	nameFor { |index|

		var found;

		layout.do { |pair|
			if(buses[pair[0]].index == index, { found = pair[0] });
		};

		^found;

	}

	bus { |name|

		var bus = buses[name];

		if(bus.isNil, {
			Error("CaosEngine: unknown bus %, use one of %".format(name, busNames)).throw;
		});

		^bus;

	}

	busIndex { |name| ^this.bus(name).index }

	// nombre -> indice; numero y Bus pasan tal cual (compatibilidad)
	resolveOut { |out|

		if(out.isKindOf(Symbol), { ^this.busIndex(out) });
		if(out.isKindOf(Bus), { ^out.index });
		if(out.isKindOf(Number), { ^out });

		^Error("CaosEngine: out must be a Symbol, a Bus or a Number, got %".format(out)).throw;

	}

	// --- grupos --------------------------------------------------------

	// instrumentos -> fx -> master, en ese orden de ejecucion
	makeGroups {

		var ids;

		if(groups.notNil, { this.freeGroups });

		ids = [\instruments, \fx, \master].collect { |name| output.nextNodeID };

		ids.do { |id|
			output.sendBundle(nil, ['/g_new', id, 1, defaultRoot]);// addToTail
		};

		groups = IdentityDictionary[
			\instruments -> ids[0],
			\fx -> ids[1],
			\master -> ids[2]
		];

		^this;

	}

	// sin grupos, el destino es el grupo raiz del server
	groupID { |name|

		var id = groups !? { |all| all[name] };

		if(id.isNil, { ^defaultRoot });

		^id;

	}

	freeGroups {

		if(groups.notNil, {
			groups.keysValuesDo { |name, id|
				output.sendBundle(nil, ['/n_free', id]);
			};
		});

		groups = nil;

		^this;

	}

	// --- server --------------------------------------------------------

	boot { |onReady|

		server.options.memSize = memSize;
		server.options.maxNodes = maxNodes;

		server.waitForBoot {
			this.makeGroups;
			server.sync;
			onReady.value(this);
		};

		^this;

	}

	isReady { ^groups.notNil and: { server.serverRunning } }

	free {

		this.freeGroups;

		^this;

	}

	printOn { |stream| stream << "CaosEngine(" << server.name << ")" }

}
