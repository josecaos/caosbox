///////////////////////////////////////////
//CaosBox v1.3 Instruments  default parameters
///////////////////////////////////////////
~cbox_b={var out=50;Out.ar(out,CaosKick.ar(0.01,0.25,1,0.25,60,64,50,1,1,0.2,2))};
~cbox_b2={var out=50;Out.ar(out,CaosKick2.ar(0.01,0.7,2,modbw:0.5,bw:0.15,freq1:60,freq2:62,lowcutfreq:45,amp:0.1))};
~cbox_t={var out=50;Out.ar(out,CaosSnare.ar(0.01,0.25,360,rq:0.25,amp1:0.75,amp2:0.5))};
~cbox_t2={var out=50;Out.ar(out,CaosSnare2.ar(0.01,0.16,0.5,bw:0.35,highcutfreq:270,rq:0.35,amp1:0.1,amp2:0.05))};
~cbox_h={var out=50;Out.ar(out,CaosHats.ar(0.01,0.5,8330,rq:0.25,amp1:0.35,amp2:0.01))};
~cbox_h2={var out=50;Out.ar(out,CaosHats2.ar(0.025,0.25,6950,rq:0.45,amp1:0.5,amp2:0.3))};
/////////////////////////////////
//  Declare synths
~cbox_bass = Synth(\bajouno);
~cbox_bass2 = Synth(\bajodos);
~cbox_amb = Synth(\ambuno);
~cbox_amb2 = Synth(\ambdos);
~cbox_chord = Synth(\acordesuno);
~cbox_chord2 = Synth(\acordesdos);
~cbox_entrada = Synth(\ent);
//

// CaosGear.new.bass;
// CaosGear.new.bass2;
// CaosGear.new.chords;
// CaosGear.new.chords2;
// CaosGear.new.lineIn;


//ambient pad
// CaosGear.new.pad();
// (
// Tdef(\pad,{
// 	var padmel=Pxrand(~cbox_mainmelody.melody(~cbox_degrees,48),inf).asStream;
// 	~cbox_amb.set(\waveform, 'pulse' );//use 'sin' or 'tri' or 'pulse' only
// 	loop{
// 		~cbox_amb.set(\note,padmel.next,
// 			\trem,8,
// 			\vrel,2,
// 			\iphase,0.25,
// 			\cutf,12420,
// 			\rq,0.5,
// 			\amp,0.05,
// 			\out,50);
// 		~cbox_tiempos.wait;
// 	}
// }).quant_(1);
// );
//ambiente pad 2
// CaosGear.new.pad2();
// (
// Tdef(\pad2,{
// 	var pad2mel=Pseq(~cbox_mainmelody.melody(~cbox_degrees,48),inf).asStream;
// 	loop{
// 		~cbox_amb2.set(\note,pad2mel.next,
// 			\fmax,[16,32,64,128,8].choose,
// 			\fm,[2,4,8].choose,
// 			\harm,120,
// 			\rmix,0.79,
// 			\rroom,0.15,
// 			\rfilt,0.5,
// 			\amp1,0.09,
// 			\amp2,0.05,
// 			\out,50);
// 		~cbox_tiempos.wait;
// 	}
// }).quant_(1);
// );
//LineIn
// (
// SynthDef(\ent,{|out=50,gate,att,rel|
// 	Out.ar(out,Pan2.ar(SoundIn.ar(0)*EnvGen.ar(Env.perc(att,rel),gate,doneAction:2)))}).add;
// );
