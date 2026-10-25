CaosGear : CaosBox {

	var <instance_id;
	var <instrument;
	classvar <>custom_bass,<>custom_bass2,<>custom_pad,<>custom_pad2,<>custom_chords,<>custom_guitchords;

	*new {

		^super.new;

	}

	melody {|scaleArray=#[0,3,7,11], index=60|

		if(scaleArray.isArray, {

			^scaleArray + index;

		},{

			^"Please use an array with degrees, 'Scale.mayor.degrees' can be useful";

		});

	}

	kick {|out=50,att=0.01,rel=0.25,modFreq=2,modbw=0.25,freq1=60,freq2=52,lowcutfreq=45,gate=1,amp1=1,amp2=0.25,pan=0|

		~cbox_b = {
			var signal;
			signal = CaosKick.ar(att,rel,modFreq,modbw,freq1,freq2,lowcutfreq,gate,amp1,amp2,pan);
			Out.ar(out,signal);
		};

		^this.prPercussion(\kick, ~cbox_b, "Kick");
	}

	kickCustom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		if(ugenFunc != nil,{

			~cbox_b = {
				var signal;
				signal = CaosKick.customSignal(ugenFunc,att,rel,pan);
				Out.ar(out,signal);
			};

		^this.prPercussion(\kick, ~cbox_b, "Kick");

		},{

			^"'func' argument is required";

		});

	}

	kick2 {|out=50,att=0.01,rel=0.5,modFreq=2,modbw=0.5,bw=0.2,freq1=60,freq2=64,lowcutfreq=45,gate=1,amp=0.15,pan=0|

		~cbox_b2 = {

			var signal;
			signal = CaosKick2.ar(att,rel,modFreq,modbw,bw,freq1,freq2,lowcutfreq,gate,amp,pan);
			Out.ar(out,signal);

		};

		^this.prPercussion(\kick2, ~cbox_b2, "Kick2");

	}

	kick2Custom {|ugenFunc,out=50,att=0.01,rel=0.2,pan=0|

		if(ugenFunc != nil,{
			~cbox_b2 = {
				var signal;
				signal = CaosKick2.customSignal(ugenFunc,att,rel,pan);
				Out.ar(out,signal);

			};

		^this.prPercussion(\kick2, ~cbox_b2, "Kick2");
		});

	}

	snare {|out=50,att=0.01,rel=0.25,highcutfreq=360,rq=0.25,gate=1,amp1=0.35,amp2=0.1,pan=0|

		~cbox_t = {
			var signal;
			signal = CaosSnare.ar(att,rel,highcutfreq,rq,gate,amp1,amp2,pan);
			Out.ar(out,signal);
		};

		^this.prPercussion(\snare, ~cbox_t, "Snare");

	}

	snareCustom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		if(ugenFunc != nil,{

			~cbox_t = {
				var signal;
				signal = CaosSnare.customSignal(ugenFunc,att,rel,pan);
				Out.ar(out,signal);
			};

		^this.prPercussion(\snare, ~cbox_t, "Snare");

		},{

			^"'func' argument is required";

		});

	}

	snare2 {|out=50,att=0.01,rel=0.25,iphase=0.03,bw=0.5,highcutfreq=360,rq=0.25,gate=1,amp1=0.35,amp2=0.25,pan=0|
		~cbox_t2 = {
			var signal;
			signal = CaosSnare2.ar(att,rel,iphase,bw,highcutfreq,rq,gate,amp1,amp2,pan);
			Out.ar(out,signal);
		};
		^this.prPercussion(\snare2, ~cbox_t2, "Snare2");

	}

	snare2Custom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		~cbox_t2 = {
			var signal;
			signal = CaosSnare2.customSignal(ugenFunc,att,rel,pan);
			Out.ar(out,signal);
		};

		^this.prPercussion(\snare2, ~cbox_t2, "Snare2");

	}

	hihats {|out=50,att=0.01,rel=0.1,highcutfreq=8330,rq=0.15,gate=1,amp1=0.9,amp2=0.9,pan=0|
		~cbox_h = {
			var signal;
			signal = CaosHats.ar(att,rel,highcutfreq,rq,gate,amp1,amp2);
			Out.ar(out,signal);
		};//
		^this.prPercussion(\hihats, ~cbox_h, "HiHats");
	}

	hihatsCustom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		~cbox_h = {
			var signal;
			signal = CaosHats.customSignal(ugenFunc,out,att,rel,pan);
			Out.ar(out,signal);
		};//

		^this.prPercussion(\hihats, ~cbox_h, "HiHats");

	}

	hihats2 {|out=50,att=0.01,rel=0.1,highcutfreq=12330,rq=0.5,gate=1,amp1=0.9,amp2=0.9,pan=0|

		~cbox_h2 = {
			var signal;
			signal = CaosHats2.ar(att,rel,highcutfreq,rq,gate,amp1,amp2);
			Out.ar(out,signal);
		};//
		^this.prPercussion(\hihats2, ~cbox_h2, "HiHats2");
	}

	hihats2Custom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		~cbox_h2 = {
			var signal;
			signal = CaosHats2.customSignal(ugenFunc,out,att,rel,pan);
			Out.ar(out,signal);
		};//
		^this.prPercussion(\hihats2, ~cbox_h2, "HiHats2");
	}

	// Synths
	// Melodic instruments: a CaosInstrument owns the voice, the params and the
	// note stream. The sequencer only advances/triggers it; there are no Tdefs.

	prNoteOrder {|seqType|

		if(seqType == 'rand', { ^\rand });
		if(seqType == 'seq', { ^\seq });

		("Unknown seqType" + seqType + ", using 'seq'").inform;
		^\seq;

	}

	prRegister {|track, voice, id|

		if(~cbox_instruments.isNil, { ~cbox_instruments = Dictionary.new });

		~cbox_instruments.put(track, voice);
		~cbox_tracks[track].setInstrument(voice);
		instrument = voice;
		instance_id = id;

		^voice;

	}

	// percusion: los steps guardan la funcion (snapshot); el instrumento es el
	// handle que sabe a que pista pertenece y con que funcion suena
	prPercussion {|track, func, id|

		var voice;

		if(func.isNil, { ^("CaosGear: nothing to track for" + id).inform });

		voice = CaosInstrument.percussion(id.asSymbol, track, func, this.prInstrumentGroup);

		if(~cbox_instruments.isNil, { ~cbox_instruments = Dictionary.new });
		~cbox_instruments.put(track, voice);
		// la percusion toca funciones guardadas en el step: el grupo va en la pista
		~cbox_tracks[track].target = this.prInstrumentGroup;

		instrument = voice;
		instance_id = id;

		^voice;

	}

	// grupo de instrumentos del engine (nil sin engine: tests)
	prInstrumentGroup {

		^CaosBox.engine !? { |eng| eng.groupID(\instruments) };

	}

	bass {|out=50, semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60], seqType='seq',
		att=0.01, rel=0.5, filtMinFreq=45, filtMaxFreq=12420, filtTime=0.125,
		rq=0.25, iphase=0.5, amp1=0.5, amp2=0.5, pan=0, retrigger=true|

		var instrument;

		instrument = CaosInstrument.synth(\bass, \bass, \bajouno, CaosBox.resolveOut(out.asArray.first),
			(
				doneAction: 2,// free al soltar gate (1 = pause y deja el nodo colgado)
				att: att, rel: rel,
				filtminf: filtMinFreq, filtmaxf: filtMaxFreq, filtime: filtTime,
				rq: rq, iphase: iphase, amp1: amp1, amp2: amp2, pan: pan
			),
			semitoneArray.asArray, \free, nil, retrigger, this.prNoteOrder(seqType), oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\bass, instrument, "Bass");

	}

	bassCustom {|ugenFunc=nil, out=50, semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60],
		seqType='seq', att=0.01, rel=0.5, pan=0|

		"bassCustom: custom UGen functions are not supported yet, using \bajouno".warn;

		^this.bass(out, semitoneArray, seqType, att, rel, 45, 12420, 0.125,
			0.25, 0.5, 0.5, 0.5, pan);

	}

	bass2 {|out=50, semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60], seqType='seq',
		att=0.01, rel=0.5, filtTrig=4, filtMinFreq=45, filtMaxFreq=12420,
		filtTime=0.25, rq=0.5, bw=0.5, iphase=0.5, amp1=0.5, amp2=0.5, pan=0, retrigger=true|

		var instrument;

		instrument = CaosInstrument.synth(\bass2, \bass2, \bajodos, CaosBox.resolveOut(out.asArray.first),
			(
				doneAction: 2,// free al soltar gate (1 = pause y deja el nodo colgado)
				att: att, rel: rel, trig: filtTrig,
				filtminf: filtMinFreq, filtmaxf: filtMaxFreq, filtime: filtTime,
				rq: rq, bandw: bw, iphase: iphase, amp1: amp1, amp2: amp2, pan: pan
			),
			semitoneArray.asArray, \free, nil, retrigger, this.prNoteOrder(seqType), oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\bass2, instrument, "Bass2");

	}

	pad {|out=50, semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60], seqType='seq',
		waveform='sin', att=0.25, rel=1, semi=0, iphase=0, cutf=8920, rq=0.85,
		gate=0, amp=0.75, pan=0, retrigger=false|

		var instrument;

		instrument = CaosInstrument.synth(\pad, \amb, \ambuno, CaosBox.resolveOut(out.asArray.first),
			(
				att: att, rel: rel, semi: semi, iphase: iphase,
				cutf: cutf, rq: rq, amp: amp, pan: pan
			),
			semitoneArray.asArray, \free, nil, retrigger, this.prNoteOrder(seqType), oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\amb, instrument, "Amb");

	}

	pad2 {|out=50, semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60], seqType='seq',
		att=0.25, rel=1, maxNote=60, fm=0.125, harm=1, amp1=0.5, amp2=0.5, pan=0,
		retrigger=false|

		var instrument;

		instrument = CaosInstrument.synth(\pad2, \amb2, \ambdos, CaosBox.resolveOut(out.asArray.first),
			(
				att: att, rel: rel, maxNote: maxNote, fm: fm, harm: harm,
				amp1: amp1, amp2: amp2, pan: pan
			),
			semitoneArray.asArray, \free, nil, retrigger, this.prNoteOrder(seqType), oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\amb2, instrument, "Amb2");

	}

	chords {|out=50, semitoneArray=#[48, 50, 52, 53, 55, 57, 59], seqType='seq',
		chordsArray=#['Mmaj7', 'M', 'm'], att=0.05, rel=1, iphase=0.025,
		width=0.1, cutf=1200, rq=0.5, pan=0, amp=0.5, retrigger=true|

		var instrument;

		instrument = CaosInstrument.synth(\chords, \chords, \acordesuno, CaosBox.resolveOut(out.asArray.first),
			(
				att: att, rel: rel, iphase: iphase, width: width,
				cutf: cutf, rq: rq, pan: pan, amp: amp
			),
			semitoneArray.asArray, \free, nil, retrigger, this.prNoteOrder(seqType), oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\chords, instrument, "Chords");

	}

	chords2 {|out=#[50], semitoneArray=#[0, 2, 4, 5, 7, 9, 11], seqType='seq',
		chordsArray=#['Mmaj7'], att=0.05, rel=1, iphase=0.025,
		width=0.1, cutf=1200, rq=0.5, pan=0, amp=0.5, retrigger=true|

		var instrument;

		instrument = CaosInstrument.synth(\chords2, \chords2, \acordesdos, CaosBox.resolveOut(out.asArray.first),
			(
				att: att, rel: rel, iphase: iphase, width: width,
				cutf: cutf, rq: rq, pan: pan, amp: amp
			),
			semitoneArray.asArray, \free, nil, retrigger, this.prNoteOrder(seqType), oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\chords2, instrument, "Chords2");

	}

	lineIn {|out=50, inchan=0, att=0.05, rel=0.5, retrigger=true|

		var instrument;

		instrument = CaosInstrument.synth(\lineIn, \in, \entrada, CaosBox.resolveOut(out.asArray.first),
			(inchan: inchan, att: att, rel: rel),
			nil, \free, nil, retrigger, \seq, oneShot: true, target: this.prInstrumentGroup);

		^this.prRegister(\in, instrument, "LineIn");

	}

	toTrack {|steps = 0, overrideSteps = false|

		var track;

		if(instrument.isNil, {
			^"CaosGear: create an instrument first (shot, pad, ...)".inform;
		});

		track = instrument.track;
		CaosBox.setSteps(track, steps, overrideSteps);

		^"CaosGear: " + instance_id + " instance added to sequencer";

	}

	// sin argumentos saca la pista completa
	offTrack {|steps|

		var track;

		if(instrument.isNil, {
			^"CaosGear: create an instrument first (shot, pad, ...)".inform;
		});

		track = instrument.track;
		CaosBox.clearSteps(track, steps);

		^"CaosGear Instance deleted from sequencer";

	}

	*customOn {|on=false|

		^~cbox_custom  = on;

	}
}
