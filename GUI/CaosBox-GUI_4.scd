(//CaosBox GUI 4 - filtros, freqscope, bpm, granulador, onClose
//filter min max values
~fmaxmin=ControlSpec(20,20000,\exponential,1,1000);
~rqmaxmin=ControlSpec(0.01,1,\lin,0.01,0.5);
//Filter Aux tag
~filttag=StaticText(~w,Rect(575,290,205,12));
~filttag.string_("Filters-> code out to channel:").align_(\center).background_(Color(0.85,0.85,0.85));
//Lowpass tag
~lowfiltag=StaticText(~w,Rect(575,305,205,12));
~lowfiltag.string_("LowPassFilter: 58").align_(\center).background_(Color(0.75,0.75,0.75));
//Lowpass out
~lowoutpop=PopUpMenu(~w,Rect(575,320,205,15)).items=["LPF Out to Master","LPF Out to Reverb",
	"LPF Out to Delay","LPF Out to Pitch"];
~lowoutpop.background_(Color(0.05,0.05,0.25,1)).stringColor_(Color.gray(0.5));
~lowoutpop.action={|menu|
	switch(menu.value,
		0,{~mastlowf.set(\out,50);"+LPF Out to Master".postln;},
		1,{~mastlowf.set(\out,52);"+LPF Out to Reverb".postln;},
		2,{~mastlowf.set(\out,54);"+LPF Out to Delay".postln;},
		3,{~mastlowf.set(\out,56);"+LPF Out to Pitch".postln;}
	);
};
//Lowpass cutfreq
StaticText(~w,Rect(575,338,125,14)).string_("Cut Frequency").align_(\center).background_(Color(0,0.5,0));
~numf1=NumberBox(~w,Rect(700,337,80,16)).background_(Color(0,1,0));
~lowcfader=Slider(~w,Rect(575,355,205,20)).background_(Color(0.05,0.05,0.25,0.1));
~lowcfader.action={~mastlowf.set(\cutfreq,~fmaxmin.map(~lowcfader.value));~numf1.value_(~fmaxmin.map(~lowcfader.value))};
~numf1.action={~mastlowf.set(\cutfreq,~fmaxmin.map(~numf1.value));~lowcfader.value=~numf1.value/19980};//el cambio de numbox a fader, se vuelve lineal
~lowcfader.value=20000;
~numf1.value=20000;
//rq
StaticText(~w,Rect(575,380,125,14)).string_("Bandwidth").align_(\center).background_(Color(0,0.5,0));
~numf2=NumberBox(~w,Rect(700,379,80,16)).background_(Color(0,1,0));
~lowrqfader=Slider(~w,Rect(575,400,205,10)).background_(Color(0.05,0.05,0.25,0.1));
~lowrqfader.action={~mastlowf.set(\rq,~rqmaxmin.map(~lowrqfader.value));~numf2.value_(~rqmaxmin.map(~lowrqfader.value))};
~numf2.action={~mastlowf.set(\rq,~rqmaxmin.map(~numf2.value));~lowrqfader.value_(~rqmaxmin.map(~numf2.value))};
~lowrqfader.value=0.5;
~numf2.value=0.5;
//Highpass tag
~highfiltag=StaticText(~w,Rect(575,420,205,12));
~highfiltag.string_("HighPassFilter: 60").align_(\center).background_(Color(0.75,0.75,0.75));
//Highpass out
~highoutpop=PopUpMenu(~w,Rect(575,435,205,15)).items=["HPF Out to Master","HPF Out to Reverb",
	"HPF Out to Delay","HPF Out to Pitch"];
~highoutpop.background_(Color(0.05,0.05,0.25,1)).stringColor_(Color.gray(0.5));
~highoutpop.action={|menu|
	switch(menu.value,
		0,{~masthighf.set(\out,50);"+HPF Out to Master".postln;},
		1,{~masthighf.set(\out,52);"+HPF Out to Reverb".postln;},
		2,{~masthighf.set(\out,54);"+HPF Out to Delay".postln;},
		3,{~masthighf.set(\out,56);"+HPF Out to Pitch".postln;}
	);
};
//Highpass cutfreq
StaticText(~w,Rect(575,453,125,14)).string_("Cut Frequency").align_(\center).background_(Color(0,0.5,0));
~numf3=NumberBox(~w,Rect(700,452,80,16)).background_(Color(0,1,0));
~highcfader=Slider(~w,Rect(575,470,205,20)).background_(Color(0.05,0.05,0.25,0.1));
~highcfader.action={~masthighf.set(\cutfreq,~fmaxmin.map(~highcfader.value));~numf3.value_(~fmaxmin.map(~highcfader.value))};
~numf3.action={~masthighf.set(\cutfreq,~fmaxmin.map(~numf3.value));~highcfader.value=~numf3.value/19980};
~highcfader.value=0.15;
~numf3.value=45;
//rq
StaticText(~w,Rect(575,493,125,14)).string_("Bandwidth").align_(\center).background_(Color(0,0.5,0));
~numf4=NumberBox(~w,Rect(700,492,80,16)).background_(Color(0,1,0));
~highrqfader=Slider(~w,Rect(575,510,205,10)).background_(Color(0.05,0.05,0.25,0.1));
~highrqfader.action={~masthighf.set(\rq,~rqmaxmin.map(~highrqfader.value));~numf4.value_(~rqmaxmin.map(~highrqfader.value))};
~numf4.action={~masthighf.set(\rq,~rqmaxmin.map(~numf4.value));~highrqfader.value_(~rqmaxmin.map(~numf4.value))};
~highrqfader.value=0.5;
~numf4.value=0.5;
//Bandpass tag
~bandfiltag=StaticText(~w,Rect(575,530,205,12));
~bandfiltag.string_("BandPassFilter: 62").align_(\center).background_(Color(0.75,0.75,0.75));
//Bandpass out
~bandoutpop=PopUpMenu(~w,Rect(575,545,205,15)).items=["BPF Out to Master","BPF Out to Reverb",
	"BPF Out to Delay","BPF Out to Pitch"];
~bandoutpop.background_(Color(0.05,0.05,0.25,1)).stringColor_(Color.gray(0.5));
~bandoutpop.action={|menu|
	switch(menu.value,
		0,{~mastbandf.set(\out,50);"+BPF Out to Master".postln;},
		1,{~mastbandf.set(\out,52);"+BPF Out to Reverb".postln;},
		2,{~mastbandf.set(\out,54);"+BPF Out to Delay".postln;},
		3,{~mastbandf.set(\out,56);"+BPF Out to Pitch".postln;}
	);

};
//Bandpass cutfreq
StaticText(~w,Rect(575,563,125,14)).string_("Cut Frequency").align_(\center).background_(Color(0,0.5,0));
~numf5=NumberBox(~w,Rect(700,562,80,16)).background_(Color(0,1,0));
~bandcfader=Slider(~w,Rect(575,580,205,20)).background_(Color(0.05,0.05,0.25,0.1));
~numf5.action={~mastbandf.set(\cutfreq,~fmaxmin.map(~numf5.value));~bandcfader.value=~numf5.value/19980};//el cambio de numbox al fader es lineal
~bandcfader.action={~mastbandf.set(\cutfreq,~fmaxmin.map(~bandcfader.value));~numf5.value_(~fmaxmin.map(~bandcfader.value))};
~bandcfader.value=20000;
~numf5.value=20000;
//rq
StaticText(~w,Rect(575,603,125,14)).string_("Bandwidth").align_(\center).background_(Color(0,0.5,0));
~numf6=NumberBox(~w,Rect(700,602,80,16)).background_(Color(0,1,0));
~bandrqfader=Slider(~w,Rect(575,620,205,10)).background_(Color(0.05,0.05,0.25,0.1));
~bandrqfader.action={~mastbandf.set(\rq,~rqmaxmin.map(~bandrqfader.value));~numf6.value_(~rqmaxmin.map(~bandrqfader.value))};
~numf6.action={~mastbandf.set(\rq,~rqmaxmin.map(~numf6.value));~bandrqfader.value_(~rqmaxmin.map(~numf6.value))};
~bandrqfader.value=0.5;
~numf6.value=0.5;
//freqscope
StaticText(~w,Rect(785,12,155,15)).string_("Frequency Analyzer:").align_(\center).background_(Color(0.85,0.85,0.85));
~fbot=Button(~w,Rect(940,12,80,15));
~fbot.states=[["On",Color.black,Color.green],
	["Off",Color.white,Color.red]];
~fbot.action={|val| if(val.value==0,{~f.active_(false);"->Frequency Analyzer has Stopped<-".postcln},
	{~f.active_(true);"->Frequency Analyzer has Started<-".postcln})};
~f=FreqScopeView(~w,Rect(785,27,235,100)).freqMode_(1);
~f.background_(Color(0.1,0.1,0.1));
~f.active_(false);
//granulator
~grandcolor=Color(0,rrand(0.01,rrand(0.25,0.75)),rrand(0.01,rrand(0.25,0.75)));//color aleatorio para el pad del granulador
StaticText(~w,Rect(785,290,235,12)).string_("Granulator-> code out to" ).align_(\center).background_(Color(0.85,0.85,0.85));
StaticText(~w,Rect(785,305,235,12)).string_(" channel: 64").align_(\center).background_(Color(0.85,0.85,0.85));
//granulator out
~grainpop=PopUpMenu(~w,Rect(785,320,235,15)).items=["Granulator Out to Master","Granulator Out to Reverb",
	"Granulator Out to Delay","Granulator Out to Pitch",
	"Granulator Out to LPF","Granulator Out to HPF",
	"Granulator Out to BPF"];
~grainpop.background_(~grandcolor).stringColor_(Color.gray(0.5));
~grainpop.action={|menu|
	switch(menu.value,
		0,{~grains.set(\out,50);"+Granulator Out to Master".postln;},
		1,{~grains.set(\out,52);"+Granulator Out to Reverb".postln;},
		2,{~grains.set(\out,54);"+Granulator Out to Delay".postln;},
		3,{~grains.set(\out,56);"+Granulator Out to Pitch".postln;},
		4,{~grains.set(\out,58);"+Granulator Out to LPF".postln;},
		5,{~grains.set(\out,60);"+Granulator Out to HPF".postln;},
		6,{~grains.set(\out,62);"+Granulator Out to BPF".postln;}
	);
};
// Help.gui;
//granulator values
~gtparam=ControlSpec.new(4,32,\lin,1,4);
~gsparam=ControlSpec.new(0.01,0.05,\lin,0.001,0.05);
~gfaders=Slider2D(~w, Rect(785,340,235,195));
//~gtparam.map(~gfaders.x.value);
//~gsparam.map(~gfaders.y.value);
~gfaders.action_({|sl| ~grains.set(\trigger,~gtparam.map(sl.x.value),\size,~gsparam.map(sl.y.value))});
~gfaders.background_(~grandcolor);
//Automatizacion granulador
StaticText(~w,Rect(785,540,235,12)).string_("Auto/Speed").align_(\center).background_(Color(0.5,0.5,0.5));
~autopopg=PopUpMenu(~w,Rect(785,555,235,25)).items=["normal","fast","slow","slowest"];
~autopopg.background_(~grandcolor).stringColor_(Color.gray(0.5));
~autopopg.action={|menu|
	switch(menu.value,
		0,{~divgrain=1;"+Grains Automation Normal".postln;},
		1,{~divgrain=0.5;"+Grains Automation Fast".postln;},
		2,{~divgrain=2;"+Grains Automation Slow".postln;},
		3,{~divgrain=4;"+Grains Automation Slowest".postln;}
	);
};
//clock
StaticText(~w,Rect(785,272,185,15)).string_("BeatsPerMinute:").align_(\center).background_(Color(1,0,0));
~numclock=NumberBox(~w,Rect(970,272,50,15)).background_(Color(0,1,0)).align_(\ceneter);
~numclock.value=94;
~numclock.action={~clock={TempoClock.tempo=~numclock.value/60};~clock.value};
//
~w.onClose={Tdef(\secuencias).stop;Tdef(\pasos).stop;Tdef(\autor).stop;Tdef(\autod).stop;Tdef(\autop).stop;Tdef(\autog).stop;
	Tdef(\bass).stop;Tdef(\bass2).stop;Tdef(\pad).stop;Tdef(\pad2).stop;Tdef(\acordes).stop;Tdef(\acordes2).stop;
	~autobotr.value=0;~autobotd.value=0;~autobotp.value=0;~autobotg.value=0;~bott.value=0;~f.kill;~grains.free;History.stop;
	s.quit}
)
