// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2014-2026 Carlos Hasbun (josecaos)
// CaosBox v2.3.5 - GUI registry and palette
//
// The API reaches the view through CaosBox.gui

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
	var <accentEntries;
	var <routeViews;
	var <fxRouteViews;
	var <muteViews;
	var <soloViews;
	var <randomViews;
	var <probabilityViews;
	var <analyzerWin;
	var <freqView;
	var <scopeView;
	var <scopeSynth;
	var <freqLabel;
	var <scopeLabel;
	var <designSize;
	var <resizeView;
	var <resizeRects;
	var <colorRandomTask;

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

		accent = colorAliases.choose.copy;
		background = Color(0.075, 0.08, 0.082);
		panel = Color(0.11, 0.115, 0.12);
		text = Color(0.84, 0.86, 0.84);
		muted = Color(0.55, 0.58, 0.55);
		cellOff = Color(0.15, 0.16, 0.17);
		border = Color(0.28, 0.30, 0.28);
		stepGrids = List.new;
		colorListeners = List.new;
		accentEntries = List.new;
		routeViews = IdentityDictionary.new;
		fxRouteViews = IdentityDictionary.new;
		muteViews = IdentityDictionary.new;
		soloViews = IdentityDictionary.new;
		randomViews = IdentityDictionary.new;
		probabilityViews = IdentityDictionary.new;

		this.prUpdateDerived;

		^this;

	}

	// --- color de acento ------------------------------------------------

	// acepta Color, simbolo (\red, \blue, ...) o array [r, g, b(, a)]
	color {|value|

		var newColor;

		// sin argumento devuelve la vista: permite encadenar color.randomColor(...)
		if (value.isNil, { ^this });

		newColor = this.class.colorFor(value);

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

	// --- easter egg: acento aleatorio al tempo de la caja ---------------

	// Uso: CaosBox.gui.color.randomColor(true)  arranca
	//      CaosBox.gui.color.randomColor(false) detiene (deja el color actual)
	//
	// El Task vive en TempoClock.default, el mismo reloj de la secuencia:
	// las esperas son beats, asi que el cambio sigue el BPM y el tiempo
	// aleatorio. Apagado no registra listeners ni agrega trabajo al step.
	randomColor {|active = true|

		if (active, {
			this.prStartColorRandom;
		}, {
			this.prStopColorRandom;
		});

		^this;

	}

	// alias corto: la forma original de la API
	random {|active = true| ^this.randomColor(active) }

	prStartColorRandom {

		this.prStopColorRandom;// no duplicar el Task

		colorRandomTask = Task({
			loop {
				var step = this.class.randomColorStep;
				{ this.color(step[\color]) }.defer(0);
				step[\beats].wait;
			}
		}).play(TempoClock.default);

		^this;

	}

	prStopColorRandom {

		colorRandomTask !? {|task| task.stop };
		colorRandomTask = nil;

		^this;

	}

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


	*randomColorStep {

		var palette = colorAliases.keys.asArray.reject {|name|
			(name == \grey) or: { name == \gray }
		};

		^(
			color: palette.choose,
			beats: #[0.5, 1, 2, 4].wchoose(#[0.12, 0.33, 0.35, 0.20])
		);

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

	// popups de ruteo: la API los actualiza y ellos actualizan la API
	addRoute {|track, popup, buses|

		routeViews.put(track, (popup: popup, buses: buses));

		^this;

	}

	routeChanged {|track, name|

		var entry = routeViews[track];
		var index;

		if(entry.notNil, {
			index = entry[\buses].indexOf(name.asSymbol);
			if(index.notNil, {
				{ entry[\popup].value_(index) }.defer;
			});
		});

		^this;

	}

	addFxRoute {|fx, popup, buses|

		fxRouteViews.put(fx, (popup: popup, buses: buses));

		^this;

	}

	fxRouteChanged {|fx, name|

		var entry = fxRouteViews[fx];
		var index;

		if(entry.notNil, {
			index = entry[\buses].indexOf(name.asSymbol);
			if(index.notNil, {
				{ entry[\popup].value_(index) }.defer;
			});
		});

		^this;

	}

	addMuteView {|track, button|

		muteViews.put(track, button);

		^this;

	}

	addSoloView {|track, button|

		soloViews.put(track, button);

		^this;

	}

	addRandomView {|track, button|

		randomViews.put(track, button);

		^this;

	}

	addProbabilityView {|track, box|

		probabilityViews.put(track, box);

		^this;

	}

	trackStateChanged {|track|

		var tr = CaosBox.tracks !? {|tracks| tracks[track]};

		tr !? {|t|
			{
				muteViews[track] !? {|button| button.value_(if(t.muted, 1, 0)) };
				soloViews[track] !? {|button| button.value_(if(t.solo, 1, 0)) };
			}.defer;
		};

		^this;

	}

	trackPatternChanged {|track|

		var active = CaosBox.hasPatternHistory(track);

		{ randomViews[track] !? {|button| button.value_(if(active, 1, 0)) } }.defer;

		^this;

	}

	trackProbabilityChanged {|track|

		var value = CaosBox.trackProbability(track);

		if(value.isNumber, {
			{ probabilityViews[track] !? {|box| box.value_((value * 100).round) } }.defer;
		});

		^this;

	}

	playhead {|index|

		{ stepGrids.do {|grid| grid.playhead_(index) } }.defer;

		^this;

	}

	// --- resize fluido del GUI principal --------------------------------

	// Reparte el bloque inferior en el ancho nuevo conservando la proporcion
	// horizontal del diseno de 1120. Es idempotente: si ya esta escalado, no
	// vuelve a mover los widgets.
	scaleLowerSection {|win, top = 400, left = 16, oldRight = 1104, newRight = 1164|

		var scale = (newRight - left) / (oldRight - left);
		var maxRight = 0;

		win.asView.children(View).do {|child|
			var rect = child.bounds;
			if(rect.top >= top, {
				maxRight = max(maxRight, rect.left + rect.width);
			});
		};

		if(maxRight > (oldRight + 1), { ^this });

		win.asView.children(View).do {|child|
			var rect = child.bounds;
			if(rect.top >= top, {
				child.bounds_(Rect(
					(left + ((rect.left - left) * scale)).round,
					rect.top,
					(rect.width * scale).round,
					rect.height
				));
			});
		};

		^this;

	}

	// guarda los rects de diseno y los escala con la ventana
	makeResizable {|win, width = 1180, height = 860|

		designSize = Point(width, height);
		resizeView = win.asView;
		resizeRects = IdentityDictionary.new;

		resizeView.children(View).do {|child|
			resizeRects.put(child, child.bounds);
		};

		resizeView.onResize_({|view| this.prFluidResize(view) });

		^this;

	}

	prFluidResize {|view|

		var bounds = view.bounds;
		var sx = bounds.width / designSize.x;
		var sy = bounds.height / designSize.y;

		if(bounds.width > 0 and: { bounds.height > 0 }, {
			resizeRects.keysValuesDo {|child, rect|
				child.bounds_(Rect(
					(rect.left * sx).round,
					(rect.top * sy).round,
					(rect.width * sx).round,
					(rect.height * sy).round
				));
			};
		});

		^this;

	}

	// --- widgets viejos con verde hardcodeado ---------------------------

	// recorre la ventana una vez y guarda que widgets deben seguir al acento
	themeLegacy {|parent, skip|

		accentEntries = List.new;
		this.prCollectGreen(parent, skip ? []);

		^this.prApplyAccent;

	}

	isGreen {|color|

		if(color.isNil or: { color.isKindOf(Color).not }, { ^false });

		^(color.green > 0.25)
			and: { color.red < 0.45 }
			and: { color.blue < 0.45 }
			and: { color.green > (color.red + 0.12) }
			and: { color.green > (color.blue + 0.12) };

	}

	prCollectGreen {|view, skip|

		view.children(View).do {|child|
			if(skip.includes(child).not, {
				this.prCollectGreenView(child);
				this.prCollectGreen(child, skip);
			});
		};

		^this;

	}

	prCollectGreenView {|view|

		if(view.isKindOf(NumberBox), {
			if(this.isGreen(view.background), {
				accentEntries.add((view: view, role: \number));
			});
		});

		if(view.isKindOf(Button), {
			var states = view.states;
			if(states.notNil, {
				// todos los botones: inactivo = texto acento / fondo panel;
				// activo (state > 0) = fondo acento / texto negro
				accentEntries.add((
					view: view,
					role: \button,
					labels: states.collect {|state| state[0] }
				));
			});
		});

		if(view.isKindOf(Slider) or: { view.isKindOf(Slider2D) }, {
			accentEntries.add((view: view, role: \slider));
		});

		if(view.isKindOf(StaticText), {
			// todas las etiquetas: mismo color bajo sobre panel
			accentEntries.add((view: view, role: \label));
		});

		if(view.isKindOf(PopUpMenu), {
			accentEntries.add((view: view, role: \popup));
		});

		^this;

	}

	prApplyAccent {

		accentEntries.do {|entry|
			var view = entry[\view];

			if(view.notNil, {
				switch(entry[\role],

					\number, {
						view.background_(panel);
						view.stringColor_(accent);
						view.normalColor_(accent);
						view.typingColor_(accent);
					},

					\button, {
						var value = view.value;
						var count = entry[\labels].size;
						var states = entry[\labels].collect {|label, index|
							var active = (count > 1) and: { index > 0 };
							if(active, {
								[label, Color.black, accent]
							}, {
								[label, accent, panel]
							});
						};
						view.states_(states);
						view.value_(value);
					},

					\slider, {
						var palette = view.palette;
						view.knobColor_(accent);
						palette.button_(accent);
						view.palette_(palette);
					},

					\label, {
						view.background_(panel);
						view.stringColor_(muted);
					},

					\popup, {
						view.background_(panel);
						view.stringColor_(muted);
					}
				);
			});
		};

		^this;

	}

	prRefresh {

		stepGrids.do {|grid| grid.refresh };
		colorListeners.do {|func| func.value(this) };
		this.prApplyAccent;
		this.prThemeAnalyzers;

		^this;

	}

	prThemeAnalyzers {

		analyzerWin !? {|win| win.background_(background) };
		freqView !? {|view|
			view.background_(panel);
			if(view.scope.isKindOf(ScopeView), {
				view.scope.waveColors_([accent]);
			});
		};
		scopeView !? {|view|
			view.background_(panel);
			view.waveColors_([accent, accent]);
		};

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

		freqLabel = StaticText(win, Rect(8, 8, 200, 14))
			.string_("Spectrum")
			.stringColor_(muted)
			.font_(Font("DejaVu Sans", 10, true));
		freqView = FreqScopeView(win, Rect(8, 24, 584, 190));
		freqView.freqMode_(1);
		freqView.background_(panel);

		scopeLabel = StaticText(win, Rect(8, 222, 200, 14))
			.string_("Oscilloscope")
			.stringColor_(muted)
			.font_(Font("DejaVu Sans", 10, true));
		scopeView = ScopeView(win, Rect(8, 238, 584, 184));
		scopeView.server_(server);
		scopeView.background_(panel);

		win.asView.onResize_({ this.prLayoutAnalyzers });
		this.prLayoutAnalyzers;

		scopeSynth = BusScopeSynth(server);

		win.onClose_({ this.prCleanupAnalyzers });
		this.prThemeAnalyzers;

		^this;

	}

	prLayoutAnalyzers {

		var bounds;
		var width, height;
		var pad = 8, labelH = 14, gap = 8, tight = 4;
		var viewH, y;

		if(analyzerWin.isNil, { ^this });

		bounds = analyzerWin.asView.bounds;
		width = bounds.width;
		height = bounds.height;
		viewH = ((height - (pad * 2) - (labelH * 2) - (tight * 4) - gap) / 2).max(40);
		y = pad;

		freqLabel !? {|label| label.bounds_(Rect(pad, y, width - (pad * 2), labelH)) };
		y = y + labelH + tight;
		freqView !? {|view|
			if(view.scope.respondsTo(\bounds_), {
				view.scope.bounds_(Rect(pad, y, width - (pad * 2), viewH));
			});
		};
		y = y + viewH + gap;

		scopeLabel !? {|label| label.bounds_(Rect(pad, y, width - (pad * 2), labelH)) };
		y = y + labelH + tight;
		scopeView !? {|view| view.bounds_(Rect(pad, y, width - (pad * 2), viewH)) };

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
		freqLabel = nil;
		scopeLabel = nil;

		^this;

	}

	printOn {|stream|

		stream << "CaosBoxGUI(" << stepGrids.size << " step grids, accent "
		<< accent << ")";

	}

}
