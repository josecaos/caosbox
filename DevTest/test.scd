//random checkbox patterns
(
~clear_steps = {|track,steps|
	var a;
	track = ~checkbombo;
	// marca checkbox
	for(0,steps.size-1,{|i|
		a=steps[i];
		track[a].value = 0;
	});
};
~set_steps = {|track,steps|
	var a;
	track = ~checkbombo;
	~clear_steps.value(nil,steps);
	// marca checkbox
	for(0,steps.size-1,{|i|
		a=steps[i];
		track[a].value = 1;
	});
};
);
~set_steps.value(nil,[0,20,31,5].scramble);
~clear_steps.value(nil,[0,20,30,5].scramble);
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
