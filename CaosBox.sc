//Main Enviroment init
CaosBox {

	classvar server,url;

	*enviroment {

		if(~url.notNil,{

			^"CaosBox.enviroment is already running"

		},{
			// System files
			~urls = ["CB/CaosBox-midi.scd","CB/CaosBox-vars.scd","CB/CaosBox-signal.scd","CB/CaosBox-synths.scd",	"CB/CaosBox-auto.scd","CB/CaosBox-defaults.scd","GUI/CaosBox-GUI.scd",	"GUI/CaosBox-GUI_2.scd","GUI/CaosBox-GUI_3.scd","GUI/CaosBox-GUI_4.scd","CB/CaosBox-seq.scd","CB/CaosBox-funcs.scd"];

			~url = this.filenameSymbol.asString.dirname;

			^super.new.init;

		});

	}

	init {

		server = Server.local;

		server.waitForBoot {

			(~url +/+ "CB/CaosBox-load.scd").load;

		};

	}

	*soundcheck {|noiseType = 'white'|

		var signal;

		switch(noiseType,
			\white,{signal = WhiteNoise },
			\pink,{signal =  PinkNoise},
			\brown,{signal = BrownNoise},
			{
				signal = PinkNoise;
				"Use 'white', 'pink' or 'brown' keys only".inform;}
		);

		play{signal.ar(SinOsc.ar(2,0,0.01,1))*EnvGen.ar(Env.perc(0.5,8),1,doneAction:2)!2};

		^"Soundcheck running with" + signal.asString + " noise"

	}

	*play {

		if(Tdef(\secuencias).isPlaying,{
			^"CaosBox already running";
		},{
			~bot.valueAction_(1);
			^"Machine is running";
		});

	}

	*stop {

		~bot.valueAction_(0);
		Tdef(\secuencias).pause;

		^"";
	}

	*bpm {|val|

		~numclock.value = val;

		~clock  = {TempoClock.tempo=~numclock.value/60};

		~clock.value;

		^("+ BPM set to" + ~numclock.value);
	}

	*randomTime {|random = false, editBPM = false, bpmArray = #[47,62,94,141,188]|

		if(random == true or:{ random == false} ,{

			if(editBPM == true,{
				~randtimes = bpmArray;
			});

			switch(random,
				true,{~botr.valueAction_(1)},
				false,{~botr.valueAction_(0)});

			^"";

		},{

			^"Use only 'true' or 'false'";
		});

	}

	*toggleMetric {

		var v = ~botm;

		if(v.value == 0,{v.valueAction_(1);},{v.valueAction_(0);});

		^"";
	}

	*record {

		~recbot.valueAction_(1);

		^"";

	}

	*stopRecording {

		~recbot.valueAction_(0);

		^"";
	}

	*history {|state, name|

		if(state == \start or: {state == \stop} or: {state == \load}, {
			switch(state,
				\start, {History.start},
				\stop, {~hbutt.valueAction_(0)},
				\load, {History.loadStory(~url +/+ "Histories" +/+ name).play(verbose:true)}
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
		~fbot.valueAction_(onoff);

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
				return.postcln;

				^return;
		});
	}

	//Regresa un array de 32 elementos
	//valor 'default' en todos los slots del array + 'in' valor secundario en: 'steps' especificos
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

		var a,dir = ~steps;

		for(0,steps.size-1,{|i|

			a=steps[i];

			dir[track][0][a].valueAction_(false);

		});

		^"Cleared steps".inform;

	}

	*setSteps {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],overrideSteps = false|

		var index,arr,dir = ~steps;

		arr = steps.asArray;//en caso de no usar array como parametro

		if(overrideSteps == true,{this.clearSteps(track)},{this.clearSteps(track,arr)});

		for(0,arr.size-1,{|i|
			index=arr[i];
			dir[track][0][index].valueAction_(true);
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
						'normal',{~autopopr.valueAction_(0);"Reverb normal speed".postln},
						'fast',{~autopopr.valueAction_(1);"Reverb fast speed".postln},
						'slow',{~autopopr.valueAction_(2);"Reverb slow speed".postln},
						'slowest',{~autopopr.valueAction_(3);"Reverb slowest speed".postln}
					);
					~autoreverbmix=argArr1.asArray;
					~autoreverbroom=argArr2.asArray;
					~autoreverbdamp=argArr3.asArray;
					(~url +/+ "CB/CaosBox-auto.scd").load;//reload
					if(Tdef(\autor).isPlaying,{
						^"Reverb Automation already running";
					},{
						~autobotr.valueAction_(1);
						^"Reverb Automation running";
					});
				}, {
					~autobotr.valueAction_(0);
					^"Reverb Automation stopped";
				});
			},
			'delay',{
				if(play == true, {
					switch(speed,
						'normal',{~autopopd.valueAction_(0);"Delay normal speed".postln},
						'fast',{~autopopd.valueAction_(1);"Delay fast speed".postln},
						'slow',{~autopopd.valueAction_(2);"Delay slow speed".postln},
						'slowest',{~autopopd.valueAction_(3);"Delay slowest speed".postln}
					);
					~autodelaytime=argArr1.asArray;
					~autodelayfeed=argArr2.asArray;
					(~url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autod).isPlaying,{
						^"Delay Automation already running";
					},{
						~autobotd.valueAction_(1);
						^"Delay Automation running";
					});
				}, {
					~autobotd.valueAction_(0);
					^"Delay Automation stopped";
				});
			},
			'pitch',{
				if(play == true, {
					switch(speed,
						'normal',{~autopopp.valueAction_(0);"Pitch normal speed".postln},
						'fast',{~autopopp.valueAction_(1);"Pitch fast speed".postln},
						'slow',{~autopopp.valueAction_(2);"Pitch slow speed".postln},
						'slowest',{~autopopp.valueAction_(3);"Pitch slowest speed".postln}
					);
					~autopitchrate=argArr1.asArray;
					~autopitchdispersion=argArr2.asArray;
					~autotimedispersion=argArr3.asArray;
					(~url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autop).isPlaying,{
						^"Pitch Automation already running";
					},{
						~autobotp.valueAction_(1);
						^"Pitch Automation running";
					});
				}, {
					~autobotp.valueAction_(0);
					^"Pitch Automation stopped";
				});
			},
			'grains',{
				if(play == true, {
					switch(speed,
						'normal',{~autopopg.valueAction_(0);"Grains normal speed".postln},
						'fast',{~autopopg.valueAction_(1);"Grains fast speed".postln},
						'slow',{~autopopg.valueAction_(2);"Grains slow speed".postln},
						'slowest',{~autopopg.valueAction_(3);"grains slowest speed".postln}
					);
					~autograintrig=argArr1.asArray;
					~autograinsize=argArr2.asArray;
					(~url +/+ "CB/CaosBox-auto.scd").load;
					if(Tdef(\autog).isPlaying,{
						^"Grains Automation already running";
					},{
						~autobotg.valueAction_(1);
						^"Grains Automation running";
					});
				}, {
					~autobotg.valueAction_(0);
					^"Grains Automation stopped";
				});
			},
			"Use only 'reverb','delay','pitch','grains' keys for FX type argument, and 'normal','fast','slow','slowest' keys for FX speed argument";);
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
						~numr.value=arg1;
						~auxrfader.value=arg1;
						~numroom.value=arg2;
						~auxroomfader.value=arg2;
						~numd.value=arg3;
						~auxdfader.value=arg3;
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
							~numt.value=arg1;
							~auxtfader.value=arg1;
							~numf.value=arg2;
							~auxffader.value=arg2;
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
						~nump.value=arg1;
						~auxpfader.value=arg1;
						~numpd.value=arg2;
						~auxpdfader.value=arg2;
						~numtd.value=arg3;
						~auxtdfader.value=arg3;
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
							~grains.set(\trigger,~gfaders.x_(arg1));
							~grains.set(\size,~gfaders.y_(arg2));
							^"Granulator Parameters, Seted";
						});
				});
			},
			'master',{
				if(arg1 < 0 or: {arg1 > 1} or: {arg2 < 0} or: {arg2 > 1} or: {arg3 < 0 }	or: {arg3 > 1}
					or: {arg4 < 0} or: {arg4 > 1} or: {arg5 < 0} or: {arg5 > 1}, {
						^"Master FX parameters only between 0 and 1";
					},{
						~num.value = arg1;
						~mastfader.value = arg1;
						~num1.value = arg2;
						~mastfader1.value = arg2;
						~num2.value = arg3;
						~mastfader2.value = arg3;
						~num3.value = arg4;
						~mastfader3.value = arg4;
						~num4.value = arg5;
						~mastfader4.value = arg5;
						^"Master Parameters, Seted ";
				});
			},
			"Use only 'reverb','delay','pitch','grains' or 'master' keys for FX type argument";
		);
	}
	//
}