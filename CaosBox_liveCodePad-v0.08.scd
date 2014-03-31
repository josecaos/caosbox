//written by @joseCao5
//Dic13/ene14 @ Puerto Morelos Q. Roo Mx.
////////////////////////////////////////////
//s.scope;
//s.meter;
s.makeWindow;
///////////////////////////////////////////
//CaosBox liveCodePad v 0.08
//this file is mostly to liveCode CaosPercLib.
//It contains the pseudoclasses library, and automation seqs.
//Change the arguments, then sequence and route in the GUI.
//Master channel is #50 
////////////////////////////////////////////
//Percussion
(
//kick
~b={var out=64;Out.ar(out,CaosKick.ar(modFreq:2,modbw:0.15,freq1:60,freq2:64,lowcutfreq:60,att:0.1,rel:0.25,gate:1,amp1:0.6,amp2:0.05))};
//snare
~t={var out=64;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.3,highcutfreq:620,rq:0.5,amp1:0.15,amp2:0.05))};//
//hat
~h={var out=64;Out.ar(out,CaosHats.ar(att:0.05,rel:0.25,highcutfreq:730,rq:0.75,amp1:0.5,amp2:0.25))};//
//kick2
~b2={var out=64;Out.ar(out,CaosKick2.ar(modFreq:2,modbw:0.05,bw:0.5,freq1:60,freq2:60,lowcutfreq:1200,att:0.01,rel:0.35,amp:0.1))};//
//snare2
~t2={var out=64;Out.ar(out,CaosSnare2.ar(att:0.01,rel:0.5,iphase:0.5,bw:0.05,highcutfreq:1920,rq:0.75,amp1:0.05,amp2:0.03))};//
//hat2
~h2={var out=62	;Out.ar(out,CaosHats2.ar(att:0.05,rel:0.3,highcutfreq:2950,rq:0.75,amp1:0.5,amp2:0.9))};//
);
////////////////////Melodic, pads and chords
//
~mainmelody=[36,39,43,48+7,50,55+12,60];
//
//////////////////////
//Evaluate each one of these Tdef to change Synth parameters
//bajo 1
(
Tdef(\bass,{
//CaosBass args: |att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,amp1,amp2|
	var bassmel=Prand(~mainmelody.pyramid.mirror2,inf).asStream;	
	loop{
	~bass.set(\att,0.075);
	~bass.set(\rel,0.5);
	~bass.set(\note,bassmel.next);
	~bass.set(\filtminf,56);
	~bass.set(\filtmaxf,700);	
	~bass.set(\filtime,0.25);
	~bass.set(\rq,0.15);
	~bass.set(\iphase,0.25);
	~bass.set(\amp1,1);
	~bass.set(\amp2,0.7);
	~bass.set(\out,50);//route
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
	~bass2.set(\att,0.075);
	~bass2.set(\rel,4);
	~bass2.set(\note,bass2mel.next);
	~bass2.set(\trig,(1..16).choose);	
	~bass2.set(\filtminf,56);
	~bass2.set(\filtmaxf,700);	
	~bass2.set(\filtime,0.25);
	~bass2.set(\rq,0.25);
	~bass2.set(\bandw,0.25);
	~bass2.set(\iphase,0.25);
	~bass2.set(\amp1,1);
	~bass2.set(\amp2,0.7);
	~bass2.set(\out,50);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad,{
//CaosPad args: |waveform,att,rel,note,trem,vrel,iphase,cutf,rq,amp|
	var padmel=Pseq(~mainmelody.scramble,inf).asStream;
	~amb.set(\waveform, 'pulse' );	
	loop{
	~amb.set(\att,0.5);
	~amb.set(\rel,6);	
	~amb.set(\note,padmel.next);
	~amb.set(\trem,(1..8).choose);
	~amb.set(\vrel,2);	
	~amb.set(\iphase,0.25);
	~amb.set(\cutf,1920);
	~amb.set(\rq,0.15);
	~amb.set(\amp,0.25);
	~amb.set(\out,50);//route
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
	~amb2.set(\att,0.25);
	~amb2.set(\rel,2);
	~amb2.set(\note,padmel.next*[0.25,0.5,1,1.25,1.5,1.75,2,3].choose);
	~amb2.set(\fmax,100);	
	~amb2.set(\fm,0.125);	
	~amb2.set(\harm,4);
	~amb2.set(\rmix,0.75);	
	~amb2.set(\rroom,0.5);
	~amb2.set(\rfilt,0.1);
	~amb2.set(\amp1,0.25);
	~amb2.set(\amp2,0.35);
	~amb2.set(\out,60);//route
	~tiempos.wait;
	}
}).quant_(4);
);
/*
////////////////////work in progress
////Solo falta integrar dos sintetizadores que hagan acordes.
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
////fader AUTOMATION
//valores automatizacion //se tiene que evaluar de nuevo el Tdef que contiene estas variables para que cambie
/*
~autoreverbmix=[0.1,0.5];
~autodelaytime=[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.05);
*/
//automation seqs
(
Tdef(\autor,{
		 var revmix,univar;
		 	revmix=Prand(~autoreverbmix,inf).asStream;//
		 {
		 univar=revmix.resume;
		 ~mastrev.set(\mix,univar);//reverb mix
		{~numr.value=univar;~auxrfader.value=univar}.defer(0.1);//reverb mix GUI update
		 ~tiempos/~divrev.wait;
		 }.loop;
}).quant_(4)
);
(
Tdef(\autod,{
		 var deltm,univar;
		 deltm=Prand(~autodelaytime,inf).asStream;//delay time
	 	{
	 	univar=deltm.resume;
		 ~mastdel.set(\deltime,univar);//delay time
		{~numt.value=univar;~auxtfader.value=univar}.defer(0.1);//delay time GUI update
		 ~tiempos/~divdel.wait;
		 }.loop;
}).quant_(4)
);
(
Tdef(\autop,{
		 var pitrat,pitdisp,univar,univar1;
		 pitrat=Prand(~autopitchrate,inf).asStream;//pitch rate
		 pitdisp=Prand(~autopitchdispersion,inf).asStream;//pitch dispersion
		{
		univar=pitrat.resume;
		univar1=pitdisp.resume;
 	     ~mastpit.set(\rate,univar);//pitch rate
     	 //~mastpit.set(\pitchDispersion,univar1);//pitch rate
		{~nump.value=univar;~auxpfader.value=univar.next/4;
		// ~numpd.value=univar1.next;~auxpdfader.value=univar1;
		}.defer(0.1);//pitch rate GUI update
		 ~tiempos/~divpitch.wait;
		 }.loop;
}).quant_(4)
);
(
Tdef(\autog,{
	var univar, univar1;
	var trig=Pseq(~autograintrig.scramble,inf).asStream;
	var siz=Pseq(~autograinsize.scramble,inf).asStream;
	{
	univar=trig.resume;
	univar1=siz.resume;
		//~grains.set(\trigger,trig.next.postcln);
		//~grains.set(\size,siz.next);
		{~grains.set(\trigger,~gfaders.x_(univar));~grains.set(\size,~gfaders.y_(univar1))}.defer(0.1);
		~tiempos/~divgrain.wait;
	}.loop;
})
);
( 
Tdef(\randtime,{
    {
        var timer=Prand(~randtimes,inf).asStream;
        TempoClock.tempo=timer.next/60;
        ~tiempos.wait;
	}.loop;
});
);
