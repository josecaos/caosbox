// CaosBox v2.1.2 - Tests for the engine (Layer 1)
//
// Headless: no Server boot, no GUI. El engine habla contra un output inyectable,
// asi que se verifican buses, ruteo por nombre y mensajes de grupos sin audio.
//
// Desde el IDE: TestCaosEngine.run

TestCaosEngine : UnitTest {

	var <engine;
	var <spy;

	setUp {

		spy = CaosTestOutput.new(3000);
		engine = CaosEngine.new(Server.default, spy);

	}

	tearDown {

		engine = nil;
		spy = nil;

	}

	// ------------------------------------------------------------------
	// construccion
	// ------------------------------------------------------------------

	test_defaults {

		this.assertEquals(engine.server, Server.default);
		this.assertEquals(engine.output, spy);
		this.assertEquals(engine.memSize, 66666, "memSize default");
		this.assertEquals(engine.maxNodes, 4096, "maxNodes default");
		this.assert(engine.isReady.not, "not ready before boot");

	}

	test_acceptsAnExplicitServer {

		var other = Server(\caosTestServer, NetAddr("127.0.0.1", 57123));
		var custom = CaosEngine.new(other, spy);

		this.assertEquals(custom.server, other, "an explicit server is kept");
		other.remove;

	}

	// ------------------------------------------------------------------
	// buses
	// ------------------------------------------------------------------

	test_defaultBusLayout {

		this.assertEquals(engine.busNames.asArray,
			[\master, \reverb, \delay, \pitch, \lpf, \hpf, \bpf, \grains],
			"the named buses, in order");

		this.assertEquals(engine.busNames.collect { |name| engine.busIndex(name) }.asArray,
			[50, 52, 54, 56, 58, 60, 62, 64],
			"historic indices are preserved");

		this.assertEquals(engine.busNames.collect { |name| engine.bus(name).numChannels }.asArray,
			[2, 2, 2, 2, 2, 2, 2, 2],
			"stereo pairs, including the granulador input");

	}

	test_busNameForIndex {

		this.assertEquals(engine.nameFor(50), \master);
		this.assertEquals(engine.nameFor(52), \reverb);
		this.assertEquals(engine.nameFor(64), \grains);
		this.assertEquals(engine.nameFor(9999), nil,
			"an index outside the layout has no name");

	}

	test_busLookup {

		this.assertEquals(engine.bus(\reverb).index, 52);
		this.assertEquals(engine.bus(\grains).numChannels, 2);

		this.assertException({ engine.bus(\nope) }, Error,
			"an unknown bus must throw");

	}

	test_customStartBus {

		engine = CaosEngine.new(Server.default, spy, 100);

		this.assertEquals(engine.busIndex(\master), 100);
		this.assertEquals(engine.busIndex(\reverb), 102);
		this.assertEquals(engine.busIndex(\grains), 114);

	}

	// ------------------------------------------------------------------
	// ruteo por nombre
	// ------------------------------------------------------------------

	test_resolveOutAcceptsNamesNumbersAndBuses {

		this.assertEquals(engine.resolveOut(\reverb), 52);
		this.assertEquals(engine.resolveOut(\grains), 64);
		this.assertEquals(engine.resolveOut(0), 0, "numbers pass through");
		this.assertEquals(engine.resolveOut(engine.bus(\delay)), 54,
			"a Bus resolves to its index");

	}

	test_resolveOutRejectsUnknown {

		this.assertException({ engine.resolveOut(\nope) }, Error,
			"an unknown name must throw");
		this.assertException({ engine.resolveOut("reverb") }, Error,
			"a String is not a bus name");

	}

	// ------------------------------------------------------------------
	// grupos
	// ------------------------------------------------------------------

	test_makeGroupsAddsThemInExecutionOrder {

		engine.makeGroups;

		this.assertEquals(spy.messages.size, 3, "three /g_new");

		spy.messages.do { |msg|
			this.assertEquals(msg[0], '/g_new');
			this.assertEquals(msg[2], 1, "addToTail");
			this.assertEquals(msg[3], CaosEngine.defaultRoot, "inside the default group");
		};

		this.assert(engine.groupID(\instruments) < engine.groupID(\fx),
			"instruments execute before fx");
		this.assert(engine.groupID(\fx) < engine.groupID(\master),
			"fx executes before master");

	}

	test_groupIDFallsBackToTheRootGroup {

		this.assertEquals(engine.groupID(\nope), CaosEngine.defaultRoot);

	}

	test_freeGroupsFreesThem {

		engine.makeGroups;
		spy.reset;

		engine.freeGroups;

		this.assertEquals(spy.messages.size, 3, "three /n_free");
		spy.messages.do { |msg| this.assertEquals(msg[0], '/n_free') };
		this.assert(engine.groups.isNil, "the groups are forgotten");
		this.assertEquals(engine.groupID(\master), CaosEngine.defaultRoot,
			"after freeing, the root group is the fallback");

	}

	test_makeGroupsTwiceFreesTheOldOnes {

		engine.makeGroups;
		spy.reset;
		engine.makeGroups;

		this.assertEquals(spy.messages.size, 6, "3 frees + 3 new groups");

	}

}
