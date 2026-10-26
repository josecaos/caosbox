// CaosBox v2.3.0 - GUI registry and palette
//
// The API reaches the view through CaosBox.gui. The registry owns the colors
// (so `CaosBox.gui.color(\red)` repaints every registered step grid) and the
// list of step grids that need the playhead. No widgets are created here: the
// GUI files build them and register them.

CaosBoxGUI {

	classvar <colorAliases;

	var <accent;
	var <background;
	var <cellOff;
	var <border;
	var <playheadColor;
	var <stepGrids;

	*initClass {

		colorAliases = Dictionary[
			\green -> Color(0.24, 0.80, 0.54),
			\red -> Color(0.90, 0.28, 0.30),
			\blue -> Color(0.30, 0.55, 0.95),
			\cyan -> Color(0.25, 0.80, 0.85),
			\magenta -> Color(0.85, 0.30, 0.75),
			\purple -> Color(0.62, 0.42, 0.92),
			\yellow -> Color(0.92, 0.82, 0.30),
			\orange -> Color(0.95, 0.55, 0.20),
			\teal -> Color(0.20, 0.70, 0.65),
			\lime -> Color(0.62, 0.92, 0.28),
			\pink -> Color(0.95, 0.45, 0.65),
			\white -> Color(0.90, 0.92, 0.90),
			\grey -> Color(0.55, 0.55, 0.55),
			\gray -> Color(0.55, 0.55, 0.55)
		];

	}

	*new { ^super.new.init }

	init {

		accent = colorAliases[\green].copy;
		background = Color(0.075, 0.08, 0.082);
		cellOff = Color(0.15, 0.16, 0.17);
		border = Color(0.28, 0.30, 0.28);
		stepGrids = List.new;

		this.prUpdatePlayheadColor;

		^this;

	}

	// --- color de acento ------------------------------------------------

	// acepta Color, simbolo (\red, \blue, ...) o array [r, g, b(, a)]
	color {|value|

		var newColor = this.class.colorFor(value);

		if (newColor.isNil, {
			("CaosBoxGUI: color no reconocido: " ++ value).warn;
			^this;
		});

		accent = newColor;
		this.prUpdatePlayheadColor;
		this.prRefresh;

		^this;

	}

	color_ {|value| ^this.color(value) }

	*colorFor {|value|

		if (value.isNil, { ^nil });
		if (value.isKindOf(Color), { ^value.copy });
		if (value.isKindOf(Symbol), { ^colorAliases[value] });

		if (value.isKindOf(SequenceableCollection), {
			if (value.size == 3, { ^Color(value[0], value[1], value[2]) });
			if (value.size == 4, { ^Color(value[0], value[1], value[2], value[3]) });
		});

		^nil;

	}

	prUpdatePlayheadColor {

		playheadColor = accent.blend(Color.white, 0.7);
		^this;

	}

	// --- registro de la vista -------------------------------------------

	addStepGrid {|grid|

		stepGrids.add(grid);

		^this;

	}

	removeStepGrid {|grid|

		stepGrids.remove(grid);

		^this;

	}

	playhead {|index|

		stepGrids.do {|grid| grid.playhead_(index) };

		^this;

	}

	prRefresh {

		stepGrids.do {|grid| grid.refresh };

		^this;

	}

	printOn {|stream|

		stream << "CaosBoxGUI(" << stepGrids.size << " step grids, accent "
		<< accent << ")";

	}

}
