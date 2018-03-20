(//CaosBox GUI file 2 - v1.1 - bass, ambientes, acordes
//bajo
StaticText(~w,Rect(5,132,53,15)).string_("Bass:").align_(\left).background_(Color(0.85,0.85,0.85));
~checkbox = 60;
for (0, 31, { |i|

		var checkvar = "~bassteps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checkbajo.put(i,variable);

	~checkbajo[i] = CheckBox.new(~w,Rect(~checkbox, 130, 20, 20)).action = {|val|
		if(val.value,{~bajo.put(i,~bass=Synth(\bajouno))},{~bajo.put(i,nil)})};

	~checkbox = ~checkbox + a;

});
~delbass=Button(~w,Rect(765,132,15,15));
~delbass.states=[[" X ",Color.black,Color.red]];
~delbass.action={|val|if(val.value==0,{

	"Cleared bass steps!".inform;

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

	"Cleared bass 2 steps!".inform;

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

	"Cleared pad steps!".inform;

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

	"Cleared pad 2 steps!".inform;

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

	"Cleared chord steps!".inform;

	~sinte.put((0..31),nil);

	for(0, 31, {|i|
		~checksinte[i].value = 0;

	});

})};
//acordes attack and release knobs
~sinte1attknob=EZKnob(~w,Rect(785,211,81,17),nil,ControlSpec(0.01,1,\lin,0.001,0.01,\att),{|a| a.value;~synth.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~sinte1relknob=EZKnob(~w,Rect(870,211,81,17),nil,ControlSpec(0.05,8,\lin,0.001,1,\rel),{|a| a.value;~synth.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);


//Acordes2
StaticText(~w,Rect(5,232,53,15)).string_("Chords2:").align_(\left).background_(Color(0.85,0.85,0.85));

~checkbox = 60;

for (0, 31, { |i|

	var checkvar = "~sinte2steps";

	var a = ~checksteps[i%~checksteps.size];

	var variable = checkvar ++ i;

	~checksinte2.put(i,variable);

	~checksinte2[i] = CheckBox.new(~w,Rect(~checkbox, 230, 20, 20)).action={|val| if(val.value,{~sinte2.put(i,~chord2=Synth(\acordesdos);)},{~sinte2.put(i,nil)})};

	~checkbox = ~checkbox + a;

});
//resetea secuencias sinte
~delsinte2=Button(~w,Rect(765,232,15,15));
~delsinte2.states=[[" X ",Color.black,Color.red]];
~delsinte2.action={|val|if(val.value==0,{

	"Cleared guitChord steps!".inform;

	~sinte2.put((0..31),nil);

	for(0, 31, {|i|
		~checksinte2[i].value = 0;

	});

})};
//acordes 2 attack and release knobs
~sinte2attknob=EZKnob(~w,Rect(785,231,81,17),nil,ControlSpec(0.01,1,\lin,0.001,0.1,\att),{|a| a.value;~synth2.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~sinte2relknob=EZKnob(~w,Rect(870,231,81,17),nil,ControlSpec(0.05,8,\lin,0.001,0.5,\rel),{|a| a.value;~synth2.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
);