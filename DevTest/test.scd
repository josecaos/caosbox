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
~clear_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
	var a,dir = ~steps;
	for(0,steps.size-1,{|i|
		a=steps[i];
		dir[track][0][a].value = 0;
		dir[track][1].put(a,nil);
	});
	"Manually cleared step pattern".inform;
};
~set_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
	var a,b,dir = ~steps;
	a = ~clear_steps.value(track,(0..31));
	for(0,steps.size-1,{|i|
		b=steps[i];
		dir[track][0][b].value = 1;
		dir[track][1].put(b,dir[track][2]);
	});
	"Manualy added step pattern".inform;
};
);
~set_steps.value(\in);
~set_steps.value(\bass,Array.series(32,0,1));
~clear_steps.value(\in,[0,31]);
x = ~steps;
x.find(['bass']);
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
//  test global variable constructed with string
~x = Dictionary[
	\kick -> [["check1","check2"],["sint123","sint"],"solo"],
	\snare -> ["checktarola","tarola"],
];
~x[\kick][0][1];
~x[\kick][1][1];
~x[\kick][2];
//
~set_steps.value(\kick, [1,3,6,7,8,9,0,11,22,]);