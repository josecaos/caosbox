(
c = CaosBox;
c.enviroment;
);
// c.server.scope;
c.play;
c.guiAlpha(0.35);
~bpm = 140;
c.bpm(~bpm);

~inst = CaosGear;

b = ~inst.new;
b.bass(64);
b.toTrack([0,4,8,12,16,20,24,28]);
b.bass([56,60],seqType:\seq);
b.bass([56,60],seqType:\rand);
b.bass(64,seqType:\rand);
b.bass([64,52],seqType:\rand);
b.toTrack(0,true);
b.offTrack([0,4,8,12,16,20,24,28]);

x = ~inst.new;
x.chords([58,64],LCNE.dupOctave(Scale.minor.degrees,3)+24,\rand);
x.toTrack([0,4,8,12,16,20,24,28])

z = ~inst.new;
z.pad(64,LCNE.dupOctave(Scale.minor.degrees,3)+36,\rand);
z.toTrack([0,4,8,12,16,20,24,28])

q = ~inst.new;
q.bass2(64);
q.bass2(64,[48,52,56,68,62,73,74,75,80,82,85,86],\rand);
q.toTrack([0,4,8,12,16,20,24,28])
q.offTrack([0,4,8,12,16,20,24,28])

k = ~inst.new
k.kick(64)
k.toTrack(0,true)
k.toTrack([0,16],true)
k.toTrack(Array.series(8,0,4))
k.toTrack(Array.series(8,0,16),true)

h = ~inst.new
h.hihats
h.toTrack(Array.series(8,0,6))
h.toTrack(Array.series(8,0,6),true)

m = ~inst.new
m.hihats2(50);
m.hihats2(54,amp1:0.75,amp2:0.125);
m.hihats(64);


t = ~inst.new
t.snare()
t.snare([50,52])
t.snare(64)

// Posible nuevo metodo
(
Tdef(\rand,{
	var i = 0;

	inf.do{|i|
		i.postln;
		{
			// if(i.odd,{k.kick(64)},{k.kick(52)});
			// k.toTrack(Array.series(rrand(4,10),0,rrand(1,8)),true);
			// h.toTrack(Array.series(16,0,rrand(1,8)),true);
			// b.toTrack(Array.series(rrand(8,12),0,rrand(2,8)),true);
			q.toTrack(Array.series(rrand(8,12),0,rrand(2,8)),true);
		}.defer(0.1);
		(~bpm/60).wait;
	}
});
);
Tdef(\rand).play;
Tdef(\rand).stop;



c.autoFx(\delay, true,\normal,Array.series(8,0.125,0.125),0.125)
c.autoFx(\grains, true,\normal,Array.series(5,0.75,0.05),Array.series(5,0.75,0.05))
c.autoFx(\lpf, true,\normal,Array.series(220,100,80), Array.series(5,0.75,0.05))
c.autoFx(\reverb, true,\normal,Array.series(10,0,0.09), Array.series(10,0.5,0.06),0)
c.autoFx(\pitch, true,\normal,Array.series(40,0,0.09),0,0)
c.autoFx(\hpf, false,\normal,Array.series(10,280,620), 0.25)

c.randomTime(true,true,[~bpm, ~bpm/2,~bpm*2]/1.25)

c.record