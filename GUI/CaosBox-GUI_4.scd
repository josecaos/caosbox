(//CaosBox GUI file 4 - v1.3 - filtros, freqscope, bpm, granulador, Close
//Lowpass filter min max values
~cbox_fmaxmin=ControlSpec(20,20000,\exponential,1,20000);
~cbox_rqmaxmin=ControlSpec(0.01,1,\lin,0.01,1);
//Filter Aux tag
~cbox_filttag=StaticText(~cbox_w,Rect(650,410,220,13.4));
~cbox_filttag.string_("Filters").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
//Lowpass tag
~cbox_lowfiltag=StaticText(~cbox_w,Rect(650,426.75,220,13.4));
~cbox_lowfiltag.string_("LowPassFilter: " ++ CaosBox.engine.busIndex(\lpf)).font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.75,0.75,0.75));
//Lowpass out
~cbox_lowoutpop=PopUpMenu(~cbox_w,Rect(650,443.51,220,16.75)).items=["LPF Out to Master","LPF Out to Reverb",
	"LPF Out to Delay","LPF Out to Pitch"];
~cbox_lowoutpop.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_lowoutpop.action={|menu|
	switch(menu.value,
		0,{~cbox_mastlowf.set(\out,CaosBox.engine.busIndex(\master));"+ LPF Out to Master".inform;},
		1,{~cbox_mastlowf.set(\out,CaosBox.engine.busIndex(\reverb));"+ LPF Out to Reverb".inform;},
		2,{~cbox_mastlowf.set(\out,CaosBox.engine.busIndex(\delay));"+ LPF Out to Delay".inform;},
		3,{~cbox_mastlowf.set(\out,CaosBox.engine.busIndex(\pitch));"+ LPF Out to Pitch".inform;}
	);
};
//Lowpass cutfreq
StaticText(~cbox_w,Rect(650,463.61,134.15,15.64)).string_("Cut Frequency").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf1=NumberBox(~cbox_w,Rect(784.15,462.5,85.85,17.87)).background_(Color(0,1,0));
~cbox_lowcfader=Slider(~cbox_w,Rect(650,482.6,220,22.34)).background_(Color(alpha:0));
~cbox_lowcfader.action={
	~cbox_mastlowf.set(
		\cutfreq,~cbox_fmaxmin.map(~cbox_lowcfader.value));
		~cbox_numf1.value_(~cbox_fmaxmin.map(~cbox_lowcfader.value))
	};
~cbox_numf1.action={~cbox_mastlowf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_numf1.value));~cbox_lowcfader.value=~cbox_numf1.value/19980};//el cambio de numbox a fader, se vuelve lineal
~cbox_lowcfader.value=20000;
~cbox_numf1.value=20000;
//rq
StaticText(~cbox_w,Rect(650,510.53,134.15,15.64)).string_("Bandwidth").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf2=NumberBox(~cbox_w,Rect(784.15,509.41,85.85,17.87)).background_(Color(0,1,0));
~cbox_lowrqfader=Slider(~cbox_w,Rect(650,532.87,220,11.17)).background_(Color(alpha:0));
~cbox_lowrqfader.action={~cbox_mastlowf.set(\rq,~cbox_rqmaxmin.map(~cbox_lowrqfader.value));~cbox_numf2.value_(~cbox_rqmaxmin.map(~cbox_lowrqfader.value))};
~cbox_numf2.action={~cbox_mastlowf.set(\rq,~cbox_rqmaxmin.map(~cbox_numf2.value));~cbox_lowrqfader.value_(~cbox_rqmaxmin.map(~cbox_numf2.value))};
~cbox_lowrqfader.value=0.5;
~cbox_numf2.value=0.5;
//Highpass tag
~cbox_highfiltag=StaticText(~cbox_w,Rect(650,555.2,220,13.4));
~cbox_highfiltag.string_("HighPassFilter: " ++ CaosBox.engine.busIndex(\hpf)).font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.75,0.75,0.75));
//Highpass out
~cbox_highoutpop=PopUpMenu(~cbox_w,Rect(650,571.96,220,16.75)).items=["HPF Out to Master","HPF Out to Reverb",
	"HPF Out to Delay","HPF Out to Pitch"];
~cbox_highoutpop.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_highoutpop.action={|menu|
	switch(menu.value,
		0,{~cbox_masthighf.set(\out,CaosBox.engine.busIndex(\master));"+ HPF Out to Master".inform;},
		1,{~cbox_masthighf.set(\out,CaosBox.engine.busIndex(\reverb));"+ HPF Out to Reverb".inform;},
		2,{~cbox_masthighf.set(\out,CaosBox.engine.busIndex(\delay));"+ HPF Out to Delay".inform;},
		3,{~cbox_masthighf.set(\out,CaosBox.engine.busIndex(\pitch));"+ HPF Out to Pitch".inform;}
	);
};
//Highpass cutfreq
StaticText(~cbox_w,Rect(650,592.06,134.15,15.64)).string_("Cut Frequency").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf3=NumberBox(~cbox_w,Rect(784.15,590.95,85.85,17.87)).background_(Color(0,1,0));
~cbox_highcfader=Slider(~cbox_w,Rect(650,611.05,220,22.34)).background_(Color(alpha:0));
~cbox_highcfader.action={~cbox_masthighf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_highcfader.value));~cbox_numf3.value_(~cbox_fmaxmin.map(~cbox_highcfader.value))};
~cbox_numf3.action={~cbox_masthighf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_numf3.value));~cbox_highcfader.value=~cbox_numf3.value/19980};
~cbox_highcfader.value=0.15;
~cbox_numf3.value=45;
//rq
StaticText(~cbox_w,Rect(650,636.74,134.15,15.64)).string_("Bandwidth").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf4=NumberBox(~cbox_w,Rect(784.15,635.63,85.85,17.87)).background_(Color(0,1,0));
~cbox_highrqfader=Slider(~cbox_w,Rect(650,655.73,220,11.17)).background_(Color(alpha:0));
~cbox_highrqfader.action={~cbox_masthighf.set(\rq,~cbox_rqmaxmin.map(~cbox_highrqfader.value));~cbox_numf4.value_(~cbox_rqmaxmin.map(~cbox_highrqfader.value))};
~cbox_numf4.action={~cbox_masthighf.set(\rq,~cbox_rqmaxmin.map(~cbox_numf4.value));~cbox_highrqfader.value_(~cbox_rqmaxmin.map(~cbox_numf4.value))};
~cbox_highrqfader.value=0.5;
~cbox_numf4.value=0.5;
//Bandpass tag
~cbox_bandfiltag=StaticText(~cbox_w,Rect(650,678.07,220,13.4));
~cbox_bandfiltag.string_("BandPassFilter: " ++ CaosBox.engine.busIndex(\bpf)).font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.75,0.75,0.75));
//Bandpass out
~cbox_bandoutpop=PopUpMenu(~cbox_w,Rect(650,694.82,220,16.75)).items=["BPF Out to Master","BPF Out to Reverb",
	"BPF Out to Delay","BPF Out to Pitch"];
~cbox_bandoutpop.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_bandoutpop.action={|menu|
	switch(menu.value,
		0,{~cbox_mastbandf.set(\out,CaosBox.engine.busIndex(\master));"+ BPF Out to Master".inform;},
		1,{~cbox_mastbandf.set(\out,CaosBox.engine.busIndex(\reverb));"+ BPF Out to Reverb".inform;},
		2,{~cbox_mastbandf.set(\out,CaosBox.engine.busIndex(\delay));"+ BPF Out to Delay".inform;},
		3,{~cbox_mastbandf.set(\out,CaosBox.engine.busIndex(\pitch));"+ BPF Out to Pitch".inform;}
	);

};
//Bandpass cutfreq
StaticText(~cbox_w,Rect(650,714.93,134.15,15.64)).string_("Cut Frequency").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf5=NumberBox(~cbox_w,Rect(784.15,713.81,85.85,17.87)).background_(Color(0,1,0));
~cbox_bandcfader=Slider(~cbox_w,Rect(650,733.92,220,22.34)).background_(Color(alpha:0));
~cbox_numf5.action={~cbox_mastbandf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_numf5.value));~cbox_bandcfader.value=~cbox_numf5.value/19980};//el cambio de numbox al fader es lineal
~cbox_bandcfader.action={~cbox_mastbandf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_bandcfader.value));~cbox_numf5.value_(~cbox_fmaxmin.map(~cbox_bandcfader.value))};
~cbox_bandcfader.value=20000;
~cbox_numf5.value=20000;
//rq
StaticText(~cbox_w,Rect(650,759.61,134.15,15.64)).string_("Bandwidth").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf6=NumberBox(~cbox_w,Rect(784.15,758.49,85.85,17.87)).background_(Color(0,1,0));
~cbox_bandrqfader=Slider(~cbox_w,Rect(650,778.6,220,11.17)).background_(Color(alpha:0));
~cbox_bandrqfader.action={~cbox_mastbandf.set(\rq,~cbox_rqmaxmin.map(~cbox_bandrqfader.value));~cbox_numf6.value_(~cbox_rqmaxmin.map(~cbox_bandrqfader.value))};
~cbox_numf6.action={~cbox_mastbandf.set(\rq,~cbox_rqmaxmin.map(~cbox_numf6.value));~cbox_bandrqfader.value_(~cbox_rqmaxmin.map(~cbox_numf6.value))};
~cbox_bandrqfader.value=0.5;
~cbox_numf6.value=0.5;
// analizadores (FFT + osciloscopio): ahora viven en una ventana flotante
// CaosBox.freqAnalyzer(true/false), ver Classes/CaosBoxGUI.sc
//granulator
~cbox_grandcolor=Color(alpha:0);//color aleatorio para el pad del granulador
StaticText(~cbox_w,Rect(882,410,222,13.4)).string_("Granulator" ).font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
StaticText(~cbox_w,Rect(882,426.75,222,13.4)).string_(" channel: " ++ CaosBox.engine.busIndex(\grains)).font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
//granulator out
~cbox_grainpop=PopUpMenu(~cbox_w,Rect(882,443.51,222,16.75)).items=["Granulator Out to Master","Granulator Out to Reverb",
	"Granulator Out to Delay","Granulator Out to Pitch",
	"Granulator Out to LPF","Granulator Out to HPF",
	"Granulator Out to BPF"];
~cbox_grainpop.background_(~cbox_grandcolor).stringColor_(Color.gray(0.5));
~cbox_grainpop.action={|menu|
	switch(menu.value,
		0,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\master));"+ Granulator Out to Master".inform;},
		1,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\reverb));"+ Granulator Out to Reverb".inform;},
		2,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\delay));"+ Granulator Out to Delay".inform;},
		3,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\pitch));"+ Granulator Out to Pitch".inform;},
		4,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\lpf));"+ Granulator Out to LPF".inform;},
		5,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\hpf));"+ Granulator Out to HPF".inform;},
		6,{~cbox_grains.set(\out,CaosBox.engine.busIndex(\bpf));"+ Granulator Out to BPF".inform;}
	);
};
//
//granulator values
~cbox_gtparam=ControlSpec.new(4,32,\lin,1,4);
~cbox_gsparam=ControlSpec.new(0.01,0.05,\lin,0.001,0.05);
~cbox_gfaders=Slider2D(~cbox_w, Rect(882,465.85,222,217.81));
//~cbox_gtparam.map(~cbox_gfaders.x.value);
//~cbox_gsparam.map(~cbox_gfaders.y.value);
~cbox_gfaders.action_({|sl| ~cbox_grains.set(\trigger,~cbox_gtparam.map(sl.x.value),\size,~cbox_gsparam.map(sl.y.value))});
~cbox_gfaders.background_(~cbox_grandcolor);
//Automatizacion granulador
StaticText(~cbox_w,Rect(882,689.24,222,13.4)).string_("Auto/Speed").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_autopopg=PopUpMenu(~cbox_w,Rect(882,705.99,222,27.92)).items=["normal","fast","slow","slowest"];
~cbox_autopopg.background_(~cbox_grandcolor).stringColor_(Color.gray(0.5));
~cbox_autopopg.action={|menu|
	switch(menu.value,
		0,{~cbox_divgrain=1;"+ Grains Automation Normal".inform},
		1,{~cbox_divgrain=0.5;"+ Grains Automation Fast".inform},
		2,{~cbox_divgrain=2;"+ Grains Automation Slow".inform},
		3,{~cbox_divgrain=4;"+ Grains Automation Slowest".inform}
	);
};
// el BPM se movio a la fila de transporte (GUI_1) para no tapar LineIn
//
// una sola pasada: los verdes viejos siguen al acento global (play excluido)
CaosBox.gui.themeLegacy(~cbox_w.asView);
CaosBox.gui.makeResizable(~cbox_w, 1120, 860);
~cbox_w.onClose={~cbox_url = nil; CaosBox.close; Main.recompile};//ALV todo!
);
