CaosGear : CaosBox {

	var <instance_id;
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

		instance_id = "Kick";
		^instance_id;
	}

	kickCustom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		if(ugenFunc != nil,{

			~cbox_b = {
				var signal;
				signal = CaosKick.customSignal(ugenFunc,att,rel,pan);
				Out.ar(out,signal);
			};

			instance_id = "Kick";
			^instance_id;

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

		instance_id = "Kick2";
		^instance_id;

	}

	kick2Custom {|ugenFunc,out=50,att=0.01,rel=0.2,pan=0|

		if(ugenFunc != nil,{
			~cbox_b2 = {
				var signal;
				signal = CaosKick2.customSignal(ugenFunc,att,rel,pan);
				Out.ar(out,signal);

			};

			instance_id = "Kick2";
			^instance_id;
		});

	}

	snare {|out=50,att=0.01,rel=0.25,highcutfreq=360,rq=0.25,gate=1,amp1=0.35,amp2=0.1,pan=0|

		~cbox_t = {
			var signal;
			signal = CaosSnare.ar(att,rel,highcutfreq,rq,gate,amp1,amp2,pan);
			Out.ar(out,signal);
		};

		instance_id = "Snare";
		^instance_id;

	}

	snareCustom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		if(ugenFunc != nil,{

			~cbox_t = {
				var signal;
				signal = CaosSnare.customSignal(ugenFunc,att,rel,pan);
				Out.ar(out,signal);
			};

			instance_id = "Snare";
			^instance_id;

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
		instance_id = "Snare2";
		^instance_id;

	}

	snare2Custom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		~cbox_t2 = {
			var signal;
			signal = CaosSnare2.customSignal(ugenFunc,att,rel,pan);
			Out.ar(out,signal);
		};

		instance_id = "Snare2";
		^instance_id;

	}

	hihats {|out=50,att=0.01,rel=0.1,highcutfreq=8330,rq=0.15,gate=1,amp1=0.9,amp2=0.9,pan=0|
		~cbox_h = {
			var signal;
			signal = CaosHats.ar(att,rel,highcutfreq,rq,gate,amp1,amp2);
			Out.ar(out,signal);
		};//
		instance_id = "HiHats";
		^instance_id;
	}

	hihatsCustom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		~cbox_h = {
			var signal;
			signal = CaosHats.customSignal(ugenFunc,out,att,rel,pan);
			Out.ar(out,signal);
		};//

		instance_id = "HiHats";
		^instance_id;

	}

	hihats2 {|out=50,att=0.01,rel=0.1,highcutfreq=12330,rq=0.5,gate=1,amp1=0.9,amp2=0.9,pan=0|

		~cbox_h2 = {
			var signal;
			signal = CaosHats2.ar(att,rel,highcutfreq,rq,gate,amp1,amp2);
			Out.ar(out,signal);
		};//
		instance_id = "HiHats2";
		^instance_id;
	}

	hihats2Custom {|ugenFunc=nil,out=50,att=0.01,rel=0.25,pan=0|

		~cbox_h2 = {
			var signal;
			signal = CaosHats2.customSignal(ugenFunc,out,att,rel,pan);
			Out.ar(out,signal);
		};//
		instance_id = "HiHats2";
		^instance_id;
	}

	// Synths
	bass {|
		out=50,
		semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60],
		seqType='seq',
		attack=0.01,
		release=0.5,
		filtMinFreq=45,
		filtMaxFreq=12420,
		filtTime=0.125
		rq=0.25,
		iphase=0.5,
		amp1=0.5,
		amp2=0.5
		pan=0|
		//
		var note = semitoneArray;
		var attk = attack;
		var rel = release;
		var filt1 = filtMinFreq;
		var filt2 = filtMaxFreq;
		var filt3 = filtTime;
		var	bandwidth = rq;
		var waveiphase = iphase;
		var ampx = amp1;
		var ampy = amp2;
		var panner = pan;
		var outbus = out;

		~cbox_custom = false;

		Tdef(\bass,{|i = 0|

			var	bassmel,outstream;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						bassmel=Prand(note.asArray,inf).asStream;
						outstream=Prand(outbus.asArray,inf).asStream;
					},
					'seq', {
						bassmel=Pseq(note.asArray,inf).asStream;
						outstream=Pseq(outbus.asArray,inf).asStream;
					},
					("Bass Melodic secuence type is" + seqType).inform;
				);

			}, {
				"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});

			loop {
				i=i+1;
				~cbox_bass.set(
					\att,attk,
					\rel,rel,
					\note,bassmel.next,
					\filtminf,filt1,
					\filtmaxf,filt2,
					\filtime,filt3,
					\rq,bandwidth,
					\iphase,waveiphase,
					\amp1,ampx,
					\amp2,ampy,
					\pan,panner,
					\out,outstream.next
				);
				~cbox_tiempos.wait;
			}
		});
		instance_id = "Bass";
		^instance_id;
	}

	bassCustom {|
		ugenFunc=nil,
		out=50,
		semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60],
		seqType='seq',
		att=0.01,
		rel=0.5,
		pan=0|
		//
		var func = ugenFunc;
		var outbus = out;
		var note = semitoneArray;
		var attk = att;
		var release = rel;
		var panner = pan;

		~cbox_custom = true;

		Tdef(\bass,{

			var	bassmel,outstream;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						bassmel=Prand(note.asArray,inf).asStream;
						outstream=Prand(outbus.asArray,inf).asStream;
					},
					'seq', {
						bassmel=Pseq(note.asArray,inf).asStream;
						outstream=Pseq(outbus.asArray,inf).asStream;
					},
					("Bass Melodic secuence type is" + seqType).inform;
				);

			}, {
				"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});

			loop{
				~cbox_bass.set(
					\ugenFunc, func,
					\att,attk,
					\rel,release,
					\note,bassmel.next,
					\pan, panner,
					\out,outstream.next
				);
				~cbox_tiempos.wait;
			}
		});

		instance_id = "Bass";
		^instance_id;


	}

	bass2 {|
		out=50,
		semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60],
		seqType='seq',
		attack=0.01,
		release=0.5,
		filtTrig=4,
		filtMinFreq=45,
		filtMaxFreq=12420,
		filtTime=0.25
		rq=0.5,
		bw=0.5,
		iphase=0.5,
		amp1=0.5,
		amp2=0.5
		pan=0|
		//
		var note = semitoneArray;
		var attk = attack;
		var rel = release;
		var trigger = filtTrig;
		var filt1 = filtMinFreq;
		var filt2 = filtMaxFreq;
		var filt3 = filtTime;
		var	bandwidth = rq;
		var band = bw;
		var waveiphase = iphase;
		var ampx = amp1;
		var ampy = amp2;
		var panner = pan;
		var outbus = out;
		Tdef(\bass2,{

			var	bassmel, outstream;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						bassmel=Prand(note.asArray,inf).asStream;
						outstream=Prand(outbus.asArray,inf).asStream;
					},
					'seq', {
						bassmel=Pseq(note.asArray,inf).asStream;
						outstream=Pseq(outbus.asArray,inf).asStream;
					},
					("Bass Melodic secuence type is" + seqType).inform;
				);

			}, {
				"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});

			loop{
				~cbox_bass2.set(
					\att,attk,
					\rel,rel,
					\note,bassmel.next,
					\trig,trigger,
					\filtminf,filt1,
					\filtmaxf,filt2,
					\filtime,filt3,
					\rq,bandwidth,
					\bandw,band,
					\iphase,waveiphase,
					\amp1,ampx,
					\amp2,ampy,
					\pan,panner,
					\out,outstream.next,
				);
				~cbox_tiempos.wait;
			}
		});
		instance_id = "Bass2";
		^instance_id;
	}

	pad {|
		out=50,
		semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60],
		seqType='seq',
		waveform='sin',
		att=0.25,
		rel=1,
		semi=0,
		iphase=0,
		cutf=8920,
		rq=0.85,
		gate=0,
		amp=0.75,
		pan=0|
		//
		var wave = waveform;
		var nota = semitoneArray;
		var attack = att;
		var release = rel;
		var semitones = semi;
		var phase = iphase;
		var cutFreq = cutf;
		var band = rq;
		var vol = amp;
		var panner = pan;
		var outbus = out;
		Tdef(\pad,{

			var	mel, outstream;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						mel=Prand(nota.asArray,inf).asStream;
						outstream=Prand(outbus.asArray,inf).asStream;
					},
					'seq', {
						mel=Pseq(nota.asArray,inf).asStream;
						outstream=Pseq(outbus.asArray,inf).asStream;
					},
					("Pad Melodic secuence type is" + seqType).inform;
				);

			}, {
				"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});

			loop{
				~cbox_amb.set(
					\note, mel.next,
					\waveform, wave,
					\att, attack,
					\rel, release,
					\semi, semitones,
					\iphase, phase,
					\cutf, cutFreq,
					\rq, band,
					\amp, vol,
					\pan,panner,
					\out,outstream.next,
				);
				~cbox_tiempos.wait;
			}
		});
		instance_id = "Amb";
		^instance_id;
	}

	pad2 {|out=50,semitoneArray=#[48, 50, 52, 53, 55, 57, 59, 60],seqType='seq',
		att=0.25,rel=1,maxNote=60,fm=0.125,harm=1,amp1=0.5,amp2=0.5,pan=0|
		//
		var nota = semitoneArray;
		var attack = att;
		var release = rel;
		var max = maxNote;
		var mod = fm;
		var harmonics = harm;
		var vol1 = amp1;
		var vol2 = amp2;
		var panner = pan;
		var outbus = out;
		Tdef(\pad2,{

			var	mel, outstream;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						mel=Prand(nota.asArray,inf).asStream;
						outstream=Prand(outbus.asArray,inf).asStream;
					},
					'seq', {
						mel=Pseq(nota.asArray,inf).asStream;
						outstream=Pseq(outbus.asArray,inf).asStream;
					},
					("Pad2 Melodic secuence type is" + seqType).inform;
				);

			}, {
				"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});

			loop{
				~cbox_amb2.set(
					\note, mel.next,
					\att, attack,
					\rel, release,
					\maxNote, max,
					\fm, mod,
					\harm, harmonics,
					\amp1, vol1,
					\amp2, vol2,
					\pan, panner,
					\out, outstream.next,
				);
				~cbox_tiempos.wait;
			}
		});
		instance_id = "Amb2";
		^instance_id;
	}

	chords {|out = 50,semitoneArray = #[ 48, 50, 52, 53, 55, 57, 59 ],seqType = 'seq',
		chordsArray = #['Mmaj7','M', 'm'],	attack = 0.05, release = 1, iphase = 0.025,
		width = 0.1, cutf = 1200, rq = 0.5, pan = 0, amp = 0.5|
		//
		var note = semitoneArray;
		var chords = chordsArray;
		var attk = attack;
		var rel = release;
		var iph = iphase;
		var iwidth = width;
		var cutfreq = cutf;
		var	bandwidth = rq;
		var panner = pan;
		var vol = amp;
		var outbus = out;
		Tdef(\acordes,{

			var mel, chord, outstream;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						mel=Prand(note.asArray,inf).asStream;
						outstream=Prand(outbus.asArray,inf).asStream;
						chord=Prand(chords.asArray,inf).asStream;
					},
					'seq', {
						mel=Pseq(note.asArray,inf).asStream;
						outstream=Pseq(outbus.asArray,inf).asStream;
						chord=Pseq(chords.asArray,inf).asStream;
					},
					("Chord Melodic secuence type is" + seqType).inform;
				);
			}, {
				"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});
			//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
			loop{
				~cbox_chord.set(
					\chord,chord.next,
					\note,mel.next,
					\att, attk,
					\rel, rel,
					\iphase,iph,
					\width,iwidth,
					\cutf,cutfreq,
					\rq,bandwidth,
					\pan,panner,
					\amp,vol,
					\out,outbus
				);
				~cbox_tiempos.wait;
			}
		});
		instance_id = "Chords";
		^instance_id;
	}

	chords2 {|out = #[50],semitoneArray = #[ 0, 2, 4, 5, 7, 9, 11 ],seqType = 'seq',
		chordsArray = #['Mmaj7'],attack = 0.05, release = 1, iphase = 0.025,
		width = 0.1, cutf = 1200, rq = 0.5, pan = 0, amp = 0.5|
		//
		var note = semitoneArray.asArray;
		var chords = chordsArray.asArray;
		var attk = attack;
		var rel = release;
		var iph = iphase;
		var iwidth = width;
		var cutfreq = cutf;
		var	bandwidth = rq;
		var panner = pan;
		var vol = amp;
		var outbus = out;
		Tdef(\acordes,{

			var mel, chord, outbus;

			if(seqType == 'rand' or: {seqType == 'seq'}, {

				switch(seqType,
					'rand', {
						mel=Prand(note.asArray,inf).asStream;
						outbus=Prand(out.asArray,inf).asStream;
						chord=Prand(chords.asArray,inf).asStream;
					},
					'seq', {
						mel=Pseq(note.asArray,inf).asStream;
						outbus=Pseq(out.asArray,inf).asStream;
						chord=Pseq(chords.asArray,inf).asStream;
					},
					("Chord Melodic secuence type is" + seqType).inform;
				);
				}, {
					"For seqType parameter, use only keys: 'rand' or 'seq'".inform;
			});
			//Use 'M', 'm', 'M7', 'm7', 'Mmaj7', 'mmaj7', '5dim7' or '5aug7' keys only
			loop{
				~cbox_chord2.set(
					\chord, chord.next,
					\note, mel.next,
					\att, attk,
					\rel, rel,
					\iphase, iph,
					\width, iwidth,
					\cutf, cutfreq,
					\rq, bandwidth,
					\pan, panner,
					\amp, vol,
					\out, outbus.next
				);
				~cbox_tiempos.wait;
			}
		});

		instance_id = "Chords2";

		^instance_id;
	}

	lineIn {|out=50,inchan=0,att=0.05,rel=0.5|

		var outbus, inChannel=inchan, attack=att, release=rel;

		Tdef(\entrada, {

			var outbus = Prand(out.asArray,inf).asStream;

			loop {
				~cbox_entrada.set(
					\out,outbus.next,
					\inchan,inChannel,
					\att,attack,
					\rel,release
					);
				~cbox_tiempos.wait;
			}

		});
		instance_id = "LineIn";

		^instance_id;
	}

	toTrack {|steps = 0, overrideSteps = false |

		var track;

		switch( instance_id,
			"Kick", {track = \kick},
			"Kick2", {track = \kick2},
			"Snare", {track = \snare},
			"Snare2", {track = \snare2},
			"HiHats", {track = \hihats},
			"HiHats2", {track = \hihats2},
			"Bass", {track = \bass},
			"Bass2", {track = \bass2},
			"Amb", {track = \amb},
			"Amb2", {track = \amb2},
			"Chords", {track = \chords},
			"Chords2", {track = \chords2},
			"LineIn", {track = \in}
		);

		CaosBox.setSteps(track,steps, overrideSteps);

		^"CaosGear: " + instance_id + " instance added to sequencer";
	}

	offTrack {|steps = 0 |

		var track;

		switch( instance_id,
			"Kick", {track = \kick},
			"Kick2", {track = \kick2},
			"Snare", {track = \snare},
			"Snare2", {track = \snare2},
			"HiHats", {track = \hihats},
			"HiHats2", {track = \hihats2},
			"Bass", {track = \bass},
			"Bass2", {track = \bass2},
			"Amb", {track = \amb},
			"Amb2", {track = \amb2},
			"Chords", {track = \chords},
			"Chords2", {track = \chords2},
			"LineIn", {track = \in}
		);

		CaosBox.clearSteps(track,steps);

		^"CaosGear Instance deleted from sequencer";

	}

	*customOn {|on=false|

		^~cbox_custom  = on;

	}
}
