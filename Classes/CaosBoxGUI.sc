// CaosBox v2.3.1 - GUI registry and palette
//
// The API reaches the view through CaosBox.gui. The registry owns the palette
// (so `CaosBox.gui.color(\red)` repaints every registered view), the list of
// step grids that need the playhead and the floating analyzers window.
// No widgets are created here at load time: the GUI files build them and
// register them.

CaosBoxGUI {

	classvar <colorAliases;

	var <accent;
	var <accentText;
	var <background;
	var <panel;
	var <text;
	var <muted;
	var <cellOff;
	var <border;
	var <playheadColor;
	var <stepGrids;
	var <colorListeners;
	var <analyzerWin;
	var <freqView;
	var <scopeView;
	var <scopeSynth;

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
		panel = Color(0.11, 0.115, 0.12);
		text = Color(0.84, 0.86, 0.84);
		muted = Color(0.55, 0.58, 0.55);
		cellOff = Color(0.15, 0.16, 0.17);
		border = Color(0.28, 0.30, 0.28);
		stepGrids = List.new;
		colorListeners = List.new;

		this.prUpdateDerived;

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
		this.prUpdateDerived;
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

	prUpdateDerived {

		var luminance;

		playheadColor = accent.blend(Color.white, 0.7);

		// texto legible sobre el acento (contraste por luminancia)
		luminance = (0.2126 * accent.red) + (0.7152 * accent.green) + (0.0722 * accent.blue);
		accentText = if(luminance > 0.55,
			{ Color(0.05, 0.05, 0.05) },
			{ Color(0.95, 0.96, 0.95) });

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

	// funciones que repintan widgets propios cuando cambia la paleta
	addColorListener {|func|

		colorListeners.add(func);

		^this;

	}

	removeColorListener {|func|

		colorListeners.remove(func);

		^this;

	}

	playhead {|index|

		stepGrids.do {|grid| grid.playhead_(index) };

		^this;

	}

	prRefresh {

		stepGrids.do {|grid| grid.refresh };
		colorListeners.do {|func| func.value(this) };
		this.prThemeAnalyzers;

		^this;

	}

	prThemeAnalyzers {

		analyzerWin !? {|win| win.background_(background) };
		freqView !? {|view| view.background_(panel) };
		scopeView !? {|view| view.background_(panel) };

		^this;

	}

	// --- analizadores flotantes (FFT + osciloscopio) --------------------

	// true abre/activa la ventana; false la apaga y cierra
	freqAnalyzer {|on = true|

		if (on.asBoolean, { this.prOpenAnalyzers }, { this.prCloseAnalyzers });

		^this;

	}

	toggleFreqAnalyzer {

		var visible = analyzerWin.notNil and: { analyzerWin.isClosed.not };

		this.freqAnalyzer(visible.not);

		^this;

	}

	prOpenAnalyzers {

		var server = CaosBox.server ?? { Server.default };

		if (server.isNil or: { server.serverRunning.not }, {
			"CaosBox: el servidor no esta corriendo; no puedo abrir los analizadores".warn;
			^this;
		});

		analyzerWin ?? { this.prBuildAnalyzers };

		analyzerWin.front;
		freqView !? {|view| view.active_(true) };

		scopeSynth !? {|synth|
			synth.play(4096, Bus(\audio, 0, 2, server), 1024);
			scopeView !? {|view|
				view.bufnum_(synth.bufferIndex);
				view.start;
			};
		};

		^this;

	}

	prBuildAnalyzers {

		var server = CaosBox.server ?? { Server.default };
		var win = Window.new(
			"CaosBox v" ++ CaosBox.version ++ " - Analyzers",
			Rect.aboutPoint(Window.screenBounds.center, 300, 215)
		);

		win.background_(background);
		analyzerWin = win;

		StaticText(win, Rect(8, 8, 200, 14))
			.string_("Spectrum")
			.stringColor_(muted)
			.font_(Font("DejaVu Sans", 10, true))
			.resize_(2);
		freqView = FreqScopeView(win, Rect(8, 24, 584, 190));
		freqView.freqMode_(1);
		freqView.resize_(5);// FreqScopeView delega resize_ en su ScopeView interno
		freqView.background_(panel);

		StaticText(win, Rect(8, 222, 200, 14))
			.string_("Oscilloscope")
			.stringColor_(muted)
			.font_(Font("DejaVu Sans", 10, true))
			.resize_(2);
		scopeView = ScopeView(win, Rect(8, 238, 584, 184));
		scopeView.resize_(5);
		scopeView.server_(server);
		scopeView.background_(panel);

		scopeSynth = BusScopeSynth(server);

		win.onClose_({ this.prCleanupAnalyzers });

		^this;

	}

	prCloseAnalyzers {

		analyzerWin !? {|win| win.close };

		^this;

	}

	prCleanupAnalyzers {

		freqView !? {|view| view.kill };
		scopeView !? {|view| view.stop };
		scopeSynth !? {|synth| synth.free };

		analyzerWin = nil;
		freqView = nil;
		scopeView = nil;
		scopeSynth = nil;

		^this;

	}

	printOn {|stream|

		stream << "CaosBoxGUI(" << stepGrids.size << " step grids, accent "
		<< accent << ")";

	}

}
