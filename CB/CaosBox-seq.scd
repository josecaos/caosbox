//////////////////////////////////////////////////
//CaosBox v2.1.5 Main sequencer
//
// El tiempo vive en ~cbox_seq (CaosSequencer). Aca solo se define:
//   step:    que pasa en cada paso (LED + pistas)
//   prepare: las voces fijas del engine (master, fx, filtros), una sola vez
//////////////////////////////////////////////////
(
~cbox_seq = CaosSequencer.new(
	step: { |index|
		var last;
		// guia led steps
		last = if(index == 0, { 31 }, { index - 1 });
		{
			~cbox_lightsteps[index].value = 1;
			~cbox_lightsteps[last].value = 0;
			CaosBox.gui.playhead(index);// la rejilla nueva dibuja su columna
		}.defer(0.01);
		// cada pista despacha su step: percusion toca la funcion guardada,
		// melodicos avanzan su linea y disparan la voz
		~cbox_tracks.do { |track| track.step(index) };
	},
	prepare: { |seq|
		var eng = CaosBox.engine;
		//master (dentro de su grupo; lee el bus \master)
		~cbox_mast = Synth(\master,
			[\inbus, eng.busIndex(\master), \out, 0],
			eng.groupID(\master));
		// fx (grupo fx; entran por su bus y salen al master)
		~cbox_mastrev = Synth(\aux1,
			[\inbus, eng.busIndex(\reverb), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
		~cbox_mastdel = Synth(\aux2,
			[\inbus, eng.busIndex(\delay), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
		~cbox_mastpit = Synth(\aux3,
			[\inbus, eng.busIndex(\pitch), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
		//Filtros
		~cbox_mastlowf = Synth(\lowfilt,
			[\inbus, eng.busIndex(\lpf), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
		~cbox_masthighf = Synth(\highfilt,
			[\inbus, eng.busIndex(\hpf), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
		~cbox_mastbandf = Synth(\bandfilt,
			[\inbus, eng.busIndex(\bpf), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
		//granulador
		~cbox_grains = Synth(\granulador,
			[\inbus, eng.busIndex(\grains), \out, eng.busIndex(\master)],
			eng.groupID(\fx));
	},
	size: 32,
	bpm: 126,
	stepDur: 0.25,
	randtimes: ~cbox_randtimes
);

// el numbox de BPM sigue al tempo (tambien en random time)
~cbox_seq.onTempoChange = {|value|
	{ ~cbox_numclock !? {|num| num.value_(value)} }.defer;
};
);
