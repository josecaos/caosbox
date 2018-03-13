CaosGear : CaosBox {

	*new {

		^super.new;

	}

	kick {|out=50,att=0.01,rel=0.25,modFreq=2,modbw=0.25,freq1=60,freq2=52,lowcutfreq=45,gate=1,amp1=1,amp2=0.25,doneAction=2|

		~b = {
			var signal;
			signal = CaosKick.ar(att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction);
			Out.ar(out,signal)
		};

		^"Kick values changed";
	}

	kickDyn {|out=50,att=0.01,rel=0.25,modFreq=2,modbw=0.25,freq1=60,freq2=52,lowcutfreq=45,gate=0,amp1=1,amp2=0.25,doneAction=2|

		~kickgear.set(\out,out,\att,att,\rel,rel,\modFreq,modFreq,\modbw,modbw,\freq1,freq1,\freq2,freq2,\lowcutfreq,lowcutfreq,\gate,gate,\amp1,amp1,\amp2,amp2,\doneAction,doneAction);
		// ~kickgear.set(\out,out,\att,att,\rel,rel,\modFreq,modFreq,\modbw,modbw,\freq1,freq1,\freq2,freq2,\lowcutfreq,lowcutfreq,\gate,gate,\amp1,amp1,\amp2,amp2,\doneAction,doneAction);

		^"Dynamic kick";
	}


}