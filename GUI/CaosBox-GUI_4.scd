(//CaosBox GUI file 4 - v1.2 - filtros, freqscope, bpm, granulador, Close
//Lowpass filter min max values
~cbox_fmaxmin=ControlSpec(20,20000,\exponential,1,1000);
~cbox_rqmaxmin=ControlSpec(0.01,1,\lin,0.01,0.5);
//Filter Aux tag
~cbox_filttag=StaticText(~cbox_w,Rect(575,290,205,12));
~cbox_filttag.string_("Filters").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
//Lowpass tag
~cbox_lowfiltag=StaticText(~cbox_w,Rect(575,305,205,12));
~cbox_lowfiltag.string_("LowPassFilter: 58").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.75,0.75,0.75));
//Lowpass out
~cbox_lowoutpop=PopUpMenu(~cbox_w,Rect(575,320,205,15)).items=["LPF Out to Master","LPF Out to Reverb",
	"LPF Out to Delay","LPF Out to Pitch"];
~cbox_lowoutpop.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_lowoutpop.action={|menu|
	switch(menu.value,
		0,{~cbox_mastlowf.set(\out,50);"+ LPF Out to Master".inform;},
		1,{~cbox_mastlowf.set(\out,52);"+ LPF Out to Reverb".inform;},
		2,{~cbox_mastlowf.set(\out,54);"+ LPF Out to Delay".inform;},
		3,{~cbox_mastlowf.set(\out,56);"+ LPF Out to Pitch".inform;}
	);
};
//Lowpass cutfreq
StaticText(~cbox_w,Rect(575,338,125,14)).string_("Cut Frequency").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf1=NumberBox(~cbox_w,Rect(700,337,80,16)).background_(Color(0,1,0));
~cbox_lowcfader=Slider(~cbox_w,Rect(575,355,205,20)).background_(Color(alpha:0));
~cbox_lowcfader.action={~cbox_mastlowf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_lowcfader.value));~cbox_numf1.value_(~cbox_fmaxmin.map(~cbox_lowcfader.value))};
~cbox_numf1.action={~cbox_mastlowf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_numf1.value));~cbox_lowcfader.value=~cbox_numf1.value/19980};//el cambio de numbox a fader, se vuelve lineal
~cbox_lowcfader.value=20000;
~cbox_numf1.value=20000;
//rq
StaticText(~cbox_w,Rect(575,380,125,14)).string_("Bandwidth").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf2=NumberBox(~cbox_w,Rect(700,379,80,16)).background_(Color(0,1,0));
~cbox_lowrqfader=Slider(~cbox_w,Rect(575,400,205,10)).background_(Color(alpha:0));
~cbox_lowrqfader.action={~cbox_mastlowf.set(\rq,~cbox_rqmaxmin.map(~cbox_lowrqfader.value));~cbox_numf2.value_(~cbox_rqmaxmin.map(~cbox_lowrqfader.value))};
~cbox_numf2.action={~cbox_mastlowf.set(\rq,~cbox_rqmaxmin.map(~cbox_numf2.value));~cbox_lowrqfader.value_(~cbox_rqmaxmin.map(~cbox_numf2.value))};
~cbox_lowrqfader.value=0.5;
~cbox_numf2.value=0.5;
//Highpass tag
~cbox_highfiltag=StaticText(~cbox_w,Rect(575,420,205,12));
~cbox_highfiltag.string_("HighPassFilter: 60").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.75,0.75,0.75));
//Highpass out
~cbox_highoutpop=PopUpMenu(~cbox_w,Rect(575,435,205,15)).items=["HPF Out to Master","HPF Out to Reverb",
	"HPF Out to Delay","HPF Out to Pitch"];
~cbox_highoutpop.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_highoutpop.action={|menu|
	switch(menu.value,
		0,{~cbox_masthighf.set(\out,50);"+ HPF Out to Master".inform;},
		1,{~cbox_masthighf.set(\out,52);"+ HPF Out to Reverb".inform;},
		2,{~cbox_masthighf.set(\out,54);"+ HPF Out to Delay".inform;},
		3,{~cbox_masthighf.set(\out,56);"+ HPF Out to Pitch".inform;}
	);
};
//Highpass cutfreq
StaticText(~cbox_w,Rect(575,453,125,14)).string_("Cut Frequency").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf3=NumberBox(~cbox_w,Rect(700,452,80,16)).background_(Color(0,1,0));
~cbox_highcfader=Slider(~cbox_w,Rect(575,470,205,20)).background_(Color(alpha:0));
~cbox_highcfader.action={~cbox_masthighf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_highcfader.value));~cbox_numf3.value_(~cbox_fmaxmin.map(~cbox_highcfader.value))};
~cbox_numf3.action={~cbox_masthighf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_numf3.value));~cbox_highcfader.value=~cbox_numf3.value/19980};
~cbox_highcfader.value=0.15;
~cbox_numf3.value=45;
//rq
StaticText(~cbox_w,Rect(575,493,125,14)).string_("Bandwidth").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf4=NumberBox(~cbox_w,Rect(700,492,80,16)).background_(Color(0,1,0));
~cbox_highrqfader=Slider(~cbox_w,Rect(575,510,205,10)).background_(Color(alpha:0));
~cbox_highrqfader.action={~cbox_masthighf.set(\rq,~cbox_rqmaxmin.map(~cbox_highrqfader.value));~cbox_numf4.value_(~cbox_rqmaxmin.map(~cbox_highrqfader.value))};
~cbox_numf4.action={~cbox_masthighf.set(\rq,~cbox_rqmaxmin.map(~cbox_numf4.value));~cbox_highrqfader.value_(~cbox_rqmaxmin.map(~cbox_numf4.value))};
~cbox_highrqfader.value=0.5;
~cbox_numf4.value=0.5;
//Bandpass tag
~cbox_bandfiltag=StaticText(~cbox_w,Rect(575,530,205,12));
~cbox_bandfiltag.string_("BandPassFilter: 62").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.75,0.75,0.75));
//Bandpass out
~cbox_bandoutpop=PopUpMenu(~cbox_w,Rect(575,545,205,15)).items=["BPF Out to Master","BPF Out to Reverb",
	"BPF Out to Delay","BPF Out to Pitch"];
~cbox_bandoutpop.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_bandoutpop.action={|menu|
	switch(menu.value,
		0,{~cbox_mastbandf.set(\out,50);"+ BPF Out to Master".inform;},
		1,{~cbox_mastbandf.set(\out,52);"+ BPF Out to Reverb".inform;},
		2,{~cbox_mastbandf.set(\out,54);"+ BPF Out to Delay".inform;},
		3,{~cbox_mastbandf.set(\out,56);"+ BPF Out to Pitch".inform;}
	);

};
//Bandpass cutfreq
StaticText(~cbox_w,Rect(575,563,125,14)).string_("Cut Frequency").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf5=NumberBox(~cbox_w,Rect(700,562,80,16)).background_(Color(0,1,0));
~cbox_bandcfader=Slider(~cbox_w,Rect(575,580,205,20)).background_(Color(alpha:0));
~cbox_numf5.action={~cbox_mastbandf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_numf5.value));~cbox_bandcfader.value=~cbox_numf5.value/19980};//el cambio de numbox al fader es lineal
~cbox_bandcfader.action={~cbox_mastbandf.set(\cutfreq,~cbox_fmaxmin.map(~cbox_bandcfader.value));~cbox_numf5.value_(~cbox_fmaxmin.map(~cbox_bandcfader.value))};
~cbox_bandcfader.value=20000;
~cbox_numf5.value=20000;
//rq
StaticText(~cbox_w,Rect(575,603,125,14)).string_("Bandwidth").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0,0.5,0));
~cbox_numf6=NumberBox(~cbox_w,Rect(700,602,80,16)).background_(Color(0,1,0));
~cbox_bandrqfader=Slider(~cbox_w,Rect(575,620,205,10)).background_(Color(alpha:0));
~cbox_bandrqfader.action={~cbox_mastbandf.set(\rq,~cbox_rqmaxmin.map(~cbox_bandrqfader.value));~cbox_numf6.value_(~cbox_rqmaxmin.map(~cbox_bandrqfader.value))};
~cbox_numf6.action={~cbox_mastbandf.set(\rq,~cbox_rqmaxmin.map(~cbox_numf6.value));~cbox_bandrqfader.value_(~cbox_rqmaxmin.map(~cbox_numf6.value))};
~cbox_bandrqfader.value=0.5;
~cbox_numf6.value=0.5;
//freqscope
StaticText(~cbox_w,Rect(785,12,155,15)).string_("Frequency Analyzer:").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
~cbox_fbot=Button(~cbox_w,Rect(940,12,80,15));
~cbox_fbot.states=[["On",Color.black,Color.green],
	["Off",Color.white,Color.red]];
~cbox_fbot.action={|val| if(val.value==0,{~cbox_f.active_(false);"->Frequency Analyzer has Stopped<-".inform},
	{~cbox_f.active_(true);"->Frequency Analyzer has Started<-".inform})};
~cbox_f=FreqScopeView(~cbox_w,Rect(785,27,235,100)).freqMode_(1);
~cbox_f.background_(Color(0.1,0.1,0.1));
~cbox_f.active_(false);
//granulator
~cbox_grandcolor=Color(alpha:0);//color aleatorio para el pad del granulador
StaticText(~cbox_w,Rect(785,290,235,12)).string_("Granulator" ).font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
StaticText(~cbox_w,Rect(785,305,235,12)).string_(" channel: 64").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
//granulator out
~cbox_grainpop=PopUpMenu(~cbox_w,Rect(785,320,235,15)).items=["Granulator Out to Master","Granulator Out to Reverb",
	"Granulator Out to Delay","Granulator Out to Pitch",
	"Granulator Out to LPF","Granulator Out to HPF",
	"Granulator Out to BPF"];
~cbox_grainpop.background_(~cbox_grandcolor).stringColor_(Color.gray(0.5));
~cbox_grainpop.action={|menu|
	switch(menu.value,
		0,{~cbox_grains.set(\out,50);"+ Granulator Out to Master".inform;},
		1,{~cbox_grains.set(\out,52);"+ Granulator Out to Reverb".inform;},
		2,{~cbox_grains.set(\out,54);"+ Granulator Out to Delay".inform;},
		3,{~cbox_grains.set(\out,56);"+ Granulator Out to Pitch".inform;},
		4,{~cbox_grains.set(\out,58);"+ Granulator Out to LPF".inform;},
		5,{~cbox_grains.set(\out,60);"+ Granulator Out to HPF".inform;},
		6,{~cbox_grains.set(\out,62);"+ Granulator Out to BPF".inform;}
	);
};
//
//granulator values
~cbox_gtparam=ControlSpec.new(4,32,\lin,1,4);
~cbox_gsparam=ControlSpec.new(0.01,0.05,\lin,0.001,0.05);
~cbox_gfaders=Slider2D(~cbox_w, Rect(785,340,235,195));
//~cbox_gtparam.map(~cbox_gfaders.x.value);
//~cbox_gsparam.map(~cbox_gfaders.y.value);
~cbox_gfaders.action_({|sl| ~cbox_grains.set(\trigger,~cbox_gtparam.map(sl.x.value),\size,~cbox_gsparam.map(sl.y.value))});
~cbox_gfaders.background_(~cbox_grandcolor);
//Automatizacion granulador
StaticText(~cbox_w,Rect(785,540,235,12)).string_("Auto/Speed").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_autopopg=PopUpMenu(~cbox_w,Rect(785,555,235,25)).items=["normal","fast","slow","slowest"];
~cbox_autopopg.background_(~cbox_grandcolor).stringColor_(Color.gray(0.5));
~cbox_autopopg.action={|menu|
	switch(menu.value,
		0,{~cbox_divgrain=1;"+ Grains Automation Normal".inform},
		1,{~cbox_divgrain=0.5;"+ Grains Automation Fast".inform},
		2,{~cbox_divgrain=2;"+ Grains Automation Slow".inform},
		3,{~cbox_divgrain=4;"+ Grains Automation Slowest".inform}
	);
};
//clock
StaticText(~cbox_w,Rect(785,272,185,15)).string_("BPM:").font_(Font("Dejavu Sans",14,true)).align_(\center).background_(Color(1,0,0));
~cbox_numclock=NumberBox(~cbox_w,Rect(970,272,50,15)).background_(Color(0,1,0)).align_(\center);
~cbox_numclock.value=115;
~cbox_numclock.action={
	~cbox_clock={TempoClock.tempo=~cbox_numclock.value/60};
	~cbox_clock.value;
	("+ BPM set to" + ~cbox_numclock.value).inform;
};
//
~cbox_w.onClose={~cbox_url = nil; CaosBox.close};//ALV todo!
);