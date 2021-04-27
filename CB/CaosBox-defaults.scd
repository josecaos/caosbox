///////////////////////////////////////////
//CaosBox v1.3 Instruments  default parameters
///////////////////////////////////////////
Tdef.defaultQuant = 1;
//
// ~cbox_b={var out=50;Out.ar(out,CaosKick.ar(0.01,0.25,1,0.25,60,64,55,1,1,0.2,0))};
~cbox_b={|out=50,att=0.01,rel=0.25|
	Out.ar(out,CaosKick.ar(att,rel,1,0.25,60,64,55,1,1,0.2,0))
};
~cbox_b2={var out=50;Out.ar(out,CaosKick2.ar(0.01,0.7,2,modbw:0.5,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1,pan:0))};
~cbox_t={var out=50;Out.ar(out,CaosSnare.ar(0.01,0.25,360,rq:0.25,amp1:0.75,amp2:0.5,pan:0))};
~cbox_t2={var out=50;Out.ar(out,CaosSnare2.ar(0.01,0.16,0.5,bw:0.35,highcutfreq:270,rq:0.35,amp1:0.1,amp2:0.05,pan:0))};
~cbox_h={var out=50;Out.ar(out,CaosHats.ar(0.01,0.5,8330,rq:0.25,amp1:0.35,amp2:0.01,pan:0))};
~cbox_h2={var out=50;Out.ar(out,CaosHats2.ar(0.025,0.25,6950,rq:0.45,amp1:0.5,amp2:0.3,pan:0))};
/////////////////////////////////
~cbox_sintetizadores = {|sinth|
	switch(sinth,
		\bass,{
			~cbox_bass=Synth(\bajouno);
		},
		\bass2,{
			~cbox_bass2=Synth(\bajodos);
		},
		\amb,{
			~cbox_amb=Synth(\ambuno);
		},
		\amb2,{
			~cbox_amb2=Synth(\ambdos);
		},
		\chords,{
			~cbox_chord=Synth(\acordesuno);
		},
		\chords2,{
			~cbox_chord2=Synth(\acordesdos);
		},
		\in,{
			~cbox_entrada=Synth(\entrada);
		}
	);
};
//
CaosGear.new.bass(50,~cbox_mainmelody.melody(LCNE.dupOctave(Scale.minor.degrees,3),36),\seq);
CaosGear.new.bass2(50,~cbox_mainmelody.melody(LCNE.dupOctave(Scale.minor.degrees,3),48),\seq);
CaosGear.new.pad(50,~cbox_mainmelody.melody(LCNE.dupOctave(Scale.minor.degrees,4),24),\seq);
CaosGear.new.pad2(50,~cbox_mainmelody.melody(LCNE.dupOctave(Scale.minor.degrees,4),24),\seq);
CaosGear.new.chords(50,~cbox_mainmelody.melody(LCNE.dupOctave(Scale.minor.degrees,4),24),\seq);
CaosGear.new.chords2(50,~cbox_mainmelody.melody(LCNE.dupOctave(Scale.minor.degrees,4),24),\seq);
CaosGear.new.lineIn(50);
