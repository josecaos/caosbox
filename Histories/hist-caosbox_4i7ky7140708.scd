///////////////////////////////////////////////////
// History, as it was on Tue Jul  8 00:33:20 2014.
///////////////////////////////////////////////////

// - 0:0:0 -
(
History.start;
s.waitForBoot{
	 ~cbox_url="/home/josecaos/.ssh/caosbox/";/* <--- Change for your local URL to caosbox folder*/
	(~cbox_url +/+ "CB/CaosBox-load-v0.08.scd").load};/* <-- don't change this one */
);

// - 0:0:28.92 -
(
//kick
~cbox_b={var out=50;Out.ar(out,CaosKick.ar(modFreq:2,modbw:0.15,freq1:60,freq2:84,lowcutfreq:1100,att:0.01,rel:0.25,gate:1,amp1:0.75,amp2:0.15))};
//snare
~cbox_t={var out=60;Out.ar(out,CaosSnare.ar(att:0.01,rel:0.25,highcutfreq:220,rq:0.35,amp1:0.15,amp2:0.05))};//
//hat
~cbox_h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.3,highcutfreq:1530,rq:0.5,amp1:0.25,amp2:0.05))};//
//kick2
~cbox_b2={var out=64;Out.ar(out,CaosKick2.ar(modFreq:2,modbw:0.15,bw:0.5,freq1:60,freq2:72,lowcutfreq:2200,att:0.05,rel:1,amp:0.3))};//
//snare2
~cbox_t2={var out=58;Out.ar(out,CaosSnare2.ar(att:0.05,rel:0.2,iphase:0.05,bw:0.5,highcutfreq:870,rq:0.75,amp1:0.01,amp2:0.01))};//
//hat2
~cbox_h2={var out=64;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.5,highcutfreq:1950,rq:0.45,amp1:0.15,amp2:0.15))};//
);

// - 0:2:47.51 -
~cbox_h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.3,highcutfreq:1530,rq:0.5,amp1:0.35,amp2:0.15))};//

// - 0:3:20.43 -
~cbox_h={var out=50;Out.ar(out,CaosHats.ar(att:0.05,rel:0.5,highcutfreq:1230,rq:0.5,amp1:0.45,amp2:0.15))};//

// - 0:3:35.2 -
~cbox_h={var out=58;Out.ar(out,CaosHats.ar(att:0.05,rel:0.5,highcutfreq:1230,rq:0.5,amp1:0.45,amp2:0.15))};//

// - 0:4:45.05 -
(
Tdef(\acordes2,{
//CaosGuitChords args: |chord,att=0.1,rel=1,note=57,cutf=420,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var ac2mel=Pseq(~cbox_mainmelody.scramble,inf).asStream;
	var cambia2=Prand(['m','M9','mmaj7','m9m'],inf).asStream;//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	loop{
	~cbox_chord2.set(\chord,cambia2.next);
	~cbox_chord2.set(\note,ac2mel.next);
	~cbox_chord2.set(\cutf,3220);//
	~cbox_chord2.set(\rq,0.35);
	~cbox_chord2.set(\pan,0);// -1 to 1 where 0 is middle
	~cbox_chord2.set(\amp,0.5);
	~cbox_chord2.set(\out,64);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);

// - 0:8:34.12 -
~cbox_mainmelody=[36,39+3,44,48+7,51,55+12,60]-2;

// - 0:8:43.31 -
( //all Tdefs
(//bajo 1
Tdef(\bass,{
//CaosBass args: |att,rel,note,filtminf,filtmaxf,filtime,rq,iphase,amp1,amp2|
	var bassmel=Prand(~cbox_mainmelody.pyramid.mirror2-2,inf).asStream;
	loop{
	~cbox_bass.set(\note,bassmel.next,
			   \filtminf,56,
			   \filtmaxf,700,
			   \filtime,0.25,
			   \rq,0.15,
			   \iphase,0.5,
			   \amp1,1,
			   \amp2,0.5);
	~cbox_bass.set(\out,64);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);
//bajo 2
(
Tdef(\bass2,{
//CaosBass2 args: |att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,amp1,amp2|
	var bass2mel=Prand(~cbox_mainmelody.scramble.mirror2,inf).asStream;
	loop{
	~cbox_bass2.set(\note,bass2mel.next,
			   \trig,4,
			   \filtminf,56,
			   \filtmaxf,700,
			   \filtime,0.25,\rq,0.25,
			   \bandw,0.25,
			   \iphase,0.25,
			   \amp1,1,
			   \amp2,0.5);
	~cbox_bass2.set(\out,56);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad,{
//CaosPad args: |waveform,att,rel,note,trem,vrel,iphase,cutf,rq,amp|
	var padmel=Pseq(~cbox_mainmelody.scramble/1.22,inf).asStream;
	~cbox_amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
	loop{
	~cbox_amb.set(\note,padmel.next);
	~cbox_amb.set(\trem,2);
	~cbox_amb.set(\vrel,8);
	~cbox_amb.set(\iphase,0.5);
	~cbox_amb.set(\cutf,1420);
	~cbox_amb.set(\rq,0.5);
	~cbox_amb.set(\amp,0.24);
	~cbox_amb.set(\out,64);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);
//ambiente/pad
(
Tdef(\pad2,{
//CaosPad2 args: |att,rel,note,fmax,fm,harm,rmix,rroom,rfilt,amp1,amp2|
	var pad2mel=Pseq(~cbox_mainmelody.scramble,inf).asStream;
	loop{
	~cbox_amb2.set(\note,pad2mel.next);
	~cbox_amb2.set(\fmax,[1,2,4,8,16].choose);
	~cbox_amb2.set(\fm,[1,2,4,8,16].choose);//
	~cbox_amb2.set(\harm,4);
	~cbox_amb2.set(\rmix,0.9);
	~cbox_amb2.set(\rroom,0.5);
	~cbox_amb2.set(\rfilt,0.1);
	~cbox_amb2.set(\amp1,0.15);
	~cbox_amb2.set(\amp2,0.35);
	~cbox_amb2.set(\out,50);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);
////////////////////Chord Synths
(
Tdef(\acordes,{
//CaosChords args: |chord,att=0.1,rel=1,note=57,iphase=0.025,width=0.1,cutf=620,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var acmel=Pseq(~cbox_mainmelody.scramble,inf).asStream;
	var cambia=Prand(['m','M7','mmaj7','5dim7'],inf).asStream;//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
	loop{
	~cbox_chord.set(\chord,cambia.next);
	~cbox_chord.set(\note,acmel.next);
	~cbox_chord.set(\iphase,0.1);//
	~cbox_chord.set(\width,0.2);
	~cbox_chord.set(\cutf,1220);
	~cbox_chord.set(\rq,0.5);
	~cbox_chord.set(\pan,0);// -1 to 1 where 0 is middle
	~cbox_chord.set(\amp,0.5);
	~cbox_chord.set(\out,50);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);
(
Tdef(\acordes2,{
//CaosGuitChords args: |chord,att=0.1,rel=1,note=57,cutf=420,rq=0.5,pan=0,gate=0,amp=0.5,out=50|
	var ac2mel=Pseq(~cbox_mainmelody.scramble,inf).asStream;
	var cambia2=Prand(['m','M9','mmaj7','m9m'],inf).asStream;//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', 'M9',  'M9m', 'm9' or 'm9m' keys only
	loop{
	~cbox_chord2.set(\chord,cambia2.next);
	~cbox_chord2.set(\note,ac2mel.next);
	~cbox_chord2.set(\cutf,3220);//
	~cbox_chord2.set(\rq,0.35);
	~cbox_chord2.set(\pan,0);// -1 to 1 where 0 is middle
	~cbox_chord2.set(\amp,0.5);
	~cbox_chord2.set(\out,64);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);
//LineIn
~cbox_entrada.set(\out,50);//route
);

// - 0:9:41.76 -
~cbox_h2={var out=62;Out.ar(out,CaosHats2.ar(att:0.025,rel:0.5,highcutfreq:1950,rq:0.45,amp1:0.15,amp2:0.15))};//

// - 0:12:22.58 -
(
Tdef(\bass2,{
//CaosBass2 args: |att,rel,note,trig,filtminf,filtmaxf,filtime,rq,bandw,iphase,amp1,amp2|
	var bass2mel=Prand(~cbox_mainmelody.scramble.mirror2,inf).asStream;
	loop{
	~cbox_bass2.set(\note,bass2mel.next,
			   \trig,4,
			   \filtminf,56,
			   \filtmaxf,700,
			   \filtime,0.25,\rq,0.25,
			   \bandw,0.25,
			   \iphase,0.25,
			   \amp1,1,
			   \amp2,0.5);
	~cbox_bass2.set(\out,50);//route
	~cbox_tiempos.wait;
	}
}).quant_(4);
);

