//Main Environment init
CaosBox {

	classvar <server,url;
	classvar <engine;
	classvar <version = "2.2.0";// version unica: la usan el GUI y la bienvenida

	*environment {|gui = true|


		if(~cbox_url.notNil,{

			^"CaosBox.environment is already running";

		},{
			// System files
			~cbox_urls = [
				"CB/CaosBox-midi.scd",
				"CB/CaosBox-vars.scd",
				"CB/CaosBox-signal.scd",
				"CB/CaosBox-synths.scd",
				"CB/CaosBox-defaults.scd",
				"CB/CaosBox-auto.scd",
				"GUI/CaosBox-GUI.scd",
				"GUI/CaosBox-GUI_2.scd",
				"GUI/CaosBox-GUI_3.scd",
				"GUI/CaosBox-GUI_4.scd",
				"CB/CaosBox-seq.scd",
			];

			// revisa dependencias obligatorias
			if(\CaosEnv.asClass != nil,{
				~cbox_url = this.filenameSymbol.asString.dirname;

				^super.new.init(gui);

			}, {

				"CaosPercLib not installed, without this CaosBox won't work".error;
				"You can download the library here: https://github.com/josecaos/caosperclib \nDownload and Unzip into: Platform.userExtensionDir;".inform;
				^"Dependency problem detected";

			});

		});

	}

	// Deprecated alias: old misspelling kept for docs and saved histories
	*enviroment {|gui = true|

		"CaosBox.enviroment is deprecated, use CaosBox.environment".warn;
		^this.environment(gui);

	}

	init {|window = true|

		server = Server.local;
		engine = CaosEngine.new(server);// server, buses con nombre y grupos

		engine.boot({|eng|

			(~cbox_url +/+ "CB/CaosBox-load.scd").load;

			//evalua si se muestra el GUI
			if(window == true, {
				~cbox_w.front;
				"Sequencer GUI is ON".inform;
			},{
				"Sequencer GUI is OFF, you are running without a Visual Interface".inform;
			});

		});

		^this;

	}

	// nombre de bus -> indice; sin engine, el valor pasa tal cual (compat)
	*resolveOut {|out|

		if(engine.isNil, { ^out });

		^engine.resolveOut(out);

	}

	*guiAlpha {|alpha = 1|

		~cbox_w.alpha_(alpha);
		^("- GUI opacity set to " + alpha).inform;

	}

	*guiState {|open = true|

		//open GUI at any time
		if (open == true,{

			if(~cbox_w.visible != true,{
				~cbox_w.front;
				^"- CaosBox Gui Opened".inform;
			},{
				^"- CaosBox GUI already Open".inform;
			});

		}, {
			if(~cbox_w.visible == true,{

				^"- Once opened, GUI cannot be closed, if you do, all work will be lost";

			},{

				^"- GUI is already closed, use 'true' to open it";

			});

		});

	}

	*soundcheck {|noiseType = 'white'|

		var signal, check;

		switch(noiseType,
			\white,{signal = WhiteNoise; check = 1 },
			\pink,{signal =  PinkNoise; check = 1 },
			\brown,{signal = BrownNoise;  check = 1 },
			{
				signal = PinkNoise;
				check  = nil;
				^"Use 'white', 'pink' or 'brown' keys only".inform;
			}
		);

		if(check != nil,{

			play{signal.ar(SinOsc.ar(2,0,0.01,1))*EnvGen.ar(Env.perc(0.5,8),1,doneAction:2)!2};

			^"Soundcheck running with" + signal.asString + " UGen";

		});

	}

	*play {

		if(~cbox_seq.notNil and: { ~cbox_seq.isPlaying }, {
			^"CaosBox already running";
		});

		~cbox_seq !? { |seq| seq.play };
		~cbox_bot !? { |bot| bot.value_(1) };

		^"Machine is running";

	}

	// pausa: conserva el paso; play reanuda desde ahi
	*pause {

		~cbox_seq !? { |seq| seq.pause };
		this.prPauseAutomations;
		~cbox_bot !? { |bot| bot.value_(0) };

		^"";

	}

	// stop: vuelve al paso 0 para el proximo play
	*stop {

		~cbox_seq !? { |seq| seq.stop };
		this.prPauseAutomations;
		~cbox_bot !? { |bot| bot.value_(0) };

		^"";

	}

	*prPauseAutomations {

		#[\autor, \autod, \autop, \autog].do { |name| Tdef(name).pause };

		~cbox_autobotr !? { |bot| bot.value_(0) };
		~cbox_autobotd !? { |bot| bot.value_(0) };
		~cbox_autobotp !? { |bot| bot.value_(0) };
		~cbox_autobotg !? { |bot| bot.value_(0) };

	}

	*bpm {|val|

		~cbox_numclock !? { |num| num.value_(val) };
		~cbox_seq !? { |seq| seq.bpm = val };

		^("+ BPM set to" + val);

	}

	*stepDur {|dur|

		~cbox_seq !? { |seq| seq.stepDur = dur };

		^"";

	}

	*randomTime {|random = false, editBPM = false, bpmArray = #[47,62,94,141,188]|

		var flag;

		if(random.isKindOf(Boolean).not, {
			^"Use only 'true' or 'false'";
		});

		flag = random;

		if(editBPM == true, {
			~cbox_randtimes = bpmArray;
			~cbox_seq !? { |seq| seq.randtimes = bpmArray };
		});

		~cbox_seq !? { |seq| seq.randomTime = flag };
		// boton: la etiqueta muestra lo que hara al apretar; random encendido
		// deja "Regular Time" (apretar lo apaga) y viceversa
		~cbox_botr !? { |bot| bot.value_(if(flag, 1, 0)) };

		^"";

	}

	*toggleMetric {

		var button = ~cbox_botm;

		if(button.notNil, {
			button.valueAction_(if(button.value == 0, 1, 0));
		}, {
			~cbox_seq !? { |seq| seq.stepDur = if(seq.stepDur == 0.25, 1/3, 0.25) };
		});

		^"";

	}

	*record {

		~cbox_recbot.valueAction_(1);

		^"";

	}

	*stopRecording {

		~cbox_recbot.valueAction_(0);

		^"";
	}

	*history {|state, name|

		if(state == \start or: {state == \stop} or: {state == \load}, {
			switch(state,
				\start, {History.start},
				\stop, {~cbox_hbutt.valueAction_(0)},
				\load, {History.loadStory(~cbox_url +/+ "Histories" +/+ name).play(verbose:true)}
			);

			^"";
		}, {

			^"Use only 'start','stop' or 'load' keys";

		});

	}

	*freqAnalyzer {|active = false|

		var onoff;
		if(active==false, {
			onoff = 0;
		},{
			onoff = 1;
		});
		~cbox_fbot.valueAction_(onoff);

		^"";
	}

	// seq methods
	*randStream {|seq,array|

		var out, return;

		if(seq != \rand2 and:{ seq != \rand1},
			{

				"Use 'rand1' or 'rand2' keys to choose output sequence style \n".inform;

			},{

				switch(seq,
					\rand1,{out=Prand(array,inf).asStream},
					\rand2,{out=Pshuf(array,inf).asStream},
				);

				return = out.next;
				("randStream: " + return).inform
				^return;
		});
	}

	//Regresa un array de 32 elementos
	//parametro 'default' en todos los slots del array + 'in'; Parametro secundario: 'steps' especificos
	*stepsArray {|default=50,in=52,steps=#[0,16]|

		var arr = Array.fill(32,nil);

		var a;

		for(0,steps.size-1,{|i|
			a=steps[i];
			arr=arr.put(a,in);
		});

		arr.collect({|item,i|
			if(item == nil,{
				arr.put(i,default);
			});

		});

		^arr;

	}

	// step patterns live in CaosTrack (~cbox_tracks). See Classes/CaosTrack.sc
	*clearSteps {|track, steps|

		var pattern = ~cbox_tracks[track];

		if(pattern.isNil, { ^("Unknown track: " + track).inform });

		pattern.clear(steps);

		^"Cleared steps".inform;

	}

	*setSteps {|track, steps, overrideSteps = false|

		var pattern = ~cbox_tracks[track];

		if(pattern.isNil, { ^("Unknown track: " + track).inform });

		if(steps.isNil, { steps = (0 .. (pattern.size - 1)) });

		pattern.setIndices(steps, overrideSteps);

		^"Added steps".inform;

	}

	*setStep {|track, index, on = true|

		var pattern = ~cbox_tracks[track];

		if(pattern.isNil, { ^("Unknown track: " + track).inform });

		pattern.putStep(index, on);

		^"";

	}

	*randSteps {|track, steps_num = 1|

		var pattern = ~cbox_tracks[track];
		var picks, randomStep;

		if(pattern.isNil, { ^("Unknown track: " + track).inform });

		picks = Array.new;
		randomStep = Pxrand((0 .. (pattern.size - 1)), inf).asStream;

		steps_num.do { |i| picks = picks.add(randomStep.next) };

		pattern.setIndices(picks);

		^"Added steps".inform;

	}
	//

	*autoFx {|fx = 'reverb', play = true, speed = 'normal', argArr1 = 0, argArr2 = 0, argArr3 = 0|

		switch(fx,
			'reverb',{
				if(play == true, {
					//velocidad
					switch(speed,
						'normal',{~cbox_autopopr.valueAction_(0);"Reverb normal speed".postln},
						'fast',{~cbox_autopopr.valueAction_(1);"Reverb fast speed".postln},
						'slow',{~cbox_autopopr.valueAction_(2);"Reverb slow speed".postln},
						'slowest',{~cbox_autopopr.valueAction_(3);"Reverb slowest speed".postln}
					);
					~cbox_autoreverbmix=argArr1.asArray;
					~cbox_autoreverbroom=argArr2.asArray;
					~cbox_autoreverbdamp=argArr3.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;//reload
					if(Tdef(\autor).isPlaying,{
						^"Reverb Automation already running";
					},{
						~cbox_autobotr.valueAction_(1);
						^"Reverb Automation running";
					});
				}, {
					~cbox_autobotr.valueAction_(0);
					^"Reverb Automation stopped";
				});
			},
			'delay',{
				if(play == true, {
					switch(speed,
						'normal',{~cbox_autopopd.valueAction_(0);"Delay normal speed".postln},
						'fast',{~cbox_autopopd.valueAction_(1);"Delay fast speed".postln},
						'slow',{~cbox_autopopd.valueAction_(2);"Delay slow speed".postln},
						'slowest',{~cbox_autopopd.valueAction_(3);"Delay slowest speed".postln}
					);
					~cbox_autodelaytime=argArr1.asArray;
					~cbox_autodelayfeed=argArr2.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autod).isPlaying,{
						^"Delay Automation already running";
					},{
						~cbox_autobotd.valueAction_(1);
						^"Delay Automation running";
					});
				}, {
					~cbox_autobotd.valueAction_(0);
					^"Delay Automation stopped";
				});
			},
			'pitch',{
				if(play == true, {
					switch(speed,
						'normal',{~cbox_autopopp.valueAction_(0);"Pitch normal speed".postln},
						'fast',{~cbox_autopopp.valueAction_(1);"Pitch fast speed".postln},
						'slow',{~cbox_autopopp.valueAction_(2);"Pitch slow speed".postln},
						'slowest',{~cbox_autopopp.valueAction_(3);"Pitch slowest speed".postln}
					);
					~cbox_autopitchrate=argArr1.asArray;
					~cbox_autopitchdispersion=argArr2.asArray;
					~cbox_autotimedispersion=argArr3.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autop).isPlaying,{
						^"Pitch Automation already running";
					},{
						~cbox_autobotp.valueAction_(1);
						^"Pitch Automation running";
					});
				}, {
					~cbox_autobotp.valueAction_(0);
					^"Pitch Automation stopped";
				});
			},
			'grains',{
				if(play == true, {
					switch(speed,
						'normal',{~cbox_autopopg.valueAction_(0);"Grains normal speed".postln},
						'fast',{~cbox_autopopg.valueAction_(1);"Grains fast speed".postln},
						'slow',{~cbox_autopopg.valueAction_(2);"Grains slow speed".postln},
						'slowest',{~cbox_autopopg.valueAction_(3);"grains slowest speed".postln}
					);
					~cbox_autograintrig=argArr1.asArray;
					~cbox_autograinsize=argArr2.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autog).isPlaying,{
						^"Grains Automation already running";
					},{
						~cbox_autobotg.valueAction_(1);
						^"Grains Automation running";
					});
				}, {
					~cbox_autobotg.valueAction_(0);
					^"Grains Automation stopped";
				});
			},
			'lpf',{
				if(play == true, {
					switch(speed,
						'normal',{"velocidad 'normal'".postcln;~cbox_divlpf = 1;"LPF normal speed".postln},
						'fast',{"velocidad 'fast'".postcln;~cbox_divlpf = 0.5; "LPF normal speed".postln},
						'slow',{"velocidad 'slow'".postcln;~cbox_divlpf = 2; "LPF normal speed".postln},
						'slowest',{"velocidad 'slowest'".postcln;~cbox_divlpf = 4; "LPF normal speed".postln}
					);
					~cbox_autolpffreq=argArr1.asArray;
					~cbox_autolpfband=argArr2.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autolpf).isPlaying,{
						^"Low pass filter Automation already running";
					},{
			 			Tdef(\autolpf).play;
						^"Low pass filter Automation running";
					});
				}, {
					Tdef(\autolpf).pause;
					^"Low pass fiter Automation stopped";
				});
			},
			'hpf',{
				if(play == true, {
					switch(speed,
						'normal',{"velocidad 'normal'".postcln;~cbox_divhpf = 1;"HPF normal speed".postln},
						'fast',{"velocidad 'fast'".postcln;~cbox_divhpf = 0.5; "HPF normal speed".postln},
						'slow',{"velocidad 'slow'".postcln;~cbox_divhpf = 2; "HPF normal speed".postln},
						'slowest',{"velocidad 'slowest'".postcln;~cbox_divhpf = 4; "HPF normal speed".postln}
					);
					~cbox_autohpffreq=argArr1.asArray;
					~cbox_autohpfband=argArr2.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autohpf).isPlaying,{
						^"High pass filter Automation already running";
					},{
			 			Tdef(\autohpf).play;
						^"High pass filter Automation running";
					});
				}, {
					Tdef(\autohpf).pause;
					^"High pass fiter Automation stopped";
				});
			},
			'bpf',{
				if(play == true, {
					switch(speed,
						'normal',{"velocidad 'normal'".postcln;~cbox_divbpf = 1;"BPF normal speed".postln},
						'fast',{"velocidad 'fast'".postcln;~cbox_divbpf = 0.5; "BPF normal speed".postln},
						'slow',{"velocidad 'slow'".postcln;~cbox_divbpf = 2; "BPF normal speed".postln},
						'slowest',{"velocidad 'slowest'".postcln;~cbox_divbpf = 4; "BPF normal speed".postln}
					);
					~cbox_autobpffreq=argArr1.asArray;
					~cbox_autobpfband=argArr2.asArray;
					(~cbox_url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autobpf).isPlaying,{
						^"Band pass filter Automation already running";
					},{
			 			Tdef(\autobpf).play;
						^"Band pass filter Automation running";
					});
				}, {
					Tdef(\autobpf).pause;
					^"Band pass fiter Automation stopped";
				});
			},
			"Use only 'reverb','delay','pitch','grains','lpf','hpf','bpf' keys for FX type argument, and 'normal','fast','slow','slowest' keys for FX speed argument";);
	}

	*fx {|fx = 'reverb', arg1 = 0, arg2 = 0, arg3 = 0, arg4 = 0, arg5 = 0|

		switch(fx,
			'reverb',{
				if(Tdef(\autor).isPlaying,{
					^"Reverb Automation is running, use .autoFx Method to stop it";
				},{
					if(arg1 < 0 or: {arg1 > 1} or: {arg2 < 0} or: {arg2 > 1} or: {arg3 < 0 }	or: {arg3 > 1}, {
						^"Reverb FX parameters only between 0 and 1";
					}, {
						~cbox_numr.value=arg1;
						~cbox_auxrfader.value=arg1;
						~cbox_numroom.value=arg2;
						~cbox_auxroomfader.value=arg2;
						~cbox_numd.value=arg3;
						~cbox_auxdfader.value=arg3;
						^"Reverb Parameters, Seted";
					});
				});
			},
			'delay',{
				if(Tdef(\autod).isPlaying,{
					^"Delay Automation is running, use .autoFx Method to stop it";
				},{
					if(arg1 < 0 or: {arg1 > 4} or: {arg2 < 0} or: {arg2 > 10}, {
						^"Delay Time Parameter between 0 and 6, feedback parameter between 0 or 10";
					},
					{
						~cbox_numt.value=arg1;
						~cbox_auxtfader.value=arg1;
						~cbox_numf.value=arg2;
						~cbox_auxffader.value=arg2;
						^"Delay Parameters, Seted";
					});
				});
			},
			'pitch',{
				if(Tdef(\autop).isPlaying,{
					^"Pitch Automation is running, use .autoFx Method to stop it";
				},{
					if(arg1 < 0 or: {arg1 > 6} or: {arg2 < 0} or: {arg2 > 1} or: {arg3 < 0 }	or: {arg3 > 1},{
						^"Pitch Rate parameter only btween 0 and 6, other args between 0 and 1";
					}, {
						~cbox_nump.value=arg1;
						~cbox_auxpfader.value=arg1;
						~cbox_numpd.value=arg2;
						~cbox_auxpdfader.value=arg2;
						~cbox_numtd.value=arg3;
						~cbox_auxtdfader.value=arg3;
						^"Pitch Parameters, Seted";
					});
				});
			},
			'grains',{
				if(Tdef(\autog).isPlaying,{
					^"Grains Automation is running, use .autoFx Method to stop it";
				},{
					if(arg1 < 0 or: {arg1 > 1} or: {arg2 < 0} or: {arg2 > 1},{
						^"Granulator FX Parameters only between 0 and 1";
					},
					{
						~cbox_grains.set(\trigger,~cbox_gfaders.x_(arg1));
						~cbox_grains.set(\size,~cbox_gfaders.y_(arg2));
						^"Granulator Parameters, Seted";
					});
				});
			},
			'master',{
				if(arg1 < 0 or: {arg1 > 1} or: {arg2 < 0} or: {arg2 > 1} or: {arg3 < 0 }	or: {arg3 > 1}
					or: {arg4 < 0} or: {arg4 > 1} or: {arg5 < 0} or: {arg5 > 1}, {
						^"Master FX parameters only between 0 and 1";
					},{
						~cbox_num.value = arg1;
						~cbox_mastfader.value = arg1;
						~cbox_num1.value = arg2;
						~cbox_mastfader1.value = arg2;
						~cbox_num2.value = arg3;
						~cbox_mastfader2.value = arg3;
						~cbox_num3.value = arg4;
						~cbox_mastfader3.value = arg4;
						~cbox_num4.value = arg5;
						~cbox_mastfader4.value = arg5;
						^"Master Parameters, Seted ";
				});
			},
			"Use only 'reverb','delay','pitch','grains' or 'master' keys for FX type argument";
		);
	}

	*openDefaults {

		(~cbox_url +/+ "CB/CaosBox-defaults.scd").openOS;

		^"Defaults file opened";

	}

	*close {

		~cbox_seq !? { |seq| seq.stop };
		engine !? { |eng| eng.free };
		Tdef.removeAll;
		this.server.quit.freeAll.reboot;
		this.server.recompile;
		^"Terminando CaosBox";

	}

}
