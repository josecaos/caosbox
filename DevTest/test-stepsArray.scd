c = CaosBox;
c.enviroment;
c.play;
///
(
Tdef(\test,{
	inf.do({
		c.stepsArray(50,rrand(50,64),[0,2,3,5,9,13,17,21,31]).postln;
		0.5.wait;
	});
});
);
Tdef(\test).play;
Tdef(\test).stop;

