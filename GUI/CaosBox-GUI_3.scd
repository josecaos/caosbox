(//CaosBox GUI file 3 - v1.2 - In, steps, aux
//In
StaticText(~cbox_w,Rect(5,252,53,15)).string_("LineIn:").stringColor_(Color(0.85,0.85,0.85)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.5,0.5,0.5));

~cbox_checkbox = 60;

for (0, 31, { |i|

	var checkvar = "~cbox_insteps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checkin.put(i,variable);

	~cbox_checkin[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 250, 20, 20)).action={|val|
		if(val.value,{~cbox_in.put(i,~cbox_entrada=Synth(\ent))},{~cbox_in.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});
//resetea secuencias In
~cbox_delin=Button(~cbox_w,Rect(765,252,15,15));
~cbox_delin.states=[[" X ",Color.black,Color.red]];
~cbox_delin.action={|val|

	if(val.value==0,{

		~cbox_in.put((0..31),nil);

		for(0, 31, {|i|
			~cbox_checkin[i].value = 0;

		});

		"Cleared line in steps!".inform;
})};

//line In attack and release knobs
~cbox_inattknob=EZKnob(~cbox_w,Rect(785,251,81,17),nil,ControlSpec(0.01,0.25,\lin,0.001,0.1,\att),{|a| a.value;~cbox_entrada.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green,Color.grey, Color.black, Color.yellow);

~cbox_inrelknob=EZKnob(~cbox_w,Rect(870,251,81,17),nil,ControlSpec(0.05,0.75,\lin,0.001,0.1,\rel),{|a| a.value;~cbox_entrada.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green,Color.grey, Color.black, Color.yellow);

//master sliders
//master tag
~cbox_mastertag=StaticText(~cbox_w,Rect(5,290,270,12));
~cbox_mastertag.string_("Master Compressor/Limiter: 50").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
//master Vol
~cbox_mastervol=StaticText(~cbox_w,Rect(5,305,50,15));//
~cbox_mastervol.string_("Amp:").font_(Font("Dejavu Sans",12,true)).align_(\left).background_(Color(0.5,0.5,0.5));
~cbox_num=NumberBox(~cbox_w,Rect(5,322,50,20)).background_(Color(0,1,0));
~cbox_mastfader=Slider(~cbox_w,Rect(5,342,50,290)).background_(Color(alpha:0));
~cbox_mastfader.action={~cbox_mast.set(\vol,~cbox_mastfader.value);~cbox_num.value_(~cbox_mastfader.value)};
~cbox_num.action={~cbox_mast.set(\vol,1);~cbox_mastfader.value_(~cbox_num.value)};
~cbox_mastfader.value=1;
~cbox_num.value=1;
//compresor threshold
~cbox_mastercomp=StaticText(~cbox_w,Rect(60,305,50,15));//
~cbox_mastercomp.string_("Thres:").font_(Font("Dejavu Sans",12,true)).align_(\left).background_(Color(0.5,0.5,0.5));
~cbox_num1=NumberBox(~cbox_w,Rect(60,322,50,20)).background_(Color(0,1,0));
~cbox_mastfader1=Slider(~cbox_w,Rect(60,342,50,290)).background_(Color(alpha:0));
~cbox_mastfader1.action={~cbox_mast.set(\compThres,~cbox_mastfader1.value);~cbox_num1.value_(~cbox_mastfader1.value)};
~cbox_num1.action={~cbox_mast.set(\compThres,~cbox_num1.value);~cbox_mastfader1.value_(~cbox_num1.value)};
~cbox_mastfader1.value=1;
~cbox_num1.value=1;
//compresor slopeBelow
~cbox_mastercomp1=StaticText(~cbox_w,Rect(115,305,50,15));//
~cbox_mastercomp1.string_("Below:").font_(Font("Dejavu Sans",12,true)).align_(\left).background_(Color(0.5,0.5,0.5));
~cbox_num2=NumberBox(~cbox_w,Rect(115,322,50,20)).background_(Color(0,1,0));
~cbox_mastfader2=Slider(~cbox_w,Rect(115,342,50,290)).background_(Color(alpha:0));
~cbox_mastfader2.action={~cbox_mast.set(\below,~cbox_mastfader2.value);~cbox_num2.value_(~cbox_mastfader2.value)};
~cbox_num2.action={~cbox_mast.set(\below,~cbox_num2.value);~cbox_mastfader2.value_(~cbox_num2.value)};
~cbox_mastfader2.value=0.5;
~cbox_num2.value=0.5;
//compresor relaxtime
~cbox_mastercomp2=StaticText(~cbox_w,Rect(170,305,50,15));//
~cbox_mastercomp2.string_("Relax:").font_(Font("Dejavu Sans",12,true)).align_(\left).background_(Color(0.5,0.5,0.5));
~cbox_num3=NumberBox(~cbox_w,Rect(170,322,50,20)).background_(Color(0,1,0));
~cbox_mastfader3=Slider(~cbox_w,Rect(170,342,50,290)).background_(Color(alpha:0));
~cbox_mastfader3.action={~cbox_mast.set(\relaxTime,~cbox_mastfader3.value);~cbox_num3.value_(~cbox_mastfader3.value)};
~cbox_num3.action={~cbox_mast.set(\relaxTime,~cbox_num3.value);~cbox_mastfader3.value_(~cbox_num3.value)};
~cbox_mastfader3.value=1;
~cbox_num3.value=1;
//limiter
~cbox_masterlimit=StaticText(~cbox_w,Rect(225,305,50,15));//
~cbox_masterlimit.string_("limiter:").font_(Font("Dejavu Sans",12,true)).align_(\left).background_(Color(0.5,0.5,0.5));
~cbox_num4=NumberBox(~cbox_w,Rect(225,322,50,20)).background_(Color(0,1,0));
~cbox_mastfader4=Slider(~cbox_w,Rect(225,342,50,290)).background_(Color(alpha:0));
~cbox_mastfader4.action={~cbox_mast.set(\limit,~cbox_mastfader4.value);~cbox_num4.value_(~cbox_mastfader4.value)};
~cbox_num4.action={~cbox_mast.set(\limit,~cbox_num.value);~cbox_mastfader4.value_(~cbox_num4.value)};
~cbox_mastfader4.value=0.9;
~cbox_num4.value=0.9;
//
//Aux tag
~cbox_auxtag=StaticText(~cbox_w,Rect(280,290,290,12));
~cbox_auxtag.string_("Effects").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.85,0.85,0.85));
//aux tag
~cbox_auxrtag=StaticText(~cbox_w,Rect(280,305,105,12));
~cbox_auxrtag.string_("Reverb:52").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
//reverb mix
~cbox_auxrmix=StaticText(~cbox_w,Rect(280,320,35,15));//
~cbox_auxrmix.string_("mix").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numr=NumberBox(~cbox_w,Rect(280,337,35,20)).background_(Color(0,1,0));
~cbox_auxrfader=Slider(~cbox_w,Rect(280,357,35,180)).background_(Color(alpha:0));
~cbox_auxrfader.action={~cbox_mastrev.set(\mix,~cbox_auxrfader.value);~cbox_numr.value_(~cbox_auxrfader.value)};
~cbox_numr.action={~cbox_mastrev.set(\mix,~cbox_numr.value);~cbox_auxrfader.value_(~cbox_numr.value)};
~cbox_auxrfader.value=0;
~cbox_numr.value=0;
//reverb room
~cbox_auxroom=StaticText(~cbox_w,Rect(315,320,35,15));//
~cbox_auxroom.string_("room").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numroom=NumberBox(~cbox_w,Rect(315,337,35,20)).background_(Color(0,1,0));
~cbox_auxroomfader=Slider(~cbox_w,Rect(315,357,35,180)).background_(Color(alpha:0));
~cbox_auxroomfader.action={~cbox_mastrev.set(\room,~cbox_auxroomfader.value);~cbox_numroom.value_(~cbox_auxroomfader.value)};
~cbox_numroom.action={~cbox_mastrev.set(\room,~cbox_numroom.value);~cbox_auxroomfader.value_(~cbox_numroom.value)};
~cbox_auxroomfader.value=0.1;
~cbox_numroom.value=0.1;
//reverb damp
~cbox_auxd=StaticText(~cbox_w,Rect(350,320,35,15));//
~cbox_auxd.string_("damp").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numd=NumberBox(~cbox_w,Rect(350,337,35,20)).background_(Color(0,1,0));
~cbox_auxdfader=Slider(~cbox_w,Rect(350,357,35,180)).background_(Color(alpha:0));
~cbox_auxdfader.action={~cbox_mastrev.set(\damp,~cbox_auxdfader.value);~cbox_numd.value_(~cbox_auxdfader.value)};
~cbox_numd.action={~cbox_mastrev.set(\damp,~cbox_numd.value);~cbox_auxdfader.value_(~cbox_numd.value)};
~cbox_auxdfader.value=0.1;
~cbox_numd.value=0.1;
//rev velocidad atomatizacion
StaticText(~cbox_w,Rect(280,540,105,12)).string_("Auto/Speed").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_autopopr=PopUpMenu(~cbox_w,Rect(280,555,105,25)).items=["normal","fast","slow","slowest"];
~cbox_autopopr.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_autopopr.action={|menu|

	switch(menu.value,
		0,{~cbox_divrev=1},
		1,{~cbox_divrev=0.5},
		2,{~cbox_divrev=2},
		3,{~cbox_divrev=4}
	);

};
//aux2 tag
~cbox_auxdtag=StaticText(~cbox_w,Rect(390,305,70,12));
~cbox_auxdtag.string_("Delay:54").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
//tipo delay
StaticText(~cbox_w,Rect(390,497,70,15)).string_("Cub/Lin").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_bott=Button(~cbox_w,Rect(390,515,70,22));
~cbox_bott.states=[["CombC",Color.white,Color.gray(0.25)],
	["CombL",Color.black,Color.gray(0.35)]];
~cbox_bott.action={|val|if(val.value==0,{~cbox_mastdel.set(\delind,0);"->Cubic Delay<-".inform},
	{~cbox_mastdel.set(\delind,1);"->Lineal Delay<-".inform})};
//delay time
~cbox_auxt=StaticText(~cbox_w,Rect(390,320,35,15));//
~cbox_auxt.string_("time").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numt=NumberBox(~cbox_w,Rect(390,337,35,20)).background_(Color(0,1,0));
~cbox_auxtfader=Slider(~cbox_w,Rect(390,357,35,135)).background_(Color(alpha:0));
~cbox_auxtfader.action={~cbox_mastdel.set(\deltime,~cbox_auxtfader.value);~cbox_numt.value_(~cbox_auxtfader.value)};
~cbox_numt.action={~cbox_mastdel.set(\deltime,~cbox_numt.value);~cbox_auxtfader.value_(~cbox_numt.value)};
~cbox_auxtfader.value=0;
~cbox_numt.value=0;
//delay feedback
~cbox_auxf=StaticText(~cbox_w,Rect(425,320,35,15));//
~cbox_auxf.string_("feed").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numf=NumberBox(~cbox_w,Rect(425,337,35,20)).background_(Color(0,1,0));
~cbox_auxffader=Slider(~cbox_w,Rect(425,357,35,135)).background_(Color(alpha:0));
~cbox_auxffader.action={~cbox_mastdel.set(\delfeed,~cbox_auxffader.value*4);~cbox_numf.value_(~cbox_auxffader.value*4)};
~cbox_numf.action={~cbox_mastdel.set(\delfeed,~cbox_numf.value*4);~cbox_auxffader.value_(~cbox_numf.value/4)};
~cbox_auxffader.value=0.1;
~cbox_numf.value=0.1;
//delay valor atomatizacion
StaticText(~cbox_w,Rect(390,540,70,12)).string_("Auto/Speed").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_autopopd=PopUpMenu(~cbox_w,Rect(390,555,70,25)).items=["normal","fast","slow","slowest"];
~cbox_autopopd.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_autopopd.action={|menu|

	switch(menu.value,
		0,{~cbox_divdel=1},
		1,{~cbox_divdel=0.5},
		2,{~cbox_divdel=2},
		3,{~cbox_divdel=4}
	);

};
//aux3 tag
~cbox_auxdtag=StaticText(~cbox_w,Rect(465,305,105,12));
~cbox_auxdtag.string_("Pitch:56").font_(Font("Dejavu Sans",12,true)).align_(\center).background_(Color(0.5,0.5,0.5));
//pitch rate
~cbox_auxp=StaticText(~cbox_w,Rect(465,320,35,15));//
~cbox_auxp.string_("rate").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_nump=NumberBox(~cbox_w,Rect(465,337,35,20)).background_(Color(0,1,0));
~cbox_auxpfader=Slider(~cbox_w,Rect(465,357,35,180)).background_(Color(alpha:0));
~cbox_auxpfader.action={~cbox_mastpit.set(\pitch,~cbox_auxpfader.value*4);~cbox_nump.value_(~cbox_auxpfader.value*4)};
~cbox_nump.action={~cbox_mastpit.set(\pitch,~cbox_nump.value*4);~cbox_auxpfader.value_(~cbox_nump.value/4)};
~cbox_auxpfader.value=0.25;
~cbox_nump.value=1;
// pitch dispersion
~cbox_auxpd=StaticText(~cbox_w,Rect(500,320,35,15));//
~cbox_auxpd.string_("pDis").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numpd=NumberBox(~cbox_w,Rect(500,337,35,20)).background_(Color(0,1,0));
~cbox_auxpdfader=Slider(~cbox_w,Rect(500,357,35,180)).background_(Color(alpha:0));
~cbox_auxpdfader.action={~cbox_mastpit.set(\pitchDispersion,~cbox_auxpdfader.value);~cbox_numpd.value_(~cbox_auxpdfader.value)};
~cbox_numpd.action={~cbox_mastpit.set(\pitchDispersion,~cbox_numpd.value);~cbox_auxpdfader.value_(~cbox_numpd.value)};
~cbox_auxpdfader.value=0;
~cbox_numpd.value=0;
//pitch time dispersion
~cbox_auxtd=StaticText(~cbox_w,Rect(535,320,35,15));//
~cbox_auxtd.string_("tDis").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_numtd=NumberBox(~cbox_w,Rect(535,337,35,20)).background_(Color(0,1,0));
~cbox_auxtdfader=Slider(~cbox_w,Rect(535,357,35,180)).background_(Color(alpha:0));
~cbox_auxtdfader.action={~cbox_mastpit.set(\timeDispersion,~cbox_auxtdfader.value/5);~cbox_numtd.value_(~cbox_auxtdfader.value/5)};
~cbox_numtd.action={~cbox_mastpit.set(\timeDispersion,~cbox_numtd.value/5);~cbox_auxtdfader.value_(~cbox_numtd.value/5)};
~cbox_auxtdfader.value=0;
~cbox_numtd.value=0;
//pitch valor atomatizacion
StaticText(~cbox_w,Rect(465,540,105,12)).string_("Auto/Speed").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_autopopp=PopUpMenu(~cbox_w,Rect(465,555,105,25)).items=["normal","fast","slow","slowest"];
~cbox_autopopp.background_(Color(alpha:0)).stringColor_(Color.gray(0.5));
~cbox_autopopp.action={|menu|

	switch(menu.value,
		0,{~cbox_divpitch=1},
		1,{~cbox_divpitch=0.5},
		2,{~cbox_divpitch=2},
		3,{~cbox_divpitch=4},
	);

};
//Botones automatizacion
//autoreverb
StaticText(~cbox_w,Rect(280,585,105,15)).string_("Automation:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.75,0.75,0.75));
~cbox_autobotr=Button(~cbox_w,Rect(280,600,105,30));
~cbox_autobotr.states=[[" Auto On ",Color.white,Color(alpha:0.25)],
	[" Auto Off ",Color.black,Color.green(0.9)]];
~cbox_autobotr.action={|val|if(val.value==1,{Tdef(\autor).play},{Tdef(\autor).stop})};
//autodelay
StaticText(~cbox_w,Rect(390,585,70,15)).string_("Automation:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.75,0.75,0.75));
~cbox_autobotd=Button(~cbox_w,Rect(390,600,70,30));
~cbox_autobotd.states=[[" Auto On ",Color.white,Color(alpha:0.25)],
	[" Auto Off ",Color.black,Color.green(0.9)]];
~cbox_autobotd.action={|val|if(val.value==1,{Tdef(\autod).play},{Tdef(\autod).stop})};
//autopitch
StaticText(~cbox_w,Rect(465,585,105,15)).string_("Automation:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.75,0.75,0.75));
~cbox_autobotp=Button(~cbox_w,Rect(465,600,105,30));
~cbox_autobotp.states=[[" Auto On ",Color.white,Color(alpha:0.25)],
	[" Auto Off ",Color.black,Color.green(0.9)]];
~cbox_autobotp.action={|val|if(val.value==1,{Tdef(\autop).play},{Tdef(\autop).stop})};
//autograin
StaticText(~cbox_w,Rect(785,585,235,15)).string_("Automation:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.75,0.75,0.75));
~cbox_autobotg=Button(~cbox_w,Rect(785,600,235,30));
~cbox_autobotg.states=[[" Auto On ",Color.gray(0.85),Color(alpha:0.25)],
	[" Auto Off ",Color.black,Color.green(0.5)]];
~cbox_autobotg.action={|val|if(val.value==1,{Tdef(\autog).play},{Tdef(\autog).stop})};
//
);