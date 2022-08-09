(
c = CaosBox;
c.enviroment;
);
c.play;
~bpm = 182;
c.bpm(~bpm);

~inst = CaosGear;

b = ~inst.new;
b.bass();
b.toTrack([0,4,8,12,16,20,24,28],true);
b.offTrack([0,4,8,12,16,20,24,28]);

k = ~inst.new
k.kick(64)
k.toTrack(Array.series(8,0,4))

q = ~inst.new
q.kick2(56)

h = ~inst.new
h.hihats
h.toTrack(Array.series(8,0,4))

m = ~inst.new
m.hihats2(amp1:0.5,amp2:0.125);
m.hihats(64);
// Posible nuevo metodo
(
Tdef(\rand,{
	var i = 0;

	inf.do{
		i.postln;
		{
			// if(i.odd,{k.kick(64)},{k.kick(52)});
			k.toTrack(Array.series(rrand(4,10),0,rrand(1,4)),true);
			h.toTrack(Array.series(16,0,rrand(1,2)),true);
			// b.toTrack(Array.series(rrand(4,8),0,rrand(1,4)),true);
		}.defer(0.1);

		i = i+1;
		1.wait;
	}
});
);
Tdef(\rand).play;
Tdef(\rand).stop;



c.autoFx(\grains, true,\normal,Array.series(5,0.75,0.05),Array.series(5,0.75,0.05))
c.autoFx(\lpf, true,\normal,Array.series(220,100,80), Array.series(5,0.75,0.05))
c.autoFx(\reverb, true,\normal,Array.series(10,0,0.09), Array.series(10,0.5,0.06),0)
c.autoFx(\pitch, true,\normal,Array.series(40,0,0.09), Array.series(6,0.01,0.05),0.5)