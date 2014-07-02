///////////////////////////////////////////
//CaosBox liveCodePad v 0.08
//written by @joseCao5
//Dic2013/ene2014 @ Puerto Morelos Q. Roo Mx.
/////////////////README//////////////////////////
//This file is mostly to liveCode CaosPercLib.
//It contains the pseudoClass library, within functions or Tdefs..
//First: change the Class argument values, and evaluate .
//Then: sequence and fx in the CaosBox GUI.
//note: If functions are not evaluated before
//sequencing, this might fail.
//Master channel is #50
////////////////////////////////////////////
//Percussion Functions:
(
//kick
~b={var out=50;Out.ar(out,CaosKick.ar(modFreq:4,modbw:0.5,freq1:60,freq2:84,lowcutfreq:2100,att:0.01,rel:0.125,gate:1,amp1:0.75,amp2:0.5))};
//snare
~t={var out=60;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:220,rq:0.35,amp1:0.15,amp2:0.05))};//
//hat
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.15,highcutfreq:530,rq:0.5,amp1:0.15,amp2:0.05))};//
//kick2
~b2={var out=64;Out.ar(out,CaosKick2.ar(modFreq:2,modbw:0.15,bw:0.5,freq1:60,freq2:72,lowcutfreq:2200,att:0.05,rel:1,amp:0.3))};//
//snare2
~t2={var out=54;Out.ar(out,CaosSnare2.ar(att:0.05,rel:0.2,iphase:0.05,bw:0.5,highcutfreq:420,rq:0.5,amp1:0.08,amp2:0.01))};//
//hat2
~h2={var out=62;Out.ar(out,CaosHats2.ar(att:0.21,rel:0.32,highcutfreq:2950,rq:0.75,amp1:0.15,amp2:0.05))};//
);
////////////////////Bass and pad functions:
//you can create more variables as melodies for instrument Tdefs
~mainmelody=[36,39+3,44,48+7,51,55+12,60]-4;
//
//////////////////////
//Evaluate each one of these Tdef to change Synth parameters
( //all Tdefs
(//bajo 1
Tdef(\bass,{
//CaosBass args: |att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,amp1,amp2|
	var bassmel=Prand(~mainmelody.pyramid.mirror2-2,inf).asStream;
	loop{
	~bass.set(\note,bassmel.next,
			   \filtminf,56,
			   \filtmaxf,700,
			   \filtime,0.25,
			   \rq,0.15,
			   \iphase,0.5,
			   \amp1,1,
			   \amp2,0.5);
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
			   \amp1,1,
			   \amp2,0.5);
	~bass2.set(\out,58);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad,{
//CaosPad args: |waveform,att,rel,note,trem,vrel,iphase,cutf,rq,amp|
	var padmel=Pseq(~mainmelody.scramble/1.22,inf).asStream;
	~amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
	~amb.set(\note,padmel.next);
	~amb.set(\trem,2);
	~amb.set(\vrel,8);
	~amb.set(\iphase,0.5);
	~amb.set(\cutf,1420);
	~amb.set(\rq,0.5);
	~amb.set(\amp,0.24);
	~amb.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad2,{
//CaosPad2 args: |att,rel,note,fmax,fm,harm,rmix,rroom,rfilt,amp1,amp2|
	var padmel=Pseq(~mainmelody.scramble,inf).asStream;
	loop{
	~amb2.set(\note,padmel.next);
	~amb2.set(\fmax,[1,2,4,8,16].choose);
	~amb2.set(\fm,[1,2,4,8,16].choose);//
	~amb2.set(\harm,4);
	~amb2.set(\rmix,0.9);
	~amb2.set(\rroom,0.5);
	~amb2.set(\rfilt,0.1);
	~amb2.set(\amp1,0.15);
	~amb2.set(\amp2,0.35);
	~amb2.set(\out,50);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//LineIn
~entrada.set(\out,50);//route
);
/*
////////////////////work in progress
~synth
~synth2
*/
////////////////////////////////////////
//To make changes to automation settings,
//please open Automation file:
/*
(~url +/+ "CB/CaosBox-auto-v0.08.scd").openOS;
*/
//////////////////////////////////////
