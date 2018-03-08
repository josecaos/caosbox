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
//Test
// CaosBox.enviroment;
//
//
//
~b={var out=50;Out.ar(out,CaosKick.ar(0.01,0.25,1,0.25,60,64,50,1,1,0.2,2))};
~b={var out=60;Out.ar(out,CaosKick.ar(0.01,0.25,2,0.15,60,64,50,1,1,0.75,2))};

//snare
~t={var out=64;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:360,rq:0.25,amp1:0.55,amp2:0.25))};//

~t2={var out=60;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.15,highcutfreq:160,rq:0.5,amp1:0.01,amp2:0.2))};//
//hat
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.01,rel:0.5,highcutfreq:8330,rq:0.25,amp1:0.35,amp2:0.01))};//
~h={var out=60;Out.ar(out,CaosHats.ar(att:0.01,rel:0.1,highcutfreq:6330,rq:0.05,amp1:0.9,amp2:0.9))};//
//kick
~b2={var out=58;Out.ar(out,CaosKick2.ar(att:0.01,rel:0.16,modFreq:2,modbw:0.5,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1))};//
//snare
~t2={var out=58;Out.ar(out,CaosSnare2.ar(att:0.01,rel:0.16,iphase:0.5,bw:0.35,highcutfreq:270,rq:0.35,amp1:0.1,amp2:0.05))};//
//hat
~h2={var out=50;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.25,highcutfreq:6950,rq:0.45,amp1:0.5,amp2:0.3))};//
~h2={var out=58;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.75,highcutfreq:6950,rq:0.45,amp1:0.5,amp2:0.3))};//
// s.queryAllNodes;

// Melodies as intervals array
// Scale.hungarianMinor.degrees;
// Scale.directory;
//core functions
// ~mainmelody = [0, 3, 7, 10, 13, 17, 21]+60;
// ~mainmelody = [ 0, 2, 3, 6, 7, 8, 11 ]+60;
~mainmelody = Scale.phrygian.degrees+60;
~mainmelody = LCNE.dupOctave(~mainmelody,2);
// ~random_steps.value(\hihats,2);
/*
~set_steps.value(\bass,[1,12,24]);
~clear_steps.value(\snare);
~steps.keys;
*/
/* Bass, Pad, Chord functions: */
/////////////////////////////////
(//all Tdefs
(//bass 1
Tdef(\bass,{
	var bassmel=Prand(~mainmelody-12,inf).asStream;
	// var out=Pseq(~pat_arr.value(52,(0..31)),inf).asStream;
	loop{
		~bass.set(\note,bassmel.next,
			\filtminf,45,
			\filtmaxf,10420,
			\filtime,0.5,
			\rq,0.25,
			\iphase,0.015,
			\amp1,0.1,
			\amp2,0.04,
			\out,[52,58]);
			// \out,~rand_stream.value('rand2',[52,56,60,58,54,64]));
		~tiempos.wait;
	}
}).quant_(1);
);
//bass 2
(
Tdef(\bass2,{
	var bass2mel=Pxrand(~mainmelody+7,inf).asStream;
	// var out=Prand(~pat_arr.value(50,62,[0,4,8,12,16,20,30]),inf).asStream;
	loop{
		~bass2.set(\note,bass2mel.next,
			\trig,1,
			\filtminf,80,
			\filtmaxf,10900,
			\filtime,0.0125,
			\rq,0.5,
			\bandw,0.05,
			\iphase,0.05,
			\amp1,0.05,
			\amp2,0.06,
			\out,[64,58]);
			// \out,~rand_stream.value('rand2',[52,56,60,58,54,64]));
		~tiempos.wait;
	}
}).quant_(1);
);
//ambient pad
(
Tdef(\pad,{
	var padmel=Pxrand(~mainmelody-[4,3],inf).asStream;
	~amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
		~amb.set(\note,padmel.next);
		~amb.set(\trem,32);
		~amb.set(\vrel,4);
		~amb.set(\iphase,0.15);
		~amb.set(\cutf,9420);
		~amb.set(\rq,0.15);
		~amb.set(\amp,0.035);
		~amb.set(\out,58);
		~tiempos.wait;
	}
}).quant_(1);
);
//ambiente pad 2
(
Tdef(\pad2,{
	var pad2mel=Pseq(~mainmelody,inf).asStream;
	loop{
		~amb2.set(\note,pad2mel.next);
		~amb2.set(\fmax,[16,32,64,128,8].choose);
		~amb2.set(\fm,[2,4,8].choose);
		~amb2.set(\harm,20);
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
	var ac2mel=Prand(~mainmelody,inf).asStream;
	//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	var cambia2=Prand(['m','M','M9','mmaj7','m9m'],inf).asStream;
	loop{
		~chord2.set(\chord,cambia2.next);
		~chord2.set(\note,ac2mel.next);
		~chord2.set(\cutf,12220);
		~chord2.set(\rq,0.25);
		~chord2.set(\pan,[0,-0.97]);
		~chord2.set(\amp,0.025);
		~chord2.set(\out,~rand_stream.value('rand2',[58,60,62,64]));
		~tiempos.wait;
	}
}).quant_(1);
);
//LineIn
(
SynthDef(\ent,{|out=64,gate,att,rel|
	Out.ar(out,Pan2.ar(SoundIn.ar(0)*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
)

);
////////////////////////////////////////
//You can configure the Automation file:
// (~url +/+ "CB/CaosBox-auto.scd").openOS;
//////////////////////////////////////