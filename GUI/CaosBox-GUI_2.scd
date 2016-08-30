(//CaosBox GUI 2 v0.1 - steps bajos, ambientes, sintetizadores
//bajo
StaticText(~w,Rect(5,132,53,15)).string_("Bass:").align_(\left).background_(Color(0.85,0.85,0.85));
~checkbox = 60;
//crea los steps
for (0, 31, { |i|

	var checkvar = "~bassteps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkbajo.put(i,variable);

	~checkbajo[i] = CheckBox.new(~w,Rect(~checkbox, 130, 20, 20)).action={|val| if(val.value,{~bajo.put(i,~bass=Synth(\bajouno);)},{~bajo.put(i,nil)})};

	~checkbox = ~checkbox + a;


});
// borra steps
~delbass=Button(~w,Rect(765,132,15,15));
~delbass.states=[[" X ",Color.black,Color.red]];
~delbass.action={|val|if(val.value==0,{

	"Bass have been cleared!".postln;

	~bajo.put((0..31),nil);

	for(0, 31, {|i|
		~checkbajo[i].value = 0;

	});

})};
//bajo attack and release knobs
~bass1attknob=EZKnob(~w,Rect(785,131,81,17),nil,ControlSpec(0.01,0.5,\lin,0.001,0.05,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~bass1relknob=EZKnob(~w,Rect(870,131,81,17),nil,ControlSpec(0.1,2,\lin,0.001,0.5,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);



//bajo2
StaticText(~w,Rect(5,152,53,15)).string_("Bass2:").align_(\left).background_(Color(0.85,0.85,0.85));
//resetea posicion
~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~bass2teps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkbajo2.put(i,variable);

	~checkbajo2[i] = CheckBox.new(~w,Rect(~checkbox, 150, 20, 20)).action={|val| if(val.value,{~bajo2.put(i,~bass2=Synth(\bajodos);)},{~bajo2.put(i,nil)})};

	~checkbox = ~checkbox + a;


});
// borra steps
~delbass2=Button(~w,Rect(765,152,15,15));
~delbass2.states=[[" X ",Color.black,Color.red]];
~delbass2.action={|val|if(val.value==0,{

	"Bass have been cleared!".warn;

	~bajo2.put((0..31),nil);

	for(0, 31, {|i|
		~checkbajo2[i].value = 0;

	});

})};
//bass attack and release knobs
~bass2attknob=EZKnob(~w,Rect(785,151,81,17),nil,ControlSpec(0.01,0.5,\lin,0.001,0.05,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~bass2relknob=EZKnob(~w,Rect(870,151,81,17),nil,ControlSpec(0.05,4,\lin,0.001,0.5,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);




//ambiente
StaticText(~w,Rect(5,172,53,15)).string_("Pad:").align_(\left).background_(Color(0.85,0.85,0.85));

//reset
~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~ambsteps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkambiente.put(i,variable);

	~checkambiente[i] = CheckBox.new(~w,Rect(~checkbox, 170, 20, 20)).action={|val| if(val.value,{~ambiente.put(i,~amb=Synth(\ambuno);)},{~ambiente.put(i,nil)})};

	~checkbox = ~checkbox + a;


});
// borra steps
~delamb=Button(~w,Rect(765,173,15,15));
~delamb.states=[[" X ",Color.black,Color.red]];
~delamb.action={|val|if(val.value==0,{

	"Ambient pad steps cleared!".warn;

	~ambiente.put((0..31),nil);

	for(0, 31, {|i|
		~checkambiente[i].value = 0;

	});

})};
//ambiente attack and release knobs
~amb1attknob=EZKnob(~w,Rect(785,171,81,17),nil,ControlSpec(0.25,2,\lin,0.001,0.5,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~amb1relknob=EZKnob(~w,Rect(870,171,81,17),nil,ControlSpec(0.25,12,\lin,0.001,2,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);




//ambiente2
StaticText(~w,Rect(5,192,53,15)).string_("pad2:").align_(\left).background_(Color(0.85,0.85,0.85));
//reset pos
~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~ambsteps2";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkambiente2.put(i,variable);

	~checkambiente2[i] = CheckBox.new(~w,Rect(~checkbox, 190, 20, 20)).action={|val| if(val.value,{~ambiente2.put(i,~amb2=Synth(\ambdos);)},{~ambiente2.put(i,nil)})};

	~checkbox = ~checkbox + a;


});
// borra steps
~delamb2=Button(~w,Rect(765,192,15,15));
~delamb2.states=[[" X ",Color.black,Color.red]];
~delamb2.action={|val|if(val.value==0,{

	"Ambient pad steps cleared!".warn;

	~ambiente2.put((0..31),nil);

	for(0, 31, {|i|
		~checkambiente2[i].value = 0;

	});

})};

//ambiente2 attack and release knobs
~amb2attknob=EZKnob(~w,Rect(785,191,81,17),nil,ControlSpec(0.25,2,\lin,0.001,0.25,\att),{|a| a.value;},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~amb2relknob=EZKnob(~w,Rect(870,191,81,17),nil,ControlSpec(0.25,12,\lin,0.001,4,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);




//acordes
StaticText(~w,Rect(5,212,53,15)).string_("Chords:").align_(\left).background_(Color(0.85,0.85,0.85));
//reset posicion
~checkbox = 60;
for (0, 31, { |i|

	var checkvar = "~sintesteps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checksinte.put(i,variable);

	~checksinte[i] = CheckBox.new(~w,Rect(~checkbox, 210, 20, 20)).action={|val| if(val.value,{~sinte.put(i,~chord=Synth(\acordesuno);)},{~sinte.put(i,nil)})};

	~checkbox = ~checkbox + a;


});
//resetea secuencias sinte
~delsinte=Button(~w,Rect(765,212,15,15));
~delsinte.states=[[" X ",Color.black,Color.red]];
~delsinte.action={|val|if(val.value==0,{

	"Chords have been cleared!".warn;

	~sinte.put((0..31),nil);

	for(0, 31, {|i|
		~checksinte[i].value = 0;

	});

})};




//sinte attack and release knobs
~sinte1attknob=EZKnob(~w,Rect(785,211,81,17),nil,ControlSpec(0.01,1,\lin,0.001,0.01,\att),{|a| a.value;~synth.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~sinte1relknob=EZKnob(~w,Rect(870,211,81,17),nil,ControlSpec(0.05,8,\lin,0.001,1,\rel),{|a| a.value;~synth.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
//Acordes2
StaticText(~w,Rect(5,232,53,15)).string_("Chords2:").align_(\left).background_(Color(0.85,0.85,0.85));
~sinte2steps1=CheckBox.new(~w,Rect(60,230,20,20)).action={|val|if(val.value,{~sinte2.put(0,~chord2=Synth(\acordesdos))},{~sinte2.put(0,nil)})};
~sinte2steps2=CheckBox.new(~w,Rect(80,230,20,20)).action={|val|if(val.value,{~sinte2.put(1,~chord2=Synth(\acordesdos))},{~sinte2.put(1,nil)})};
~sinte2steps3=CheckBox.new(~w,Rect(100,230,20,20)).action={|val|if(val.value,{~sinte2.put(2,~chord2=Synth(\acordesdos))},{~sinte2.put(2,nil)})};
~sinte2steps4=CheckBox.new(~w,Rect(120,230,20,20)).action={|val|if(val.value,{~sinte2.put(3,~chord2=Synth(\acordesdos))},{~sinte2.put(3,nil)})};
~sinte2steps5=CheckBox.new(~w,Rect(150,230,20,20)).action={|val|if(val.value,{~sinte2.put(4,~chord2=Synth(\acordesdos))},{~sinte2.put(4,nil)})};
~sinte2steps6=CheckBox.new(~w,Rect(170,230,20,20)).action={|val|if(val.value,{~sinte2.put(5,~chord2=Synth(\acordesdos))},{~sinte2.put(5,nil)})};
~sinte2steps7=CheckBox.new(~w,Rect(190,230,20,20)).action={|val|if(val.value,{~sinte2.put(6,~chord2=Synth(\acordesdos))},{~sinte2.put(6,nil)})};
~sinte2steps8=CheckBox.new(~w,Rect(210,230,20,20)).action={|val|if(val.value,{~sinte2.put(7,~chord2=Synth(\acordesdos))},{~sinte2.put(7,nil)})};
~sinte2steps9=CheckBox.new(~w,Rect(240,230,20,20)).action={|val|if(val.value,{~sinte2.put(8,~chord2=Synth(\acordesdos))},{~sinte2.put(8,nil)})};
~sinte2steps10=CheckBox.new(~w,Rect(260,230,20,20)).action={|val|if(val.value,{~sinte2.put(9,~chord2=Synth(\acordesdos))},{~sinte2.put(9,nil)})};
~sinte2steps11=CheckBox.new(~w,Rect(280,230,20,20)).action={|val|if(val.value,{~sinte2.put(10,~chord2=Synth(\acordesdos))},{~sinte2.put(10,nil)})};
~sinte2steps12=CheckBox.new(~w,Rect(300,230,20,20)).action={|val|if(val.value,{~sinte2.put(11,~chord2=Synth(\acordesdos))},{~sinte2.put(11,nil)})};
~sinte2steps13=CheckBox.new(~w,Rect(330,230,20,20)).action={|val|if(val.value,{~sinte2.put(12,~chord2=Synth(\acordesdos))},{~sinte2.put(12,nil)})};
~sinte2steps14=CheckBox.new(~w,Rect(350,230,20,20)).action={|val|if(val.value,{~sinte2.put(13,~chord2=Synth(\acordesdos))},{~sinte2.put(13,nil)})};
~sinte2steps15=CheckBox.new(~w,Rect(370,230,20,20)).action={|val|if(val.value,{~sinte2.put(14,~chord2=Synth(\acordesdos))},{~sinte2.put(14,nil)})};
~sinte2steps16=CheckBox.new(~w,Rect(390,230,20,20)).action={|val|if(val.value,{~sinte2.put(15,~chord2=Synth(\acordesdos))},{~sinte2.put(15,nil)})};
~sinte2steps17=CheckBox.new(~w,Rect(420,230,20,20)).action={|val|if(val.value,{~sinte2.put(16,~chord2=Synth(\acordesdos))},{~sinte2.put(16,nil)})};
~sinte2steps18=CheckBox.new(~w,Rect(440,230,20,20)).action={|val|if(val.value,{~sinte2.put(17,~chord2=Synth(\acordesdos))},{~sinte2.put(17,nil)})};
~sinte2steps19=CheckBox.new(~w,Rect(460,230,20,20)).action={|val|if(val.value,{~sinte2.put(18,~chord2=Synth(\acordesdos))},{~sinte2.put(18,nil)})};
~sinte2steps20=CheckBox.new(~w,Rect(480,230,20,20)).action={|val|if(val.value,{~sinte2.put(19,~chord2=Synth(\acordesdos))},{~sinte2.put(19,nil)})};
~sinte2steps21=CheckBox.new(~w,Rect(510,230,20,20)).action={|val|if(val.value,{~sinte2.put(20,~chord2=Synth(\acordesdos))},{~sinte2.put(20,nil)})};
~sinte2steps22=CheckBox.new(~w,Rect(530,230,20,20)).action={|val|if(val.value,{~sinte2.put(21,~chord2=Synth(\acordesdos))},{~sinte2.put(21,nil)})};
~sinte2steps23=CheckBox.new(~w,Rect(550,230,20,20)).action={|val|if(val.value,{~sinte2.put(22,~chord2=Synth(\acordesdos))},{~sinte2.put(22,nil)})};
~sinte2steps24=CheckBox.new(~w,Rect(570,230,20,20)).action={|val|if(val.value,{~sinte2.put(23,~chord2=Synth(\acordesdos))},{~sinte2.put(23,nil)})};
~sinte2steps25=CheckBox.new(~w,Rect(600,230,20,20)).action={|val|if(val.value,{~sinte2.put(24,~chord2=Synth(\acordesdos))},{~sinte2.put(24,nil)})};
~sinte2steps26=CheckBox.new(~w,Rect(620,230,20,20)).action={|val|if(val.value,{~sinte2.put(25,~chord2=Synth(\acordesdos))},{~sinte2.put(25,nil)})};
~sinte2steps27=CheckBox.new(~w,Rect(640,230,20,20)).action={|val|if(val.value,{~sinte2.put(26,~chord2=Synth(\acordesdos))},{~sinte2.put(26,nil)})};
~sinte2steps28=CheckBox.new(~w,Rect(660,230,20,20)).action={|val|if(val.value,{~sinte2.put(27,~chord2=Synth(\acordesdos))},{~sinte2.put(27,nil)})};
~sinte2steps29=CheckBox.new(~w,Rect(690,230,20,20)).action={|val|if(val.value,{~sinte2.put(28,~chord2=Synth(\acordesdos))},{~sinte2.put(28,nil)})};
~sinte2steps30=CheckBox.new(~w,Rect(710,230,20,20)).action={|val|if(val.value,{~sinte2.put(29,~chord2=Synth(\acordesdos))},{~sinte2.put(29,nil)})};
~sinte2steps31=CheckBox.new(~w,Rect(730,230,20,20)).action={|val|if(val.value,{~sinte2.put(30,~chord2=Synth(\acordesdos))},{~sinte2.put(30,nil)})};
~sinte2steps32=CheckBox.new(~w,Rect(750,230,20,20)).action={|val|if(val.value,{~sinte2.put(31,~chord2=Synth(\acordesdos))},{~sinte2.put(31,nil)})};
//resetea secuencias sinte2
~delsinte2=Button(~w,Rect(765,232,15,15));
~delsinte2.states=[[" X ",Color.black,Color.red]];
~delsinte2.action={|val|if(val.value==0,{"Chords have been cleared!".postln;
	~sinte2.put((0..31),nil);
	~sinte2steps1.value=0;~sinte2steps2.value=0;
	~sinte2steps3.value=0;~sinte2steps4.value=0;
	~sinte2steps5.value=0;~sinte2steps6.value=0;
	~sinte2steps7.value=0;~sinte2steps8.value=0;
	~sinte2steps9.value=0;~sinte2steps10.value=0;
	~sinte2steps11.value=0;~sinte2steps12.value=0;
	~sinte2steps13.value=0;~sinte2steps14.value=0;
	~sinte2steps15.value=0;~sinte2steps16.value=0;
	~sinte2steps17.value=0;~sinte2steps18.value=0;
	~sinte2steps19.value=0;~sinte2steps20.value=0;
	~sinte2steps21.value=0;~sinte2steps22.value=0;
	~sinte2steps23.value=0;~sinte2steps24.value=0;
	~sinte2steps25.value=0;~sinte2steps26.value=0;
	~sinte2steps27.value=0;~sinte2steps28.value=0;
	~sinte2steps29.value=0;~sinte2steps30.value=0;
	~sinte2steps31.value=0;~sinte2steps32.value=0;
})};
//sinte2 attack and release knobs
~sinte2attknob=EZKnob(~w,Rect(785,231,81,17),nil,ControlSpec(0.01,1,\lin,0.001,0.1,\att),{|a| a.value;~synth2.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~sinte2relknob=EZKnob(~w,Rect(870,231,81,17),nil,ControlSpec(0.05,8,\lin,0.001,0.5,\rel),{|a| a.value;~synth2.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
);
