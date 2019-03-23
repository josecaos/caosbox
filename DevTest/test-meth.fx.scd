(
c = CaosBox;
c.enviroment;
);

k = CaosGear.new;
k.kick;
k.toTrack([0,2,3,4,6,7,8,11,24]+3);

z = CaosGear.new;
y = LCNE.dupOctave(Scale.dorian.degrees,4);
z.chords([52,56],~mainmelody.melody(y,48),\seq,[\m,\M],1,0.015,0.5,0.5,12000,0.25,0,1 );
z.chords();
z.toTrack(Array.series(16,0,2));
//
c.play;
c.freqAnalyzer(true);

x = CaosGear.new;
x.bass(z,~mainmelody.melody([0,3,7,11,12],48));
x.toTrack(Array.series(16,0,2),true);
x.instance_id_("Kick");//no setter
x.instance_id;//getter

CaosGear.browse;
c.play;
(
Tdef(\test,{
	loop{
		// c.randStream('rand1',[50,52,54,56,68,60,62,64]);
		z = c.randStream('rand1',[50,52,54,56,68,60,62,64]);
		x.bass(z,~mainmelody.melody([0,3,7,11,12],48));
		~tiempos.wait;
	}
});
);
Tdef(\test).play;
Tdef(\test).stop;
c.fx(\reverb,arg1:0.5,arg2:0.95,arg3:0.7);
c.fx(\delay,arg1:0.5,arg2:0.5);
c.fx(\pitch,arg1:2,arg2:0,arg3:0);
c.fx(\grains,arg1:0.5,arg2:0.5);
c.fx(\master,arg1:1,arg2:1,arg3:0.45,arg4:0.425,arg5:0.95);

c.openDefaults;
CaosBox.openDefaults;
~degrees = LCNE.dupOctave(Scale.hungarianMinor.degrees,4)

//
ClassBrowser.initGUI;