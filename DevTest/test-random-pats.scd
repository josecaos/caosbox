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
	for(0,steps_num,{|i|
		a = a.put(i,step.next);
	});
	b = ~set_steps.value(track,a);
	b;
	"Random steps pattern".inform;
};
);
~rand_steps.value(\hihats,2);
~clear_steps.value(\kick);
(
Tdef(\rand, {
	inf.do({

		~rand_steps.value(\kick,10);

		1.wait;
	});
});
);
Tdef(\rand).play;
Tdef(\rand).stop;