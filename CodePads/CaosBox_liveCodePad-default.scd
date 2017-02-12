///////////////////////////////////////////
//CaosBox default liveCodePad
//written by @joseCao5 in Puerto Morelos Q. Roo Mx.
/////////////////README//////////////////////////
//This file is mostly to liveCode CaosPercLib.
//It contains the pseudoClass library, within functions or Tdefs..
//First: change the Class argument values, and evaluate .
//Then: sequence and fx in the CaosBox GUI.
//Master channel is #50
////////////////////////////////////////////
//Percussion Functions:
(
//kick
~b={var out=64;Out.ar(out,CaosKick.ar(0.01,0.25,1,0.5,60,64,50,1,0.59,0.15,2))};
//snare
~t={var out=52;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.15,highcutfreq:420,rq:0.65,amp1:0.05,amp2:0.1))};//
//hat
~h={var out=60;Out.ar(out,CaosHats.ar(att:0.01,rel:0.35,highcutfreq:9330,rq:0.5,amp1:0.15,amp2:0.15))};//
//kick2
~b2={var out=64;Out.ar(out,CaosKick2.ar(att:0.01,rel:0.32,modFreq:2,modbw:0.35,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1))};//
//snare2
~t2={var out=54;Out.ar(out,CaosSnare2.ar(att:0.05,rel:0.2,iphase:0.05,bw:0.5,highcutfreq:470,rq:0.5,amp1:0.2,amp2:0.1))};//
//hat2?
~h2={var out=64;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.25,highcutfreq:2950,rq:0.45,amp1:0.5,amp2:0.3))};//
);
//
// Help.gui;
s.queryAllNodes;
////////////////////Bass, Pad, Chord functions:
//you can create more variables as melodies for instrument Tdefs
~mainmelody=[ 0, 1, 3, 5, 6, 8, 10 ];
// Scale.minor.degrees;
// Scale.locrian.degrees;
//
//////////////////////
//Evaluate each one of these Tdef to change Synth parameters
( //all Tdefs
(//bajo 1
Tdef(\bass,{
//CaosBass args: |att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,amp1,amp2|
	var bassmel=Prand(~mainmelody+24,inf).asStream;
	loop{
	~bass.set(\note,bassmel.next,
			   \filtminf,56,
			   \filtmaxf,700,
			   \filtime,0.25,
			   \rq,0.15,
			   \iphase,0.5,
			   \amp1,0.5,
			   \amp2,0.75);
	~bass.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//bajo 2
(
Tdef(\bass2,{
//CaosBass2 args: |att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,amp1,amp2|
	var bass2mel=Prand(~mainmelody.scramble.mirror2,inf).asStream;
	loop{
	~bass2.set(\note,bass2mel.next,
			   \trig,4,
			   \filtminf,56,
			   \filtmaxf,700,
			   \filtime,0.25,\rq,0.25,
			   \bandw,0.25,
			   \iphase,0.25,
			   \amp1,0.035,
			   \amp2,0.01);
	~bass2.set(\out,64);//route
	~tiempos*4.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad,{
//CaosPad args: |waveform,att,rel,note,trem,vrel,iphase,cutf,rq,amp|
	var padmel=Pseq(~mainmelody.scramble,inf).asStream;
	~amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
		~amb.set(\note,padmel.next);
	~amb.set(\trem,0);
	~amb.set(\vrel,0.5);
	~amb.set(\iphase,0.05);
	~amb.set(\cutf,6420);
	~amb.set(\rq,0.5);
	~amb.set(\amp,0.5);
	~amb.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad2,{
//CaosPad2 args: |att,rel,note,fmax,fm,harm,rmix,rroom,rfilt,amp1,amp2|
	var pad2mel=Pseq(~mainmelody.scramble*1.4,inf).asStream;
	loop{
	~amb2.set(\note,pad2mel.next);
	~amb2.set(\fmax,[1,2,4,8,16].choose);
	~amb2.set(\fm,[1,2,4,8,16].choose);//
	~amb2.set(\harm,4);
	~amb2.set(\rmix,0.9);
	~amb2.set(\rroom,0.75);
	~amb2.set(\rfilt,0.1);
	~amb2.set(\amp1,0.15);
	~amb2.set(\amp2,0.1);
	~amb2.set(\out,62);//route
	~tiempos.wait;
	}
}).quant_(4);
);
////////////////////Chord Synths
(
Tdef(\acordes,{
//CaosChords args: |chord,att=0.1,rel=1,note=57,iphase=0.025,width=0.1,cutf=620,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var acmel=Pseq(~mainmelody.scramble,inf).asStream;
	var cambia=Prand(['m','M7','mmaj7','5dim7'],inf).asStream;//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
	loop{
	~chord.set(\chord,cambia.next);
	~chord.set(\note,acmel.next);
	~chord.set(\iphase,0.1);//
	~chord.set(\width,0.2);
	~chord.set(\cutf,1220);
	~chord.set(\rq,0.5);
	~chord.set(\pan,0);// -1 to 1 where 0 is middle
	~chord.set(\amp,0.25);
	~chord.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);
(
Tdef(\acordes2,{
//CaosGuitChords args: |chord,att=0.1,rel=1,note=57,cutf=420,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var ac2mel=Pseq(~mainmelody.scramble,inf).asStream;
	var cambia2=Prand(['m','M9','mmaj7','m9m'],inf).asStream;//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	loop{
	~chord2.set(\chord,cambia2.next);
	~chord2.set(\note,ac2mel.next);
	~chord2.set(\cutf,10220);//
	~chord2.set(\rq,0.35);
	~chord2.set(\pan,0);// -1 to 1 where 0 is middle
	~chord2.set(\amp,0.35);
	~chord2.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//LineIn
(
SynthDef(\ent,{|out=64,gate,att,rel|
	Out.ar(out,Pan2.ar(SoundIn.ar([0,1])*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
)

);
////////////////////////////////////////
//To make changes to automation settings,
//please open Automation file:
/*
(~url +/+ "CB/CaosBox-auto.scd").openOS;
*/
//////////////////////////////////////
