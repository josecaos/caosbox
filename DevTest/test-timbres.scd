(
Task({
	c = CaosBox;
	c.enviroment;
	5.yield;
	{
		c.play;
		c.bpm(115);
		x = CaosGear;
		a = x.new;
		// a.chords2([52,60,62,64,62,60,58,60,56,52],~cbox_mainmelody.melody(LCNE.dupOctave(Scale.locrian.degrees,4),24),\rand);
		a.lineIn([52,60,62,64,62,60,58,60,56,52]);
		// a.lineIn(50);
		a.toTrack(Array.series(8,0,4),true);
	}.defer(0.1);
}).play;
);
a.lineIn(52);
// c.record;
//
k = x.new;
k.kick(50,0.01,0.5,amp1:0.5,amp2:0.125);
k.toTrack(0,true);
k.kick(64,0.01,0.25,amp1:0.35,amp2:0.5);
k.toTrack(Array.series(2,16,4));
//
h = x.new;
h.hihats(50,0.01,0.5,amp1:0.25,amp2:0.125);
h.toTrack(0);
h.hihats(64,0.01,0.15,amp1:0.35,amp2:0.5);
h.hihats(60,0.01,0.25,amp1:0.35,amp2:0.5);
h.toTrack(Array.series(12,2,4));
//
c.autoFx(\delay,true,\normal,Array.series(10,0.01,0.05),0.15);
c.autoFx(\reverb,true,\normal,0.5,Array.series(5,0.75,0.125),0.5);
c.autoFx(\grains,true,\normal,Array.series(10,0.1,0.1),Array.series(10,0.01,0.1));
c.randomTime(true,true,[115,115/2,115*2])
~cbox_checkbajo[0].value
~cbox_checkbajo[31].value
//
Tdef.all
Tdef.gui
Scale.directory
y = Scale.major;
y.degrees();        // [ 0, 2, 4, 5, 7, 9, 11 ]
y.semitones;        // [ 0, 2, 4, 5, 7, 9, 11 ]
y.cents;        // [ 0, 200, 300, 500, 700, 900, 1100 ]
y.ratios;
y.stepsPerOctave
//
s.boot
(
z = {|out=0,att=0.01,rel=0.25|
	// out.postln;
	// att.postln;
	// rel.postln;
	Out.ar(out,CaosKick.ar(att,rel,1,0.25,60,64,55,1,1,0.2,0));
};
)
(
Tdef(\test,{
	loop{
		z.value(0,0.1,8);
		z.play();
		0.5.wait;
	}
	}).play;
);

~cbox_b.value(rel:4);
//
q = nil
q ? {"si 'q' NO es nil se ejecuta la funcion".postln}//
q ?? {"si 'q' es nil se ejecuta la funcion".postln}//
//
u = -100;
[1, 2, nil, 3].collect{ |x| if(x === nil, {x ? u=u+1},{x.postln})};
