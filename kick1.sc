Kick1 : CaosBox {

	*new {

		^super.new;

	}

	*dyn {|out,att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction|

		this.synth(out,att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction);

		^"Dynamic kick function";
	}

	synth {|out,att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction|

		SynthDef(\test,{|out,att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction|

			var sig;
			Out.ar(out,CaosKick.ar(att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction));

		}).add;

	}

	static {|out,att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate=1,amp1,amp2,doneAction|
		~b={Out.ar(out,CaosKick.ar(att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,doneAction))};

		^"static kick Function";
	}

}