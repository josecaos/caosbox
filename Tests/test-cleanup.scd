// CaosBox v2.5.2 - Cleanup regression test
//
// Comprueba que CaosBox.close:
//   - detiene secuenciador y automatizaciones de CaosBox
//   - libera los grupos/nodos de CaosBox
//   - NO mata nodos ni Tdefs de otros proyectos
//   - deja ~cbox_url en nil para poder volver a arrancar
//
// Necesita un servidor de audio real.
//
// Desde una terminal:
//   sclang Tests/test-cleanup.scd

(
var s = Server.local;
var pass = 0, fail = 0;

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
	var external;

	s.waitForBoot { booted = true };

	if(waitFor.value({ booted }, 15).not, {
		"SKIP  no audio device available".postln;
		0.exit;
	});

	SynthDef(\keepAlive, {|out = 0|
		Out.ar(out, DC.ar(0).dup);
	}).add;

	s.sync;

	external = Synth(\keepAlive, target: s, addAction: \addToTail);
	NodeWatcher.register(external);

	Tdef(\externalKeep, { inf.do { 1.wait } }).play;

	CaosBox.environment(false);

	if(waitFor.value({ ~cbox_seq.notNil }, 20).not, {
		"FAIL  CaosBox did not boot".postln;
		external.free;
		Tdef(\externalKeep).stop;
		s.quit;
		1.exit;
	});

	{ CaosBox.play }.defer;

	if(waitFor.value({ ~cbox_grains.notNil }, 20).not, {
		"FAIL  CaosBox did not create nodes".postln;
		external.free;
		Tdef(\externalKeep).stop;
		s.quit;
		1.exit;
	});

	// Automatización de CaosBox (sin GUI), para probar que close la detiene.
	Tdef(\autolpf, { inf.do { 1.wait } }).play;

	NodeWatcher.register(~cbox_grains);
	0.2.wait;

	ok.value(Tdef(\externalKeep).isPlaying, "external Tdef is running before close");
	ok.value(external.isPlaying, "external synth is running before close");
	ok.value(~cbox_grains.isPlaying, "CaosBox grains is running before close");

	CaosBox.close;
	1.wait; // beats, not seconds: at 192 BPM 0.5 beats < the 0.2 s close delay

	ok.value(Tdef(\secuencias).isPlaying.not, "CaosBox sequencer Tdef stopped");
	ok.value(Tdef(\autolpf).isPlaying.not, "CaosBox filter automation stopped");
	ok.value(~cbox_grains.isPlaying.not, "CaosBox grains node freed");
	ok.value(CaosBox.engine.groups.isNil, "CaosBox engine groups forgotten");
	ok.value(~cbox_url.isNil, "CaosBox environment marker cleared");

	ok.value(Tdef(\externalKeep).isPlaying, "external Tdef survived close");
	ok.value(external.isPlaying, "external synth survived close");

	external.free;
	Tdef(\externalKeep).stop;

	("RESULT: % passed, % failed".format(pass, fail)).postln;

	s.quit;
	if(fail > 0, { 1.exit }, { 0.exit });
};
)
