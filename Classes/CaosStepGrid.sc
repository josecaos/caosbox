// CaosBox v2.3.0 - one lane step grid (UserView)
//
// Replaces the 32 CheckBox of a track with a single hand-drawn grid: rounded
// cells, group gaps every 4 steps, playhead column and drag painting. It does
// not own the pattern: CaosTrack is the model and onChange refreshes the view.
//
// Geometry lives in class methods so it can be tested headless.

CaosStepGrid {

	classvar <defaultCells = 32;
	classvar <defaultGroupSize = 4;
	classvar <defaultGap = 3;
	classvar <defaultGroupExtra = 6;
	classvar <defaultMargin = 2;
	classvar <cellRadius = 3;

	var <view;
	var <track;
	var <gui;
	var <playhead;
	var paintValue, lastIndex;

	*new {|parent, bounds, track, gui|

		^super.new.init(parent, bounds, track, gui);

	}

	init {|argParent, argBounds, argTrack, argGui|

		track = argTrack;
		gui = argGui ?? { CaosBox.gui };

		view = UserView(argParent, argBounds);
		view.background_(gui.background);
		view.drawFunc_({ this.draw });
		view.mouseDownAction_({|v, x, y, mods, button, clicks| this.mouseDown(x, y) });
		view.mouseMoveAction_({|v, x, y, mods| this.mouseMove(x, y) });
		view.mouseUpAction_({|v, x, y, mods, button| this.mouseUp });
		view.onResize_({|v| v.refresh });

		gui.addStepGrid(this);

		if (track.notNil, {
			track.onChange = {|t, i, value| { this.refresh }.defer };
		});

		^this;

	}

	// --- geometria (testeable headless) ---------------------------------

	*groupCount {|cells|

		^((cells - 1) / defaultGroupSize).floor;

	}

	*cellWidth {|width, cells = 32|

		var avail = width - (defaultMargin * 2);

		^((avail - ((cells - 1) * defaultGap) - (this.groupCount(cells) * defaultGroupExtra)) / cells);

	}

	*cellLeft {|index, width, cells = 32|

		^(defaultMargin + (index * (this.cellWidth(width, cells) + defaultGap))
			+ (((index / defaultGroupSize).floor) * defaultGroupExtra));

	}

	*cellRect {|index, width, height, cells = 32|

		^Rect(this.cellLeft(index, width, cells), 3,
			this.cellWidth(width, cells), height - 6);

	}

	*indexAt {|x, width, cells = 32|

		var hit;
		var cellW = this.cellWidth(width, cells);

		cells.do {|i|
			var left = this.cellLeft(i, width, cells);
			if (hit.isNil and: { x >= left } and: { x <= (left + cellW) }, {
				hit = i;
			});
		};

		^hit;

	}

	// --- vista ----------------------------------------------------------

	cells { ^if(track.notNil, { track.size }, { defaultCells }) }

	refresh {

		view.refresh;

		^this;

	}

	playhead_ {|index|

		playhead = index;
		this.refresh;

		^this;

	}

	draw {

		var bounds = view.bounds;
		var width = bounds.width;
		var height = bounds.height;
		var cells = this.cells;

		Pen.fillColor = gui.background;
		Pen.fillRect(bounds);

		cells.do {|i|
			this.prDrawCell(
				this.class.cellRect(i, width, height, cells),
				i,
				track.at(i).notNil,
				bounds
			);
		};

		^this;

	}

	prDrawCell {|rect, index, isOn, bounds|

		if (playhead == index, {
			Pen.fillColor = Color(gui.accent.red, gui.accent.green, gui.accent.blue, 0.12);
			Pen.fillRect(Rect(rect.left - 1.5, 0, rect.width + 3, bounds.height));
		});

		Pen.fillColor = if(isOn, { gui.accent }, { gui.cellOff });
		Pen.addRoundedRect(rect, cellRadius, cellRadius);
		Pen.fill;

		Pen.strokeColor = if(isOn,
			{ gui.accent.blend(Color.white, 0.18) },
			{ gui.border });
		Pen.width = 1;
		Pen.addRoundedRect(rect.insetBy(0.5, 0.5), cellRadius - 0.5, cellRadius - 0.5);
		Pen.stroke;

		if (playhead == index, {
			Pen.strokeColor = gui.playheadColor;
			Pen.width = 1.5;
			Pen.addRoundedRect(rect.insetBy(1.5, 1.5), cellRadius - 1, cellRadius - 1);
			Pen.stroke;
		});

		^this;

	}

	// --- pintar arrastrando ---------------------------------------------

	mouseDown {|x, y|

		var index = this.class.indexAt(x, view.bounds.width, this.cells);

		if (index.notNil, {
			paintValue = track.at(index).isNil;
			lastIndex = index;
			track.putStep(index, paintValue);
		});

		^this;

	}

	mouseMove {|x, y|

		var index;

		if (lastIndex.notNil, {
			index = this.class.indexAt(x, view.bounds.width, this.cells);
			if (index.notNil and: { index != lastIndex }, {
				track.putStep(index, paintValue);
				lastIndex = index;
			});
		});

		^this;

	}

	mouseUp {

		lastIndex = nil;

		^this;

	}

	printOn {|stream|

		stream << "CaosStepGrid(" << track.name << ", playhead: " << playhead << ")";

	}

}
