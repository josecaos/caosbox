////FX fader Automation
/*
//Automation values
/*Re-evaluate the sequence containing the updated array*/

~autoreverbmix=[0.1,0.5];
~autodelaytime=[0.02,0.04,0.06,0.08,0.1];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.05);

*/
//automation seqs
(
Tdef(\autor,{
	var revmix,univar;
	revmix=Prand(~autoreverbmix,inf).asStream;
	{
		univar=revmix.resume;
		~mastrev.set(\mix,univar);
		{~numr.value=univar;~auxrfader.value=univar}.defer(0.1);
		~tiempos/~divrev.wait;
	}.loop;
}).quant_(4)
);
(
Tdef(\autod,{
	var deltm,univar;
	deltm=Prand(~autodelaytime,inf).asStream;
	{
		univar=deltm.resume;
		~mastdel.set(\deltime,univar);
		{~numt.value=univar;~auxtfader.value=univar}.defer(0.1);
		~tiempos/~divdel.wait;
	}.loop;
}).quant_(4)
);
(
Tdef(\autop,{
	var pitrat,pitdisp,univar,univar1;
	pitrat=Prand(~autopitchrate,inf).asStream;
	pitdisp=Prand(~autopitchdispersion,inf).asStream;
	{
		univar=pitrat.resume;
		univar1=pitdisp.resume;
		~mastpit.set(\rate,univar);
		~mastpit.set(\pitchDispersion,univar1);
		{~nump.value=univar;~auxpfader.value=univar.next/4;
			~numpd.value=univar1.next;~auxpdfader.value=univar1;
		}.defer(0.1);//pitch rate GUI update
		~tiempos/~divpitch.wait;
	}.loop;
}).quant_(4)
);
//grains
(
Tdef(\autog,{
	var univar, univar1;
	var trig=Pseq(~autograintrig.scramble,inf).asStream;
	var siz=Pseq(~autograinsize.scramble,inf).asStream;
	{
		univar=trig.resume;
		univar1=siz.resume;
		~grains.set(\trigger,univar);
		~grains.set(\size,univar1);
		{~grains.set(\trigger,~gfaders.x_(univar));~grains.set(\size,~gfaders.y_(univar1))}.defer(0.1);
		~tiempos/~divgrain.wait;
	}.loop;
})
);