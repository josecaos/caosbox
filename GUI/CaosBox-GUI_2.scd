(//CaosBox GUI file 2 - v2.3.5 - las 13 pistas del secuenciador
//
// Un solo builder para todas las filas: etiqueta, rejilla de steps, ruteo
// (melodicos) o aviso de ruteo por step (percision) y boton de limpiar.
// El orden del spec es el orden visual; CaosTrack sigue siendo el modelo.
	var specs, gui, buses, busLabels;
	var gridX = 80, gridW = 908, routeX = 994, routeW = 86, clearX = 1088;
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
		var label, grid, route, clear;

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

		clear = Button(~cbox_w, Rect(clearX, y + 6, 16, 16))
			.states_([["×", Color(0.85, 0.35, 0.35), gui.panel]])
			.action_({|button|
				if (button.value == 0, {
					CaosBox.clearSteps(spec[\name]);
				});
			});
		gui.addColorListener({|g|
			clear !? {|bot|
				bot.states = [["×", Color(0.85, 0.35, 0.35), g.panel]];
			};
		});
	};
)
