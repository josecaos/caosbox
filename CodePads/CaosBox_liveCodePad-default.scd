///////////////////////////////////////////
//CaosBox v1.1 default liveCodePad
/////////////////Leeme//////////////////////////
//Archivo complementario para modificar la 'CaosPercLib' junto con la GUI.
//Primero: Cambia los argumentos de las clases qué desees y evalua.
//Segundo: Secuencia la función del instrumento en los chckboxes de la GUI.
//Rutas: El canal Master es el #50.
/////////////////ReadMe//////////////////////////
//Complementary file to live code 'CaosPercLib' along the secuence on GUI.
//First: Change the class argument value you desire, and evaluate.
//Second: Sequence the instrument function in the checkboxes on the GUI.
//Routing: Master channel is #50.
////////////////////////////////////////////
/* Percussion Functions: */
///////////////////////////
//kick
~b={var out=50;Out.ar(out,CaosKick.ar(0.01,0.15,2,0.5,60,60,50,1,0.01,0.5,2))};

//snare
~t={var out=60;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.05,highcutfreq:220,rq:0.35,amp1:0.05,amp2:0.1))};//

~t2={var out=50;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:420,rq:0.65,amp1:0.1,amp2:0.1))};//
//hat
~h={var out=64;Out.ar(out,CaosHats.ar(att:0.01,rel:0.15,highcutfreq:10330,rq:0.75,amp1:0.05,amp2:0.1))};//
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.01,rel:0.2,highcutfreq:12330,rq:0.5,amp1:0.2,amp2:0.25))};//
//kick
~b2={var out=58;Out.ar(out,CaosKick2.ar(att:0.01,rel:0.16,modFreq:2,modbw:0.5,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1))};//
//snare
~t2={var out=64;Out.ar(out,CaosSnare2.ar(att:0.05,rel:0.12,iphase:0.05,bw:0.5,highcutfreq:270,rq:0.5,amp1:0.1,amp2:0.05))};//
//hat
~h2={var out=50;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.25,highcutfreq:6950,rq:0.45,amp1:0.5,amp2:0.3))};//
~h2={var out=58;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.75,highcutfreq:6950,rq:0.45,amp1:0.5,amp2:0.3))};//
// s.queryAllNodes;

// Melodies as intervals array
Scale.hungarianMinor.degrees;
Scale.directory;
//core functions
// ~mainmelody = [0, 3, 7, 10, 13, 17, 21]+60;
~mainmelody = [ 0, 2, 3, 6, 7, 8, 11 ]+60;
~random_steps.value(\hihats,2);
/*
~set_steps.value(\hihats,Array.series(16,0,2));
~clear_steps.value(\snare);
~steps.keys;
*/
/* Bass, Pad, Chord functions: */
/////////////////////////////////
(//all Tdefs
(//bass 1
Tdef(\bass,{
	var bassmel=Prand(~mainmelody-24,inf).asStream;
	// var out=Pseq(~pat_arr.value(52,(0..31)),inf).asStream;
	loop{
		~bass.set(\note,bassmel.next,
			\filtminf,80,
			\filtmaxf,12700,
			\filtime,0.01,
			\rq,0.25,
			\iphase,0.05,
			\amp1,0.25,
			\amp2,0.01,
			\out,50);
		// \out,~rand_stream.value('rand2',[52,60,58,54,64]));
		~tiempos.wait;
	}
}).quant_(4);
);
//bass 2
(
Tdef(\bass2,{
	var bass2mel=Prand(~mainmelody.scramble.mirror2-27,inf).asStream;
	// var out=Prand(~pat_arr.value(50,62,[0,4,8,12,16,20,30]),inf).asStream;
	loop{
		~bass2.set(\note,bass2mel.next,
			\trig,1,
			\filtminf,56,
			\filtmaxf,440,
			\filtime,0.25,
			\rq,0.5,
			\bandw,0.05,
			\iphase,0.15,
			\amp1,0.25,
			\amp2,0.35,
		\out,~rand_stream.value('rand2',[52,60,58,54,64]));
		~tiempos.wait;
	}
}).quant_(4);
);
//ambient pad
(
Tdef(\pad,{
	var padmel=Pxrand(~mainmelody.scramble,inf).asStream;
	~amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
		~amb.set(\note,padmel.next);
		~amb.set(\trem,4);
		~amb.set(\vrel,1);
		~amb.set(\iphase,0.5);
		~amb.set(\cutf,16420);
		~amb.set(\rq,0.25);
		~amb.set(\amp,0.015);
		~amb.set(\out,52);
		~tiempos.wait;
	}
}).quant_(4);
);
//ambiente pad 2
(
Tdef(\pad2,{
	var pad2mel=Pseq(~mainmelody+24,inf).asStream;
	loop{
		~amb2.set(\note,pad2mel.next);
		~amb2.set(\fmax,[16,32,64,128,8].choose);
		~amb2.set(\fm,[2].choose);
		~amb2.set(\harm,440);
		~amb2.set(\rmix,0.79);
		~amb2.set(\rroom,0.15);
		~amb2.set(\rfilt,0.5);
		~amb2.set(\amp1,0.03);
		~amb2.set(\amp2,0.02);
		~amb2.set(\out,~rand_stream.value('rand2',[50,52,56,58,60,62,64]));
		~tiempos.wait;
	}
}).quant_(4);
);
//Chord Synths
(
Tdef(\acordes,{
	var acmel=Pseq(~mainmelody-12,inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
	var cambia=Prand(['m','m7','mmaj7','5dim7'],inf).asStream;
	loop{
		~chord.set(\chord,cambia.next);
		~chord.set(\note,acmel.next);
		~chord.set(\iphase,0.1);
		~chord.set(\width,0.5);
		~chord.set(\cutf,6220);
		~chord.set(\rq,0.25);
		~chord.set(\pan,0);
		~chord.set(\amp,0.15);
		~chord.set(\out,~rand_stream.value('rand1',[58,60,62,64]));
		~tiempos.wait;
	}
}).quant_(4);
);
(
Tdef(\acordes2,{
	var ac2mel=Prand(~mainmelody.scramble,inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	var cambia2=Prand(['m','M','M9','mmaj7','m9m'],inf).asStream;
	loop{
		~chord2.set(\chord,cambia2.next);
		~chord2.set(\note,ac2mel.next);
		~chord2.set(\cutf,12220);
		~chord2.set(\rq,0.5);
		~chord2.set(\pan,[0,-0.97]);
		~chord2.set(\amp,0.03);
		~chord2.set(\out,~rand_stream.value('rand2',[58,60,62,64]));
		~tiempos.wait;
	}
}).quant_(4);
);
//LineIn
(
SynthDef(\ent,{|out=50,gate,att,rel|
	Out.ar(out,Pan2.ar(SoundIn.ar(0)*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
)

);
////////////////////////////////////////
//You can configure the Automation file:
// (~url +/+ "CB/CaosBox-auto.scd").openOS;
//////////////////////////////////////