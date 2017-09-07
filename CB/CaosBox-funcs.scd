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