c = CaosBox;
c.enviroment;

c.play;
c.freqAnalyzer(true);
c.bpm(260);

c.auto(\reverb,true,\normal,Array.series(4,0.01,0.24),[0.5,0.95],0.95);
c.auto(\delay,true,\normal,Array.series(10,0.01,0.025),0.5);
c.auto(\pitch,false,\normal,Array.series(8,0.5,0.5),0.5,0);
c.auto(\grains,false,\normal,Array.series(10,0.1,0.1),Array.series(10,0.01,0.1));
a = CaosGear.new;
a.kick(50,0.01,0.04,8,0.01);
(
a.kick([50,51,52,53,64],0.01,0.25,1,0.01);
~set_steps.value(\kick,[0,8,16,24]);
);
//
a.kickDyn(52,0.5,1,amp1:0.25,amp2:1);
~kickgear.set(\out,52);

~kickgear;
(~url +/+ "CB/CaosBox-synths.scd").load;
//
~set_steps.value(\kick,[0],false);
~set_steps.value(\kick,[0]);
~set_steps.value(\kick2,[0]);
~set_steps.value(\kick,[8,16,24],false);
~set_steps.value(\hihats,Array.series(8,2,4),true);
~set_steps.value(\hihats,Array.series(8,0,4),false);
~set_steps.value(\snare,Array.series(4,4,8),true);
~set_steps.value(\snare,Array.series(1,6,16),false);
~set_steps.value(\bass2);
~set_steps.value(\bass,Array.series(0,4,4));

TdefAllGui.new(16);

