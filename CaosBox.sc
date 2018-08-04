//Main Enviroment init
CaosBox {

	classvar server,url;

	*enviroment {

		if(~url.notNil,{

			^"CaosBox.enviroment is already running"

			},{

		~url = this.filenameSymbol.asString.dirname;

		^super.new.init;

		});

	}

	init {

		server = Server.local;

		server.waitForBoot {

			(~url +/+ "CB/CaosBox-load.scd").load;

			fork{1.do({13.wait;

				//debug
				"\n => Class in development ... if you are having trouble booting sequencer, please refer to file 'CaosBox.scd' to use legacy boot".inform;
			})};

		};

	}

	*play {

		if(Tdef(\secuencias).isPlaying,{
			^"CaosBox already running";
			},{
				~bot.valueAction_(1);
				^"";
		});

	}

	*stop {

		~bot.valueAction_(0);
		Tdef(\secuencias).reset;

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

	*metric {

		var v = ~botm;

		if(v.value == 0,{v.valueAction_(1)},{v.valueAction_(0)});

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

				^"Use only 'start' or 'stop' keys";

		});

	}

	*freqAnalyzer {|active = false|

		~f.valueAction_(active);

	}

	// seq methods
	*randStream {|seq,array|

		var out;

		if(seq != \rand2 and:( seq != \rand1),
			{

				"Use 'seq' or 'rand' keys to choose output sequence style \n".inform;

			},{

				switch(seq,
					\rand1,{out=Prand(array,inf).asStream},
					\rand2,{out=Pshuf(array,inf).asStream},
				);

				^out.next;
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

		^"Manually cleared step pattern".inform;

	}

	*setSteps {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],resetCheckboxes = true|

	var index,arr,dir = ~steps;

		arr = steps.asArray;//en caso de no usar array como parametro

		if(resetCheckboxes == true,{this.clearSteps(track)},{this.clearSteps(track,arr)});

		for(0,arr.size-1,{|i|
			index=arr[i];
			dir[track][0][index].valueAction_(true);
		});

		^"Manually added step pattern".inform;
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
			// 'LPF',{}, //later implementation of filter automation
			// 'BPF',{},
			// 'HPF',{},

			"Use only 'reverb','delay','pitch','grains' keys for FX type argument, and 'normal','fast','slow','slowest' keys for FX speed argument";);

	}

}