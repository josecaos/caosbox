////////////////////////////////////////////
//Master and auxFx
//Master 'In' is routed to chan 50
///////////////////////////////////////////
(
SynthDef(\master,{|limit=0.9,compThres=1,below=0.5,relaxTime=1,out=0,vol=1|
	var in,env;
	in=HPF.ar(In.ar([50,51]),50,0.5);
	in=CompanderD.ar(in,compThres,below,relaxTime:relaxTime);//compresor
	in=Limiter.ar(in,limit);//limitador
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01));
	Out.ar(out,Pan2.ar(in*env,[1,-1])*vol)
}).add;
//aux1 canal 52
SynthDef(\aux1,{|vol=1,mix=0,room=0.1,damp=0.1|
	var aux1,env;
	aux1=In.ar([52,53]);
	aux1=FreeVerb.ar(aux1,mix,room,damp);//reverb
	env=EnvGen.ar(Env.asr(0.05,0.95,0.01),1);
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
//granulador
SynthDef(\granulador,{|trigger,size,out=50| Out.ar(out,GrainIn.ar(2,Impulse.kr(trigger),size,In.ar(64),[0,0.96],-1,1512,mul:2))}).add;
);
