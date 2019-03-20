//CaosBox v1.1 Soundcheck + Welcome + Complementary files
(
Task({|i|
	var texto = "CaosBox v1.1";
	var display = texto.size*6;
	var crece=Array.new(display);
	var creseq=Pseq([0,1],31).asStream;
	i=0;
	5.yield;
	display.do{
		if(i>0,{
			texto.rotate(i).inform;
		}, {

			CaosBox.soundcheck(\pink);

		});
		i=i+1;
		0.1.wait;
	};
	1.do{crece.join.inform;"CaosBox v1.1".inform};
	1.yield;
	1.do{"Bienvenido/Welcome.".inform};
	1.yield;
	1.do{" + CaosBox v1.1 es una Máquina no tan común, para hacer Algorave/Livecoding con CaosPercLib. \n + CaosBox v1.1 is a not so common Algoraving/Livecoding Machine for CaosPercLib. \n + Escrito/Written: @Ill_Slide  [at]: http://www.josecaos.xyz".inform;
	};
	//
}).play;
);
// Complementary files
for(0,~urls.size-1,{|i|

	(~url +/+ ~urls[i]).load;

});
//
// (~url +/+ "CodePads/CaosBox_liveCodePad-default.scd").openOS;