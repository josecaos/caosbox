///////////////////////////////////////////////////
// History, as it was on Tue Jul  8 00:33:20 2014.
///////////////////////////////////////////////////

// - 0:0:0 -  
(
History.start;
s.waitForBoot{
	 ~url="/home/josecaos/.ssh/caosbox/";/* <--- Change for your local URL to caosbox folder*/
	(~url +/+ "CB/CaosBox-load-v0.08.scd").load};/* <-- don't change this one */
);

// - 0:0:28.92 -  
(
//kick
~b={var out=50;Out.ar(out,CaosKick.ar(modFreq:2,modbw:0.15,freq1:60,freq2:84,lowcutfreq:1100,att:0.01,rel:0.25,gate:1,amp1:0.75,amp2:0.15))};
//snare
~t={var out=60;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:220,rq:0.35,amp1:0.15,amp2:0.05))};//
//hat
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.3,highcutfreq:1530,rq:0.5,amp1:0.25,amp2:0.05))};//
//kick2
~b2={var out=64;Out.ar(out,CaosKick2.ar(modFreq:2,modbw:0.15,bw:0.5,freq1:60,freq2:72,lowcutfreq:2200,att:0.05,rel:1,amp:0.3))};//
//snare2
~t2={var out=58;Out.ar(out,CaosSnare2.ar(att:0.05,rel:0.2,iphase:0.05,bw:0.5,highcutfreq:870,rq:0.75,amp1:0.01,amp2:0.01))};//
//hat2
~h2={var out=64;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.5,highcutfreq:1950,rq:0.45,amp1:0.15,amp2:0.15))};//
);

// - 0:2:47.51 -  
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.3,highcutfreq:1530,rq:0.5,amp1:0.35,amp2:0.15))};//

// - 0:3:20.43 -  
~h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.5,highcutfreq:1230,rq:0.5,amp1:0.45,amp2:0.15))};//

// - 0:3:35.2 -  
~h={var out=58;Out.ar(out,CaosHats.ar(att:0.05,rel:0.5,highcutfreq:1230,rq:0.5,amp1:0.45,amp2:0.15))};//

// - 0:4:45.05 -  
(
Tdef(\acordes2,{
//CaosGuitChords args: |chord,att=0.1,rel=1,note=57,cutf=420,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var ac2mel=Pseq(~mainmelody.scramble,inf).asStream;
	var cambia2=Prand(['m','M9','mmaj7','m9m'],inf).asStream;//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	loop{
	~chord2.set(\chord,cambia2.next);
	~chord2.set(\note,ac2mel.next);
	~chord2.set(\cutf,3220);//
	~chord2.set(\rq,0.35);
	~chord2.set(\pan,0);// -1 to 1 where 0 is middle
	~chord2.set(\amp,0.5);
	~chord2.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);

// - 0:8:34.12 -  
~mainmelody=[36,39+3,44,48+7,51,55+12,60]-2;

// - 0:8:43.31 -  
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
	~bass2.set(\out,56);//route
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
	var pad2mel=Pseq(~mainmelody.scramble,inf).asStream;
	loop{
	~amb2.set(\note,pad2mel.next);
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
	~chord.set(\amp,0.5);
	~chord.set(\out,50);//route
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
	~chord2.set(\cutf,3220);//
	~chord2.set(\rq,0.35);
	~chord2.set(\pan,0);// -1 to 1 where 0 is middle
	~chord2.set(\amp,0.5);
	~chord2.set(\out,64);//route
	~tiempos.wait;
	}
}).quant_(4);
);
//LineIn
~entrada.set(\out,50);//route
);

// - 0:9:41.76 -  
~h2={var out=62;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.5,highcutfreq:1950,rq:0.45,amp1:0.15,amp2:0.15))};//

// - 0:12:22.58 -  
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
	~bass2.set(\out,50);//route
	~tiempos.wait;
	}
}).quant_(4);
);

