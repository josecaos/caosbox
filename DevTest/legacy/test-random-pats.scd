//random checkbox patterns
~steps = Dictionary[
	\kick -> [~checkbombo,~bombo,~b],
	\snare -> [~checktarola,~tarola],
	\hihats -> ~checkcontras,
	\kick2 -> ~checkbombo2,
	\snare2 -> ~checktarola2,
	\hihats2 -> ~checkcontras2,
	\bass -> ~checkbajo,
	\bass2 -> ~checkbajo2,
	\amb -> ~checkambiente,
	\amb2 -> ~checkambiente2,
	\chords -> ~checksinte,
	\chords2 -> ~checksinte2,
	\in -> ~checkin
];
~steps.keys;
~steps.values;
~steps.getPairs;
(
~rand_steps = {|track,steps_num = 1|

	var a,b,step;
	a = Array.new(32);
	step = Pxrand((0..31),inf).asStream;
	for(1,steps_num,{|i|
		a = a.add(step.next);
	});
	b = ~set_steps.value(track,a);
	b;
};
);
(
~rand_steps.value(\snare,4);
~rand_steps.value(\hihats,22);
~rand_steps.value(\kick,5);
~rand_steps.value(\bass,16);
);
~clear_steps.value(\kick);
(
Tdef(\func, {
	inf.do({

		~set_steps.value(\kick,[0,1,2,3,5,9,13,17]);
		~rand_steps.value(\kick,8);
		~rand_steps.value(\snare,5);
		~rand_steps.value(\hihats,26);
		~rand_steps.value(\bass,8);

		1.wait;
	});
});
);
Tdef(\func).play;
Tdef(\func).stop;
//
~set_steps.value(\bass);
s.scope;