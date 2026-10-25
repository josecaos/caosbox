//////////////////////////////////////////////////
//CaosBox v2.1.1 Main Instrument sequencer and steps
//////////////////////////////////////////////////
(//orden de ejecucion
Tdef(\secuencias,{
	var reset;
	//master
	~cbox_mast=Synth(\master);
	// fx
	~cbox_mastrev=Synth(\aux1);
	~cbox_mastdel=Synth(\aux2);
	~cbox_mastpit=Synth(\aux3);
	//Filtros
	~cbox_mastlowf=Synth(\lowfilt);
	~cbox_masthighf=Synth(\highfilt);
	~cbox_mastbandf=Synth(\bandfilt);
	//granulador
	~cbox_grains=Synth(\granulador);
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
		// percussions: the step holds the function captured when it was set
		~cbox_tracks[\kick].at(~cbox_indice).play;
		~cbox_tracks[\snare].at(~cbox_indice).play;
		~cbox_tracks[\hihats].at(~cbox_indice).play;
		~cbox_tracks[\kick2].at(~cbox_indice).play;
		~cbox_tracks[\snare2].at(~cbox_indice).play;
		~cbox_tracks[\hihats2].at(~cbox_indice).play;
		// melodic lines: each track advances its note stream and triggers its voice
		~cbox_tracks[\bass].step(~cbox_indice);
		~cbox_tracks[\bass2].step(~cbox_indice);
		~cbox_tracks[\amb].step(~cbox_indice);
		~cbox_tracks[\amb2].step(~cbox_indice);
		~cbox_tracks[\chords].step(~cbox_indice);
		~cbox_tracks[\chords2].step(~cbox_indice);
		~cbox_tracks[\in].step(~cbox_indice);
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
