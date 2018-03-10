////FX fader Automation
/*
//Automation values
/*Re-evaluate the sequence containing the updated array*/
132/4
~autoreverbmix=[0.1,0.5];
~autodelaytime=[0.02,0.04,0.06,0.08,0.1];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.02);

*/
//automation seqs
(
Tdef(\autor,{
	var revmix,revroom,revdamp,univar;
	revmix=Prand(~autoreverbmix,inf).asStream;
	revroom=Prand(~autoreverbroom,inf).asStream;
	revdamp=Prand(~autoreverbdamp,inf).asStream;
	{
		univar=[revmix.resume,revroom.resume,revdamp.resume];
		~mastrev.set(\mix,univar[0]);
		~mastrev.set(\room,univar[1]);
		~mastrev.set(\damp,univar[2]);
		{
			~numr.value=univar[0];~auxrfader.value=univar[0];
			~numroom.value=univar[1];~auxroomfader.value=univar[1];
			~numd.value=univar[2];~auxdfader.value=univar[2]
		}.defer(0.1);
		~tiempos/~divrev.wait;
	}.loop;
}).quant_(4)
);
(
Tdef(\autod,{
	var deltm,delf,univar;
	deltm=Prand(~autodelaytime,inf).asStream;
	delf=Prand(~autodelayfeed,inf).asStream;
	{
		univar=[deltm.resume,delf.resume];
		~mastdel.set(\deltime,univar[0]);
		~mastdel.set(\feedback,univar[1]);
		{
			~numt.value=univar[0];~auxtfader.value=univar[0];
			~numf.value=univar[1];~auxffader.value=univar[1]
		}.defer(0.1);
		~tiempos/~divdel.wait;
	}.loop;
}).quant_(4)
);
(
Tdef(\autop,{
	var pitrat,pitdisp,pittdisp,univar;
	pitrat=Prand(~autopitchrate,inf).asStream;
	pitdisp=Prand(~autopitchdispersion,inf).asStream;
	pittdisp=Prand(~autotimedispersion,inf).asStream;
	{
		univar=[pitrat.resume,pitdisp.resume,pittdisp.resume];
		~mastpit.set(\rate,univar[0]);
		~mastpit.set(\pitchDispersion,univar[1]);
		~mastpit.set(\timeDispersion,univar[2]);
		{
			~nump.value=univar[0];~auxpfader.value=univar[0]/4;
			~numpd.value=univar[1];~auxpdfader.value=univar[1];
			~numtd.value=univar[2];~auxtdfader.value=univar[2];
		}.defer(0.1);
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