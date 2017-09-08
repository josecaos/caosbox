//random checkbox patterns
	~steps = Dictionary[
		\kick -> ~checkbombo,
		\snare -> ~checktarola,
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
	~clear_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
		var a;
		for(0,steps.size-1,{|i|
			a=steps[i];
			track[a].value = 0;
		});
	};
	~set_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
		var a,b;
		a = ~clear_steps.value(track);
		a.value;
		for(0,steps.size-1,{|i|
			b=steps[i];
			track[b].value = 1;
		});
	};
);
a = [0,3,6,17,22,30,31];
~set_steps.value(~steps[\kick],);
~clear_steps.value(~steps[\kick]);
(
Tdef(\testc,{
	inf.do({
		~set_steps.value(52,[0,2,3,5,9,13,17,21,31].scramble).postln;
		0.5.wait;
	});
});
);
Tdef(\testc).play;
Tdef(\testc).stop;
//
