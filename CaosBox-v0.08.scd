//written by @joseCao5 (mixfuckedup.net) on SuperCollider 3.6.3 | Linux
//11Dic13/18ene14 @ Puerto Morelos Q. Roo Mx.
//////////////////////////////////////////////////////////////////////
//CaosBox v 0.08
//////////////////////////////////////////////////////////////////////
(// * evalua todo en esta linea
s.waitForBoot{//
(//variables
~url="/home/josecaos/.ssh/caosbox008/";//ajusta esta URL local por la de tu sistema
~bombo=Array.fill(32,nil);
~tarola=Array.fill(32,nil);
~contras=Array.fill(32,nil);
~bombo2=Array.fill(32,nil);
~tarola2=Array.fill(32,nil);
~contras2=Array.fill(32,nil);
~bajo=Array.fill(32,nil);
~bajo2=Array.fill(32,nil);
~ambiente=Array.fill(32,nil);
~ambiente2=Array.fill(32,nil);
~sinte=Array.fill(32,nil);
~sinte2=Array.fill(32,nil);
~in=Array.fill(32,nil);
~clock=TempoClock.tempo=94/60;
~indice=0; 
~tiempos=0.25;
~autoreverbmix=[0,0.4,0.75];
~autodelaytime=[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.005);
//divisores automatizacion
~divrev=1;//no usar '0'
~divdel=1;//no usar '0'
~divpitch=1;//no usar '0'
~divgrain=1;//no usar '0'
~randtimes=[47,62,94,141,188];//igualar estos valores a la variable del reloj
);
//Master
(//entrada desde canal 50
SynthDef(\master,{|limit=0.9,compThres=1,clampTime=0.5,relaxTime=1,cutfreq=20000,bw=1,out=0,vol=1|
			var in,filt,env;
				in=HPF.ar(In.ar([50,51]),45,0.5);
				in=CompanderD.ar(in,compThres,clampTime,relaxTime:relaxTime);//compresor
				filt=RLPF.ar(in,cutfreq,bw);//low pass filter
				in=Limiter.ar(in,limit);//limitador
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01));
			Out.ar(out,Pan2.ar(in*env,[1,-1])*vol)	
}).add;
//aux1 canal 52
SynthDef(\aux1,{|vol=1,mix=0,room=0.1,damp=0.1|
			var aux1,env;
				aux1=In.ar([52,53]);
				aux1=FreeVerb.ar(aux1,mix,room,damp);//reverb
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
			Out.ar(50,Pan2.ar(aux1*env,[1,-1])*vol)	
}).add;
//aux2 canal 54
SynthDef(\aux2,{|vol=1,deltime=0,delfeed=0|
			var deltype,delind,aux2,env;
				deltype=[CombC,CombL];
				delind=0;
				aux2=In.ar([54,55]);
				aux2=deltype[delind].ar(aux2,1,deltime,delfeed);//delay
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
			Out.ar(50,Pan2.ar(aux2*env,[1,-1])*vol)	
}).add;
//aux3 canal 56
SynthDef(\aux3,{|vol=1,pitch=1,pitchDispersion=0,timeDispersion=0|
			var aux3,env;
				aux3=In.ar([56,57]);
				aux3=PitchShift.ar(aux3,0.2,pitch,pitchDispersion,timeDispersion);//pitch
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
			Out.ar(50,Pan2.ar(aux3*env,[1,-1])*vol)	
}).add;
//aux4 canal 58
SynthDef(\lowfilt,{|cutfreq=20000,rq=1,out=50,vol=1|
			var filtro,env;
				filtro=In.ar([58,59]);
				filtro=RLPF.ar(filtro,cutfreq,rq);//Low Pass Filter
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
			Out.ar(out,Pan2.ar(filtro*env,[1,-1])*vol)	
}).add;
//aux5 canal 60
SynthDef(\highfilt,{|cutfreq=60,rq=1,out=50,vol=1|
			var filtro,env;
				filtro=In.ar([60,61]);
				filtro=RHPF.ar(filtro,cutfreq,rq);//High Pass Filter
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
			Out.ar(out,Pan2.ar(filtro*env,[1,-1])*vol)	
}).add;
//aux6 canal 62
SynthDef(\bandfilt,{|cutfreq=1000,rq=1,out=50,vol=1|
			var filtro,env;
				filtro=In.ar([62,63]);
				filtro=BPF.ar(filtro,cutfreq,rq);//Band Pass Filter
				env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
			Out.ar(out,Pan2.ar(filtro*env,[1,-1])*vol)	
}).add;
);
//granulador
SynthDef(\granulador,{|trigger,size,out=50| Out.ar(out,Pan2.ar(GrainIn.ar(2,Impulse.kr(trigger),size,In.ar(64),2,-1,512,mul:2),[1,-0.98]))}).add;
//Instrumentos
//bass
(
SynthDef(\bajouno,{|out=50,att=0.01,rel=1.5,note=38,filtminf=45,filtmaxf=750,filtime=0.25,rq=0.5,iphase=0.1,gate=0,amp1=0.5,amp2=0.25| 
						Out.ar(out,CaosBass.ar(att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,gate,amp1,amp2))}).add;
SynthDef(\bajodos,{|out=50,att=0.2,rel=8,note=36,trig=4,filtminf=45,filtmaxf=1266,filtime=0.5,rq=0.25,bandw=0.25,iphase=0.05,gate=0,
							amp1=0.5,amp2=0.5| 
						Out.ar(out,CaosBass2.ar(att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,gate,amp1,amp2))}).add;
);
(//estas variables se declaran cuando un checkbox es activado, mientras nil
~bass=nil;
~bass2=nil;
);
//master var
~mast=Synth(\master);
//Secuencias
(
Tdef(\secuencias,{
// fx
~mastrev=Synth(\aux1);
~mastdel=Synth(\aux2);
~mastpit=Synth(\aux3);
//Filtros
~mastlowf=Synth(\lowfilt);
~masthighf=Synth(\highfilt);
~mastbandf=Synth(\bandfilt);
//granuladores
~grains=Synth(\granulador);
		{
		~bombo[~indice].play;
		~tarola[~indice].play;
		~contras[~indice].play;
		~bombo2[~indice].play;
		~tarola2[~indice].play;
		~contras2[~indice].play;
        if(~bajo[~indice] == nil,{nil},{~bajo[~indice].set(\gate,1);~bajo.put(~indice,~bass=Synth(\bajouno))});
		if(~bajo2[~indice] == nil,{nil},{~bajo2[~indice].set(\gate,1);~bajo2.put(~indice,~bass2=Synth(\bajodos))});
		~ambiente[~indice].set(\t_trig,1);
		~ambiente2[~indice].set(\t_trig,1);
		~sinte[~indice].set(\t_trig,1);
		~sinte2[~indice].set(\t_trig,1);
		~in[~indice].set(\t_trig,1);
    	~indice=~indice+1;
   	 	if(~indice==32,{~indice=0},{nil});
		~tiempos.wait;
	}.loop;
});
);
(
Tdef(\pasos,{
//pasos 
		{
		{if(~indice==0,{~step1.value=1;~step32.value=0;});
		if(~indice==1,{~step2.value=1;~step1.value=0;});
		if(~indice==2,{~step3.value=1;~step2.value=0;});
        if(~indice==3,{~step4.value=1;~step3.value=0;});
        if(~indice==4,{~step5.value=1;~step4.value=0;});
        if(~indice==5,{~step6.value=1;~step5.value=0;});
        if(~indice==6,{~step7.value=1;~step6.value=0;});
        if(~indice==7,{~step8.value=1;~step7.value=0;});
        if(~indice==8,{~step9.value=1;~step8.value=0;});
        if(~indice==9,{~step10.value=1;~step9.value=0;});
        if(~indice==10,{~step11.value=1;~step10.value=0;});
        if(~indice==11,{~step12.value=1;~step11.value=0;});
        if(~indice==12,{~step13.value=1;~step12.value=0;});
        if(~indice==13,{~step14.value=1;~step13.value=0;});
        if(~indice==14,{~step15.value=1;~step14.value=0;});
        if(~indice==15,{~step16.value=1;~step15.value=0;});
        if(~indice==16,{~step17.value=1;~step16.value=0;});
        if(~indice==17,{~step18.value=1;~step17.value=0;});
        if(~indice==18,{~step19.value=1;~step18.value=0;});
		if(~indice==19,{~step20.value=1;~step19.value=0;});
        if(~indice==20,{~step21.value=1;~step20.value=0;});
        if(~indice==21,{~step22.value=1;~step21.value=0;});
        if(~indice==22,{~step23.value=1;~step22.value=0;});
        if(~indice==23,{~step24.value=1;~step23.value=0;});
        if(~indice==24,{~step25.value=1;~step24.value=0;});
        if(~indice==25,{~step26.value=1;~step25.value=0;});
        if(~indice==26,{~step27.value=1;~step26.value=0;});
        if(~indice==27,{~step28.value=1;~step27.value=0;});
        if(~indice==28,{~step29.value=1;~step28.value=0;});
        if(~indice==29,{~step30.value=1;~step29.value=0;});
        if(~indice==30,{~step31.value=1;~step30.value=0;});
        if(~indice==31,{~step32.value=1;~step31.value=0;})}.defer(0.2);
		~tiempos.wait;
	}.loop;
});
);
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
     	 ~mastpit.set(\pitchDispersion,univar1);//pitch rate
		{~nump.value=univar;~auxpfader.value=univar.next/4;
		 ~numpd.value=univar1.next;~auxpdfader.value=univar1}.defer(0.1);//pitch rate GUI update
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
//archivos complementarios
(~url +/+ "CaosBox_liveCodePad-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI_2-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI_3-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI_4-v0.08.scd").load;
(~url +/+ "CaosBox_liveCodePad-v0.08.scd").openOS;
});
//end of file
