c = CaosBox;
c.enviroment;

c.play;
c.freqAnalyzer(true);

c.bpm(198);
// c.scope;

a = CaosGear.new;
a.bass([0,3,7,11,12,15,19]+36,'rand',400,10100,0.25);
//debug
a.melody(Scale.romanianMinor.degrees,60);
Scale.directory;
Scale.minor.semitones;
Scale.major.degrees;
~mainmelody.value
//
a.kick(50,0.01,0.04,8,0.01);
(
a.kick(50,0.01,0.25,1,0.01);
~set_steps.value(\kick,[0,2,6,8,14,16,18,24,28,30]);
);
//
// a.kickDyn(56,0.5,1,amp1:1,amp2:1);


~set_steps.value(\bass,[2,4,8,16,24,28],false);
~set_steps.value(\bass);

c.clearSteps(\bass);

c.auto(\reverb,true,\normal,Array.series(4,0.01,0.24),[0.5,0.95],0.95);
c.auto(\delay,true,\normal,Array.series(10,0.01,0.025),0.5);
c.auto(\pitch,false,\normal,Array.series(8,0.5,0.5),0.5,0);
c.auto(\grains,false,\normal,Array.series(10,0.1,0.1),Array.series(10,0.01,0.1));
// (~url +/+ "CB/CaosBox-synths.scd").load;
//
~set_steps.value(\kick,Array.series(8,0,4));
~set_steps.value(\kick,[0]);
~set_steps.value(\kick2,[0]);
~set_steps.value(\kick,[8,16,24],false);
~set_steps.value(\hihats,Array.series(8,2,4),true);
~set_steps.value(\hihats,Array.series(8,0,4),false);
~set_steps.value(\snare,Array.series(4,4,8),true);
~set_steps.value(\snare,Array.series(1,6,16),false);
~set_steps.value(\bass2,[0]);

TdefAllGui.new(16);

