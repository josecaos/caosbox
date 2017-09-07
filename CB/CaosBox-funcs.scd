//Functions class-alike used between the code

// outputs random sequence stream
// arg1 sequence type key: '\rand1' and '\rand2'
// arg2 array of number ouputs
~rand_outs = {|seq,array|
	// var arr = Array.newClear(args.size);
	var out;
	if(seq != \rand2 and:( seq != \rand1),
		{"Use \seq or \rand keys to choose output sequence style \n".postln;},
		{
			switch(seq,
				\rand1,{out=Prand(array,inf).asStream},
				\rand2,{out=Pwalk(array,inf).asStream},
			);
			out.next;
	});
};

//