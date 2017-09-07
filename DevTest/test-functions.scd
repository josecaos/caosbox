//random checkbox patterns
(
~pat_out = {|out,steps|
	var arr = Array.fill(32,nil);
	var a;
	for(0,steps.size-1,{|i|
		a=steps[i];
		arr.put(a,a);
	});
	arr;

};
);
~pat_out.value(52,[0,1,2,3,5,9,13,17,21]);
(
Tdef(\test,{
	inf.do({
		~pat_out.value(52,[0,2,3,5,9,13,17,21,31]).postln;
		0.5.wait;
	});
});
);
Tdef(\test).play;
Tdef(\test).stop;

//
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


~checkbombo[2].value = 1;