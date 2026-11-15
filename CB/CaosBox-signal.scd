////////////////////////////////////////////
//Master and auxFx
//
// Cada procesador recibe su bus de entrada por parametro (inbus) y manda su
// salida al master (out). Los indices por defecto son los historicos; el
// CaosEngine es quien los resuelve por nombre (\master, \reverb, \lpf, ...).
///////////////////////////////////////////
(
SynthDef(\master,{|inbus=50,limit=0.9,compThres=1,below=0.5,relaxTime=1,out=0,vol=1|
	var sig,env;
	sig=HPF.ar(In.ar(inbus,2),50,0.5);
	sig=CompanderD.ar(sig,compThres,below,relaxTime:relaxTime);//compresor
	sig=Limiter.ar(sig,limit);//limitador
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01));
	Out.ar(out,Pan2.ar(sig*env,[1,-1])*vol)
}).add;
//aux1 reverb
SynthDef(\aux1,{|inbus=52,out=50,vol=1,mix=0,room=0.1,damp=0.1|
	var aux1,env;
	aux1=In.ar(inbus,2);
	aux1=FreeVerb.ar(aux1,mix,room,damp);//reverb
	env=EnvGen.ar(Env.asr(0.05,0.95,0.01),1);
	Out.ar(out,Pan2.ar(aux1*env,[1,-1])*vol)
}).add;
//aux2 delay
// deltime: 0..8 s; delfeed: 0..4 s de decay time, no un coeficiente
// de feedback. El modo libre/metrico se resuelve en sclang y aqui solo
// llega el tiempo final en segundos.
SynthDef(\aux2,{|inbus=54,out=50,vol=1,deltime=0,delfeed=0,mix=0.5|
	var dry,wet,env,dt,decay,active;
	dry=In.ar(inbus,2);
	// suaviza los saltos de la automatizacion: evita el click del puntero
	dt=deltime.clip(0.005,8).lag(0.08);
	decay=delfeed.clip(0,4).lag(0.08);
	wet=CombC.ar(dry,8,dt,decay);
	// 0 en Free significa "sin delay": el wet se apaga y queda solo el dry.
	// El lag evita el click al entrar o salir de ese estado.
	active=(deltime > 0.0001).lag(0.02);
	// el dry siempre esta: el delay es un insert, no un send que reemplaza
	// la señal seca. Asi el ataque del step suena a tiempo y despues llega
	// el eco. `mix` controla solo la parte húmeda.
	wet=dry + (wet * mix * active);
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
	Out.ar(out,Pan2.ar(wet*env,[1,-1])*vol)
}).add;
//aux3 pitch
SynthDef(\aux3,{|inbus=56,out=50,vol=1,pitch=1,pitchDispersion=0,timeDispersion=0|
	var aux3,env;
	aux3=In.ar(inbus,2);
	aux3=PitchShift.ar(aux3,0.2,pitch,pitchDispersion,timeDispersion);//pitch
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
	Out.ar(out,Pan2.ar(aux3*env,[1,-1])*vol)
}).add;
//low pass filter
SynthDef(\lowfilt,{|inbus=58,cutfreq=20000,rq=1,out=50,vol=1|
	var filtro,env;
	filtro=In.ar(inbus,2);
	filtro=RLPF.ar(filtro,cutfreq,rq);//Low Pass Filter
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
	Out.ar(out,Pan2.ar(filtro*env,[1,-1])*vol)
}).add;
//high pass filter
SynthDef(\highfilt,{|inbus=60,cutfreq=60,rq=1,out=50,vol=1|
	var filtro,env;
	filtro=In.ar(inbus,2);
	filtro=RHPF.ar(filtro,cutfreq,rq);//High Pass Filter
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
	Out.ar(out,Pan2.ar(filtro*env,[1,-1])*vol)
}).add;
//band pass filter
SynthDef(\bandfilt,{|inbus=62,cutfreq=1000,rq=1,out=50,vol=1|
	var filtro,env;
	filtro=In.ar(inbus,2);
	filtro=BPF.ar(filtro,cutfreq,rq);//Band Pass Filter
	env=EnvGen.ar(Env.asr(0.01,0.98,0.01),1);
	Out.ar(out,Pan2.ar(filtro*env,[1,-1])*vol)
}).add;
//granulador
SynthDef(\granulador,{|inbus=64,trigger,size,out=50|
	// el bus de granos es estereo: se suman los dos canales antes de granular
	Out.ar(out,GrainIn.ar(2,Impulse.kr(trigger),size,Mix(In.ar(inbus,2)),[0,0.96],-1,1024,mul:2))}).add;
);
