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

	kickDyn {|out=50,att=0.01,rel=0.25,modFreq=2,modbw=0.25,freq1=60,freq2=52,lowcutfreq=45,gate=0,amp1=1,amp2=0.25,doneAction=2|

		// ~kickgear.set(\out,out,\att,att,\rel,rel,\modFreq,modFreq,\modbw,modbw,\freq1,freq1,\freq2,freq2,\lowcutfreq,lowcutfreq,\gate,gate,\amp1,amp1,\amp2,amp2,\doneAction,doneAction);
		// Synth(\kickgear,[\out,out,\att,att,\rel,rel,\modFreq,modFreq,\modbw,modbw,\freq1,freq1,\freq2,freq2,\lowcutfreq,lowcutfreq,\gate,gate,\amp1,amp1,\amp2,amp2,\doneAction,doneAction]);

		^"Dynamic kick";
	}

	//
	bass {
		|semitoneArray=#[ 0, 2, 4, 5, 7, 9, 11 ],
		seqType='seq',
		filtMinFreq=45,
		filtMaxFreq=12420,
		filtTime=0.125|
		// var bassmel;
		var note = semitoneArray;
		var filt1 = filtMinFreq;
		var filt2 = filtMaxFreq;
		var filt3 = filtTime;
		(//bass 1
			Tdef(\bass,{

				var	bassmel;//=Prand(note+60,inf).asStream;

				if(seqType == 'rand' or: {seqType == 'seq'}, {

					switch(seqType,
						'rand', {
							bassmel=Prand(note,inf).asStream;
							bassmel.next.postcln;
						},
						'seq', {
							bassmel=Pseq(note,inf).asStream;
						},
						("Bass Melodic secuence type is" + seqType).inform;
					);

					}, {
						"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
				});

				loop{
					~bass.set(\note,bassmel.next,
						\filtminf,filt1,
						\filtmaxf,filt2,
						\filtime,filt3,
						\rq,0.15,
						\iphase,0.5,
						\amp1,0.5,
						\amp2,0.2,
						\out,50);
					// \out,~rand_stream.value('rand2',[52,56,60,58,54,64]));
					~tiempos.wait;
				}
			}).quant_(0.15);
		);

		^"Bass values changed";

	}

}