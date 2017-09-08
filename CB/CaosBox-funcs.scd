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
// Returns cleared checkboxes from assigned track
// arg1: assigns track with ~steps[n] global variable
// arg2: Array of specific indexes affected in ~steps[n]. Default "all"
(
~clear_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
		var a;
		for(0,steps.size-1,{|i|
			a=steps[i];
			track[a].value = 0;
		});
	};
// Returns checked checkboxes from assigned track
// arg1: assigns track with ~steps[n] global variable
// arg2: Array of specific indexes affected in ~steps[n]. Defaults "all"
~set_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
		var a,b;
		a = ~clear_steps.value(track,(0..31));
		a.value;
		for(0,steps.size-1,{|i|
			b=steps[i];
			track[b].value = 1;
		});
	};
);