(//CaosBox GUI file 1 - v1.1 - percusiones, botones de control, bienvenida
~w=Window.new("CaosBox v1.1 live Coding Machine for Algorave music ~" + "today is " + ~fecha,Rect.aboutPoint(Window.screenBounds.center,512,340),false).front.background=Color(0,0,0);//
//
// leds
StaticText(~w,Rect(5,272,53,15)).string_("Steps:").align_(\left).background_(Color(0,0.9,0));
for (0, 31, { |i|

	var gvar = "~step";
	var space = [4,8,12,16,20,24,28];
	var variable = gvar ++ i;

	~lightsteps.put(i,variable);

	//crea los espacios entre steps
	// colores boton step
	if((i == 0) || (i == space[0]) || (i == space[1]) || (i == space[2]) || (i == space[3]) || (i == space[4]) || (i == space[5]) || (i == space[6]), {

		if(i != 0, {
			~lightpos = ~lightpos + 10;//brinco de grupo
		});

		~lightsteps[i] = Button(~w,Rect(~lightpos,275,10,10)).states = [[" - ",Color.white(0.5),Color.green(0.25)],["^",Color.yellow,Color.green(0.9)]];

		},{

			~lightsteps[i] = Button(~w,Rect(~lightpos,275,10,10)).states = [[" - ",Color.white(0.5),Color.red(0.25)],["+",Color.yellow,Color.red(1)]];

	});

	~lightpos = ~lightpos + 20;
	//
});
//

// bombo steps
StaticText(~w,Rect(5,12,53,15)).string_("Kick:").align_(\left).background_(Color(0.85,0.85,0.85));

~checkbox = 60;

for (0, 31, { |i|

	// var checkvar = "~bsteps";

	var a = ~checksteps[i%~checksteps.size];

	// var variable = checkvar ++ i;

	// ~checkbombo.put(i,variable);

	~checkbombo[i] = CheckBox.new(~w,Rect(~checkbox, 10, 20, 20)).action={|val|
		if(val.value,{~bombo.put(i,~b)},{~bombo.put(i,nil)});
	};

	~checkbox = ~checkbox + a;

});
// borra steps
~delbombo=Button(~w,Rect(765,12,15,15));
~delbombo.states=[[" X ",Color.black,Color.red]];
~delbombo.action={|val|if(val.value==0,{

	"Cleared kick sequence!".inform;

	~bombo.put((0..31),nil);

	for(0, 31, {|i|

		~checkbombo[i].value = 0;

	});

})};
//


//tarola steps
StaticText(~w,Rect(5,32,53,15)).string_("Snare:").align_(\left).background_(Color(0.85,0.85,0.85));

~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~tsteps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checktarola.put(i,variable);

	~checktarola[i] = CheckBox.new(~w,Rect(~checkbox, 30, 20, 20)).action={|val|
		if(val.value,{~tarola.put(i,~t)},{~tarola.put(i,nil)})};

	~checkbox = ~checkbox + a;

});

// borra steps
~deltarola=Button(~w,Rect(765,32,15,15));
~deltarola.states=[[" X ",Color.black,Color.red]];
~deltarola.action={|val|if(val.value==0,{

	"Cleared snare sequence!".inform;

	~tarola.put((0..31),nil);

	for(0, 31, {|i|

		~checktarola[i].value = 0;

	});

})};

// hihat steps
StaticText(~w,Rect(5,52,53,15)).string_("HiHats:").align_(\left).background_(Color(0.85,0.85,0.85));

~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~hsteps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkcontras.put(i,variable);

	~checkcontras[i] = CheckBox.new(~w,Rect(~checkbox, 50, 20, 20)).action={|val|
		if(val.value,{~contras.put(i,~h)},{~contras.put(i,nil)})};

	~checkbox = ~checkbox + a;

});

// borra steps
~delcontras=Button(~w,Rect(765,52,15,15));
~delcontras.states=[[" X ",Color.black,Color.red]];
~delcontras.action={|val|if(val.value==0,{

	"Cleared hihat sequence!".inform;

	~contras.put((0..31),nil);

	for(0, 31, {|i|

		~checkcontras[i].value = 0;

	});

})};

// bombo 2 steps
StaticText(~w,Rect(5,72,53,15)).string_("Kick2:").align_(\left).background_(Color(0.85,0.85,0.85));
~checkbox = 60;
//crea los steps
for (0, 31, { |i|

	var checkvar = "~b2steps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkbombo2.put(i,variable);

	~checkbombo2[i] = CheckBox.new(~w,Rect(~checkbox, 70, 20, 20)).action={|val|
		if(val.value,{~bombo2.put(i,~b2)},{~bombo2.put(i,nil)})};

	~checkbox = ~checkbox + a;

});

// borra steps
~delbombo2=Button(~w,Rect(765,72,15,15));
~delbombo2.states=[[" X ",Color.black,Color.red]];
~delbombo2.action={|val|if(val.value==0,{

	"Cleared kick 2 steps!".inform;

	~bombo2.put((0..31),nil);

	for(0, 31, {|i|

		~checkbombo2[i].value = 0;

	});

})};

//tarola 2 steps
StaticText(~w,Rect(5,92,53,15)).string_("Snare2:").align_(\left).background_(Color(0.85,0.85,0.85));
~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~t2steps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checktarola2.put(i,variable);

	~checktarola2[i] = CheckBox.new(~w,Rect(~checkbox, 90, 20, 20)).action={|val|
		if(val.value,{~tarola2.put(i,~t2)},{~tarola2.put(i,nil)})};

	~checkbox = ~checkbox + a;

});

// borra steps
~deltarola2=Button(~w,Rect(765,92,15,15));
~deltarola2.states=[[" X ",Color.black,Color.red]];
~deltarola2.action={|val|if(val.value==0,{

	"Cleared snare 2 steps!".inform;

	~tarola2.put((0..31),nil);

	for(0, 31, {|i|

		~checktarola2[i].value = 0;

	});

})};

// hihat 2 steps
StaticText(~w,Rect(5,112,53,15)).string_("HiHats2:").align_(\left).background_(Color(0.85,0.85,0.85));
~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~h2steps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkcontras2.put(i,variable);

	~checkcontras2[i] = CheckBox.new(~w,Rect(~checkbox, 110, 20, 20)).action={|val|
		if(val.value,{~contras2.put(i,~h2)},{~contras2.put(i,nil)})};

	~checkbox = ~checkbox + a;

});

// borra steps
~delcontras2=Button(~w,Rect(765,112,15,15));
~delcontras2.states=[[" X ",Color.black,Color.red]];
~delcontras2.action={|val|if(val.value==0,{

	"Cleared hihat 2 steps!".inform;

	~contras2.put((0..31),nil);

	for(0, 31, {|i|

		~checkcontras2[i].value = 0;

	});

})};

// tempo
StaticText(~w,Rect(5,635,270,15)).string_("Beat:").align_(\center).background_(Color(0.65,0.65,0.65));
~botm=Button(~w,Rect(5,650,135,25));
~botm.states=[["Thirds",Color.white,Color.green(0.35)],
	["Fourths",Color.black,Color.green(0.35)]];
~botm.action={|val|if(val.value==0,{~tiempos=0.25;"->Fourths<-".inform},
	{~tiempos=0.3333333333333333333;"->Thirds<-".inform})};
//tempo aleatorio
~botr=Button(~w,Rect(140,650,135,25));
~botr.states=[["Random Time",Color.black,Color.green(0.35)],
	["Regular Time",Color.white,Color.green(0.35)]];
~botr.action={|val|if(val.value==0,{Tdef(\randtime).stop;~clock.value;"->Main BPM <-".inform},
	{Tdef(\randtime).play;"->Random Clock Values<-".inform})};
//
//automatizacion
//autoreverb
StaticText(~w,Rect(280,585,105,15)).string_("Automation:").align_(\center).background_(Color(0.75,0.75,0.75));
~autobotr=Button(~w,Rect(280,600,105,30));
~autobotr.states=[[" Auto On ",Color.white,Color(0.05,0.05,0.25)],
	[" Auto Off ",Color.black,Color.green(0.9)]];
~autobotr.action={|val|if(val.value==1,{Tdef(\autor).play},{Tdef(\autor).stop})};
//autodelay
StaticText(~w,Rect(390,585,70,15)).string_("Automation:").align_(\center).background_(Color(0.75,0.75,0.75));
~autobotd=Button(~w,Rect(390,600,70,30));
~autobotd.states=[[" Auto On ",Color.white,Color(0.05,0.15,0.25)],
	[" Auto Off ",Color.black,Color.green(0.9)]];
~autobotd.action={|val|if(val.value==1,{Tdef(\autod).play},{Tdef(\autod).stop})};
//autopitch
StaticText(~w,Rect(465,585,105,15)).string_("Automation:").align_(\center).background_(Color(0.75,0.75,0.75));
~autobotp=Button(~w,Rect(465,600,105,30));
~autobotp.states=[[" Auto On ",Color.white,Color(0.05,0.25,0.25)],
	[" Auto Off ",Color.black,Color.green(0.9)]];
~autobotp.action={|val|if(val.value==1,{Tdef(\autop).play},{Tdef(\autop).stop})};
//autograin
StaticText(~w,Rect(785,585,235,15)).string_("Automation:").align_(\center).background_(Color(0.75,0.75,0.75));
~autobotg=Button(~w,Rect(785,600,235,30));
~autobotg.states=[[" Auto On ",Color.gray(0.85),Color.black(0.5)],
	[" Auto Off ",Color.black,Color.green(0.5)]];
~autobotg.action={|val|if(val.value==1,{Tdef(\autog).play},{Tdef(\autog).stop})};
//
//play
StaticText(~w,Rect(275,635,515,15)).string_("PLAY/STOP:").align_(\center).background_(Color(0.5,0.5,0.5));
~bot=Button(~w,Rect(275,650,515,25));
~bot.states=[["=>",Color.black,Color.green],
	["[_]",Color.white,Color.red]];
~bot.action={|val|if(val.value==0,{Tdef(\secuencias).stop;Tdef(\autor).stop;Tdef(\autod).stop;Tdef(\autop).stop;Tdef(\autog).stop;
	Tdef(\bass).stop;Tdef(\bass2).stop;Tdef(\pad).stop;Tdef(\pad2).stop;Tdef(\acordes).stop;Tdef(\acordes2).stop;
	~autobotr.value=0;~autobotd.value=0;~autobotp.value=0;~autobotg.value=0;~botm.value=0;~hbutt.value=0;
	"->You just Stopped CaosBox<-".inform;},
	{Tdef(\secuencias).play;/*Tdef(\pasos).play;*/Tdef(\pad).play;Tdef(\bass).play;Tdef(\bass2).play;
		Tdef(\pad2).play;Tdef(\acordes).play;Tdef(\acordes2).play;"\n -> Now playing, please start algoraving <-".inform})};
//record
~filea=[~n.choose,~l.choose,~n.choose,~l.choose];
~filename=~filename.add(~filea.stutter((1..2).choose).scramble.join);
//
StaticText(~w,Rect(790,635,130,15)).string_("Recording").align_(\center).background_(Color(0.65,0.65,0.65));
~recbot=Button(~w,Rect(790,650,130,25));
~recbot.states=[["Record",Color.black,Color.green(0.35)],
	["Stop Recording",Color.white,Color.red]];
~recbot.action={|val|if(val.value==0,{s.stopRecording;
	"->Stoped Recording<-".inform;
	~filename=["c","a","o","s","b","o","x","_",~filea.join,~l.choose,~n.choose];
	},
	{s.record(~url +/+ "Recorded" +/+  ~ftype[0] ++ ~filename.value.join ++ ~fecha.dayStamp ++ ".aiff");
		"->Recording<-".inform})
};
//Historial
StaticText(~w,Rect(920,635,99,20)).string_("History:").align_(\center).background_(Color(0.75,0.75,0.75));
~hbutt=Button(~w,Rect(920,650,99,25));
~hbutt.states=[[" Save File ",Color.green,Color.black]];
~hbutt.action={|val| var h=History; if(val.value==0,{"->History saved @ caosbox/Histories folder<-".inform;
	h.saveStory(~url +/+ "Histories" +/+ ~ftype[1] ++ ~filename.value.join ++ ~fecha.dayStamp ++ ".scd");
	h.stop; h.clear})};
);