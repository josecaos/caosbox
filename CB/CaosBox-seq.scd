//////////////////////////////////////////////////
//CaosBox v1.1 Main Instrument sequencer and steps
//////////////////////////////////////////////////
(//orden de ejecucion
Tdef(\secuencias,{
	var reset;
	//master
	~mast=Synth(\master);
	// fx
	~mastrev=Synth(\aux1);
	~mastdel=Synth(\aux2);
	~mastpit=Synth(\aux3);
	//Filtros
	~mastlowf=Synth(\lowfilt);
	~masthighf=Synth(\highfilt);
	~mastbandf=Synth(\bandfilt);
	//granulador
	~grains=Synth(\granulador);
	//
	// ~kickgear=Synth(\kickgear);
	{
		//guide light steps
		if(~indice == 32,{~indice=0},{nil});
		// elimina el step anterior
		if(~indice == 0,{reset = 31},{reset = ~indice-1});
		{switch(~indice,
			~indice,{~lightsteps[~indice].value = 1;~lightsteps[reset].value = 0},
		)
		}.defer(0.01);
		//
		~bombo[~indice].play;
		// if(~bombo[~indice] == nil,{nil},{~bombo[~indice].set(\gate,1);~bombo.put(~indice,~kickgear)});
		~tarola[~indice].play;
		~contras[~indice].play;
		~bombo2[~indice].play;
		~tarola2[~indice].play;
		~contras2[~indice].play;
		//
		// if(~bajo[~indice].isNil,{nil},{~bajo.put(~indice,~bass=Synth(\bajouno));~bajo[~indice].set(\gate,1,\att,~bass1attknob.value,\rel,~bass1relknob.value)});
		if(~bajo[~indice] == nil,{nil},{~bajo[~indice].set(\gate,1,\att,~bass1attknob.value,\rel,~bass1relknob.value);~bajo.put(~indice,~bass=Synth(\bajouno))});
		if(~bajo2[~indice] == nil,{nil},
			{~bajo2[~indice].set(\gate,1,\att,~bass2attknob.value,\rel,~bass2relknob.value);~bajo2.put(~indice,~bass2=Synth(\bajodos))});
		if(~ambiente[~indice] == nil,{nil},
			{~ambiente[~indice].set(\gate,1,\att,~amb1attknob.value,\rel,~amb1relknob.value);~ambiente.put(~indice,~amb=Synth(\ambuno))});
		if(~ambiente2[~indice] == nil,{nil},
			{~ambiente2[~indice].set(\gate,1,\att,~amb2attknob.value,\rel,~amb2relknob.value);~ambiente2.put(~indice,~amb2=Synth(\ambdos))});
		if(~sinte[~indice] == nil,{nil},
			{~sinte[~indice].set(\gate,1,\att,~sinte1attknob.value,\rel,~sinte1relknob.value);~sinte.put(~indice,~chord=Synth(\acordesuno))});
		if(~sinte2[~indice] == nil,{nil},
			{~sinte2[~indice].set(\gate,1,\att,~sinte2attknob.value,\rel,~sinte2relknob.value);~sinte2.put(~indice,~chord2=Synth(\acordesdos))});
		if(~in[~indice] == nil,{nil},
			{~in[~indice].set(\gate,1,\att,~inattknob.value,\rel,~inrelknob.value);~in.put(~indice,~entrada=Synth(\ent))});
		//
		~indice = ~indice+1;
		////
		~tiempos.wait;
	}.loop;
}).quant_(1);
//tiempo random
Tdef(\randtime,{
	{
		var timer=Prand(~randtimes,inf).asStream;
		TempoClock.tempo=timer.next/60;
		~tiempos.wait;
	}.loop;
}).quant_(1);
);
//
/*
//s.queryAllNodes
/*
~gmast=Group.head;
~gaux=Group.before(~gmast);
~gfilt=Group.before(~gaux);
~ginst=Group.before(~gfilt);
*/
//nodos
//master var
~mast=Synth.head(~gmast,\master);
// fx
~mastrev=Synth.head(~gaux,\aux1);
~mastdel=Synth.before(~mastrev,\aux2);
~mastpit=Synth.before(~mastdel,\aux3);
//Filtros
~mastlowf=Synth.head(~gfilt,\lowfilt);
~masthighf=Synth.before(~mastlowf,\highfilt);
~mastbandf=Synth.before(~masthighf,\bandfilt);
//granulador
~grains=Synth.before(~mastbandf,\granulador);
*/