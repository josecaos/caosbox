//random checkbox patterns

~rythm_patter

// random outputs
(
~outputs = {|seq,array|
	// var arr = Array.newClear(args.size);
	var out;
	if(seq != \rand1 and:( seq != \rand2),
		{"Use \seq or \rand keys to choose output sequence style \n".postln;},
		{
			switch(seq,
				\rand1,{out=Prand(array,inf).asStream},
				\rand2,{out=Pshuf(array,inf).asStream},
			);
			out.next;
	});
};
);
~outputs.value(\rand1,[52,54,56]);
~outputs.value(\rand2,(1..100));
~outputs.value;
(
Tdef(\test1,{
	inf.do({
		~outputs.value(\rand1,(1..99)).post;
		"will miss you grandma".scramble.postcln;
		0.125.wait;
	});
});
);
Tdef(\test1).play;
Tdef(\test1).stop;
// ~outputs.def


