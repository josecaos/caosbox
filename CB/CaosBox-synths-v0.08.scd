//written by @joseCao5
//CaosBox Instrment synthesizers
////////////////////////////////////////////
//this are the Instruments of the melodic part of CaosBox
///////////////////////////////////////////
(
//bass
SynthDef(\bajouno,{|att=0.05,rel=1,note=38,filtminf=45,filtmaxf=750,filtime=0.25,rq=0.5,iphase=0.1,gate=0,amp1=0.5,amp2=0.25,out=50| 
						Out.ar(out,CaosBass.ar(att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,gate,amp1,amp2))}).add;//bajo
SynthDef(\bajodos,{|att=0.2,rel=8,note=36,trig=4,filtminf=45,filtmaxf=1266,filtime=0.5,rq=0.25,bandw=0.25,iphase=0.05,gate=0,
							amp1=0.5,amp2=0.5,out=50|
						Out.ar(out,CaosBass2.ar(att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,gate,amp1,amp2))}).add;//bajo dos
//ambiences
SynthDef(\ambuno,{|waveform,att=0.5,rel=1,note=57,trem=0,vrel=1,iphase=0,cutf=920,rq=0.7,gate=0,amp=0.5,out=50| 
								var onda='sin';
						Out.ar(out,CaosPad.ar(onda,att,rel,note,trem,vrel,iphase,cutf,rq,gate,amp))}).add;//ambiente
SynthDef(\ambdos,{|att=0.5,rel=1,note=220,fmax=1,fm=0.001,harm=1,rmix=0.5,rroom=0.5,rfilt=0.1,gate=0,amp1=0.5,amp2=0.5,out=50| 
						Out.ar(out,CaosPad2.ar(att,rel,note,fmax,fm,harm,rmix,rroom,rfilt,gate,amp1,amp2))}).add;//ambiente
//////////////
// faltan sintes armonicos
///////
//LineIn
SynthDef(\ent,{|gate=0,att=0.1,rel=0.25,	out=50|
				Out.ar(out,Pan2.ar(SoundIn.ar([0,1])*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
);
(//estas variables se declaran cuando un checkbox es activado, mientras nil
~bass=nil;
~bass2=nil;
~amb=nil;
~amb2=nil;
~entrada=nil;
);
