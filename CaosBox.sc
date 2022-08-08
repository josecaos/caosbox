//Main Enviroment init
CaosBox {

	classvar server,url;

	*enviroment {|gui = true|


		if(~cbox_url.notNil,{

			^"CaosBox.enviroment is already running";

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
			if(\CaosKick.asClass != nil,{

				~cbox_url = this.filenameSymbol.asString.dirname;

				^super.new.init(gui);

			}, {

				"CaosPercLib not installed, without this CaosBox won't work".error;
				"You can download the library here: https://github.com/josecaos/caosperclib \nDownload and Unzip into: Platform.userExtensionDir;".inform;
				^"Dependency problem detected";

			});

		});

	}

	init {|window = true|

		server = Server.local;

			server.waitForBoot {

				(~cbox_url +/+ "CB/CaosBox-load.scd").load;

				//evalua si se muestra el GUI
				if(window == true, {
					~cbox_w.front;
					"Sequencer GUI is ON".inform;
				},{
					"Sequencer GUI is OFF, you are running without a Visual Interface".inform;
				});

			};

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

		if(Tdef(\secuencias).isPlaying,{
			^"CaosBox already running";
		},{
			~cbox_bot.valueAction_(1);
			^"Machine is running";
		});

	}

	*stop {

		~cbox_bot.valueAction_(0);
		Tdef(\secuencias).pause;

		^"";
	}

	*bpm {|val|

		~cbox_numclock.value = val;

		~cbox_clock  = {TempoClock.tempo=~cbox_numclock.value/60};

		~cbox_clock.value;

		^("+ BPM set to" + ~cbox_numclock.value);
	}

	*randomTime {|random = false, editBPM = false, bpmArray = #[47,62,94,141,188]|

		if(random == true or:{ random == false} ,{

			if(editBPM == true,{
				~cbox_randtimes = bpmArray;
			});

			switch(random,
				true,{~cbox_botr.valueAction_(1)},
				false,{~cbox_botr.valueAction_(0)});

			^"";

		},{

			^"Use only 'true' or 'false'";
		});

	}

	*toggleMetric {

		var v = ~cbox_botm;

		if(v.value == 0,{v.valueAction_(1);},{v.valueAction_(0);});

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

	*clearSteps {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|

		var index,dictionary = ~cbox_steps;

		for(0,steps.size-1,{|i|

			index=steps[i];

			dictionary[track][0][index].valueAction_(false);

		});

		^"Cleared steps".inform;

	}

	*setSteps {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31], overrideSteps = false|

		var index,arr,dictionary = ~cbox_steps;

		if(arr.isArray.not,{
			arr = steps.asArray;//en caso de no usar array como parametro
			}, {
			" DEBUG: YES IS AN ARRAY".postcln;
		});
		// DEBUG:
		if(arr.size > 32, {arr = arr.clipAt(32)});

		if(overrideSteps == true,{this.clearSteps(track)},{this.clearSteps(track,arr)});

		for(0,arr.size-1,{|i|
			index=arr[i];
			dictionary[track][0][index].valueAction_(true);
		});

		^"Added steps".inform;
	}

	*randSteps {|track,steps_num = 1|

		var a,step;

		a = Array.new(32);

		step = Pxrand((0..31),inf).asStream;

		for(1,steps_num,{|i|
			a = a.add(step.next);
		});

		this.clearSteps(track);

		^this.setSteps(track,a);

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
				if(Tdef(\autoz).isPlaying,{
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

		Tdef.removeAll;
		^server.quit.freeAll.reboot;

	}

}
