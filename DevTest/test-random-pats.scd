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
	var arr = Pxrand(Array.newClear(32),inf).asStream;
	var a,b,dir = ~steps;
	a = ~clear_steps.value(track,(0..31));
	b=steps_num;
	for(0,32,{|i|
		dir[track][0][b].value = 1;
		dir[track][1].put(b,dir[track][2]);
	});
	"Manualy added random step pattern".inform;
};
);
~rand_steps.value(\in);
~rand_steps.value(\bass,Array.series(32,0,1));
~clear_steps.value(\bass);
