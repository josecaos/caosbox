// Test .randStream + nuevo metodo .offTrack
c = CaosBox;
c.enviroment;

c.soundcheck(\pink);

c.play;
c.freqAnalyzer(true);

b = CaosGear.new;
b.bass(50,~mainmelody.melody(~degrees,48),\seq);
~degrees = LCNE.dupOctave(Scale.minor.degrees,1);
b.toTrack(28);
// b.offTrack(28); //prototipo
b.toTrack(30);
//
d = CaosGear.new;
d.bass2(50,~mainmelody.melody(~degrees,60),\seq);
d.toTrack(29);
d.toTrack(31);

c.bpm(60*2);

c.stop

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