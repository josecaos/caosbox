//random checkbox patterns
(
~pat_arr = {|default=50,in=50,steps|
	var arr = Array.fill(32,nil);
	var a;
	// inserta valores especificos
	for(0,steps.size-1,{|i|
		a=steps[i];
		arr=arr.put(a,in);
	});
	// inserta valor default en los espacios vacios
	 arr.collect({|item,i|
	 	if(item == nil,{
		arr.put(i,default);
	 	});
	 });
	//
	arr;
};
);
~pat_arr.value(50,52,[0,2,3,5,9,13,17,21]);
//
y = [4, 1, 4, 3, 4, 5, 6, 7, 8, 9];
y.putEach([4, 7], [\smelly, \head]);
y.putEach([2, 3, 5, 6], \wotsits);
//
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


/*~checkbombo[2].value = 1;*/