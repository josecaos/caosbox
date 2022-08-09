//CaosBox GUI file 1 - v1.3 - leds, percusiones, botones de control, bienvenida
(
~cbox_w=Window.new("CaosBox v1.3.3 Live Coding Machine for Algorave Music" + " Today is " + ~cbox_fecha,Rect.aboutPoint(Window.screenBounds.center,512,340),false).background=Color(0,0,0);//
//
// leds
StaticText(~cbox_w,Rect(5,272,53,15)).string_("Steps:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0,0.9,0));
for (0, 31, { |i|

	var gvar = "~cbox_step";
	var space = [4,8,12,16,20,24,28];
	var variable = gvar ++ i;

	~cbox_lightsteps.put(i,variable);

	//crea los espacios entre steps
	// colores boton step
	if((i == 0) || (i == space[0]) || (i == space[1]) || (i == space[2]) || (i == space[3]) || (i == space[4]) || (i == space[5]) || (i == space[6]), {

		if(i != 0, {
			~cbox_lightpos = ~cbox_lightpos + 10;//brinco de grupo
		});

		~cbox_lightsteps[i] = Button(~cbox_w,Rect(~cbox_lightpos-1,271,15,15)).font_(Font("DejaVu Sans",9,true)).states = [[" - ",Color.white(0.5),Color.green(0.15)],[i,Color.black,Color.green(0.95)]];

	},{

		~cbox_lightsteps[i] = Button(~cbox_w,Rect(~cbox_lightpos-1,271,15,15)).font_(Font("DejaVu Sans",9,true)).states = [[" - ",Color.white(0.5),Color.red(0.15)],[i,Color.white,Color.red(1)]];

	});

	~cbox_lightpos = ~cbox_lightpos + 20;
	//
});
//
// bombo steps
StaticText(~cbox_w,Rect(5,12,53,15)).string_("Kick:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.85,0.85,0.85));

~cbox_checkbox = 60;

for (0, 31, {|i|

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	~cbox_checkbombo[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 10, 20, 20)).action={|val|
		if(val.value,{ ~cbox_bombo.put(i,~cbox_b/*~cbox_kickgear=Synth(\kickgear)*/)},{~cbox_bombo.put(i,nil)});
	};

	~cbox_checkbox = ~cbox_checkbox + a;

});
// borra steps
~cbox_delbombo=Button(~cbox_w,Rect(765,12,15,15));
~cbox_delbombo.states=[[" X ",Color.black,Color.red]];
~cbox_delbombo.action={|val|if(val.value==0,{

	"Cleared kick sequence!".inform;

	~cbox_bombo.put((0..31),nil);

	for(0, 31, {|i|

		~cbox_checkbombo[i].value = 0;

	});

})};
//

//tarola steps
StaticText(~cbox_w,Rect(5,32,53,15)).string_("Snare:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.85,0.85,0.85));

~cbox_checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~cbox_tsteps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checktarola.put(i,variable);

	~cbox_checktarola[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 30, 20, 20)).action={|val|
		if(val.value,{~cbox_tarola.put(i,~cbox_t)},{~cbox_tarola.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});

// borra steps
~cbox_deltarola=Button(~cbox_w,Rect(765,32,15,15));
~cbox_deltarola.states=[[" X ",Color.black,Color.red]];
~cbox_deltarola.action={|val|if(val.value==0,{

	"Cleared snare sequence!".inform;

	~cbox_tarola.put((0..31),nil);

	for(0, 31, {|i|

		~cbox_checktarola[i].value = 0;

	});

})};

// hihat steps
StaticText(~cbox_w,Rect(5,52,53,15)).string_("HiHats:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.85,0.85,0.85));

~cbox_checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~cbox_hsteps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checkcontras.put(i,variable);

	~cbox_checkcontras[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 50, 20, 20)).action={|val|
		if(val.value,{~cbox_contras.put(i,~cbox_h)},{~cbox_contras.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});

// borra steps
~cbox_delcontras=Button(~cbox_w,Rect(765,52,15,15));
~cbox_delcontras.states=[[" X ",Color.black,Color.red]];
~cbox_delcontras.action={|val|if(val.value==0,{

	"Cleared hihat sequence!".inform;

	~cbox_contras.put((0..31),nil);

	for(0, 31, {|i|

		~cbox_checkcontras[i].value = 0;

	});

})};

// bombo 2 steps
StaticText(~cbox_w,Rect(5,72,53,15)).string_("Kick2:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.85,0.85,0.85));
~cbox_checkbox = 60;
//crea los steps
for (0, 31, { |i|

	var checkvar = "~cbox_b2steps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checkbombo2.put(i,variable);

	~cbox_checkbombo2[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 70, 20, 20)).action={|val|
		if(val.value,{~cbox_bombo2.put(i,~cbox_b2)},{~cbox_bombo2.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});

// borra steps
~cbox_delbombo2=Button(~cbox_w,Rect(765,72,15,15));
~cbox_delbombo2.states=[[" X ",Color.black,Color.red]];
~cbox_delbombo2.action={|val|if(val.value==0,{

	"Cleared kick 2 steps!".inform;

	~cbox_bombo2.put((0..31),nil);

	for(0, 31, {|i|

		~cbox_checkbombo2[i].value = 0;

	});

})};

//tarola 2 steps
StaticText(~cbox_w,Rect(5,92,53,15)).string_("Snare2:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.85,0.85,0.85));
~cbox_checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~cbox_t2steps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checktarola2.put(i,variable);

	~cbox_checktarola2[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 90, 20, 20)).action={|val|
		if(val.value,{~cbox_tarola2.put(i,~cbox_t2)},{~cbox_tarola2.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});

// borra steps
~cbox_deltarola2=Button(~cbox_w,Rect(765,92,15,15));
~cbox_deltarola2.states=[[" X ",Color.black,Color.red]];
~cbox_deltarola2.action={|val|if(val.value==0,{

	"Cleared snare 2 steps!".inform;

	~cbox_tarola2.put((0..31),nil);

	for(0, 31, {|i|

		~cbox_checktarola2[i].value = 0;

	});

})};

// hihat 2 steps
StaticText(~cbox_w,Rect(5,112,53,15)).string_("HiHats2:").font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.85,0.85,0.85));
~cbox_checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~cbox_h2steps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checkcontras2.put(i,variable);

	~cbox_checkcontras2[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 110, 20, 20)).action={|val|
		if(val.value,{~cbox_contras2.put(i,~cbox_h2)},{~cbox_contras2.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});

// borra steps
~cbox_delcontras2=Button(~cbox_w,Rect(765,112,15,15));
~cbox_delcontras2.states=[[" X ",Color.black,Color.red]];
~cbox_delcontras2.action={|val|if(val.value==0,{

	"Cleared hihat 2 steps!".inform;

	~cbox_contras2.put((0..31),nil);

	for(0, 31, {|i|

		~cbox_checkcontras2[i].value = 0;

	});

})};

// tempo
StaticText(~cbox_w,Rect(5,635,270,15)).string_("Beat:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.65,0.65,0.65));
~cbox_botm=Button(~cbox_w,Rect(5,650,135,25));
~cbox_botm.states=[["Thirds",Color.white,Color(alpha:0.25)],
	["Fourths",Color.white,Color(alpha:0)]];
~cbox_botm.action={|val|if(val.value==0,{~cbox_tiempos=0.25;"->Fourths<-".inform},
	{~cbox_tiempos=0.3333333333333333333;"->Thirds<-".inform})};
//tempo aleatorio
~cbox_botr=Button(~cbox_w,Rect(140,650,135,25));
~cbox_botr.states=[["Random Time",Color.white,Color(alpha:0.25)],
	["Regular Time",Color.white,Color(alpha:0.25)]];
~cbox_botr.action={|val|if(val.value==0,{Tdef(\randtime).stop;~cbox_clock.value;"->Main BPM <-".inform},
	{Tdef(\randtime).play;"->Random Clock Values<-".inform})};
//
//play
StaticText(~cbox_w,Rect(275,635,515,15)).string_("PLAY/STOP:").font_(Font("Dejavu Sans",14,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_bot=Button(~cbox_w,Rect(275,650,515,25));
~cbox_bot.states=[["=>",Color.black,Color.green],
	["[_]",Color.white,Color.red]];
~cbox_bot.action={|val|
	var  bool = true;
	if(val.value == 0,{
		bool = false;
		Tdef(\secuencias).pause;Tdef(\autor).pause;Tdef(\autod).pause;Tdef(\autop).pause;Tdef(\autog).pause;
Tdef(\bass).pause;Tdef(\bass2).pause;Tdef(\pad).pause;Tdef(\pad2).pause;Tdef(\acordes).pause;Tdef(\acordes2).pause;Tdef(\entrada).pause;
	~cbox_autobotr.value=0;~cbox_autobotd.value=0;~cbox_autobotp.value=0;~cbox_autobotg.value=0;~cbox_botm.value=0;~cbox_hbutt.value=0;
	"->You just Stopped CaosBox<-".inform;},
{
	if(bool  != true, {
		Tdef(\secuencias).resume;Tdef(\pad).resume;Tdef(\bass).resume;Tdef(\bass2).resume;
		Tdef(\pad2).resume;Tdef(\acordes).resume;Tdef(\acordes2).resume;Tdef(\entrada).resume;"\n -> Now playing, please start algoraving <-".inform;
	},{
		Tdef(\secuencias).play;Tdef(\pad).play;Tdef(\bass).play;Tdef(\bass2).play;
		Tdef(\pad2).play;Tdef(\acordes).play;Tdef(\acordes2).play;Tdef(\entrada).play;"\n -> Now playing, please start algoraving <-".inform;
	});
});
};
//record
~cbox_filea=[~cbox_n.choose,~cbox_l.choose,~cbox_n.choose,~cbox_l.choose];
~cbox_filename=~cbox_filename.add(~cbox_filea.stutter((1..2).choose).scramble.join);
//
StaticText(~cbox_w,Rect(790,635,130,15)).string_("Recording").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.65,0.65,0.65));
~cbox_recbot=Button(~cbox_w,Rect(790,650,130,25));
~cbox_recbot.states=[["Record",Color.green,Color(alpha:0.25)],
	["Stop Recording",Color.white,Color.red]];
~cbox_recbot.action={|val|if(val.value==0,{s.stopRecording;
	"->Stoped Recording<-".inform;
	~cbox_filename=["c","a","o","s","b","o","x","_",~cbox_filea.join,~cbox_l.choose,~cbox_n.choose];
},
{s.record(~cbox_url +/+ "Recorded" +/+  ~cbox_ftype[0] ++ ~cbox_filename.value.join ++ "-" ++ ~cbox_fecha.dayStamp ++ "-" ++ ~cbox_numclock.value ++ "bpm.aiff");
	"->Recording<-".inform})
};
//Historial
StaticText(~cbox_w,Rect(920,635,99,15)).string_("History:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.75,0.75,0.75));
~cbox_hbutt=Button(~cbox_w,Rect(920,650,99,25));
~cbox_hbutt.states=[[" Save File ",Color.green,Color(alpha:0.25)]];
~cbox_hbutt.action={|val| var h=History; if(val.value==0,{"->History saved @ caosbox/Histories folder<-".inform;
	h.saveStory(~cbox_url +/+ "Histories" +/+ ~cbox_ftype[1] ++ ~cbox_filename.value.join ++ ~cbox_fecha.dayStamp ++ ".scd");
	h.stop; h.clear})};
);
