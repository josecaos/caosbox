// CaosBox v2.0.0 - Tests for Layer 1: ENGINE
// Run headless:  TestCaosEngine.run(reset: true, report: true);
// Run from GUI:  UnitTest.gui;

TestCaosEngine : UnitTest {

	var engine;

	setUp {

		engine = CaosEngine.new;

	}

	tearDown {

		engine.freeGroups;

	}

	// ------------------------------------------------------------------
	// Server-less: these must pass without booting anything.
	// ------------------------------------------------------------------

	test_defaultsToDefaultServer {

		this.assertEquals(engine.server, Server.default,
			"a new engine adopts Server.default");

	}

	test_acceptsAnExplicitServer {

		var other = Server(\caosTestServer, NetAddr("127.0.0.1", 57123));

		this.assertEquals(CaosEngine.new(other).server, other,
			"an explicit server overrides Server.default");

		other.remove;

	}

	test_serverOptionDefaults {

		this.assertEquals(engine.memSize, 66666, "memSize default");
		this.assertEquals(engine.maxNodes, 4096, "maxNodes default");

	}

	test_serverOptionsAreSettable {

		engine.memSize = 131072;
		engine.maxNodes = 8192;

		this.assertEquals(engine.memSize, 131072, "memSize is settable");
		this.assertEquals(engine.maxNodes, 8192, "maxNodes is settable");

	}

	test_isNotReadyBeforeBoot {

		this.assert(engine.isReady.not,
			"an engine with no groups is not ready");

	}

	// ------------------------------------------------------------------
	// With a running server.
	// ------------------------------------------------------------------

	test_makeGroupsCreatesThreeDistinctGroups {

		var ids;

		this.prReadyServer;
		engine.makeGroups;
		engine.server.sync;

		this.assert(engine.instruments.notNil, "instruments group exists");
		this.assert(engine.fx.notNil, "fx group exists");
		this.assert(engine.master.notNil, "master group exists");

		ids = [engine.instruments, engine.fx, engine.master].collect(_.nodeID);

		this.assertEquals(ids.asSet.size, 3, "the three groups are distinct nodes");

	}

	// The point of Layer 1: signal flows instruments -> fx -> master.
	// Node tree order is execution order, so this asserts the audio path.
	test_executionOrderIsInstrumentsThenFxThenMaster {

		var children;

		this.prReadyServer;
		engine.makeGroups;
		engine.server.sync;

		children = this.prDirectChildrenOf(engine.server.defaultGroup);

		this.assertEquals(
			children,
			[engine.instruments.nodeID, engine.fx.nodeID, engine.master.nodeID],
			"groups execute in order: instruments, fx, master"
		);

	}

	test_isReadyAfterBoot {

		this.prReadyServer;
		engine.makeGroups;
		engine.server.sync;

		this.assert(engine.isReady, "engine is ready once groups exist");

	}

	test_freeGroupsClearsStateAndNodes {

		this.prReadyServer;
		engine.makeGroups;
		engine.server.sync;

		engine.freeGroups;
		engine.server.sync;

		this.assert(engine.instruments.isNil, "instruments reference cleared");
		this.assert(engine.fx.isNil, "fx reference cleared");
		this.assert(engine.master.isNil, "master reference cleared");
		this.assert(engine.isReady.not, "engine is no longer ready");

		this.assertEquals(
			this.prDirectChildrenOf(engine.server.defaultGroup),
			[],
			"no group nodes left on the server"
		);

	}

	test_freeGroupsIsSafeBeforeMakeGroups {

		engine.freeGroups;

		this.assert(engine.instruments.isNil,
			"freeGroups on a fresh engine does not error");

	}

	// ------------------------------------------------------------------
	// Helpers: read the real node tree off the server.
	// ------------------------------------------------------------------

	// UnitTest:bootServer calls Server:freeAll on an already-running server,
	// which destroys group 1 and recreates it through initTree — and initTree
	// forks on AppClock, so it has not run yet when bootServer returns.
	// Wait for the default group to actually exist before touching the tree.
	prReadyServer {

		var server = engine.server, tries = 0;

		this.bootServer(server);

		while({
			(this.prDirectChildrenOf(RootNode(server)) ? []).includes(1).not
			and: { tries < 40 }
		}, {
			0.05.wait;
			tries = tries + 1;
		});

		server.sync;

	}

	// Direct children node IDs of a group, in execution order.
	prDirectChildrenOf {|group|

		var reply, condition = Condition.new, responder;

		responder = OSCFunc({|msg|
			reply = msg;
			condition.unhang;
		}, '/g_queryTree.reply', group.server.addr).oneShot;

		group.server.sendMsg("/g_queryTree", group.nodeID, 0);

		// Do not let a lost reply hang the whole suite.
		SystemClock.sched(3, { condition.unhang; nil });
		condition.hang;
		responder.free;

		if(reply.isNil, { ^nil });

		^this.prChildIDs(reply);

	}

	// Reply layout (flag 0): [cmd, flag, nodeID, numChildren, <subtrees...>]
	prChildIDs {|msg|

		var index = 4, ids = [];

		msg[3].do({

			ids = ids.add(msg[index]);
			index = this.prSkipSubtree(msg, index);

		});

		^ids;

	}

	// A synth is [id, -1, defName]; a group is [id, n] followed by n subtrees.
	prSkipSubtree {|msg, index|

		var numChildren = msg[index + 1], next;

		if(numChildren < 0, { ^index + 3 });

		next = index + 2;
		numChildren.do({ next = this.prSkipSubtree(msg, next) });

		^next;

	}

}