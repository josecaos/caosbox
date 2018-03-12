c = CaosBox;
c.enviroment;

c.play;
c.freqAnalyzer(true);
c.bpm(194);

c.auto(\reverb,true,\normal,Array.series(4,0.1,0.2),0.95,0.75);
c.auto(\delay,false,\normal,Array.series(10,0.01,0.01),0.5);
c.auto(\pitch,false,\normal,Array.series(8,0.5,0.5),0.5,0);
c.auto(\grains,false,\normal,Array.series(10,0.1,0.1),Array.series(10,0.01,0.1));

z = CaosGear.new;
z.kick(rel:4);
//
~set_steps.value(\kick,[0,8,16,24]);
~set_steps.value(\kick,[0],false);

TdefAllGui.new(16);

