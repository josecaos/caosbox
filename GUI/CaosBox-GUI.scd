(//CaosBox GUI - percusiones, botones de contrl, bienvenida
~w=Window.new("CaosBox v1.0 #liveCodingMachine for Algorave music by @joseCao5",Rect.aboutPoint(Window.screenBounds.center,512,340),false).front.background=Color(0,0,0);//
StaticText(~w,Rect(5,12,53,15)).string_("Kick:").align_(\left).background_(Color(0.85,0.85,0.85));
//
~checkbox = 60;
//crea los steps
for (0, 31, { |i|

	var checkvar = "~bsteps1";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkbombo.put(i,variable);

	~checkbombo[i] = CheckBox.new(~w,Rect(~checkbox, 10, 20, 20)).action={|val|
		if(val.value,{~bombo.put(i,~b)},{~bombo.put(i,nil)})};

	~checkbox = ~checkbox + a;

});

// borra steps
~delbombo=Button(~w,Rect(765,12,15,15));
~delbombo.states=[[" X ",Color.black,Color.red]];
~delbombo.action={|val|if(val.value==0,{

	"Kick have been cleared!".inform;

	~bombo.put((0..31),nil);

	for(0, 31, {|i|

		~checkbombo[i].value = 0;

	});

})};
//


//tarola steps
StaticText(~w,Rect(5,32,53,15)).string_("Snare:").align_(\left).background_(Color(0.85,0.85,0.85));

~checkbox = 60;
//crea los steps
for (0, 31, { |i|

	var checkvar = "~tsteps1";

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

	"Snare have been cleared!".inform;

	~tarola.put((0..31),nil);

	for(0, 31, {|i|

		~checktarola[i].value = 0;

	});

})};

//contratiempos
StaticText(~w,Rect(5,52,53,15)).string_("HiHats:").align_(\left).background_(Color(0.85,0.85,0.85));
~hsteps1=CheckBox.new(~w,Rect(60,50,20,20)).action={|val|if(val.value,{~contras.put(0,~h)},{~contras.put(0,nil)})};
~hsteps2=CheckBox.new(~w,Rect(80,50,20,20)).action={|val|if(val.value,{~contras.put(1,~h)},{~contras.put(1,nil)})};
~hsteps3=CheckBox.new(~w,Rect(100,50,20,20)).action={|val|if(val.value,{~contras.put(2,~h)},{~contras.put(2,nil)})};
~hsteps4=CheckBox.new(~w,Rect(120,50,20,20)).action={|val|if(val.value,{~contras.put(3,~h)},{~contras.put(3,nil)})};
~hsteps5=CheckBox.new(~w,Rect(150,50,20,20)).action={|val|if(val.value,{~contras.put(4,~h)},{~contras.put(4,nil)})};
~hsteps6=CheckBox.new(~w,Rect(170,50,20,20)).action={|val|if(val.value,{~contras.put(5,~h)},{~contras.put(5,nil)})};
~hsteps7=CheckBox.new(~w,Rect(190,50,20,20)).action={|val|if(val.value,{~contras.put(6,~h)},{~contras.put(6,nil)})};
~hsteps8=CheckBox.new(~w,Rect(210,50,20,20)).action={|val|if(val.value,{~contras.put(7,~h)},{~contras.put(7,nil)})};
~hsteps9=CheckBox.new(~w,Rect(240,50,20,20)).action={|val|if(val.value,{~contras.put(8,~h)},{~contras.put(8,nil)})};
~hsteps10=CheckBox.new(~w,Rect(260,50,20,20)).action={|val|if(val.value,{~contras.put(9,~h)},{~contras.put(9,nil)})};
~hsteps11=CheckBox.new(~w,Rect(280,50,20,20)).action={|val|if(val.value,{~contras.put(10,~h)},{~contras.put(10,nil)})};
~hsteps12=CheckBox.new(~w,Rect(300,50,20,20)).action={|val|if(val.value,{~contras.put(11,~h)},{~contras.put(11,nil)})};
~hsteps13=CheckBox.new(~w,Rect(330,50,20,20)).action={|val|if(val.value,{~contras.put(12,~h)},{~contras.put(12,nil)})};
~hsteps14=CheckBox.new(~w,Rect(350,50,20,20)).action={|val|if(val.value,{~contras.put(13,~h)},{~contras.put(13,nil)})};
~hsteps15=CheckBox.new(~w,Rect(370,50,20,20)).action={|val|if(val.value,{~contras.put(14,~h)},{~contras.put(14,nil)})};
~hsteps16=CheckBox.new(~w,Rect(390,50,20,20)).action={|val|if(val.value,{~contras.put(15,~h)},{~contras.put(15,nil)})};
~hsteps17=CheckBox.new(~w,Rect(420,50,20,20)).action={|val|if(val.value,{~contras.put(16,~h)},{~contras.put(16,nil)})};
~hsteps18=CheckBox.new(~w,Rect(440,50,20,20)).action={|val|if(val.value,{~contras.put(17,~h)},{~contras.put(17,nil)})};
~hsteps19=CheckBox.new(~w,Rect(460,50,20,20)).action={|val|if(val.value,{~contras.put(18,~h)},{~contras.put(18,nil)})};
~hsteps20=CheckBox.new(~w,Rect(480,50,20,20)).action={|val|if(val.value,{~contras.put(19,~h)},{~contras.put(19,nil)})};
~hsteps21=CheckBox.new(~w,Rect(510,50,20,20)).action={|val|if(val.value,{~contras.put(20,~h)},{~contras.put(20,nil)})};
~hsteps22=CheckBox.new(~w,Rect(530,50,20,20)).action={|val|if(val.value,{~contras.put(21,~h)},{~contras.put(21,nil)})};
~hsteps23=CheckBox.new(~w,Rect(550,50,20,20)).action={|val|if(val.value,{~contras.put(22,~h)},{~contras.put(22,nil)})};
~hsteps24=CheckBox.new(~w,Rect(570,50,20,20)).action={|val|if(val.value,{~contras.put(23,~h)},{~contras.put(23,nil)})};
~hsteps25=CheckBox.new(~w,Rect(600,50,20,20)).action={|val|if(val.value,{~contras.put(24,~h)},{~contras.put(24,nil)})};
~hsteps26=CheckBox.new(~w,Rect(620,50,20,20)).action={|val|if(val.value,{~contras.put(25,~h)},{~contras.put(25,nil)})};
~hsteps27=CheckBox.new(~w,Rect(640,50,20,20)).action={|val|if(val.value,{~contras.put(26,~h)},{~contras.put(26,nil)})};
~hsteps28=CheckBox.new(~w,Rect(660,50,20,20)).action={|val|if(val.value,{~contras.put(27,~h)},{~contras.put(27,nil)})};
~hsteps29=CheckBox.new(~w,Rect(690,50,20,20)).action={|val|if(val.value,{~contras.put(28,~h)},{~contras.put(28,nil)})};
~hsteps30=CheckBox.new(~w,Rect(710,50,20,20)).action={|val|if(val.value,{~contras.put(29,~h)},{~contras.put(29,nil)})};
~hsteps31=CheckBox.new(~w,Rect(730,50,20,20)).action={|val|if(val.value,{~contras.put(30,~h)},{~contras.put(30,nil)})};
~hsteps32=CheckBox.new(~w,Rect(750,50,20,20)).action={|val|if(val.value,{~contras.put(31,~h)},{~contras.put(31,nil)})};
//resetea secuencias contratiempos
~delcontras=Button(~w,Rect(765,52,15,15));
~delcontras.states=[[" X ",Color.black,Color.red]];
~delcontras.action={|val|if(val.value==0,{"Hihats have been cleared!".postln;
										~contras.put((0..31),nil);
										~hsteps1.value=0;~hsteps2.value=0;
										~hsteps3.value=0;~hsteps4.value=0;
										~hsteps5.value=0;~hsteps6.value=0;
										~hsteps7.value=0;~hsteps8.value=0;
										~hsteps9.value=0;~hsteps10.value=0;
										~hsteps11.value=0;~hsteps12.value=0;
										~hsteps13.value=0;~hsteps14.value=0;
										~hsteps15.value=0;~hsteps16.value=0;
										~hsteps17.value=0;~hsteps18.value=0;
										~hsteps19.value=0;~hsteps20.value=0;
										~hsteps21.value=0;~hsteps22.value=0;
										~hsteps23.value=0;~hsteps24.value=0;
										~hsteps25.value=0;~hsteps26.value=0;
										~hsteps27.value=0;~hsteps28.value=0;
										~hsteps29.value=0;~hsteps30.value=0;
										~hsteps31.value=0;~hsteps32.value=0;
										})};
//bombo2
StaticText(~w,Rect(5,72,53,15)).string_("Kick2:").align_(\left).background_(Color(0.85,0.85,0.85));
~b2steps1=CheckBox.new(~w,Rect(60,70,20,20)).action={|val|if(val.value,{~bombo2.put(0,~b2)},{~bombo2.put(0,nil)})};
~b2steps2=CheckBox.new(~w,Rect(80,70,20,20)).action={|val|if(val.value,{~bombo2.put(1,~b2)},{~bombo2.put(1,nil)})};
~b2steps3=CheckBox.new(~w,Rect(100,70,20,20)).action={|val|if(val.value,{~bombo2.put(2,~b2)},{~bombo2.put(2,nil)})};
~b2steps4=CheckBox.new(~w,Rect(120,70,20,20)).action={|val|if(val.value,{~bombo2.put(3,~b2)},{~bombo2.put(3,nil)})};
~b2steps5=CheckBox.new(~w,Rect(150,70,20,20)).action={|val|if(val.value,{~bombo2.put(4,~b2)},{~bombo2.put(4,nil)})};
~b2steps6=CheckBox.new(~w,Rect(170,70,20,20)).action={|val|if(val.value,{~bombo2.put(5,~b2)},{~bombo2.put(5,nil)})};
~b2steps7=CheckBox.new(~w,Rect(190,70,20,20)).action={|val|if(val.value,{~bombo2.put(6,~b2)},{~bombo2.put(6,nil)})};
~b2steps8=CheckBox.new(~w,Rect(210,70,20,20)).action={|val|if(val.value,{~bombo2.put(7,~b2)},{~bombo2.put(7,nil)})};
~b2steps9=CheckBox.new(~w,Rect(240,70,20,20)).action={|val|if(val.value,{~bombo2.put(8,~b2)},{~bombo2.put(8,nil)})};
~b2steps10=CheckBox.new(~w,Rect(260,70,20,20)).action={|val|if(val.value,{~bombo2.put(9,~b2)},{~bombo2.put(9,nil)})};
~b2steps11=CheckBox.new(~w,Rect(280,70,20,20)).action={|val|if(val.value,{~bombo2.put(10,~b2)},{~bombo2.put(10,nil)})};
~b2steps12=CheckBox.new(~w,Rect(300,70,20,20)).action={|val|if(val.value,{~bombo2.put(11,~b2)},{~bombo2.put(11,nil)})};
~b2steps13=CheckBox.new(~w,Rect(330,70,20,20)).action={|val|if(val.value,{~bombo2.put(12,~b2)},{~bombo2.put(12,nil)})};
~b2steps14=CheckBox.new(~w,Rect(350,70,20,20)).action={|val|if(val.value,{~bombo2.put(13,~b2)},{~bombo2.put(13,nil)})};
~b2steps15=CheckBox.new(~w,Rect(370,70,20,20)).action={|val|if(val.value,{~bombo2.put(14,~b2)},{~bombo2.put(14,nil)})};
~b2steps16=CheckBox.new(~w,Rect(390,70,20,20)).action={|val|if(val.value,{~bombo2.put(15,~b2)},{~bombo2.put(15,nil)})};
~b2steps17=CheckBox.new(~w,Rect(420,70,20,20)).action={|val|if(val.value,{~bombo2.put(16,~b2)},{~bombo2.put(16,nil)})};
~b2steps18=CheckBox.new(~w,Rect(440,70,20,20)).action={|val|if(val.value,{~bombo2.put(17,~b2)},{~bombo2.put(17,nil)})};
~b2steps19=CheckBox.new(~w,Rect(460,70,20,20)).action={|val|if(val.value,{~bombo2.put(18,~b2)},{~bombo2.put(18,nil)})};
~b2steps20=CheckBox.new(~w,Rect(480,70,20,20)).action={|val|if(val.value,{~bombo2.put(19,~b2)},{~bombo2.put(19,nil)})};
~b2steps21=CheckBox.new(~w,Rect(510,70,20,20)).action={|val|if(val.value,{~bombo2.put(20,~b2)},{~bombo2.put(20,nil)})};
~b2steps22=CheckBox.new(~w,Rect(530,70,20,20)).action={|val|if(val.value,{~bombo2.put(21,~b2)},{~bombo2.put(21,nil)})};
~b2steps23=CheckBox.new(~w,Rect(550,70,20,20)).action={|val|if(val.value,{~bombo2.put(22,~b2)},{~bombo2.put(22,nil)})};
~b2steps24=CheckBox.new(~w,Rect(570,70,20,20)).action={|val|if(val.value,{~bombo2.put(23,~b2)},{~bombo2.put(23,nil)})};
~b2steps25=CheckBox.new(~w,Rect(600,70,20,20)).action={|val|if(val.value,{~bombo2.put(24,~b2)},{~bombo2.put(24,nil)})};
~b2steps26=CheckBox.new(~w,Rect(620,70,20,20)).action={|val|if(val.value,{~bombo2.put(25,~b2)},{~bombo2.put(25,nil)})};
~b2steps27=CheckBox.new(~w,Rect(640,70,20,20)).action={|val|if(val.value,{~bombo2.put(26,~b2)},{~bombo2.put(26,nil)})};
~b2steps28=CheckBox.new(~w,Rect(660,70,20,20)).action={|val|if(val.value,{~bombo2.put(27,~b2)},{~bombo2.put(27,nil)})};
~b2steps29=CheckBox.new(~w,Rect(690,70,20,20)).action={|val|if(val.value,{~bombo2.put(28,~b2)},{~bombo2.put(28,nil)})};
~b2steps30=CheckBox.new(~w,Rect(710,70,20,20)).action={|val|if(val.value,{~bombo2.put(29,~b2)},{~bombo2.put(29,nil)})};
~b2steps31=CheckBox.new(~w,Rect(730,70,20,20)).action={|val|if(val.value,{~bombo2.put(30,~b2)},{~bombo2.put(30,nil)})};
~b2steps32=CheckBox.new(~w,Rect(750,70,20,20)).action={|val|if(val.value,{~bombo2.put(31,~b2)},{~bombo2.put(31,nil)})};
//resetea secuencias bombo2
~delbombo2=Button(~w,Rect(765,72,15,15));
~delbombo2.states=[[" X ",Color.black,Color.red]];
~delbombo2.action={|val|if(val.value==0,{"Kick have been cleared!".postln;
										~bombo2.put((0..31),nil);
										~b2steps1.value=0;~b2steps2.value=0;
										~b2steps3.value=0;~b2steps4.value=0;
										~b2steps5.value=0;~b2steps6.value=0;
										~b2steps7.value=0;~b2steps8.value=0;
										~b2steps9.value=0;~b2steps10.value=0;
										~b2steps11.value=0;~b2steps12.value=0;
										~b2steps13.value=0;~b2steps14.value=0;
										~b2steps15.value=0;~b2steps16.value=0;
										~b2steps17.value=0;~b2steps18.value=0;
										~b2steps19.value=0;~b2steps20.value=0;
										~b2steps21.value=0;~b2steps22.value=0;
										~b2steps23.value=0;~b2steps24.value=0;
										~b2steps25.value=0;~b2steps26.value=0;
										~b2steps27.value=0;~b2steps28.value=0;
										~b2steps29.value=0;~b2steps30.value=0;
										~b2steps31.value=0;~b2steps32.value=0;
										})};
//tarola2
StaticText(~w,Rect(5,92,53,15)).string_("Snare2:").align_(\left).background_(Color(0.85,0.85,0.85));
~t2steps1=CheckBox.new(~w,Rect(60,90,20,20)).action={|val|if(val.value,{~tarola2.put(0,~t2)},{~tarola2.put(0,nil)})};
~t2steps2=CheckBox.new(~w,Rect(80,90,20,20)).action={|val|if(val.value,{~tarola2.put(1,~t2)},{~tarola2.put(1,nil)})};
~t2steps3=CheckBox.new(~w,Rect(100,90,20,20)).action={|val|if(val.value,{~tarola2.put(2,~t2)},{~tarola2.put(2,nil)})};
~t2steps4=CheckBox.new(~w,Rect(120,90,20,20)).action={|val|if(val.value,{~tarola2.put(3,~t2)},{~tarola2.put(3,nil)})};
~t2steps5=CheckBox.new(~w,Rect(150,90,20,20)).action={|val|if(val.value,{~tarola2.put(4,~t2)},{~tarola2.put(4,nil)})};
~t2steps6=CheckBox.new(~w,Rect(170,90,20,20)).action={|val|if(val.value,{~tarola2.put(5,~t2)},{~tarola2.put(5,nil)})};
~t2steps7=CheckBox.new(~w,Rect(190,90,20,20)).action={|val|if(val.value,{~tarola2.put(6,~t2)},{~tarola2.put(6,nil)})};
~t2steps8=CheckBox.new(~w,Rect(210,90,20,20)).action={|val|if(val.value,{~tarola2.put(7,~t2)},{~tarola2.put(7,nil)})};
~t2steps9=CheckBox.new(~w,Rect(240,90,20,20)).action={|val|if(val.value,{~tarola2.put(8,~t2)},{~tarola2.put(8,nil)})};
~t2steps10=CheckBox.new(~w,Rect(260,90,20,20)).action={|val|if(val.value,{~tarola2.put(9,~t2)},{~tarola2.put(9,nil)})};
~t2steps11=CheckBox.new(~w,Rect(280,90,20,20)).action={|val|if(val.value,{~tarola2.put(10,~t2)},{~tarola2.put(10,nil)})};
~t2steps12=CheckBox.new(~w,Rect(300,90,20,20)).action={|val|if(val.value,{~tarola2.put(11,~t2)},{~tarola2.put(11,nil)})};
~t2steps13=CheckBox.new(~w,Rect(330,90,20,20)).action={|val|if(val.value,{~tarola2.put(12,~t2)},{~tarola2.put(12,nil)})};
~t2steps14=CheckBox.new(~w,Rect(350,90,20,20)).action={|val|if(val.value,{~tarola2.put(13,~t2)},{~tarola2.put(13,nil)})};
~t2steps15=CheckBox.new(~w,Rect(370,90,20,20)).action={|val|if(val.value,{~tarola2.put(14,~t2)},{~tarola2.put(14,nil)})};
~t2steps16=CheckBox.new(~w,Rect(390,90,20,20)).action={|val|if(val.value,{~tarola2.put(15,~t2)},{~tarola2.put(15,nil)})};
~t2steps17=CheckBox.new(~w,Rect(420,90,20,20)).action={|val|if(val.value,{~tarola2.put(16,~t2)},{~tarola2.put(16,nil)})};
~t2steps18=CheckBox.new(~w,Rect(440,90,20,20)).action={|val|if(val.value,{~tarola2.put(17,~t2)},{~tarola2.put(17,nil)})};
~t2steps19=CheckBox.new(~w,Rect(460,90,20,20)).action={|val|if(val.value,{~tarola2.put(18,~t2)},{~tarola2.put(18,nil)})};
~t2steps20=CheckBox.new(~w,Rect(480,90,20,20)).action={|val|if(val.value,{~tarola2.put(19,~t2)},{~tarola2.put(19,nil)})};
~t2steps21=CheckBox.new(~w,Rect(510,90,20,20)).action={|val|if(val.value,{~tarola2.put(20,~t2)},{~tarola2.put(20,nil)})};
~t2steps22=CheckBox.new(~w,Rect(530,90,20,20)).action={|val|if(val.value,{~tarola2.put(21,~t2)},{~tarola2.put(21,nil)})};
~t2steps23=CheckBox.new(~w,Rect(550,90,20,20)).action={|val|if(val.value,{~tarola2.put(22,~t2)},{~tarola2.put(22,nil)})};
~t2steps24=CheckBox.new(~w,Rect(570,90,20,20)).action={|val|if(val.value,{~tarola2.put(23,~t2)},{~tarola2.put(23,nil)})};
~t2steps25=CheckBox.new(~w,Rect(600,90,20,20)).action={|val|if(val.value,{~tarola2.put(24,~t2)},{~tarola2.put(24,nil)})};
~t2steps26=CheckBox.new(~w,Rect(620,90,20,20)).action={|val|if(val.value,{~tarola2.put(25,~t2)},{~tarola2.put(25,nil)})};
~t2steps27=CheckBox.new(~w,Rect(640,90,20,20)).action={|val|if(val.value,{~tarola2.put(26,~t2)},{~tarola2.put(26,nil)})};
~t2steps28=CheckBox.new(~w,Rect(660,90,20,20)).action={|val|if(val.value,{~tarola2.put(27,~t2)},{~tarola2.put(27,nil)})};
~t2steps29=CheckBox.new(~w,Rect(690,90,20,20)).action={|val|if(val.value,{~tarola2.put(28,~t2)},{~tarola2.put(28,nil)})};
~t2steps30=CheckBox.new(~w,Rect(710,90,20,20)).action={|val|if(val.value,{~tarola2.put(29,~t2)},{~tarola2.put(29,nil)})};
~t2steps31=CheckBox.new(~w,Rect(730,90,20,20)).action={|val|if(val.value,{~tarola2.put(30,~t2)},{~tarola2.put(30,nil)})};
~t2steps32=CheckBox.new(~w,Rect(750,90,20,20)).action={|val|if(val.value,{~tarola2.put(31,~t2)},{~tarola2.put(31,nil)})};
//resetea secuencias tarola2
~deltarola2=Button(~w,Rect(765,92,15,15));
~deltarola2.states=[[" X ",Color.black,Color.red]];
~deltarola2.action={|val|if(val.value==0,{"Snare have been cleared!".postln;
										~tarola2.put((0..31),nil);
										~t2steps1.value=0;~t2steps2.value=0;
										~t2steps3.value=0;~t2steps4.value=0;
										~t2steps5.value=0;~t2steps6.value=0;
										~t2steps7.value=0;~t2steps8.value=0;
										~t2steps9.value=0;~t2steps10.value=0;
										~t2steps11.value=0;~t2steps12.value=0;
										~t2steps13.value=0;~t2steps14.value=0;
										~t2steps15.value=0;~t2steps16.value=0;
										~t2steps17.value=0;~t2steps18.value=0;
										~t2steps19.value=0;~t2steps20.value=0;
										~t2steps21.value=0;~t2steps22.value=0;
										~t2steps23.value=0;~t2steps24.value=0;
										~t2steps25.value=0;~t2steps26.value=0;
										~t2steps27.value=0;~t2steps28.value=0;
										~t2steps29.value=0;~t2steps30.value=0;
										~t2steps31.value=0;~t2steps32.value=0;
										})};
//contratiempos2
StaticText(~w,Rect(5,112,53,15)).string_("HiHats2:").align_(\left).background_(Color(0.85,0.85,0.85));
~h2steps1=CheckBox.new(~w,Rect(60,110,20,20)).action={|val|if(val.value,{~contras2.put(0,~h2)},{~contras2.put(0,nil)})};
~h2steps2=CheckBox.new(~w,Rect(80,110,20,20)).action={|val|if(val.value,{~contras2.put(1,~h2)},{~contras2.put(1,nil)})};
~h2steps3=CheckBox.new(~w,Rect(100,110,20,20)).action={|val|if(val.value,{~contras2.put(2,~h2)},{~contras2.put(2,nil)})};
~h2steps4=CheckBox.new(~w,Rect(120,110,20,20)).action={|val|if(val.value,{~contras2.put(3,~h2)},{~contras2.put(3,nil)})};
~h2steps5=CheckBox.new(~w,Rect(150,110,20,20)).action={|val|if(val.value,{~contras2.put(4,~h2)},{~contras2.put(4,nil)})};
~h2steps6=CheckBox.new(~w,Rect(170,110,20,20)).action={|val|if(val.value,{~contras2.put(5,~h2)},{~contras2.put(5,nil)})};
~h2steps7=CheckBox.new(~w,Rect(190,110,20,20)).action={|val|if(val.value,{~contras2.put(6,~h2)},{~contras2.put(6,nil)})};
~h2steps8=CheckBox.new(~w,Rect(210,110,20,20)).action={|val|if(val.value,{~contras2.put(7,~h2)},{~contras2.put(7,nil)})};
~h2steps9=CheckBox.new(~w,Rect(240,110,20,20)).action={|val|if(val.value,{~contras2.put(8,~h2)},{~contras2.put(8,nil)})};
~h2steps10=CheckBox.new(~w,Rect(260,110,20,20)).action={|val|if(val.value,{~contras2.put(9,~h2)},{~contras2.put(9,nil)})};
~h2steps11=CheckBox.new(~w,Rect(280,110,20,20)).action={|val|if(val.value,{~contras2.put(10,~h2)},{~contras2.put(10,nil)})};
~h2steps12=CheckBox.new(~w,Rect(300,110,20,20)).action={|val|if(val.value,{~contras2.put(11,~h2)},{~contras2.put(11,nil)})};
~h2steps13=CheckBox.new(~w,Rect(330,110,20,20)).action={|val|if(val.value,{~contras2.put(12,~h2)},{~contras2.put(12,nil)})};
~h2steps14=CheckBox.new(~w,Rect(350,110,20,20)).action={|val|if(val.value,{~contras2.put(13,~h2)},{~contras2.put(13,nil)})};
~h2steps15=CheckBox.new(~w,Rect(370,110,20,20)).action={|val|if(val.value,{~contras2.put(14,~h2)},{~contras2.put(14,nil)})};
~h2steps16=CheckBox.new(~w,Rect(390,110,20,20)).action={|val|if(val.value,{~contras2.put(15,~h2)},{~contras2.put(15,nil)})};
~h2steps17=CheckBox.new(~w,Rect(420,110,20,20)).action={|val|if(val.value,{~contras2.put(16,~h2)},{~contras2.put(16,nil)})};
~h2steps18=CheckBox.new(~w,Rect(440,110,20,20)).action={|val|if(val.value,{~contras2.put(17,~h2)},{~contras2.put(17,nil)})};
~h2steps19=CheckBox.new(~w,Rect(460,110,20,20)).action={|val|if(val.value,{~contras2.put(18,~h2)},{~contras2.put(18,nil)})};
~h2steps20=CheckBox.new(~w,Rect(480,110,20,20)).action={|val|if(val.value,{~contras2.put(19,~h2)},{~contras2.put(19,nil)})};
~h2steps21=CheckBox.new(~w,Rect(510,110,20,20)).action={|val|if(val.value,{~contras2.put(20,~h2)},{~contras2.put(20,nil)})};
~h2steps22=CheckBox.new(~w,Rect(530,110,20,20)).action={|val|if(val.value,{~contras2.put(21,~h2)},{~contras2.put(21,nil)})};
~h2steps23=CheckBox.new(~w,Rect(550,110,20,20)).action={|val|if(val.value,{~contras2.put(22,~h2)},{~contras2.put(22,nil)})};
~h2steps24=CheckBox.new(~w,Rect(570,110,20,20)).action={|val|if(val.value,{~contras2.put(23,~h2)},{~contras2.put(23,nil)})};
~h2steps25=CheckBox.new(~w,Rect(600,110,20,20)).action={|val|if(val.value,{~contras2.put(24,~h2)},{~contras2.put(24,nil)})};
~h2steps26=CheckBox.new(~w,Rect(620,110,20,20)).action={|val|if(val.value,{~contras2.put(25,~h2)},{~contras2.put(25,nil)})};
~h2steps27=CheckBox.new(~w,Rect(640,110,20,20)).action={|val|if(val.value,{~contras2.put(26,~h2)},{~contras2.put(26,nil)})};
~h2steps28=CheckBox.new(~w,Rect(660,110,20,20)).action={|val|if(val.value,{~contras2.put(27,~h2)},{~contras2.put(27,nil)})};
~h2steps29=CheckBox.new(~w,Rect(690,110,20,20)).action={|val|if(val.value,{~contras2.put(28,~h2)},{~contras2.put(28,nil)})};
~h2steps30=CheckBox.new(~w,Rect(710,110,20,20)).action={|val|if(val.value,{~contras2.put(29,~h2)},{~contras2.put(29,nil)})};
~h2steps31=CheckBox.new(~w,Rect(730,110,20,20)).action={|val|if(val.value,{~contras2.put(30,~h2)},{~contras2.put(30,nil)})};
~h2steps32=CheckBox.new(~w,Rect(750,110,20,20)).action={|val|if(val.value,{~contras2.put(31,~h2)},{~contras2.put(31,nil)})};
//resetea secuencias contratiempos2
~delcontras2=Button(~w,Rect(765,112,15,15));
~delcontras2.states=[[" X ",Color.black,Color.red]];
~delcontras2.action={|val|if(val.value==0,{"Hihats have been cleared!".postln;
										~contras2.put((0..31),nil);
										~h2steps1.value=0;~h2steps2.value=0;
										~h2steps3.value=0;~h2steps4.value=0;
										~h2steps5.value=0;~h2steps6.value=0;
										~h2steps7.value=0;~h2steps8.value=0;
										~h2steps9.value=0;~h2steps10.value=0;
										~h2steps11.value=0;~h2steps12.value=0;
										~h2steps13.value=0;~h2steps14.value=0;
										~h2steps15.value=0;~h2steps16.value=0;
										~h2steps17.value=0;~h2steps18.value=0;
										~h2steps19.value=0;~h2steps20.value=0;
										~h2steps21.value=0;~h2steps22.value=0;
										~h2steps23.value=0;~h2steps24.value=0;
										~h2steps25.value=0;~h2steps26.value=0;
										~h2steps27.value=0;~h2steps28.value=0;
										~h2steps29.value=0;~h2steps30.value=0;
										~h2steps31.value=0;~h2steps32.value=0;
										})};
//tiempos
StaticText(~w,Rect(5,635,270,15)).string_("Beat:").align_(\center).background_(Color(0.65,0.65,0.65));
~bott=Button(~w,Rect(5,650,135,25));
~bott.states=[["Thirds",Color.white,Color.green(0.35)],
        ["Fourths",Color.black,Color.green(0.35)]];
~bott.action={|val|if(val.value==0,{~tiempos=0.25;"->Fourths<-".postcln},
        							{~tiempos=0.3333333333333333333;"->Thirds<-".postcln})};
//tiempos random
~botr=Button(~w,Rect(140,650,135,25));
~botr.states=[["Random Time",Color.black,Color.green(0.35)],
        ["Regular Time",Color.white,Color.green(0.35)]];
~botr.action={|val|if(val.value==0,{Tdef(\randtime).stop;~clock.value;"->Master BPM seted<-".postcln},
        {Tdef(\randtime).play;"->Random Clock Values<-".postcln})};
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
//play
StaticText(~w,Rect(275,635,515,15)).string_("PLAY/STOP:").align_(\center).background_(Color(0.5,0.5,0.5));
~bot=Button(~w,Rect(275,650,515,25));
~bot.states=[["=>",Color.black,Color.green],
        ["[_]",Color.white,Color.red]];
~bot.action={|val|if(val.value==0,{Tdef(\secuencias).stop;/*Tdef(\pasos).stop;*/Tdef(\autor).stop;Tdef(\autod).stop;Tdef(\autop).stop;Tdef(\autog).stop;
				Tdef(\bass).stop;Tdef(\bass2).stop;Tdef(\pad).stop;Tdef(\pad2).stop;Tdef(\acordes).stop;Tdef(\acordes2).stop;
				~autobotr.value=0;~autobotd.value=0;~autobotp.value=0;~autobotg.value=0;~bott.value=0;~f.kill;~grains.free;Server.freeAll;History.stop;
												"->You just Stopped CaosBox<-".postcln;},
        							{Tdef(\secuencias).play;/*Tdef(\pasos).play;*/Tdef(\pad).play;Tdef(\bass).play;Tdef(\bass2).play;
        								Tdef(\pad2).play;Tdef(\acordes).play;Tdef(\acordes2).play;"->Playing, please start algoravin'<-".postcln})};
//record
~filea=[~n.choose,~l.choose,~n.choose,~l.choose];
~filename=~filename.add(~filea.stutter((1..2).choose).scramble.join);
//
StaticText(~w,Rect(790,635,130,15)).string_("Recording").align_(\center).background_(Color(0.65,0.65,0.65));
~recbot=Button(~w,Rect(790,650,130,25));
~recbot.states=[["Record",Color.black,Color.green(0.35)],
        ["Stop Recording",Color.white,Color.red]];
~recbot.action={|val|if(val.value==0,{s.stopRecording;
	                                   "->Stoped Recording<-".postln;
	                                   ~filename=["c","a","o","s","b","o","x","_",~filea.join,~l.choose,~n.choose];
	                                  },
	{s.record(~url +/+ "Recorded" +/+  ~ftype[0] ++ ~filename.value.join ++ ~fecha.dayStamp ++ ".aiff");
		"->Recording<-".postcln})
     };
//Historial
StaticText(~w,Rect(920,635,99,20)).string_("History:").align_(\center).background_(Color(0.75,0.75,0.75));
~hbutt=Button(~w,Rect(920,650,99,25));
~hbutt.states=[[" Save File ",Color.green,Color.black]];
~hbutt.action={|val| var h=History; if(val.value==0,{"->History saved @ caosbox/Histories folder<-".postln;
	                      h.saveStory(~url +/+ "Histories" +/+ ~ftype[1] ++ ~filename.value.join ++ ~fecha.dayStamp ++ ".scd");
	                                h.stop; h.clear})};
)
