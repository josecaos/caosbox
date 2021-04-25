//////////////////////////////////////////////////
//CaosBox v1.1 Main Instrument sequencer and steps
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
		// percussion runs as functions
		~cbox_bombo[~cbox_indice].play;
		~cbox_tarola[~cbox_indice].play;
		~cbox_contras[~cbox_indice].play;
		~cbox_bombo2[~cbox_indice].play;
		~cbox_tarola2[~cbox_indice].play;
		~cbox_contras2[~cbox_indice].play;
		// synths run as realtime
		//bass
		{
		if(~cbox_checkbajo[~cbox_indice].value == true,//si el checkbox esta encendico
			{
				~cbox_bajo_seq.put(~cbox_indice,~cbox_bass);//sonido default
				~cbox_bajo_seq[~cbox_indice].set(// aplica valores al indice del array
					\gate,1,
					\att,~cbox_bass1attknob.value,
					\rel,~cbox_bass1relknob.value
					);
					~cbox_sintetizadores.value(\bass);//asigna synthdef a la variable del bajo
					~cbox_bajo_seq.put(~cbox_indice,~cbox_bass);// hace sonar el paso
		},{
			~cbox_checkbajo[~cbox_indice].value == false;
			~cbox_bajo_seq.put(~cbox_indice, nil);
			});
		}.defer(0.01);
		// bass2
		if(~cbox_bajo_seq2[~cbox_indice] == nil,{nil},
			{~cbox_bajo_seq2[~cbox_indice].set(
				\gate,1,
				\att,~cbox_bass2attknob.value,
				\rel,~cbox_bass2relknob.value);
			~cbox_bajo_seq2.put(~cbox_indice,~cbox_bass2=Synth(\bajodos))});
		// amb
		if(~cbox_ambiente[~cbox_indice] == nil,{nil},
			{~cbox_ambiente[~cbox_indice].set(
				\gate,1,
				\att,~cbox_amb1attknob.value,
				\rel,~cbox_amb1relknob.value);
			~cbox_ambiente.put(~cbox_indice,~cbox_amb=Synth(\ambuno))
		});
		// amb2
		if(~cbox_ambiente2[~cbox_indice] == nil,{nil},
			{~cbox_ambiente2[~cbox_indice].set(
				\gate,1,
				\att,~cbox_amb2attknob.value,
				\rel,~cbox_amb2relknob.value);
			~cbox_ambiente2.put(~cbox_indice,~cbox_amb2=Synth(\ambdos))});
		// chords
		if(~cbox_sinte[~cbox_indice] == nil,{nil},
			{~cbox_sinte[~cbox_indice].set(
				\gate,1,
				\att,~cbox_sinte1attknob.value,
				\rel,~cbox_sinte1relknob.value);
			~cbox_sinte.put(~cbox_indice,~cbox_chord=Synth(\acordesuno))});
		// chords2
		if(~cbox_sinte2[~cbox_indice] == nil,{nil},
			{~cbox_sinte2[~cbox_indice].set(
				\gate,1,
				\att,~cbox_sinte2attknob.value,
				\rel,~cbox_sinte2relknob.value);
			~cbox_sinte2.put(~cbox_indice,~cbox_chord2=Synth(\acordesdos))});
		// in
		if(~cbox_in[~cbox_indice] == nil,{nil},
			{~cbox_in[~cbox_indice].set(
				\gate,1,
				\att,~cbox_inattknob.value,
				\rel,~cbox_inrelknob.value);
			~cbox_in.put(~cbox_indice,~cbox_entrada=Synth(\ent))});
		////
		~cbox_tiempos.wait;
		//
		~cbox_indice = ~cbox_indice+1;
	}.loop;
});
//tiempo random
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
~cbox_gmast=Group.head;
~cbox_gaux=Group.before(~cbox_gmast);
~cbox_gfilt=Group.before(~cbox_gaux);
~cbox_ginst=Group.before(~cbox_gfilt);
*/
//nodos
//master var
~cbox_mast=Synth.head(~cbox_gmast,\master);
// fx
~cbox_mastrev=Synth.head(~cbox_gaux,\aux1);
~cbox_mastdel=Synth.before(~cbox_mastrev,\aux2);
~cbox_mastpit=Synth.before(~cbox_mastdel,\aux3);
//Filtros
~cbox_mastlowf=Synth.head(~cbox_gfilt,\lowfilt);
~cbox_masthighf=Synth.before(~cbox_mastlowf,\highfilt);
~cbox_mastbandf=Synth.before(~cbox_masthighf,\bandfilt);
//granulador
~cbox_grains=Synth.before(~cbox_mastbandf,\granulador);
*/
