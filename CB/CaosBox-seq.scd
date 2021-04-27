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
		{
		if(~cbox_checkbajo[~cbox_indice].value == true,//si el checkbox esta encendido
			{
				~cbox_bajo_seq.put(~cbox_indice,~cbox_bass);//sonido default
				~cbox_bajo_seq[~cbox_indice].set(// aplica valores al indice del array
					\gate,1,
					\att,~cbox_bass1attknob.value,
					\rel,~cbox_bass1relknob.value
					);
				~cbox_sintetizadores.value(\bass);//reasigna synthdef a la variable
				~cbox_bajo_seq.put(~cbox_indice,~cbox_bass);// hace sonar el paso
		},{
			~cbox_checkbajo[~cbox_indice].value == false;
			~cbox_bajo_seq.put(~cbox_indice, nil);
			});
		}.defer(0.01);
		//
		{
		if(~cbox_checkbajo2[~cbox_indice].value == true,
			{
				~cbox_bajo_seq2.put(~cbox_indice,~cbox_bass2);
				~cbox_bajo_seq2[~cbox_indice].set(
					\gate,1,
					\att,~cbox_bass2attknob.value,
					\rel,~cbox_bass2relknob.value
					);
					~cbox_sintetizadores.value(\bass2);
					~cbox_bajo_seq2.put(~cbox_indice,~cbox_bass2);
		},{
			~cbox_checkbajo2[~cbox_indice].value == false;
			~cbox_bajo_seq2.put(~cbox_indice, nil);
			});
		}.defer(0.01);
		//
		{
		if(~cbox_checkambiente[~cbox_indice].value == true,
			{
				~cbox_ambiente_seq.put(~cbox_indice,~cbox_amb);
				~cbox_ambiente_seq[~cbox_indice].set(
					\gate,1,
					\att,~cbox_amb1attknob.value,
					\rel,~cbox_amb1relknob.value
					);
					~cbox_sintetizadores.value(\amb);
					~cbox_ambiente_seq.put(~cbox_indice,~cbox_amb);
		},{
			~cbox_checkambiente[~cbox_indice].value == false;
			~cbox_ambiente_seq.put(~cbox_indice, nil);
			});
		}.defer(0.01);
		// amb2
		{
		if(~cbox_checkambiente2[~cbox_indice].value == true,
			{
				~cbox_ambiente_seq2.put(~cbox_indice,~cbox_amb2);
				~cbox_ambiente_seq2[~cbox_indice].set(
					\gate,1,
					\att,~cbox_amb2attknob.value,
					\rel,~cbox_amb2relknob.value
					);
				~cbox_sintetizadores.value(\amb2);
				~cbox_ambiente_seq2.put(~cbox_indice,~cbox_amb2);
		},{
			~cbox_checkambiente2[~cbox_indice].value == false;
			~cbox_ambiente_seq2.put(~cbox_indice, nil);
			});
		}.defer(0.01);
		//
		{
		if(~cbox_checksinte[~cbox_indice].value == true,
			{
				~cbox_sinte_seq.put(~cbox_indice,~cbox_chord);
				~cbox_sinte_seq[~cbox_indice].set(
					\gate,1,
					\att,~cbox_sinte_seq1attknob.value,
					\rel,~cbox_sinte_seq1relknob.value
					);
				~cbox_sintetizadores.value(\chords);
				~cbox_sinte_seq.put(~cbox_indice,~cbox_chord);
		},{
			~cbox_checksinte[~cbox_indice].value == false;
			~cbox_sinte_seq.put(~cbox_indice, nil);
			});
		}.defer(0.01);
		// chords2
		{
		if(~cbox_checksinte2[~cbox_indice].value == true,
			{
				~cbox_sinte_seq2.put(~cbox_indice,~cbox_chord2);
				~cbox_sinte_seq2[~cbox_indice].set(
					\gate,1,
					\att,~cbox_sinte_seq2attknob.value,
					\rel,~cbox_sinte_seq2relknob.value
					);
				~cbox_sintetizadores.value(\chords2);
				~cbox_sinte_seq2.put(~cbox_indice,~cbox_chord2);
		},{
			~cbox_checksinte2[~cbox_indice].value == false;
			~cbox_sinte_seq2.put(~cbox_indice, nil);
			});
		}.defer(0.01);
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
