c = CaosBox;
c.enviroment;

c.play;
c.stop;
c.freqAnalyzer(true);

c.bpm(198);
c.randomTime(true,false,Array.series(24,15,25));
// c.scope;

a = CaosGear.new;
b = [0,3,7,11,12,15,19]+36;
a.bass(b+24,'rand',400,10100,0.25);
//debug
a.melody(Scale.romanianMinor.degrees,60);
Scale.directory;
Scale.minor.semitones;
Scale.major.degrees;
~mainmelody.value
//
//
c.setSteps(\bass,[2,4,8,16,24,28]);
c.clearSteps(\bass);

(
a.kick(50,0.01,0.25,1,0.01);
c.setSteps(\kick,[0,2,6,8,14,16,18,24,28,30]);
);
//
c.auto(\reverb,true,\normal,Array.series(4,0.01,0.24),[0.5,0.95],0.95);
c.auto(\delay,true,\normal,Array.series(10,0.01,0.025),0.5);
c.auto(\pitch,false,\normal,Array.series(8,0.5,0.5),0.5,0);
c.auto(\grains,false,\normal,Array.series(10,0.1,0.1),Array.series(10,0.01,0.1));
// (~url +/+ "CB/CaosBox-synths.scd").load;
//
c.setSteps(\kick,Array.series(8,0,4));
c.setSteps(\kick,[0,8,16,24]);
c.setSteps(\kick2,[0]);
c.setSteps(\kick,[8,16,24],false);
c.setSteps(\hihats,Array.series(8,2,4),false);
c.setSteps(\hihats,Array.series(8,0,4),false);
c.setSteps(\snare,Array.series(4,4,8),true);
c.setSteps(\snare,Array.series(1,6,16),false);
c.setSteps(\bass2,[0]);

TdefAllGui.new(16);

