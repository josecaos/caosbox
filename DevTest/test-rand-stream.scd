// Test .randStream + nuevo metodo .offTrack
c = CaosBox;
c.enviroment;
c.play;
//
b = CaosGear.new;
b.bass(50,~mainmelody.melody(~degrees,48),\seq);
~degrees = LCNE.dupOctave(Scale.minor.degrees,1);
b.toTrack(28);
b.offTrack([28]); //prototipo
b.toTrack(30);
b.offTrack(30);
//
d = CaosGear.new;
d.bass2(50,c.randStream(\rand2,Array.series(36,48,1)),\seq);
d.bass2(50,c.stepsArray(48,60,[4,8,12,16,20,24,28,31]),\seq);
d.bass2(50,~mainmelody.melody(~degrees,60),\seq);
d.bass2(50,~mainmelody.melody(~degrees,60),\rand);
d.toTrack(29);
d.toTrack(31);
d.toTrack(Array.series(16,0,2));
//
CaosBox.stepsArray;
CaosBox.stepsArray(48,60,[4,8,12,16,20,24,28,31]);
c.bpm(60*2);

c.stop
c.randStream(\rand1,Array.series(36,48,1))
// randStream - Funciona dentro de un tdef
(
Tdef(\test,{
	loop{
		CaosBox.randStream(\rand1,[52,54,56,68,60,62,64]);
		0.125.wait;
	}
});
)
Tdef(\test).play;