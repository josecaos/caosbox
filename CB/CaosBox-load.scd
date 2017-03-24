//CaosBox v1.1 Soundcheck, welcome and complementary files
(
Task({|i|
	var texto = "CaosBox v1.1";
	var display = texto.size*4;
	var izq="x", der="+",crece=Array.new(display);
	var creseq=Pseq([0,1],31).asStream;
	i=0;
	2.yield;
	display.do{
		if(i>0,{
			crece.add(if(creseq.next==1,{izq},{der}));
			crece.join.inform;
			texto.rotate(i).inform
			}, {
				play{
					var noise=[LFNoise0,LFNoise1,LFNoise2].choose;
					var linea=[XLine,Line];
					EnvGen.ar(Env.perc(0.02,5),doneAction:2)*
					FreeVerb.ar(
						RHPF.ar(
							LFPulse.ar([{linea.choose.ar(120.10760.rand,10760.140.rand,rrand(1,8))}.dup(display),
								Phasor.kr(Impulse.kr(rrand(1,16)),1,119.10760.rand,120.10760.rand)],
								rrand(0.01,0.5),rrand(0.1,0.5),0.5)*
							noise.ar(1.32.rand),linea.choose.ar(rrand(60,10760),rrand(10760,60),0.5),rrand(0.15,0.5)),
						linea.choose.kr(0.01,0.5,2),1,0.025)!2
				};
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
(~url +/+ "CB/CaosBox-seq.scd").load;
(~url +/+ "CB/CaosBox-auto.scd").load;
(~url +/+ "CodePads/CaosBox_liveCodePad-default.scd").load;
(~url +/+ "GUI/CaosBox-GUI.scd").load;
(~url +/+ "GUI/CaosBox-GUI_2.scd").load;
(~url +/+ "GUI/CaosBox-GUI_3.scd").load;
(~url +/+ "GUI/CaosBox-GUI_4.scd").load;
(~url +/+ "CodePads/CaosBox_liveCodePad-default.scd").openOS;