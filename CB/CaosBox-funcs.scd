//class-alike library of functions used between the code to
// extend the possibilities of live creation along the CaosBox GUI

// Returns random sequence stream
// arg1: sequence type key: '\rand1' and '\rand2'
// arg2: array of number ouputs
~rand_stream = {|seq,array|
	var out;
	if(seq != \rand2 and:( seq != \rand1),
		{"Use \seq or \rand keys to choose output sequence style \n".postln;},
		{
			switch(seq,
				\rand1,{out=Prand(array,inf).asStream},
				\rand2,{out=Pshuf(array,inf).asStream},
			);
			out.next;
	});
};

// Returns an 32 step pattern array
// arg1: output channel
// arg2: array of affected steps
~pat_arr = {|aux,steps|
	var arr = Array.fill(32,nil);
	var a;
	for(0,steps.size-1,{|i|
		a=steps[i];
		arr=arr.put(a,aux);
	});
	arr
};

// The checkbox steps functions
// Array of checkbox tracks, used to assign
// new steps to track. Use the dictionary key
// ej. ~steps[\kick] assigns kick checkbox global variable
~steps = Dictionary[
	\kick -> [~checkbombo,~bombo,~b],
	\snare -> [~checktarola,~tarola,~t],
	\hihats -> [~checkcontras,~contras,~h],
	\kick2 -> [~checkbombo2,~bombo2,~b2],
	\snare2 -> [~checktarola2,~tarola2,~t2],
	\hihats2 -> [~checkcontras2,~contras2,~h2],
	\bass -> [~checkbajo,~bajo,~bass],
	\bass2 -> [~checkbajo2,~bajo2,~bass2],
	\amb -> [~checkambiente,~ambiente,~amb],
	\amb2 -> [~checkambiente2,~ambiente2,~amb2],
	\chords -> [~checksinte,~sinte,~chord],
	\chords2 -> [~checksinte2,~sinte2,~chord2],
	\in -> [~checkin,~in,~entrada]
];
// Returns cleared checkboxes from assigned track
// arg1: assigns track with ~steps[n] global variable
// arg2: Array of specific indexes affected in ~steps[n]. Default "all"
~clear_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
	var a,dir = ~steps;
	for(0,steps.size-1,{|i|
		a=steps[i];
		dir[track][0][a].value = 0;
		dir[track][1].put(a,nil);
	});
	"Manually cleared step pattern".inform;
};
// Returns checked checkboxes from assigned track
// arg1: assigns track with ~steps[n] global variable
// arg2: Array of specific indexes affected in ~steps[n]. Defaults "all"
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
