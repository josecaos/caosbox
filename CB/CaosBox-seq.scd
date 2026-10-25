//////////////////////////////////////////////////
//CaosBox v2.1.1 Main Instrument sequencer and steps
//////////////////////////////////////////////////
(//orden de ejecucion
Tdef(\secuencias,{
	var reset, eng;
	eng = CaosBox.engine;
	//master (dentro de su grupo; lee el bus \master)
	~cbox_mast=Synth(\master,
		[\inbus, eng.busIndex(\master), \out, 0],
		eng.groupID(\master));
	// fx (grupo fx; entran por su bus y salen al master)
	~cbox_mastrev=Synth(\aux1,
		[\inbus, eng.busIndex(\reverb), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	~cbox_mastdel=Synth(\aux2,
		[\inbus, eng.busIndex(\delay), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	~cbox_mastpit=Synth(\aux3,
		[\inbus, eng.busIndex(\pitch), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	//Filtros
	~cbox_mastlowf=Synth(\lowfilt,
		[\inbus, eng.busIndex(\lpf), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	~cbox_masthighf=Synth(\highfilt,
		[\inbus, eng.busIndex(\hpf), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	~cbox_mastbandf=Synth(\bandfilt,
		[\inbus, eng.busIndex(\bpf), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	//granulador
	~cbox_grains=Synth(\granulador,
		[\inbus, eng.busIndex(\grains), \out, eng.busIndex(\master)],
		eng.groupID(\fx));
	//
	{
		//guia led steps
		if(~cbox_indice >= 32,{~cbox_indice=0},{nil});
		if(~cbox_indice == 0,{reset = 31},{reset = ~cbox_indice-1});
		{
			switch(~cbox_indice,
				~cbox_indice,{~cbox_lightsteps[~cbox_indice].value = 1;~cbox_lightsteps[reset].value = 0}
			)
		}.defer(0.01);
		// cada pista despacha su step: percusion toca la funcion guardada,
		// melodicos avanzan su linea y disparan la voz
		~cbox_tracks.do { |track| track.step(~cbox_indice) };
		//// end instruments
		~cbox_tiempos.wait;

		~cbox_indice = ~cbox_indice+1;

	}.loop;
});
//random time
Tdef(\randtime,{
	{
		var timer=Prand(~cbox_randtimes,inf).asStream;
		TempoClock.tempo=timer.next/60;
		~cbox_tiempos.wait;
	}.loop;
});
);
//
/*
//s.queryAllNodes
/*
// TODO:  terminar bien el orden de ejecucion por grupos
~cbox_gmast=Group.head;
~cbox_gaux=Group.before(~cbox_gmast);
~cbox_gfilt=Group.before(~cbox_gaux);
~cbox_ginst=Group.before(~cbox_gfilt);
*/
//nodos
//master var
//~cbox_mast=Synth.head(~cbox_gmast,\master);
//// fx
//~cbox_mastrev=Synth.head(~cbox_gaux,\aux1);
//~cbox_mastdel=Synth.before(~cbox_mastrev,\aux2);
//~cbox_mastpit=Synth.before(~cbox_mastdel,\aux3);
////Filtros
//~cbox_mastlowf=Synth.head(~cbox_gfilt,\lowfilt);
//~cbox_masthighf=Synth.before(~cbox_mastlowf,\highfilt);
//~cbox_mastbandf=Synth.before(~cbox_masthighf,\bandfilt);
////granulador
//~cbox_grains=Synth.before(~cbox_mastbandf,\granulador);
