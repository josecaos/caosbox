//written by @joseCao5
//CaosBox welcome and complementary files
////////////////////////////////////////////
//These files are nedded in order to  make CaosBox Work.
///////////////////////////////////////////
(//Bienvenida
Task({|i|
	var izq="x", der="+",crece=Array.new(32);
	var creseq=Pseq([0,1],31).asStream;
	i=0;
		1.do{nil;4.wait};
		31.do{
					if(i>=0,{crece.add(if(creseq.next==1,{izq},{der}));
							 crece.join.postln;
							 "CaosBox".rotate(i-5).postln});
				i=i+1;
				0.125.wait;
			 };
		1.do{crece.join.postln;"CaosBox".postln;0.01.wait};
		1.do{"Bienvenido/Welcome.".postln;
				play{
				var noise=[LFNoise0,LFNoise1,LFNoise2].choose;
				var linea=[XLine,Line];
				EnvGen.ar(Env.perc(0.02,5),doneAction:2)*
				FreeVerb.ar(
					RHPF.ar(
						LFPulse.ar([{linea.choose.ar(120.10760.rand,10760.140.rand,rrand(1,8))}.dup(6),
							Phasor.kr(Impulse.kr(rrand(1,16)),1,119.10760.rand,120.10760.rand)],
								rrand(0.01,0.5),rrand(0.1,0.5),0.5)*
						noise.ar(2.32.rand),linea.choose.ar(rrand(60,10760),rrand(10760,60),0.5),rrand(0.15,0.5)),
					linea.choose.kr(0.01,0.5,2),1,0.025)!2};
					5.wait;};
		1.do{"+CaosBox es una Maquina no tan comun, para hacer Algorave/Livecoding con CaosPercLib. \n"
				"+CaosBox is a not so common Algoraving/Livecoding Machine for CaosPercLib.".postln;3.wait};
	//
		1.do{"+Escrito/Written by: @joseCao5  [at]: http://www.josecaos.xyz".postln;3.wait};
	//
		1.do{"+Abierto/Opened: CaosBox_liveCodePad-default.scd".postln;0.25.wait};
	//
		}).play;
);
//archivos complementarios
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
//
