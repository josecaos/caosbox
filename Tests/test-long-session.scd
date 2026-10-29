// CaosBox v2.5.2 - Long session test (5 minutes)
//
// Estrés continuo del secuenciador:
//   - kick/hihats con pasos activos
//   - automatización del filtro LPF
//   - revisión cada 10 s de server, Tdefs, índice y nodos
//   - CaosBox.close al final, sin apagar el server
//
// Necesita un servidor de audio real.
//
// Desde una terminal:
//   sclang Tests/test-long-session.scd

(
var s = Server.local;
var pass = 0, fail = 0;
var duration = 300; // segundos
var interval = 10;

var ok = {|condition, message|
	if(condition, {
		pass = pass + 1;
		("PASS  " + message).postln;
	}, {
		fail = fail + 1;
		("FAIL  " + message).postln;
	});
};

var waitFor = {|condition, timeout = 15|
	var elapsed = 0;

	while { condition.value.not and: { elapsed < timeout } } {
		0.1.wait;
		elapsed = elapsed + 0.1;
	};

	condition.value;
};

fork {
	var booted = false;
	var gear, startTime, lastIndex, maxNodes = 0, maxGroups = 0;
	var checks = 0, indexChanged = false, maxCPU = 0;

	s.waitForBoot { booted = true };

	if(waitFor.value({ booted }, 15).not, {
		"SKIP  no audio device available".postln;
		0.exit;
	});

	CaosBox.environment(false);

	if(waitFor.value({ ~cbox_seq.notNil }, 20).not, {
		"FAIL  CaosBox did not boot".postln;
		s.quit;
		1.exit;
	});

	// Un patrón completo para que el secuenciador tenga trabajo real.
	gear = CaosGear.new;
	gear.kick;
	gear.snare;
	gear.hihats;
	gear.bass;
	gear.pad;
	gear.chords;

	[0, 4, 8, 12, 16, 20, 24, 28].do {|i|
		~cbox_tracks[\kick].putStep(i, true);
	};

	[4, 12, 20, 28].do {|i|
		~cbox_tracks[\snare].putStep(i, true);
	};

	[0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30].do {|i|
		~cbox_tracks[\hihats].putStep(i, true);
	};

	[0, 4, 8, 12, 16, 20, 24, 28].do {|i|
		~cbox_tracks[\bass].putStep(i, true);
	};

	[0, 16].do {|i|
		~cbox_tracks[\amb].putStep(i, true);
	};

	[0, 8, 16, 24].do {|i|
		~cbox_tracks[\chords].putStep(i, true);
	};

	// Ejecuta prepare y arranca el transporte en AppClock.
	{ CaosBox.play }.defer;

	if(waitFor.value({ ~cbox_grains.notNil }, 20).not, {
		"FAIL  CaosBox did not create nodes".postln;
		s.quit;
		1.exit;
	});

	CaosBox.autoFx('lpf', true, 'normal',
		[200, 800, 2000, 8000, 20000],
		[0.5, 0.8, 1.0]);

	startTime = Main.elapsedTime;
	lastIndex = ~cbox_seq.index;

	"Long session started: % seconds".format(duration).postln;

	while { Main.elapsedTime - startTime < duration } {
		interval.wait;

		checks = checks + 1;

		if(~cbox_seq.index != lastIndex, { indexChanged = true });
		lastIndex = ~cbox_seq.index;

		maxNodes = max(maxNodes, s.numSynths);
		maxGroups = max(maxGroups, s.numGroups);
		maxCPU = max(maxCPU, s.avgCPU ? 0);

		("  t=%s s | index=% | nodes=% | groups=% | cpu=% | seq=% | lpf=%")
			.format(
				(Main.elapsedTime - startTime).round(1),
				~cbox_seq.index,
				s.numSynths,
				s.numGroups,
				(s.avgCPU ? 0).round(0.1),
				Tdef(\secuencias).isPlaying,
				Tdef(\autolpf).isPlaying
			).postln;
	};

	ok.value(s.serverRunning, "server is still running after 5 minutes");
	ok.value(Tdef(\secuencias).isPlaying, "sequencer Tdef is still running");
	ok.value(Tdef(\autolpf).isPlaying, "filter automation is still running");
	ok.value(indexChanged, "sequencer index advanced during the session");
	ok.value(maxNodes < 200, "node count stayed bounded (max %) ".format(maxNodes));
	ok.value(maxGroups < 50, "group count stayed bounded (max %) ".format(maxGroups));
	ok.value(maxCPU < 90, "CPU stayed below 90 percent (max %)".format(maxCPU.round(0.1)));

	CaosBox.close;
	1.wait; // beats, not seconds: at 192 BPM 0.5 beats < the 0.2 s close delay

	ok.value(Tdef(\secuencias).isPlaying.not, "sequencer stopped after close");
	ok.value(Tdef(\autolpf).isPlaying.not, "filter automation stopped after close");
	ok.value(CaosBox.engine.groups.isNil, "engine groups freed after close");
	ok.value(s.serverRunning, "server survived CaosBox.close");

	("RESULT: % passed, % failed".format(pass, fail)).postln;

	s.quit;
	if(fail > 0, { 1.exit }, { 0.exit });
};
)
