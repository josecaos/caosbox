////FX fader Automation
//automation seqs
(
Tdef(\autor,{
	var revmix,revroom,revdamp,univar;
	revmix=Prand(~cbox_autoreverbmix,inf).asStream;
	revroom=Prand(~cbox_autoreverbroom,inf).asStream;
	revdamp=Prand(~cbox_autoreverbdamp,inf).asStream;
	{
		univar=[revmix.resume,revroom.resume,revdamp.resume];
		~cbox_mastrev.set(\mix,univar[0]);
		~cbox_mastrev.set(\room,univar[1]);
		~cbox_mastrev.set(\damp,univar[2]);
		{
			~cbox_numr.value=univar[0];~cbox_auxrfader.value=univar[0];
			~cbox_numroom.value=univar[1];~cbox_auxroomfader.value=univar[1];
			~cbox_numd.value=univar[2];~cbox_auxdfader.value=univar[2]
		}.defer(0.1);
		~cbox_tiempos/~cbox_divrev.wait;
	}.loop;
}).quant_(4)
);
(
Tdef(\autod,{
	var deltm,delf,univar;
	deltm=Prand(~cbox_autodelaytime,inf).asStream;
	delf=Prand(~cbox_autodelayfeed,inf).asStream;
	{
		univar=[deltm.resume,delf.resume];
		~cbox_mastdel.set(\deltime,univar[0]);
		~cbox_mastdel.set(\feedback,univar[1]);
		{
			~cbox_numt.value=univar[0];~cbox_auxtfader.value=univar[0];
			~cbox_numf.value=univar[1];~cbox_auxffader.value=univar[1]
		}.defer(0.1);
		~cbox_tiempos/~cbox_divdel.wait;
	}.loop;
}).quant_(4)
);
(
Tdef(\autop,{
	var pitrat,pitdisp,pittdisp,univar;
	pitrat=Prand(~cbox_autopitchrate,inf).asStream;
	pitdisp=Prand(~cbox_autopitchdispersion,inf).asStream;
	pittdisp=Prand(~cbox_autotimedispersion,inf).asStream;
	{
		univar=[pitrat.resume,pitdisp.resume,pittdisp.resume];
		~cbox_mastpit.set(\rate,univar[0]);
		~cbox_mastpit.set(\pitchDispersion,univar[1]);
		~cbox_mastpit.set(\timeDispersion,univar[2]);
		{
			~cbox_nump.value=univar[0];~cbox_auxpfader.value=univar[0]/4;
			~cbox_numpd.value=univar[1];~cbox_auxpdfader.value=univar[1];
			~cbox_numtd.value=univar[2];~cbox_auxtdfader.value=univar[2];
		}.defer(0.1);
		~cbox_tiempos/~cbox_divpitch.wait;
	}.loop;
}).quant_(4)
);
//grains
(
Tdef(\autog,{
	var univar;
	var trig=Pseq(~cbox_autograintrig.scramble,inf).asStream;
	var size=Pseq(~cbox_autograinsize.scramble,inf).asStream;
	{
		univar=[trig.resume,size.resume];
		~cbox_grains.set(\trigger,univar[0]);
		~cbox_grains.set(\size,univar[1]);
		{
			~cbox_grains.set(\trigger,~cbox_gfaders.x_(univar[0]));~cbox_grains.set(\size,~cbox_gfaders.y_(univar[1]))
		}.defer(0.1);
		~cbox_tiempos/~cbox_divgrain.wait;
	}.loop;
})
);