///////////////////////////////////////////
//CaosBox v1.1 default liveCodePad
/////////////////Leeme//////////////////////////
////////////////////////////////////////////
/* Percussion Functions: */
///////////////////////////
//
//
//kick
~cbox_b={var out=62;Out.ar(out,CaosKick.ar(0.01,0.85,1,0.25,60,64,50,1,0.88,0.45,2))};
//snare
~cbox_t={var out=50;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:360,rq:0.25,amp1:0.75,amp2:0.5))};//
//hat
~cbox_h={var out=50;Out.ar(out,CaosHats.ar(att:0.01,rel:0.5,highcutfreq:8330,rq:0.25,amp1:0.35,amp2:0.01))};//
//kick
~cbox_b2={var out=64;Out.ar(out,CaosKick2.ar(att:0.01,rel:0.7,modFreq:2,modbw:0.5,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1))};//
//snare2
~cbox_t2={var out=58;Out.ar(out,CaosSnare2.ar(att:0.01,rel:0.16,iphase:0.5,bw:0.35,highcutfreq:270,rq:0.35,amp1:0.1,amp2:0.05))};//
//hat2
~cbox_h2={var out=52;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.25,highcutfreq:6950,rq:0.45,amp1:0.5,amp2:0.3))};//
// s.queryAllNodes;
// Melodies as intervals array
// ~cbox_mainmelody.melody(~cbox_degrees,36);
/* Bass, Pad, Chord functions: */
/////////////////////////////////
(//bass 1
Tdef(\bass,{
	var bassmel=Prand(~cbox_mainmelody.melody(~cbox_degrees,36),inf).asStream;
	loop{
		~cbox_bass.set(\note,bassmel.next,
			\filtminf,50,
			\filtmaxf,12420,
			\filtime,0.1125,
			\rq,0.25,
			\iphase,0.15,
			\amp1,0.15,
			\amp2,0.15,
			// \out,[52,53,56,57]);
			// \out,~cbox_rand_stream.value('rand1',[52,56,60,58,54,64]));
			\out,64);
		~cbox_tiempos.wait;
	}
}).quant_(1);
);
//bass 2
(
Tdef(\bass2,{
	var bass2mel=Pseq(~cbox_mainmelody.melody(~cbox_degrees,24).mirror2,inf).asStream;

	loop{
		~cbox_bass2.set(\note,bass2mel.next,
			\trig,1,
			\filtminf,80,
			\filtmaxf,12900,
			\filtime,0.25,
			\rq,0.5,
			\bandw,0.5,
			\iphase,0.05,
			\amp1,0.25,
			\amp2,0.1,
			\out,64);
		// \out,~cbox_rand_stream.value('rand1',[52,54,58,64]));
		~cbox_tiempos.wait;
	}
}).quant_(1);
);
//ambient pad
(
Tdef(\pad,{
	var padmel=Pxrand(~cbox_mainmelody.melody(~cbox_degrees),inf).asStream;
	~cbox_amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
		~cbox_amb.set(\note,padmel.next);
		~cbox_amb.set(\trem,8);
		~cbox_amb.set(\vrel,2);
		~cbox_amb.set(\iphase,0.25);
		~cbox_amb.set(\cutf,12420);
		~cbox_amb.set(\rq,0.5);
		~cbox_amb.set(\amp,0.04);
		~cbox_amb.set(~cbox_rand_stream.value('rand1',[52,56,60,58,54,64]));
		// ~cbox_amb.set(\out,58);
		~cbox_tiempos.wait;
	}
}).quant_(1);
);
//ambiente pad 2
(
Tdef(\pad2,{
	var pad2mel=Pseq(~cbox_mainmelody.melody(~cbox_degrees),inf).asStream;
	loop{
		~cbox_amb2.set(\note,pad2mel.next);
		~cbox_amb2.set(\fmax,[16,32,64,128,8].choose);
		~cbox_amb2.set(\fm,[2,4,8].choose);
		~cbox_amb2.set(\harm,120);
		~cbox_amb2.set(\rmix,0.79);
		~cbox_amb2.set(\rroom,0.15);
		~cbox_amb2.set(\rfilt,0.5);
		~cbox_amb2.set(\amp1,0.09);
		~cbox_amb2.set(\amp2,0.05);
		~cbox_amb2.set(\out,~cbox_rand_stream.value('rand1',[52,56,58]));
		~cbox_tiempos.wait;
	}
}).quant_(4);
);
//Chord Synths
(
Tdef(\acordes,{
	var acmel=Pseq(~cbox_mainmelody.melody(~cbox_degrees,36),inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
	var cambia=Prand(['m','m7','mmaj7'],inf).asStream;
	loop{
		~cbox_chord.set(\chord,cambia.next);
		~cbox_chord.set(\note,acmel.next);
		~cbox_chord.set(\iphase,0.2);
		~cbox_chord.set(\width,0.5);
		~cbox_chord.set(\cutf,10220);
		~cbox_chord.set(\rq,0.5);
		~cbox_chord.set(\pan,0);
		~cbox_chord.set(\amp,0.1);
		~cbox_chord.set(\out,60);
		~cbox_tiempos.wait;
	}
}).quant_(4);
);
(
Tdef(\acordes2,{
	var ac2mel=Prand(~cbox_mainmelody.melody(~cbox_degrees,[24,60]),inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	var cambia2=Prand(['m','M','M9','mmaj7','m9m'],inf).asStream;
	loop{
		~cbox_chord2.set(\chord,cambia2.next);
		~cbox_chord2.set(\note,ac2mel.next);
		~cbox_chord2.set(\cutf,12220);
		~cbox_chord2.set(\rq,0.25);
		~cbox_chord2.set(\pan,[0,-0.97]);
		~cbox_chord2.set(\amp,0.025);
		~cbox_chord2.set(\out,c.randStream('rand2',[64,52,62,56,60]));
		~cbox_tiempos.wait;
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
// (~cbox_url +/+ "CB/CaosBox-auto.scd").openOS;
///////////////////////////////////////