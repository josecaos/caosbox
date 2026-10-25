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

	var <name;
	var <mode;
	var <size;
	var <steps;
	var <source;
	var <>onChange;

	*new { |name, mode = \live, size, source|

		^super.new.init(name, mode, size, source);

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

	// --- internals ---------------------------------------------------

	prStepValue {

		^if(mode == \snapshot, { source.value }, { true });

	}

	prChanged { |index, value|

		if(onChange.notNil, { onChange.value(this, index, value) });

	}

	printOn { |stream|

		stream << "CaosTrack(" << name << ", " << mode << ", "
		<< this.count << "/" << size << ")";

	}

}
