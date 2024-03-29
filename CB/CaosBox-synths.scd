////////////////////////////////////////////
//synthesizers
//These SynthDefs contain the CaosPercLib
//Classes for the instrumental section
///////////////////////////////////////////
(
//bass
// TODO: aplicar a todos los SynthDef
if(~cbox_custom != true,{

	SynthDef(\bajouno,{|out=50,att=0.05,rel=1,note=38,filtminf=45,filtmaxf=8950,filtime=0.125,rq=0.5,iphase=0.1,gate=0,amp1=0.5,amp2=0.25,pan=0,doneAction=1|
		Out.ar(out,CaosBass.ar(att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,gate,amp1,amp2,pan,doneAction))}).add;
},{
	// "Bajo custom".postcln;
	SynthDef(\bajouno,{|ugenFunc,att,rel,note=38,pan=#[0.95,0.96],out=50|
		Out.ar(out,CaosBass.customSignal(ugenFunc,att,rel,pan))}).add;
});

SynthDef(\bajodos,{|out=50,att=0.2,rel=8,note=36,trig=4,filtminf=105,filtmaxf=12066,filtime=0.15,rq=0.125,bandw=0.5,iphase=0.25,gate=0,
	amp1=0.5,amp2=0.5,doneAction=1|
	Out.ar(out,CaosBass2.ar(att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,gate,amp1,amp2,doneAction))}).add;

//ambiences
SynthDef(\ambuno,{|waveform='sin',att=0.5,rel=1,note=57,semi=0,iphase=0,cutf=8920,rq=0.7,gate=0,amp=0.5,pan=0,out=50|
	var onda = 'sin';
	Out.ar(out,CaosPad.ar(onda,att,rel,note,semi,iphase,cutf,rq,gate,amp,pan))}).add;

SynthDef(\ambdos,{|att=0.5,rel=1,note=60,maxNote=60,fm=0.1,harm=1,gate=0,amp1=0.5,amp2=0.5,pan=0,out=50|
	Out.ar(out,CaosPad2.ar(att,rel,note,maxNote,fm,harm,gate,amp1,amp2,pan))}).add;

//Chords
SynthDef(\acordesuno,{|chord,att=0.1,rel=1,note=57,iphase=0.025,width=0.1,cutf=620,rq=0.5,gate=0,amp=0.25,pan=0,out=50|
	var tipo= 'M';
	Out.ar(out,CaosChords.ar(tipo,att,rel,note,iphase,width,cutf,rq,gate,amp,pan))}).add;

SynthDef(\acordesdos,{|chord,att=0.1,rel=1,note=57,cutf=420,rq=0.5,gate=0,amp=0.5,pan=0,out=50|
	var type= 'M';
	Out.ar(out,CaosGuitChords.ar(type,att,rel,note,cutf,rq,gate,amp,pan))}).add;

//LineIn
SynthDef(\entrada,{|inchan=0,gate=0,att=0.1,rel=0.25,out=64|
	Out.ar(out,Pan2.ar(SoundIn.ar(inchan)*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
);
