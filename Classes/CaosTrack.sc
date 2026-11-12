// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.0.0 - Step pattern model
//
// A CaosTrack owns the pattern of one lane: `size`, 32 steps by default and a
// `mode` how the instrument is resolved.
//
//   \snapshot  the step stores the value returned by `source` at the moment the
//              step is set. Redefining the source later does not touch steps
//              already set (percussion lanes today).
//   \live      the step stores only its gate (true / nil). The instrument is
//              resolved when the step is triggered (melodic lanes today).
//
// Index handling is defensive on purpose: indices outside 0..size-1 are ignored

CaosTrack {

	classvar <defaultSize = 32;
	classvar <modes = #[\snapshot, \live];
	classvar <soloed;
	classvar <repeaterMetrics;

	var <name;
	var <mode;
	var <size;
	var <steps;
	var <flams;
	var <repeaters;
	var <source;
	var <>onChange;
	var <>onFlamChange;
	var <>onRepeaterChange;
	var <>onTrigger;
	var <>onCommand;
	var <muted = false;
	var <solo = false;
	var <probability = 1.0;
	var <>instrument;        // voz activa de la pista
	var <>out;               // ruta de salida (melodicos): nombre de bus del engine
	var <>pendingInstrument; // reemplazo que entra en el siguiente trigger
	var <>target;            // grupo destino de la percusion (funciones por step)

	*initClass {

		soloed = IdentitySet.new;
		repeaterMetrics = [1, 1/2, 1/3, 1/4, 1/8];

	}

	*new { |name, mode = \live, size, source|

		^super.new.init(name, mode, size, source);

	}

	// Generador puro para randPattern: cada step se enciende con `density`.
	// No toca ninguna pista; la aplicacion la hace CaosBox.
	*randomIndices { |size = 32, density = 0.5|

		var total = size.asInteger;
		var probability = density.asFloat;
		var indices = List.new;

		if(total <= 0, { ^[] });

		total.do {|index|
			if(1.0.rand < probability, { indices.add(index) });
		};

		^indices.asArray;

	}

	*isValidRepeaterMetric {|metric|

		^repeaterMetrics.any {|valid| (valid - metric).abs < 0.0001 };

	}

	// Intervalos de las repeticiones extra; la ultima cae al final de la ventana.
	*repeaterIntervals {|repetitions = 1, metric = 1, stepDur = 0.25|

		var total = repetitions.asInteger;

		if(total <= 0, { ^[] });

		^(1 .. total).collect {|i| i * metric * stepDur / total };

	}

	init { |argName, argMode, argSize, argSource|

		name = argName.asSymbol;
		mode = argMode;
		size = (argSize ? defaultSize).asInteger;
		source = argSource;

		if(modes.includes(mode).not, {
			Error("CaosTrack(%): unknown mode %, use one of %".format(name, mode, modes)).throw;
		});

		if(mode == \snapshot and: { source.isNil }, {
			Error("CaosTrack(%): \\snapshot tracks need a source function".format(name)).throw;
		});

		steps = Array.fill(size, nil);
		flams = Array.fill(size, nil);
		repeaters = Array.fill(size, nil);

		^this;

	}

	// --- reading -----------------------------------------------------

	at { |index|

		^if(this.isValidIndex(index)) { steps[index] };

	}

	indices {

		var result = List.new;

		size.do { |index|
			if(steps[index].notNil, { result.add(index) });
		};

		^result.asArray;

	}

	count {

		^steps.count { |value| value.notNil };

	}

	isEmpty {

		^this.count == 0;

	}

	notEmpty {

		^this.isEmpty.not;

	}

	isValidIndex { |index|

		^(index.isInteger and: { index >= 0 } and: { index < size });

	}

	asArray {

		// a copy: callers may mutate it without touching the track
		^steps.copy;

	}

	// --- writing -----------------------------------------------------

	put { |index, value|

		if(this.isValidIndex(index), {
			steps[index] = value;
			if(value.isNil) {
				flams[index] = nil;
				repeaters[index] = nil;
			};
			this.prChanged(index, value);
		});

		^this;

	}

	// on = true/1 sets the step, anything else clears it
	putStep { |index, on = true|

		if(on.asBoolean, {
			this.put(index, this.prStepValue);
		}, {
			this.put(index, nil);
		});

		^this;

	}

	// El flam solo aplica a percusión (modo snapshot).
	// amount: apertura 0..1; repeats: golpes extra 1..4.
	flam {|stepsToMark, amount = 0.5, repeats = 1|

		var indices = (stepsToMark ? []).asArray;

		if(mode != \snapshot, {
			"CaosTrack: flam only applies to percussion tracks".warn;
			^this;
		});

		if(amount.isNumber.not or: { amount < 0 } or: { amount > 1 }, {
			"CaosTrack: flam amount must be a number between 0 and 1".warn;
			^this;
		});

		if(repeats.isInteger.not or: { repeats < 1 } or: { repeats > 4 }, {
			"CaosTrack: flam repeats must be an integer between 1 and 4".warn;
			^this;
		});

		indices.do {|index|
			if(this.isValidIndex(index), {
				if(repeaters[index].notNil, {
					repeaters[index] = nil;
					this.prRepeaterChanged(index, nil);
				});
				flams[index] = (amount: amount, repeats: repeats);
				this.prFlamChanged(index, flams[index]);
			});
		};

		^this;

	}

	removeFlam {|stepsToRemove|

		var indices = (stepsToRemove ? []).asArray;

		indices.do {|index|
			if(this.isValidIndex(index), {
				flams[index] = nil;
				this.prFlamChanged(index, nil);
			});
		};

		^this;

	}

	flamAt {|index|

		^if(this.isValidIndex(index)) { flams[index] };

	}

	// Repeater por step: `repetitions` son golpes EXTRA y `metric` es la
	// fraccion del step donde caen (1, 1/2, 1/3, 1/4 o 1/8).
	repeater {|stepsToMark, repetitions = 1, metric = 1|

		var indices = (stepsToMark ? []).asArray;

		if(repetitions.isInteger.not or: { repetitions < 0 } or: { repetitions > 16 }, {
			"CaosTrack: repeater repetitions must be an integer between 0 and 16".warn;
			^this;
		});

		if(this.class.isValidRepeaterMetric(metric).not, {
			"CaosTrack: repeater metric must be 1, 1/2, 1/3, 1/4 or 1/8".warn;
			^this;
		});

		indices.do {|index|
			if(this.isValidIndex(index), {
				if(repetitions == 0, {
					repeaters[index] = nil;
					this.prRepeaterChanged(index, nil);
				}, {
					if(flams[index].notNil, {
						flams[index] = nil;
						this.prFlamChanged(index, nil);
					});
					repeaters[index] = (repetitions: repetitions, metric: metric);
					this.prRepeaterChanged(index, repeaters[index]);
				});
			});
		};

		^this;

	}

	removeRepeater {|stepsToRemove|

		var indices = (stepsToRemove ? []).asArray;

		indices.do {|index|
			if(this.isValidIndex(index), {
				repeaters[index] = nil;
				this.prRepeaterChanged(index, nil);
			});
		};

		^this;

	}

	repeaterAt {|index|

		^if(this.isValidIndex(index)) { repeaters[index] };

	}

	// El patron es un array fijo de `size` posiciones: el indice ES el orden.
	// Se copian los tres arrays (gates, flams y repeaters) por posicion.
	snapshotPattern {

		^(size: size, steps: steps.copy, flams: flams.copy, repeaters: repeaters.copy);

	}

	restorePattern {|snapshot|

		var newSteps = snapshot !? {|s| s[\steps] };
		var newFlams = snapshot !? {|s| s[\flams] };
		var newRepeaters = snapshot !? {|s| s[\repeaters] };

		if(newRepeaters.isNil, { newRepeaters = Array.fill(size, nil) });

		if(newSteps.isNil or: { newFlams.isNil }, {
			"CaosTrack.restorePattern: invalid snapshot".warn;
			^this;
		});

		if(newSteps.size != size or: { newFlams.size != size }
			or: { newRepeaters.size != size }, {
			"CaosTrack.restorePattern: snapshot size mismatch".warn;
			^this;
		});

		steps = newSteps.copy;
		flams = newFlams.copy;
		repeaters = newRepeaters.copy;

		size.do {|index|
			this.prChanged(index, steps[index]);
			this.prFlamChanged(index, flams[index]);
			this.prRepeaterChanged(index, repeaters[index]);
		};

		^this;

	}

	// no argument clears the whole track
	clear { |stepsToClear|

		var targets = (stepsToClear ? (0 .. (size - 1))).asArray;

		targets.do { |index| this.put(index, nil) };

		^this;

	}

	// the old CaosBox.setSteps, with the input cleaned instead of mutated
	setIndices { |indicesToSet, clearFirst = true|

		var valid = indicesToSet.asArray.select { |index| this.isValidIndex(index) };

		if(clearFirst, { this.clear });

		valid.do { |index| this.putStep(index, true) };

		^this;

	}

	toggle { |index|

		this.putStep(index, this.at(index).isNil);

		^this;

	}

	// --- mute / solo / playback probability ---------------------------

	muted_ {|state|

		muted = state ? false;

		^this;

	}

	solo_ {|state|

		solo = state ? false;

		if(solo, { soloed.add(this) }, { soloed.remove(this) });

		^this;

	}

	isAudible {

		^muted.not and: {
			soloed.isEmpty or: { soloed.includes(this) }
		};

	}

	probability_ {|value|

		probability = (value ? 1.0).asFloat;

		^this;

	}

	// Chance de que un step activo dispare en esta pasada. 0 y 1 no consumen
	// RNG; el patron no se toca.
	prShouldPlay {

		^probability >= 1.0 or: {
			probability > 0 and: { 1.0.rand < probability }
		};

	}

	*clearSolos {

		var tracks = soloed.copy;

		soloed = IdentitySet.new;
		tracks.do {|track| track.solo_(false) };

		^this;

	}

	// --- voz de la pista ---------------------------------------------

	setInstrument { |newInstrument|

		// la primera voz entra al instante; un reemplazo espera al trigger
		if(instrument.isNil, {
			instrument = newInstrument;
		}, {
			pendingInstrument = newInstrument;
		});

		^this;

	}

	advance {

		if(instrument.notNil, { instrument.advance });

		^this;

	}

	trigger {

		this.activatePending;
		if(instrument.notNil, { instrument.trigger });

		^this;

	}

	// un step del secuenciador:
	//   con voz    -> avanza la linea y dispara (melodicos)
	//   sin voz    -> toca la funcion guardada en el step (percusion)
	step { |index, stepDur = 0.25|

		var value = this.at(index);
		var repeater = repeaters[index];
		var voice;

		this.advance;

		if(instrument.notNil, {
			if(value.notNil and: { this.prShouldPlay }, {
				if(this.isAudible, {
					this.trigger;
					voice = instrument;
					this.prTriggered(index, value, voice);
					repeater !? { this.prScheduleRepeater(repeater, stepDur, false, nil, voice) };
				});
				this.prCommand(index, value, instrument);
			});
		}, {
			if(value.notNil and: { this.prShouldPlay }
				and: { value.respondsTo(\play) }, {
				if(this.isAudible, {
					this.prPlayPercussion(value, index);
					this.prTriggered(index, value, nil);
					repeater !? { this.prScheduleRepeater(repeater, stepDur, true, value, nil) };
				});
				this.prCommand(index, value, nil);
			});
		});

		^this;

	}

	activatePending {

		if(pendingInstrument.notNil, {
			if(instrument.notNil, { instrument.release });
			instrument = pendingInstrument;
			pendingInstrument = nil;
		});

		^this;

	}

	releaseInstrument {

		if(instrument.notNil, { instrument.release });
		if(pendingInstrument.notNil, { pendingInstrument.release });
		instrument = nil;
		pendingInstrument = nil;

		^this;

	}

	// --- internals ---------------------------------------------------

	prScheduleRepeater {|config, stepDur, percussive = false, value, voice|

		var intervals = this.class.repeaterIntervals(
			config[\repetitions], config[\metric], stepDur
		);

		intervals.do {|delay|
			TempoClock.default.sched(delay, {
				if(this.isAudible, {
					if(percussive, {
						this.prPlayValue(value);
					}, {
						voice !? {|v| v.retriggerCurrent };
					});
				});
			});
		};

		^this;

	}

	prPlayPercussion {|value, index|

		var flam = flams[index];

		this.prPlayValue(value);

		if(flam.notNil, {
			flam[\repeats].do {|i|
				TempoClock.default.sched(
					(i + 1) * flam[\amount] * 0.0625,
					{ this.prPlayValue(value) }
				);
			};
		});

		^this;

	}

	prPlayValue {|value|

		if(target.notNil, { value.play(target) }, { value.play });

		^this;

	}

	prStepValue {

		^if(mode == \snapshot, { source.value }, { true });

	}

	prChanged { |index, value|

		if(onChange.notNil, { onChange.value(this, index, value) });

	}

	prFlamChanged { |index, value|

		if(onFlamChange.notNil, { onFlamChange.value(this, index, value) });

	}

	prRepeaterChanged { |index, value|

		if(onRepeaterChange.notNil, { onRepeaterChange.value(this, index, value) });

	}

	prTriggered { |index, value, voice|

		if(onTrigger.notNil, { onTrigger.value(this, index, value, voice) });

	}

	// Evento de comando: gate + probabilidad, independiente del mute/solo de
	// audio. Lo consume el tap MIDI.
	prCommand { |index, value, voice|

		if(onCommand.notNil, { onCommand.value(this, index, value, voice) });

	}

	printOn { |stream|

		stream << "CaosTrack(" << name << ", " << mode << ", "
		<< this.count << "/" << size << ")";

	}

}
