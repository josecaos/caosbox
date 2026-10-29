// CaosBox v2.5.2 - Stress session test (2 minutes)
//
// Enciende todos los canales y todas las automatizaciones, rutea cada
// instrumento por un bus distinto y graba la sesión con CaosBox.record.
//
// Necesita un servidor de audio real.
//
// Desde una terminal:
//   sclang Tests/test-stress-session.scd

(
var s = Server.local;
var pass = 0, fail = 0;
var duration = 120;
var interval = 10;
var automations = #[\autor, \autod, \autop, \autog, \autolpf, \autohpf, \autobpf];

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
	gear.kick(out: \reverb);
	gear.snare(out: \delay);
	gear.hihats(out: \lpf);
	gear.kick2(out: \hpf);
	gear.snare2(out: \bpf);
	gear.hihats2(out: \grains);

	gear.bass(out: \reverb, semitoneArray: [48, 50, 52, 55, 57, 60]);
	gear.bass2(out: \delay, semitoneArray: [36, 38, 41, 43, 46]);
	gear.pad(out: \lpf, waveform: 'tri', semitoneArray: [48, 55, 60, 64]);
	gear.pad2(out: \hpf, semitoneArray: [50, 57, 62, 65]);
	gear.chords(out: \bpf, chordsArray: #['m', 'M']);
	gear.chords2(out: \grains, chordsArray: #['M9', 'm9']);
	gear.lineIn(out: \pitch);

	// Patrones de los 13 canales.
	[0, 4, 8, 12, 16, 20, 24, 28].do {|i| ~cbox_tracks[\kick].putStep(i, true) };
	[4, 12, 20, 28].do {|i| ~cbox_tracks[\snare].putStep(i, true) };
	[0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30].do {|i| ~cbox_tracks[\hihats].putStep(i, true) };
	[2, 6, 10, 18, 22, 26, 30].do {|i| ~cbox_tracks[\kick2].putStep(i, true) };
	[14, 30].do {|i| ~cbox_tracks[\snare2].putStep(i, true) };
	[1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31].do {|i| ~cbox_tracks[\hihats2].putStep(i, true) };
	[0, 4, 8, 12, 16, 20, 24, 28].do {|i| ~cbox_tracks[\bass].putStep(i, true) };
	[2, 6, 10, 14, 18, 22, 26, 30].do {|i| ~cbox_tracks[\bass2].putStep(i, true) };
	[0, 16].do {|i| ~cbox_tracks[\amb].putStep(i, true) };
	[8, 24].do {|i| ~cbox_tracks[\amb2].putStep(i, true) };
	[0, 8, 16, 24].do {|i| ~cbox_tracks[\chords].putStep(i, true) };
	[4, 12, 20, 28].do {|i| ~cbox_tracks[\chords2].putStep(i, true) };
	[0, 16].do {|i| ~cbox_tracks[\in].putStep(i, true) };



	{
		CaosBox.bpm(105);
		CaosBox.play;
	}.defer;

	if(waitFor.value({ ~cbox_grains.notNil }, 20).not, {
		"FAIL  CaosBox did not create nodes".postln;
		s.quit;
		1.exit;
	});

	// Todas las automatizaciones.
	CaosBox.autoFx('reverb', true, 'normal',
		[0.1, 0.4, 0.8], [0.2, 0.8, 0.5], [0.2, 0.6]);
	CaosBox.autoFx('delay', true, 'normal',
		[0.01, 0.1, 0.25], [0.1, 0.5]);
	CaosBox.autoFx('pitch', true, 'normal',
		[0.5, 1, 1.5], [0.01, 0.2], [0.01, 0.3]);
	CaosBox.autoFx('grains', true, 'normal',
		[0.1, 0.5, 0.9], [0.1, 0.5]);
	CaosBox.autoFx('lpf', true, 'normal',
		[200, 2000, 12000], [0.5, 0.9]);
	CaosBox.autoFx('hpf', true, 'normal',
		[20, 200, 2000], [0.5, 0.9]);
	CaosBox.autoFx('bpf', true, 'normal',
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

		maxNodes = max(maxNodes, s.numSynths);
		maxGroups = max(maxGroups, s.numGroups);
		maxCPU = max(maxCPU, s.avgCPU ? 0);

		("  t=%s s | index=% | nodes=% | groups=% | cpu=% | rec=% | autos=%")
			.format(
				(Main.elapsedTime - startTime).round(1),
				~cbox_seq.index,
				s.numSynths,
				s.numGroups,
				(s.avgCPU ? 0).round(0.1),
				s.isRecording,
				automations.select {|name| Tdef(name).isPlaying }.size
			).postln;
	};

	CaosBox.stopRecording;
	waitFor.value({ s.isRecording.not }, 10);

	ok.value(s.serverRunning, "server is still running");
	ok.value(indexChanged, "sequencer index advanced");
	ok.value(maxNodes < 300, "node count stayed bounded (max %)".format(maxNodes));
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
