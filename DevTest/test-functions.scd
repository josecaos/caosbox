(
~outputs = {|args = #[52,54,56]|
	var arr = Array.newClear(args.size);
	var outs;
	for(0,args.size-1,{|i|
		outs = arr.put(i,args[i]);
	});
	outs.scramble.postcln;
};
);
~outputs.value([52,54,56]);
~outputs.value;
(
Tdef(\test1,{
	var out=Prand([1,2,3,4,5,6,7,8,9],inf).asStream;
	inf.do({
		out.next.postcln;
		"will miss you grandma".postcln;
		0.25.wait;
	});
});
Tdef(\test1).play;
);
~outputs.def