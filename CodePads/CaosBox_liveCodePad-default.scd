///////////////////////////////////////////
//CaosBox v1.1 default liveCodePad
/////////////////Leeme//////////////////////////
////////////////////////////////////////////
/* Percussion Functions: */
///////////////////////////
//
//
//kick
~b={var out=50;Out.ar(out,CaosKick.ar(0.01,0.25,1,0.25,60,64,50,1,1,0.2,2))};
//snare
~t={var out=50;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:360,rq:0.25,amp1:0.75,amp2:0.5))};//
//hat
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.01,rel:0.5,highcutfreq:8330,rq:0.25,amp1:0.35,amp2:0.01))};//
//kick
~b2={var out=64;Out.ar(out,CaosKick2.ar(att:0.01,rel:0.7,modFreq:2,modbw:0.5,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1))};//
//snare2
~t2={var out=58;Out.ar(out,CaosSnare2.ar(att:0.01,rel:0.16,iphase:0.5,bw:0.35,highcutfreq:270,rq:0.35,amp1:0.1,amp2:0.05))};//
//hat2
~h2={var out=50;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.25,highcutfreq:6950,rq:0.45,amp1:0.5,amp2:0.3))};//
// s.queryAllNodes;
// Melodies as intervals array
// m.melody(x,36);
/* Bass, Pad, Chord functions: */
/////////////////////////////////
(//bass 1
Tdef(\bass,{
	var bassmel=Prand(m.melody(x,24),inf).asStream;
	// var out=Pseq(~pat_arr.value(52,(0..31)),inf).asStream;
	loop{
		~bass.set(\note,bassmel.next,
			\filtminf,50,
			\filtmaxf,8420,
			\filtime,0.0125,
			\rq,0.5,
			\iphase,0.5,
			\amp1,0.5,
			\amp2,0.5,
			// \out,[52,53,56,57]);
			// \out,~rand_stream.value('rand1',[52,56,60,58,54,64]));
			\out,64);
		~tiempos.wait;
	}
}).quant_(1);
);
//bass 2
(
Tdef(\bass2,{
	var bass2mel=Pxrand(m.melody(x,36),inf).asStream;
	// var out=Prand(~pat_arr.value(50,62,[0,4,8,12,16,20,30]),inf).asStream;
	loop{
		~bass2.set(\note,bass2mel.next,
			\trig,1,
			\filtminf,80,
			\filtmaxf,12900,
			\filtime,0.25,
			\rq,0.5,
			\bandw,0.5,
			\iphase,0.05,
			\amp1,0.025,
			\amp2,0.01,
			// \out,);
		\out,~rand_stream.value('rand1',[52,54,58,64]));
		~tiempos.wait;
	}
}).quant_(1);
);
//ambient pad
(
Tdef(\pad,{
	var padmel=Pxrand(m.melody(x),inf).asStream;
	~amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
		~amb.set(\note,padmel.next);
		~amb.set(\trem,8);
		~amb.set(\vrel,2);
		~amb.set(\iphase,0.25);
		~amb.set(\cutf,12420);
		~amb.set(\rq,0.5);
		~amb.set(\amp,0.04);
		~amb.set(~rand_stream.value('rand1',[52,56,60,58,54,64]));
		// ~amb.set(\out,58);
		~tiempos.wait;
	}
}).quant_(1);
);
//ambiente pad 2
(
Tdef(\pad2,{
	var pad2mel=Pseq(m.melody(x),inf).asStream;
	loop{
		~amb2.set(\note,pad2mel.next);
		~amb2.set(\fmax,[16,32,64,128,8].choose);
		~amb2.set(\fm,[2,4,8].choose);
		~amb2.set(\harm,120);
		~amb2.set(\rmix,0.79);
		~amb2.set(\rroom,0.15);
		~amb2.set(\rfilt,0.5);
		~amb2.set(\amp1,0.09);
		~amb2.set(\amp2,0.05);
		~amb2.set(\out,~rand_stream.value('rand1',[52,56,58]));
		~tiempos.wait;
	}
}).quant_(4);
);
//Chord Synths
(
Tdef(\acordes,{
	var acmel=Pseq(m.melody(x,36),inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
	var cambia=Prand(['m','m7','mmaj7'],inf).asStream;
	loop{
		~chord.set(\chord,cambia.next);
		~chord.set(\note,acmel.next);
		~chord.set(\iphase,0.2);
		~chord.set(\width,0.5);
		~chord.set(\cutf,10220);
		~chord.set(\rq,0.5);
		~chord.set(\pan,0);
		~chord.set(\amp,0.1);
		~chord.set(\out,60);
		~tiempos.wait;
	}
}).quant_(4);
);
(
Tdef(\acordes2,{
	var ac2mel=Prand(m.melody(x,24),inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	var cambia2=Prand(['m','M','M9','mmaj7','m9m'],inf).asStream;
	loop{
		~chord2.set(\chord,cambia2.next);
		~chord2.set(\note,ac2mel.next);
		~chord2.set(\cutf,12220);
		~chord2.set(\rq,0.25);
		~chord2.set(\pan,[0,-0.97]);
		~chord2.set(\amp,0.1);
		~chord2.set(\out,c.randStream('rand2',[[52,52],[52,54],56,64]));
		~tiempos*2.wait;
	}
}).quant_(1);
);
//LineIn
(
SynthDef(\ent,{|out=64,gate,att,rel|
	Out.ar(out,Pan2.ar(SoundIn.ar(0)*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
);

////////////////////////////////////////
//You can configure the Automation file:
// (~url +/+ "CB/CaosBox-auto.scd").openOS;
//////////////////////////////////////