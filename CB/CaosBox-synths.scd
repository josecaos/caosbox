////////////////////////////////////////////
//synthesizers
//These SynthDefs contain the CaosPercLib
//Classes for the instrumental section
///////////////////////////////////////////
(
//bass
if(~cbox_custom != true,{

	// "Bajo libreria".postcln;
	SynthDef(\bajouno,{|att=0.05,rel=1,note=38,filtminf=45,filtmaxf=8950,filtime=0.125,rq=0.5,iphase=0.1,gate=0,amp1=0.5,amp2=0.25,out=50|
		Out.ar(out,CaosBass.ar(att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,gate,amp1,amp2))}).add;
},{
	// "Bajo custom".postcln;
	SynthDef(\bajouno,{|ugenFunc,att,rel,note=38,pan=#[0.95,0.96],out=50|
		Out.ar(out,CaosBass.customSignal(ugenFunc,att,rel,pan))}).add;
});

SynthDef(\bajodos,{|att=0.2,rel=8,note=36,trig=4,filtminf=105,filtmaxf=12066,filtime=0.15,rq=0.125,bandw=0.5,iphase=0.25,gate=0,
	amp1=0.5,amp2=0.5,out=50|
	Out.ar(out,CaosBass2.ar(att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,gate,amp1,amp2))}).add;
//ambiences
SynthDef(\ambuno,{|waveform='sin',att=0.5,rel=1,note=57,semi=0,iphase=0,cutf=8920,rq=0.7,gate=0,amp=0.5,pan=0,out=50|
	var onda='sin';
	Out.ar(out,CaosPad.ar(onda,att,rel,note,semi,iphase,cutf,rq,gate,amp,pan))}).add;

SynthDef(\ambdos,{|att=0.5,rel=1,note=220,fmax=1,fm=0.001,harm=1,rmix=0.5,rroom=0.5,rfilt=0.1,gate=0,amp1=0.5,amp2=0.5,out=50|
	Out.ar(out,CaosPad2.ar(att,rel,note,fmax,fm,harm,rmix,rroom,rfilt,gate,amp1,amp2))}).add;
//Chords
SynthDef(\acordesuno,{|chord,att=0.1,rel=1,note=57,iphase=0.025,width=0.1,cutf=620,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var tipo= 'M';
	Out.ar(out,CaosChords.ar(tipo,att,rel,note,iphase,width,cutf,rq,pan,gate,amp))}).add;

SynthDef(\acordesdos,{|chord,att=0.1,rel=1,note=57,cutf=420,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var type= 'M';
	Out.ar(out,CaosGuitChords.ar(type,att,rel,note,cutf,rq,pan,gate,amp))}).add;
//LineIn
SynthDef(\ent,{|out=50,inchan=#[0,1],gate=0,att=0.1,rel=0.25|
	Out.ar(out,Pan2.ar(SoundIn.ar(inchan)*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
);
//
(
~cbox_bass=nil;
~cbox_bass2=nil;
~cbox_amb=nil;
~cbox_amb2=nil;
~cbox_chord=nil;
~cbox_chord2=nil;
~cbox_entrada=nil;
);
