(//CaosBox GUI file 2 - v2.3.5 - las 13 pistas del secuenciador
//
// Un solo builder para todas las filas: etiqueta, rejilla de steps, ruteo
// (melodicos) o aviso de ruteo por step (percision), probabilidad de playback,
// boton de limpiar y botones de mute/solo/random.
// El orden del spec es el orden visual; CaosTrack sigue siendo el modelo.
	var specs, gui, buses, busLabels;
	var gridX = 80, gridW = 846, routeX = 930, routeW = 90;
	var pLabelX = 1114, pLabelW = 7;
	var probabilityX = 1122, probabilityW = 34;
	var percentX = 1157, percentW = 7;
	// columnas: clear/M/S/R y despues P; 6 px entre botones
	var clearX = 1026, muteX = 1048, soloX = 1070, randomX = 1092;
	var muteSoloW = 16;
	var rowH = 29, top = 16, gridH = 27;

	specs = [
		(name: \kick, label: "Kick", family: \drums),
		(name: \snare, label: "Snare", family: \drums),
		(name: \hihats, label: "Hats", family: \drums),
		(name: \kick2, label: "Kick2", family: \drums),
		(name: \snare2, label: "Snare2", family: \drums),
		(name: \hihats2, label: "Hats2", family: \drums),
		(name: \bass, label: "Bass", family: \melodic),
		(name: \bass2, label: "Bass2", family: \melodic),
		(name: \amb, label: "Pad", family: \melodic),
		(name: \amb2, label: "Pad2", family: \melodic),
		(name: \chords, label: "Chords", family: \melodic),
		(name: \chords2, label: "Chords2", family: \melodic),
		(name: \in, label: "LineIn", family: \melodic)
	];

	gui = CaosBox.gui;
	buses = [\master, \reverb, \delay, \pitch, \lpf, \hpf, \bpf, \grains];
	busLabels = ["Master", "Reverb", "Delay", "Pitch", "LPF", "HPF", "BPF", "Grains"];

	specs.do {|spec, row|
		var y = top + (row * rowH);
		var track = CaosBox.tracks[spec[\name]];
		var label, grid, route, clear, mute, solo, random;
		var pLabel, probability, percent;

		label = StaticText(~cbox_w, Rect(16, y + 4, 60, 15))
			.string_(spec[\label])
			.stringColor_(gui.text)
			.font_(Font("DejaVu Sans", 11, true))
			.align_(\left);

		grid = CaosStepGrid.new(~cbox_w, Rect(gridX, y, gridW, gridH), track, gui);

		if (spec[\family] == \melodic, {
			route = PopUpMenu(~cbox_w, Rect(routeX, y + 2, routeW, 25))
				.items_(busLabels)
				.background_(gui.panel)
				.stringColor_(gui.muted);
			route.value_(buses.indexOf(track.out ? \master) ? 0);
			route.action_({|menu| CaosBox.route(spec[\name], buses[menu.value]) });
			gui.addRoute(spec[\name], route, buses);
		}, {
			// percision: la salida se elige al evaluar el instrumento, por step
			StaticText(~cbox_w, Rect(routeX, y + 7, routeW, 14))
				.string_("per-step")
				.stringColor_(gui.muted)
				.font_(Font("DejaVu Sans", 9))
				.align_(\center)
				.toolTip_("La salida se elige al evaluar el instrumento: k.kick(out: ...), k.snare(out: ...)");
		});

		pLabel = StaticText(~cbox_w, Rect(pLabelX, y + 7, pLabelW, 14))
			.string_("P")
			.stringColor_(gui.muted)
			.font_(Font("DejaVu Sans", 9))
			.align_(\center);

		probability = NumberBox(~cbox_w, Rect(probabilityX, y + 6, probabilityW, 16))
			.background_(gui.panel)
			.stringColor_(gui.accent)
			.normalColor_(gui.accent)
			.typingColor_(gui.accent)
			.align_(\center)
			.font_(Font("DejaVu Sans", 9))
			.clipLo_(0)
			.clipHi_(100)
			.step_(1)
			.scroll_step_(1)
			.decimals_(0)
			.toolTip_("Playback probability (%)")
			.value_((track.probability * 100).round)
			.action_({|box| CaosBox.trackProbability(spec[\name], box.value / 100) });
		gui.addProbabilityView(spec[\name], probability);

		percent = StaticText(~cbox_w, Rect(percentX, y + 7, percentW, 14))
			.string_("%")
			.stringColor_(gui.muted)
			.font_(Font("DejaVu Sans", 9))
			.align_(\left);

		clear = Button(~cbox_w, Rect(clearX, y + 6, muteSoloW, 16))
			.states_([["×", Color(0.85, 0.35, 0.35), gui.panel]])
			.action_({|button|
				if (button.value == 0, {
					CaosBox.clearSteps(spec[\name]);
				});
			});

		mute = Button(~cbox_w, Rect(muteX, y + 6, muteSoloW, 16))
			.states_([
				["M", gui.muted, gui.panel],
				["M", gui.accentText, gui.accent]
			])
			.toolTip_("Mute this track")
			.action_({|button| CaosBox.mute(spec[\name], button.value == 1) });
		mute.value_(if(track.muted, 1, 0));
		gui.addMuteView(spec[\name], mute);

		solo = Button(~cbox_w, Rect(soloX, y + 6, muteSoloW, 16))
			.states_([
				["S", gui.muted, gui.panel],
				["S", gui.accentText, gui.accent]
			])
			.toolTip_("Solo this track")
			.action_({|button| CaosBox.solo(spec[\name], button.value == 1) });
		solo.value_(if(track.solo, 1, 0));
		gui.addSoloView(spec[\name], solo);

		random = Button(~cbox_w, Rect(randomX, y + 6, muteSoloW, 16))
			.states_([
				["R", gui.muted, gui.panel],
				["R", gui.accentText, gui.accent]
			])
			.toolTip_("Randomize this track / restore the previous pattern")
			.action_({|button|
				if(button.value == 1, {
					CaosBox.randPattern(spec[\name]);
				}, {
					CaosBox.restorePattern(spec[\name]);
				});
			});
		random.value_(if(CaosBox.hasPatternHistory(spec[\name]), 1, 0));
		gui.addRandomView(spec[\name], random);

		gui.addColorListener({|g|
			clear !? {|bot|
				bot.states = [["×", Color(0.85, 0.35, 0.35), g.panel]];
			};
			mute !? {|bot|
				bot.states = [["M", g.muted, g.panel], ["M", g.accentText, g.accent]];
			};
			solo !? {|bot|
				bot.states = [["S", g.muted, g.panel], ["S", g.accentText, g.accent]];
			};
			random !? {|bot|
				bot.states = [["R", g.muted, g.panel], ["R", g.accentText, g.accent]];
			};
			probability !? {|box|
				box.background_(g.panel);
				box.stringColor_(g.accent);
				box.normalColor_(g.accent);
				box.typingColor_(g.accent);
			};
			pLabel !? {|txt| txt.stringColor_(g.muted) };
			percent !? {|txt| txt.stringColor_(g.muted) };
		});
	};
)
