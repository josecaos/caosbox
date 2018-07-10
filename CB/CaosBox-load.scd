//CaosBox v1.1 Soundcheck + Welcome + Complementary files
(
Task({|i|
	var texto = "CaosBox v1.1";
	var display = texto.size*6;
	var crece=Array.new(display);
	var creseq=Pseq([0,1],31).asStream;
	i=0;
	4.yield;
	display.do{
		if(i>0,{
			texto.rotate(i).inform;
		}, {
			play{PinkNoise.ar(SinOsc.ar(2,0,0.01,1))*EnvGen.ar(Env.perc(0.5,5),1,doneAction:2)}
		});
		i=i+1;
		0.1.wait;
	};
	1.do{crece.join.inform;"CaosBox v1.1".inform};
	1.yield;
	1.do{"Bienvenido/Welcome.".inform};
	1.yield;
	1.do{" + CaosBox v1.1 es una Máquina no tan común, para hacer Algorave/Livecoding con CaosPercLib. \n + CaosBox v1.1 is a not so common Algoraving/Livecoding Machine for CaosPercLib. \n + Escrito/Written: @joseCao5  [at]: http://www.josecaos.xyz".inform};
	2.yield;
	//
	1.do{" => Abierto/Opened: CaosBox_liveCodePad-default.scd".inform};
}).play;
);
//
(~url +/+ "CB/CaosBox-midi.scd").load;
(~url +/+ "CB/CaosBox-vars.scd").load;
(~url +/+ "CB/CaosBox-signal.scd").load;
(~url +/+ "CB/CaosBox-synths.scd").load;
(~url +/+ "CB/CaosBox-auto.scd").load;
(~url +/+ "CodePads/CaosBox_liveCodePad-default.scd").load;
(~url +/+ "GUI/CaosBox-GUI.scd").load;
(~url +/+ "GUI/CaosBox-GUI_2.scd").load;
(~url +/+ "GUI/CaosBox-GUI_3.scd").load;
(~url +/+ "GUI/CaosBox-GUI_4.scd").load;
(~url +/+ "CB/CaosBox-seq.scd").load;
(~url +/+ "CB/CaosBox-funcs.scd").load;
(~url +/+ "CodePads/CaosBox_liveCodePad-default.scd").openOS;