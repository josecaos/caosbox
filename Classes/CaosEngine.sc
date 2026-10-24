
// No sabe nada de instrumentos, steps, GUI ni MIDI.

// CaosBox v2.0.0 - The engine
// Server, options, order of execution
// Not instruments, steps, GUI nor MIDI

CaosEngine {
    
	classvar <>default;// Leave for the future

	var <server;
	var <instruments, <fx, <master;
	var <>memSize = 66666;
	var <>maxNodes = 4096;

	*new {|server|

		^super.new.init(server);

	}

	init {|argServer|

		server = argServer ? Server.default;

		^this;

	}

	boot {|onReady|

		server.options.memSize = memSize;
		server.options.maxNodes = maxNodes;

		server.waitForBoot({

			this.makeGroups;
			server.sync;
			onReady.value(this);

		});

		^this;

	}

	// Orden de ejecución: instrumentos -> fx -> master
	makeGroups {

		instruments = Group.head(server.defaultGroup);
		fx          = Group.after(instruments);
		master      = Group.after(fx);

		^this;

	}

	freeGroups {

		[instruments, fx, master].do({|group| group !? { group.free } });

		instruments = nil;
		fx = nil;
		master = nil;

		^this;

	}

	isReady {

		^server.serverRunning and: { instruments.notNil };

	}

}