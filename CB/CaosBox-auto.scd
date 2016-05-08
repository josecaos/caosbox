//written by @joseCao5
///////////////////////////////////////////
////fader AUTOMATION
//valores automatizacion //se tiene que evaluar de nuevo el Tdef que contiene estas variables para que cambie
/*
~autoreverbmix=[0.1,0.5];
~autodelaytime=[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.05);
*/
//automation seqs
(
Tdef(\autor,{
		 var revmix,univar;
		 	revmix=Prand(~autoreverbmix,inf).asStream;//
		 {
		 univar=revmix.resume;
		 ~mastrev.set(\mix,univar);//reverb mix
		{~numr.value=univar;~auxrfader.value=univar}.defer(0.1);//reverb mix GUI update
		 ~tiempos/~divrev.wait;
		 }.loop;
}).quant_(4)
);
(
Tdef(\autod,{
		 var deltm,univar;
		 deltm=Prand(~autodelaytime,inf).asStream;//delay time
	 	{
	 	univar=deltm.resume;
		 ~mastdel.set(\deltime,univar);//delay time
		{~numt.value=univar;~auxtfader.value=univar}.defer(0.1);//delay time GUI update
		 ~tiempos/~divdel.wait;
		 }.loop;
}).quant_(4)
);
(
Tdef(\autop,{
		 var pitrat,pitdisp,univar,univar1;
		 pitrat=Prand(~autopitchrate,inf).asStream;//pitch rate
		pitdisp=Prand(~autopitchdispersion,inf).asStream;//pitch dispersion
		{
		univar=pitrat.resume;
		univar1=pitdisp.resume;
 	     ~mastpit.set(\rate,univar);//pitch rate
     	 ~mastpit.set(\pitchDispersion,univar1);//pitch rate
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
