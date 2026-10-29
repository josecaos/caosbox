
CaosBox.environment(false);
CaosBox.play;

x = CaosSampler.new;
x.load("Test",copies:1);

// esperar a que CaosSampler termine de cargar
x.loop(true);
x.play;

x.out(1, CaosBox.engine.busIndex(\grains));
~cbox_grains.set(\trigger, 3.5, \size, 0.25);
x.out(1, CaosBox.engine.busIndex(\reverb));
~cbox_mastrev.set(\mix, 0.5, \room, 1, \damp, 0.25);
x.out(1, CaosBox.engine.busIndex(\delay));
~cbox_mastdel.set(\deltime, 0.03, \delfeed, 0.5);


(
Tdef(\test, {
	loop({

		x.out(1, CaosBox.engine.busIndex(\grains));
		~cbox_grains.set(\trigger, 8, \size, 0.03);
		x.toggleReverse(1);
		1.5.wait;
		x.out(1, CaosBox.engine.busIndex(\reverb));
		~cbox_mastrev.set(\mix, 1, \room, 0.25, \damp, 1);
		x.toggleReverse(1);
		1.5.wait;
		x.out(1, CaosBox.engine.busIndex(\delay));
		~cbox_mastdel.set(\deltime, 0.03, \delfeed, 0.75);
		// x.toggleReverse(1);
		1.5.wait;
	});
})
);
Tdef(\test).play;
Tdef(\test).pause;

CaosBox.freqAnalyzer(true);

