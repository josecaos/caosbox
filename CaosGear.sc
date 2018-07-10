CaosGear : CaosBox {

	*new {

		^super.new;

	}

	melody {|scale=#[0,3,7,11,12], index=60|

		if(scale.isArray, {

			~mainmelody = scale + index;

			(~url +/+ "CodePads/CaosBox_liveCodePad-default.scd").load;

			^"New Melody seted";

			},{

				^"Please use an array with degrees, 'Scale' can be useful";

		});


	}

	kick {|out=50,att=0.01,rel=0.25,modFreq=2,modbw=0.25,freq1=60,freq2=52,lowcutfreq=45,gate=1,amp1=1,amp2=0.25,doneAction=2|

		~b = {
			var signal;
			signal = CaosKick.ar(att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction);
			Out.ar(out,signal);
		};

		^"Kick values changed";
	}

	kick2 {|out=50,att=0.01,rel=0.5,modFreq=2,modbw=0.5,bw=0.2,freq1=60,freq2=64,lowcutfreq=45,gate=1,amp=0.15|
		var signal;
		signal = CaosKick2.ar(att,rel,modFreq,modbw,bw,freq1,freq2,lowcutfreq,gate,amp);
		Out.ar(out,signal)
	}

	snare {|out=50,att=0.01,rel=0.25,highcutfreq=360,rq=0.25,gate=1,amp1=0.55,amp2=0.25|

		~t = {
			var signal;
			signal = CaosSnare.ar(att,rel,highcutfreq,rq,gate,amp1,amp2);
			Out.ar(out,signal);
		};

	}

	hihats {|out=50,att=0.01,rel=0.1,highcutfreq=6330,rq=0.05,gate=1,amp1=0.9,amp2=0.9|

		~h = {

			var signal;
			signal = CaosHats.ar(att,rel,highcutfreq,rq,gate,amp1,amp2);
			Out.ar(out,signal);

		};//

	}

/*	kickDyn {|out=50,att=0.01,rel=0.25,modFreq=2,modbw=0.25,freq1=60,freq2=52,lowcutfreq=45,gate=0,amp1=1,amp2=0.25,doneAction=2|

		// ~kickgear.set(\out,out,\att,att,\rel,rel,\modFreq,modFreq,\modbw,modbw,\freq1,freq1,\freq2,freq2,\lowcutfreq,lowcutfreq,\gate,gate,\amp1,amp1,\amp2,amp2,\doneAction,doneAction);
		// Synth(\kickgear,[\out,out,\att,att,\rel,rel,\modFreq,modFreq,\modbw,modbw,\freq1,freq1,\freq2,freq2,\lowcutfreq,lowcutfreq,\gate,gate,\amp1,amp1,\amp2,amp2,\doneAction,doneAction]);

		^"Dynamic kick";
	}*/

	//
	bass {
		|
		out=#[50],
		semitoneArray=#[ 0, 2, 4, 5, 7, 9, 11 ],
		seqType='seq',
		attack=0.01,
		release=0.25,
		filtMinFreq=45,
		filtMaxFreq=12420,
		filtTime=0.125
		rq=0.25,
		iphase=0.5,
		amp1=0.5,
		amp2=0.5
		|
		// var bassmel;
		var note = semitoneArray;
		var attk = attack;
		var rel = release;
		var filt1 = filtMinFreq;
		var filt2 = filtMaxFreq;
		var filt3 = filtTime;
		var	bandwidth = rq;
		var waveiphase = iphase;
		var ampx = amp1;
		var ampy = amp2;
		var outbus = out;
		(//bass 1
			Tdef(\bass,{

				var	bassmel,outbus;

				if(seqType == 'rand' or: {seqType == 'seq'}, {

					switch(seqType,
						'rand', {
							bassmel=Prand(note,inf).asStream;
							outbus=Prand(out.asArray,inf).asStream;
						},
						'seq', {
							bassmel=Pseq(note,inf).asStream;
							outbus=Pseq(out.asArray,inf).asStream;
						},
						("Bass Melodic secuence type is" + seqType).inform;
					);

					}, {
						"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
				});

				loop{
					~bass.set(
						\att,attk,
						\rel,rel,
						\note,bassmel.next,
						\filtminf,filt1,
						\filtmaxf,filt2,
						\filtime,filt3,
						\rq,bandwidth,
						\iphase,waveiphase,
						\amp1,ampx,
						\amp2,ampy,
						\out,outbus);
					// \out,~rand_stream.value('rand2',[52,56,60,58,54,64]));
					~tiempos.wait;
				}
			}).quant_(0.15);
		);

		^"Bass values changed";

	}

}