c = CaosBox;
c.enviroment;
c.play;
//
(//experimental test, may crash
Tdef(\randchecks,{
	loop{
		{
			c.randSteps(\kick,8);
			c.randSteps(\hihats2,4);
			// c.randSteps(\bass,16);
		}.defer(0.05);
		1.wait;
	}
});
);
Tdef(\randchecks).play;
c.randSteps(\kick,8);
c.randSteps(\hihats2,4);
c.randSteps(\bass,16);
c.setSteps(\snare,[4,12,20,28]);
//
g=CaosGear.new;
g.bass(Scale.locrian.semitones+48,out:54);
g.bass(Scale.locrian.semitones+48,out:c.patternArray(52,64,[0,2,9,12,16,20,24,26,28]).postcln);
c.setSteps('bass');
//
h=CaosGear.new;
c.setSteps(\kick,[0,4,8,12,16,20,24,28]);
c.setSteps(\hihats,[0,2,4,8,10,12,16,20,22,24,28,29,30]);
c.setSteps(\hihats,[1,3,9,13,17,21,25],false);
//
(
Tdef(\test,{
	inf.do({
		c.patternArray(50,rrand(50,65),[0,2,3,5,9,13,17,21,31]).postln;
		0.5.wait;
	});
});
);
Tdef(\test).play;
Tdef(\test).stop;

