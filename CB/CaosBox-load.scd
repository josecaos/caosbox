//CaosBox v1.3 Soundcheck + Welcome + Complementary files
(
Task({|i|
	var texto = "CaosBox v1.3";
	// var display = 666;
	var display = texto.size*6;
	var crece=Array.new(display);
	var creseq=Pseq([0,1],31).asStream;
	i=0;
	1.yield;
	display.do{
			texto.rotate(i).inform;
		i=i+1;
		0.1.wait;
	};
	1.do{crece.join.inform; texto.inform};
	1.yield;
	1.do{"To perform soundcheck, write: ' CaosBox.soundcheck('white') '".inform};
	1.yield;
	1.do{"+ CaosBox  is a not so common Algorave/Livecoding sequencer. \n + Written by: http://www.mixfuckedup.net".inform};
}).play;
);

for(0,~cbox_urls.size-1,{|i|

	(~cbox_url +/+ ~cbox_urls[i]).load;

});
