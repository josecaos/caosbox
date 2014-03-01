//written by @joseCao5
//11Dic13/19ene14 @ Puerto Morelos Q. Roo Mx.
///////////////////////////////////////////
//CaosBox liveCodePad v 0.08
//this file is mostly to liveCode CaosBox.
//It contains the percussion classes library,
//so as the synthetizers for bass, amb, 
//chords and Line in (still in progress). 
//Change its arguments,sequence and route in the GUI
////////////////////////////////////////////
//s.scope;
//s.meter;
//s.makeWindow;
//
(//CaosPercLib 0.1
//kick
~b={var out=50;Out.ar(out,CaosKick.ar(modFreq:1,modbw:0.5,freq1:60,freq2:72,lowcutfreq:80,att:0.05,rel:0.25,gate:1,amp1:0.1,amp2:0.35))};
//snare
~t={var out=64;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.1,highcutfreq:820,rq:0.75,amp1:0.35,amp2:0.15))};//
//hat
~h={var out=64;Out.ar(out,CaosHats.ar(att:0.01,rel:0.15,highcutfreq:3930,rq:0.25,amp1:0.85,amp2:0.45))};//
//kick2
~b2={var out=60;Out.ar(out,CaosKick2.ar(modFreq:0.25,modbw:0.05,bw:0.15,freq1:60,freq2:320,lowcutfreq:120,att:0.01,rel:0.35,amp:0.1))};//
//snare2
~t2={var out=60;Out.ar(out,CaosSnare2.ar(att:0.01,rel:0.5,iphase:0.5,bw:0.05,highcutfreq:1920,rq:0.75,amp1:0.05,amp2:0.03))};//
//hat2
~h2={var out=60;Out.ar(out,CaosHats2.ar(att:0.15,rel:0.15,highcutfreq:1950,rq:0.5,amp1:0.1,amp2:0.1))};//
);
//
//
////////////////////work in progress
//estoy cambiando los sintetizadores Ndef por SynthDef por que el clock del servidor no sincroniza
//con las secuencias de los Demand UGens e Impulse
//aun estoy pensando la mejor y mas flexible manera de controlar el pitch y la amplitud de los sintetizadores
//estoy metiendo nuebas clases a la libreria para los bajos y sintes
///////////////////bass 1
//melodia del bajo
~bassmel=Pseq([36,39,43,48+7,50,55+12,60].pyramid.mirror2,inf).asStream;//
(//bass func
~bass=play{|out=0,att=0.25,rel=5,nota=36,filtminf=60,filtmaxf=4920,filtime=2,rq=0.25,iphase=0.25,trig=0,amp1=0.7,amp2=0.2|

		Out.ar(out,CaosBass.ar(att,rel,nota,filtminf,filtmaxf,filtime,rq,iphase,trig,amp1,amp2));
};
);
//pruebas
//~bajo.put(Array.series(31,1,1),~bass)
//~bajo
//~bajo[1].set(\trig,1,~bassmel.next);//enciende la secuencia del bajo
//
/*
~bassmel=Pseq([36,39,43,48+7,50,55+12,60].pyramid.mirror2,inf).asStream;//
(
SynthDef(\caosbass,{
	|att=0.25,rel=5,nota=36,filtminf=60,filtmaxf=4920,filtime=2,rq=0.25,iphase=0.25,gate=0,amp1=0.7,amp2=0.2| //CaosBass aguments
	var a,out;
		out=0;
		a=CaosBass.ar(att,rel,nota,filtminf,filtmaxf,filtime,rq,iphase,gate,amp1,amp2);
	Out.ar(out,Pan2.ar(a,[1,-1]))
						};
).add;
);
*/
/////////////////
////////////////
////asi estaban antes con Ndef y funciona pero el Demand UGEN no sincroniza con el TempoClock
/*
(//bajo2
~arpegiobass2=0.0125;
~bassmel2=[48,55+12,58,60,67+7,74+7].scramble.pyramid;//
(`
~bass2=Ndef(\bajo2).quant_(4)[0]={|t_trig=0,out=#[0,1],att=0.025,rel=0.5|
						var nota=Demand.kr(Impulse.kr(~arpegiobass2),0,Dseq(~bassmel2,inf));
						Out.ar(out,
							Pan2.ar(
								RLPF.ar((LFTri.ar(nota.midicps,-1,1/4).lag(0.0012)+
											LFPulse.ar([nota.midicps,nota.midicps+0.33],0.05,0.25,1/4))*
												EnvGen.ar(Env.perc(att,rel),t_trig),
								Phasor.kr(Impulse.kr(~arpegiobass),1,45,6440),0.5)
							))};
)
);
~bass2.free
(//ambiente
~arpegioamb=4;
~ambmel=[36,39,43,46,48,50,55,58,60];//
(
~amb=Ndef(\amb).quant_(4)[0]={|t_trig=0,out=#[0,1],att=0.25,rel=3|
						var nota=Demand.kr(Impulse.kr(~arpegioamb),0,Dxrand(~ambmel,inf));
						Out.ar(out,Pan2.ar((SinOsc.ar(nota.midicps+24,0,0.25).wrap(0.25)+LFCub.ar(nota.midicps+12,0.5))*EnvGen.ar(Env.perc(att,rel),t_trig)))};
)
);
(//ambiente2
~arpegioamb2=0.5;
~ambmel2=[36,39,43,46,48,50,55,58,60].mirror2+48;
(
~amb2=Ndef(\amb2).quant_(4)[0]={|t_trig=0,out=#[0,1],att=0.25,rel=5|
						var nota=Demand.kr(Impulse.kr(~arpegioamb2),0,Dxrand(~ambmel2,inf));
						Out.ar(out,Pan2.ar(SinOsc.ar(nota.midicps,0,0.25).wrap(0.75)*EnvGen.ar(Env.perc(att,rel),t_trig)))};
)
);
(//syntheAtizador
~arpegiosynth=4;
~synthmel=[36,39+7,43,46+12,48,5+7,55+3,58,60+12].scramble;
(
~synth=Ndef(\sinte).quant_(4)[0]={|t_trig=0,out=0,att=0.01,rel=0.5|
						var nota=Demand.kr(Impulse.kr(~arpegiosynth),0,Dseq(~synthmel/1.5,inf));
						Out.ar(out,Pan2.ar(LFCub.ar(nota.midicps,0.025).wrap(0.55)*EnvGen.ar(Env.perc(att,rel),t_trig)))};
)
);
(//syntheAtizador acordes
~arpegiosynth2=1.5;
~synthmel2=[36,39+12,43+12,48,50+12,55,60-7].pyramid;
(
~synth2=Ndef(\sinte2).quant_(4)[0]={|t_trig=0,out=60,att=0.1,rel=0.5|
						var nota=Demand.kr(Impulse.kr(~arpegiosynth2),0,Drand(~synthmel2,inf));
						Out.ar(out,Pan2.ar(LFTri.ar(nota.midicps,0,0.3).wrap(0.5)*EnvGen.ar(Env.perc(att,rel),t_trig)))};
)
);
*/
(//line In
(
~entrada=Ndef(\ent).quant_(1)[0]={|t_trig=0,out=#[0,1],att=0.1,rel=0.25|
						Out.ar(out,Pan2.ar(SoundIn.ar([0,1])*EnvGen.ar(Env.perc(att,rel),t_trig)))};
);
);

//valores automatizacion // hasta ahorita se tiene que evaluar de nuevo el Tdef que contiene estas variables para que cambie
/*
~autoreverbmix=[0.1,0.5];
~autodelaytime=[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.05);
*/

/* CaosPercLib default values
(
CaosKick.ar(modFreq:1,modbw:0.1,freq1:60,freq2:66,lowcutfreq:50,att:0.01,rel:0.5,gate:1,amp1:0.5,amp2:0.5)
CaosSnare.ar(att:0.01,rel:0.35,highcutfreq:520,rq:0.75,gate:1,amp1:1,amp2:1)
CaosHats.ar(att:0.01,rel:0.15,highcutfreq:10000,rq:0.5,gate:1,amp1:1,amp2:1)
CaosKick2.ar(modFreq:1,modbw:0.1,bw:0.1,freq1:60,freq2:62,lowcutfreq:50,att:0.01,rel:0.5,gate:1,amp:0.5)
CaosSnare2.ar(att:0.01,rel:0.35,iphase:0.01,bw:0.5,highcutfreq:1520,rq:0.75,gate:1,amp1:0.25,amp2:0.2)
CaosHats2.ar(att:0.05,rel:0.2,highcutfreq:8000,rq:0.25,gate:1,amp1:1,amp2:1)
);
*/
