// class-alike library to extend the possibilities of live composition
// functions used between the code along the CaosBox GUI

// Returns random sequence stream
// arg1: sequence type key: '\rand1' and '\rand2'
// arg2: array of number ouputs
// Deprecated function turned into a method
~rand_stream = {|seq,array|
	var out;
	if(seq != \rand2 and:( seq != \rand1),
		{"Use \seq or \rand keys to choose output sequence style \n".inform;},
		{
			switch(seq,
				\rand1,{out=Prand(array,inf).asStream},
				\rand2,{out=Pshuf(array,inf).asStream},
			);
			out.next;
	});
};

// Returns an 32 step pattern array
// arg1: Default value for unchanged steps
// arg2: Pattern of changed steps value
// arg3: Array of affected steps
~pat_arr = {|default=50,in=50,steps|
	var arr = Array.fill(32,nil);
	var a;
	for(0,steps.size-1,{|i|
		a=steps[i];
		arr=arr.put(a,in);
	});
	 arr.collect({|item,i|
	 	if(item == nil,{
		arr.put(i,default);
	 	});
	 });
	//
	arr;
};

// The checkbox steps functions

// Returns cleared checkboxes for assigned track
// arg1: assigns track with ~steps[\n] global variable
// arg2: Array of specific indexes affected in ~steps[n]. Default "all"
~clear_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]|
	var a,dir = ~steps;
	for(0,steps.size-1,{|i|
		a=steps[i];
		dir[track][0][a].valueAction_(false);
	});
	"Manually cleared step pattern".inform;
};

// Returns checked checkboxes for assigned track
// arg1: assigns track with ~steps[\n] global variable
// arg2: Array of specific indexes affected in ~steps[n]. Defaults "all"
// arg3: Boolean whether or not to clear previous steps
~set_steps = {|track,steps = #[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],clear = true|
	var index,dir = ~steps;
	if(clear == true,{~clear_steps.value(track)},{~clear_steps.value(track,steps)});
	for(0,steps.size-1,{|i|
		index=steps[i];
		dir[track][0][index].valueAction_(true);
	});
	"Manually added step pattern".inform;
};

// Returns random checked checkboxes for assigned track
// arg1: assigns track with ~steps[\n] global variable
// arg2: number of used checkboxes
~rand_steps = {|track,steps_num = 1|
	var a,b,step;
	a = Array.new(32);
	step = Pxrand((0..31),inf).asStream;
	for(1,steps_num,{|i|
		a = a.add(step.next);
	});
	b = ~set_steps.value(track,a);
};