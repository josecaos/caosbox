// CaosBox v2.3.0 - 5a: prototipo de UNA fila (bass)
//
// Compara tres vistas del mismo CaosTrack(\bass):
//   1) los 32 CheckBox actuales (referencia)
//   2) rejilla propia con UserView (propuesta A)
//   3) MultiSliderView, un widget por pista (propuesta B)
//
// No toca CaosBox ni el servidor: es sólo la muestra visual de 5a.
// Correr el bloque completo y jugar con la ventana.
//
// Para las capturas headless:
//   "DevTest/img/...".load y Image.fromWindow(~cbox_proto_win.view)
(
var win, track, checks, grid, msv, msvValues, cellIndexAt, syncView;
var playIndex = 12, playing = false, clock, routine;
var bg, labelColor, mutedColor, accentColor, cellOn, cellOff, cellBorder;
var playButton, hint;

bg = Color(0.075, 0.08, 0.082);
labelColor = Color(0.80, 0.82, 0.80);
mutedColor = Color(0.52, 0.56, 0.52);
accentColor = Color(0.95, 0.97, 0.95);
cellOn = Color(0.24, 0.80, 0.54);
cellOff = Color(0.15, 0.16, 0.17);
cellBorder = Color(0.30, 0.32, 0.30);

track = CaosTrack.new(\bass, \live, 32);
track.setIndices([0, 3, 5, 8, 11, 16, 19, 22, 27, 30]);

win = Window.new("CaosBox v2.3 - prototipo 5a (una fila)",
	Rect.aboutPoint(Window.screenBounds.center, 512, 150));
win.background = bg;
win.front;

StaticText(win, Rect(16, 10, 620, 24))
	.string_("Prototipo 5a: una sola fila")
	.font_(Font("DejaVu Sans", 16, true))
	.stringColor_(labelColor);
StaticText(win, Rect(16, 34, 980, 16))
	.string_("Tres vistas sobre el mismo CaosTrack(\\bass). Pintá arrastrando en A, arrastrá en B, o tocá los CheckBox.")
	.font_(Font("DejaVu Sans", 10))
	.stringColor_(mutedColor);

// --- 1) la vista actual: 32 CheckBox ---------------------------------
StaticText(win, Rect(16, 74, 94, 16))
	.string_("Hoy")
	.font_(Font("DejaVu Sans", 11, true))
	.stringColor_(mutedColor);
StaticText(win, Rect(16, 90, 94, 14))
	.string_("32 CheckBox")
	.font_(Font("DejaVu Sans", 9))
	.stringColor_(mutedColor);

checks = Array.new(32);
{
	var x = 116;
	var spacing = [20, 20, 20, 30];
	32.do {|i|
		checks = checks.add(
			CheckBox(win, Rect(x, 74, 18, 18)).action_({|c|
				track.putStep(i, c.value == 1);
			})
		);
		x = x + spacing[i.mod(4)];
	};
}.value;

// --- 2) propuesta A: rejilla UserView --------------------------------
StaticText(win, Rect(16, 116, 94, 16))
	.string_("A · UserView")
	.font_(Font("DejaVu Sans", 11, true))
	.stringColor_(cellOn);
StaticText(win, Rect(16, 132, 94, 14))
	.string_("rejilla propia")
	.font_(Font("DejaVu Sans", 9))
	.stringColor_(mutedColor);

grid = UserView(win, Rect(116, 112, 888, 46))
	.background_(bg)
	.resize_(2)
	.onResize_({|v| v.refresh });

cellIndexAt = {|x, width|
	var margin = 2, gap = 3, groupExtra = 6, cells = 32;
	var avail, cellW, found;
	avail = width - (margin * 2);
	cellW = (avail - ((cells - 1) * gap) - (7 * groupExtra)) / cells;
	cells.do {|i|
		var cx = margin + (i * (cellW + gap)) + (((i / 4).floor) * groupExtra);
		if (found.isNil and: { x >= cx } and: { x <= (cx + cellW) }) {
			found = i;
		};
	};
	found
};

grid.drawFunc_({|v|
	var b = v.bounds, cells = 32, margin = 2, gap = 3, groupExtra = 6;
	var avail, cellW, cellH, border;
	Pen.fillColor = bg;
	Pen.fillRect(b);
	avail = b.width - (margin * 2);
	cellW = (avail - ((cells - 1) * gap) - (7 * groupExtra)) / cells;
	cellH = b.height - 24;
	cells.do {|i|
		var x = margin + (i * (cellW + gap)) + (((i / 4).floor) * groupExtra);
		var r = Rect(x, 18, cellW, cellH);
		var on = track.at(i).notNil;
		// números de grupo (rejilla de referencia)
		if ((i.mod(4)) == 0) {
			Pen.fillColor = mutedColor;
			Pen.font = Font("DejaVu Sans", 9, true);
			Pen.stringAtPoint((i + 1).asString, Point(x, 0));
		};
		// columna del playhead
		if (playIndex == i) {
			Pen.fillColor = Color(1, 1, 1, 0.07);
			Pen.fillRect(Rect(x - 1.5, 0, cellW + 3, b.height));
		};
		// celda
		Pen.fillColor = if(on, cellOn, cellOff);
		Pen.addRoundedRect(r, 3, 3);
		Pen.fill;
		border = if(on, cellOn.blend(Color.white, 0.18), cellBorder);
		Pen.strokeColor = border;
		Pen.width = 1;
		Pen.addRoundedRect(r.insetBy(0.5, 0.5), 2.5, 2.5);
		Pen.stroke;
		if (playIndex == i) {
			Pen.strokeColor = accentColor;
			Pen.width = 1.5;
			Pen.addRoundedRect(r.insetBy(1.5, 1.5), 2, 2);
			Pen.stroke;
		};
	};
});

// pintar / borrar arrastrando
{
	var paintValue = true, lastIndex;
	grid.mouseDownAction_({|v, x, y, mods, btn, clicks|
		var i = cellIndexAt.value(x, v.bounds.width);
		if (i.notNil) {
			paintValue = track.at(i).isNil;
			lastIndex = i;
			track.putStep(i, paintValue);
		};
	});
	grid.mouseMoveAction_({|v, x, y, mods|
		var i;
		if (lastIndex.notNil) {
			i = cellIndexAt.value(x, v.bounds.width);
			if (i.notNil and: { i != lastIndex }) {
				track.putStep(i, paintValue);
				lastIndex = i;
			};
		};
	});
	grid.mouseUpAction_({|v, x, y, mods| lastIndex = nil });
}.value;

// --- 3) propuesta B: MultiSliderView --------------------------------
StaticText(win, Rect(16, 176, 94, 16))
	.string_("B · MultiSlider")
	.font_(Font("DejaVu Sans", 11, true))
	.stringColor_(cellOn);
StaticText(win, Rect(16, 192, 94, 14))
	.string_("1 widget / pista")
	.font_(Font("DejaVu Sans", 9))
	.stringColor_(mutedColor);

msvValues = Array.fill(32, {|i| if(track.at(i).notNil, 1, 0) });
msv = MultiSliderView(win, Rect(116, 172, 888, 32))
	.resize_(2)
	.size_(32)
	.value_(msvValues)
	.step_(1)
	.elasticMode_(true)
	.thumbSize_(26)
	.index_(playIndex)
	.showIndex_(true)
	.isFilled_(true)
	.drawRects_(true)
	.gap_(2)
	.colors_(Color(0.10, 0.11, 0.10), cellOn)
	.background_(bg)
	.action_({|v|
		var i = v.index;
		if (i.notNil) {
			track.putStep(i, v.value[i] > 0.5);
		};
	});

// --- sincronización modelo -> las tres vistas ------------------------
syncView = {|t, i, value|
	var on = value.notNil;
	{
		checks[i].value_(if(on, 1, 0));
		msvValues[i] = if(on, 1, 0);
		msv.value_(msvValues);
		grid.refresh;
	}.defer;
};
track.onChange = syncView;

// estado inicial de la fila de CheckBox (el modelo manda)
32.do {|i| checks[i].value_(if(track.at(i).notNil, 1, 0)) };

// --- transporte de la muestra: playhead ------------------------------
clock = TempoClock(126 / 60);
playButton = Button(win, Rect(16, 236, 120, 26))
	.states_([["playhead", Color.black, cellOn], ["stop", Color.white, Color(0.55, 0.20, 0.20)]])
	.font_(Font("DejaVu Sans", 11, true))
	.action_({|b|
		if (b.value == 1) {
			routine = Routine {
				inf.do {
					playIndex = (playIndex + 1).mod(32);
					{ grid.refresh; msv.index_(playIndex) }.defer;
					0.25.wait;
				};
			}.play(clock);
		} {
			routine.stop;
			routine = nil;
		};
	});

hint = StaticText(win, Rect(150, 242, 700, 16))
	.string_("A: click = toggle, arrastrar = pintar/borrar. B: arrastrar. El playhead ya viene dibujado en cada fila (los LEDs de arriba dejan de hacer falta).")
	.font_(Font("DejaVu Sans", 9))
	.stringColor_(mutedColor);

win.onClose_({
	routine !? { routine.stop };
	~cbox_proto_win = nil;
	~cbox_proto_grid = nil;
});

~cbox_proto_win = win;
~cbox_proto_grid = grid;
~cbox_proto_msv = msv;
~cbox_proto_track = track;
)
