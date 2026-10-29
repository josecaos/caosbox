// CaosBox v2.5.2 - Maximum stress session test (3 minutes)
//
// Enciende todos los canales y todas las automatizaciones, rutea cada
// instrumento por un bus distinto y graba la sesión con CaosBox.record.
//
// Necesita un servidor de audio real.
//
// Desde una terminal:
//   sclang Tests/test-stress-session-max.scd

(
var s = Server.local;
var pass = 0, fail = 0;
var duration = 180;
var interval = 10;
var automations = #[\autor, \autod, \autop, \autog, \autolpf, \autohpf, \autobpf];
var bpms = 145;

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
	var gear, startTime, lastIndex;
	var maxNodes = 0, maxGroups = 0, maxCPU = 0;
	var indexChanged = false;
	var randomOn = false, nextRandom = 30, randomChanges = 0;

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


	// Todos los canales, cada uno por un bus distinto.
	gear = CaosGear.new;
	gear.kick(out: \lpf);
	gear.snare(out: \hpf);
	gear.hihats(out: \delay);
	gear.kick2(out: \bpf);
	gear.snare2(out: \grains);
	gear.hihats2(out: \hpf);

	gear.bass(out: \delay, semitoneArray: [48, 50, 52, 55, 57, 60]-24, seqType: \rand);
	gear.bass2(out: \delay, semitoneArray: [48, 50, 52, 55, 57, 60], seqType: \rand);
	gear.pad(out: \lpf, waveform: 'tri', semitoneArray: [48, 55, 60, 64]+12, seqType: \rand);
	gear.pad2(out: \pitch, semitoneArray: [48, 50, 52, 55, 57, 60]-12, seqType: \rand);
	gear.chords(out: \bpf, semitoneArray: [48, 50, 52, 55, 57, 60], seqType: \rand, chordsArray: #['m', 'M']);
	gear.chords2(out: \grains, semitoneArray: [48, 50, 52, 55, 57, 60]+12, seqType: \rand, chordsArray: #['M9', 'm9', 'm', 'M']);
	gear.lineIn(out: \hpf);

	// Todos los pasos de los 12 canales; lineIn queda disperso por el mic.
	#[
		\kick, \snare, \hihats, \kick2, \snare2, \hihats2,
		\bass, \bass2, \amb, \amb2, \chords, \chords2
	].do {|name|
		(0..31).do {|i| ~cbox_tracks[name].putStep(i, true) };
	};

	[0, 16].do {|i| ~cbox_tracks[\in].putStep(i, true) };



	{
		CaosBox.bpm(bpms);
		CaosBox.play;
	}.defer;

	if(waitFor.value({ ~cbox_grains.notNil }, 20).not, {
		"FAIL  CaosBox did not create nodes".postln;
		s.quit;
		1.exit;
	});

	// Todas las automatizaciones.
	CaosBox.autoFx('reverb', true, 'fast',
		[0.1, 0.4, 0.8], [0.2, 0.8, 0.5], [0.2, 0.6]);
	CaosBox.autoFx('delay', true, 'fast',
		[0.01, 0.1, 0.25], [0.1, 0.5]);
	CaosBox.autoFx('pitch', true, 'fast',
		[0.5, 1, 1.5], [0.01, 0.2], [0.01, 0.3]);
	CaosBox.autoFx('grains', true, 'fast',
		[0.1, 0.5, 0.9], [0.1, 0.5]);
	CaosBox.autoFx('lpf', true, 'fast',
		[200, 2000, 12000], [0.5, 0.9]);
	CaosBox.autoFx('hpf', true, 'fast',
		[20, 200, 2000], [0.5, 0.9]);
	CaosBox.autoFx('bpf', true, 'fast',
		[200, 2000, 8000], [0.5, 0.9]);

	// Graba la sesión completa.
	CaosBox.record;

	if(waitFor.value({ s.isRecording }, 10).not, {
		"FAIL  CaosBox.record did not start recording".postln;
		CaosBox.close;
		s.quit;
		1.exit;
	});

	startTime = Main.elapsedTime;
	lastIndex = ~cbox_seq.index;

	"Stress session started: % seconds".format(duration).postln;

	while { Main.elapsedTime - startTime < duration } {
		interval.wait;

		if(~cbox_seq.index != lastIndex, { indexChanged = true });
		lastIndex = ~cbox_seq.index;

		if((Main.elapsedTime - startTime) >= nextRandom, {
			randomOn = randomOn.not;
			if(randomOn, {
				CaosBox.randomTime(true, true, [bpms, bpms/2, bpms, bpms/3, bpms, bpms/4]);
			}, {
				CaosBox.randomTime(false);
			});
			randomChanges = randomChanges + 1;
			nextRandom = nextRandom + 30;
		});

		maxNodes = max(maxNodes, s.numSynths);
		maxGroups = max(maxGroups, s.numGroups);
		maxCPU = max(maxCPU, s.avgCPU ? 0);

		("  t=%s s | index=% | nodes=% | groups=% | cpu=% | rec=% | autos=% | rnd=%")
			.format(
				(Main.elapsedTime - startTime).round(1),
				~cbox_seq.index,
				s.numSynths,
				s.numGroups,
				(s.avgCPU ? 0).round(0.1),
				s.isRecording,
				automations.select {|name| Tdef(name).isPlaying }.size,
				~cbox_seq.randomTime
			).postln;
	};

	CaosBox.randomTime(false);
	CaosBox.stopRecording;
	waitFor.value({ s.isRecording.not }, 10);

	ok.value(randomChanges >= 5, "randomTime toggled every 30 seconds (% times)".format(randomChanges));
	ok.value(~cbox_seq.randomTime.not, "randomTime is off at the end");

	ok.value(s.serverRunning, "server is still running");
	ok.value(indexChanged, "sequencer index advanced");
	ok.value(maxNodes < 500, "node count stayed bounded (max %)".format(maxNodes));
	ok.value(maxGroups < 50, "group count stayed bounded (max %)".format(maxGroups));
	ok.value(maxCPU < 90, "CPU stayed below 90 percent (max %)".format(maxCPU.round(0.1)));
	ok.value(s.isRecording.not, "recording stopped cleanly");

	automations.do {|name|
		ok.value(Tdef(name).isPlaying, "automation still running: %".format(name));
	};

	CaosBox.close;
	1.wait; // beats, not seconds: at 192 BPM 0.5 beats < the 0.2 s close delay

	ok.value(CaosBox.engine.groups.isNil, "engine groups freed after close");
	ok.value(s.serverRunning, "server survived CaosBox.close");

	("RESULT: % passed, % failed".format(pass, fail)).postln;

	s.quit;
	if(fail > 0, { 1.exit }, { 0.exit });
};
)
