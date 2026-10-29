// CaosBox v2.5.2 - Real-path audio smoke test
//
// Prueba la ruta que se usa en vivo:
//   CaosSampler -> bus de CaosBox -> granulador / filtro -> master -> bus 0
//
// Requiere:
//   - caos_sampler instalado (usa su sample por defecto)
//   - un servidor de audio real
//
// Si no hay dispositivo de audio, imprime SKIP y sale con 0.
//
// Desde una terminal:
//   sclang Tests/test-audio.scd

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

var rms = {|data|
	if(data.isNil or: { data.isEmpty }, { 0 }, {
		(data.squared.sum / data.size).sqrt;
	});
};

var recordBus = {|bus, seconds = 0.8|
	var frames = (s.sampleRate * seconds).asInteger;
	var buf = Buffer.alloc(s, frames, 2);
	var rec, data, condition;

	s.sync;

	rec = Synth(\testAudioRec, [\inbus, bus, \bufnum, buf.bufnum], s, \addToTail);
	seconds.wait;
	rec.free;
	s.sync;

	condition = Condition.new;
	buf.loadToFloatArray(action: {|array|
		data = array;
		condition.test_(true).signal;
	});
	condition.wait;
	buf.free;

	data;
};

fork {
	var booted = false;
	var sampler, grains, lpf;
	var grainsBus, lpfBus;

	s.waitForBoot { booted = true };

	if(waitFor.value({ booted }, 15).not, {
		"SKIP  no audio device available; this test needs a real server".postln;
		0.exit;
	});

	"STAGE 1: server booted".postln;

	CaosBox.environment(false);

	if(waitFor.value({ ~cbox_seq.notNil }, 20).not, {
		"FAIL  CaosBox did not finish booting".postln;
		s.quit;
		1.exit;
	});

	16.wait;

	// `CaosBox.play` toca widgets de la GUI (aunque esté oculta), así que debe
	// ejecutarse en AppClock; desde un fork/Routine Qt falla.
	{ CaosBox.play }.defer;
	"STAGE 2: audio graph ready".postln;

	if(waitFor.value({ ~cbox_grains.notNil }, 20).not, {
		"FAIL  CaosBox did not create the fixed synths".postln;
		~cbox_seq.stop;
		s.quit;
		1.exit;
	});

	SynthDef(\testAudioRec, {|inbus = 0, bufnum|
		RecordBuf.ar(In.ar(inbus, 2), bufnum, loop: 0, doneAction: 2);
	}).add;

	s.sync;

	grainsBus = CaosBox.engine.busIndex(\grains);
	lpfBus = CaosBox.engine.busIndex(\lpf);

	// --- CaosSampler -> granulador --------------------------------
	sampler = CaosSampler.new;
	sampler.load("Test", copies: 1);

	if(waitFor.value({
		sampler.instances.notNil and: { sampler.instances.size > 0 }
	}, 15).not, {
		"FAIL  CaosSampler did not load".postln;
		~cbox_seq.stop;
		s.quit;
		1.exit;
	});

	// loadSetup todavía hace loop/out con yields después de registrar.
	4.wait;

	sampler.loop(true);
	sampler.play;
	sampler.out(1, grainsBus);
	~cbox_grains.set(\trigger, 8, \size, 0.03);

	0.2.wait;
	grains = recordBus.value(0, 1.0);

	("      sampler -> grains: rms=" + rms.value(grains)
		+ " samples=" + if(grains.notNil) { grains.size } { nil }).postln;
	ok.value(rms.value(grains) > 0.001,
		"CaosSampler -> \\grains -> master has audio");

	// --- CaosSampler -> lowpass -----------------------------------
	sampler.out(1, lpfBus);
	~cbox_mastlowf.set(\cutfreq, 20000);

	0.2.wait;
	lpf = recordBus.value(0, 1.0);

	("      sampler -> lowpass: rms=" + rms.value(lpf)
		+ " samples=" + if(lpf.notNil) { lpf.size } { nil }).postln;
	ok.value(rms.value(lpf) > 0.001,
		"CaosSampler -> \\lpf -> master has audio");

	// --- cleanup --------------------------------------------------
	~cbox_seq !? {|seq| seq.stop };
	1.wait;

	"RESULT: % passed, % failed".format(pass, fail).postln;

	s.quit;
	if(fail > 0, { 1.exit }, { 0.exit });
};
)
