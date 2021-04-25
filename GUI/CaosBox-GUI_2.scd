(//CaosBox GUI file 2 - v1.2 - bass, ambientes, acordes
//bajo
StaticText(~cbox_w,Rect(5,132,53,15)).string_("Bass:").stringColor_(Color(0.9,0.9,0.9)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.25,0.25,0.25));
~cbox_checkbox = 60;
for (0, 31, { |i|

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	~cbox_checkbajo.put(i,
		CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 130, 20, 20)).action = {|val|
			if(val.value,{
				~cbox_sintetizadores.value(\bass);
				~cbox_bajo_seq.put(i,~cbox_bass);
				},
				{
					~cbox_bajo_seq.put(i,nil)})
				};
		);

	~cbox_checkbox = ~cbox_checkbox + a;// pinta secuenciador para bajo

});
~cbox_delbass=Button(~cbox_w,Rect(765,132,15,15));
~cbox_delbass.states=[[" X ",Color.black,Color.red]];
~cbox_delbass.action={|val|if(val.value==0,{

	"Cleared bass steps!".inform;

	~cbox_bajo_seq.put((0..31),nil);

	for(0, 31, {|i|
		~cbox_checkbajo[i].value = 0;

	});

})};
//bajo attack and release knobs
~cbox_bass1attknob=EZKnob(~cbox_w,Rect(785,131,81,17),nil,ControlSpec(0.01,0.5,\lin,0.001,0.05,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~cbox_bass1relknob=EZKnob(~cbox_w,Rect(870,131,81,17),nil,ControlSpec(0.1,2,\lin,0.001,0.5,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);



//bajo2
StaticText(~cbox_w,Rect(5,152,53,15)).string_("Bass2:").stringColor_(Color(0.9,0.9,0.9)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.25,0.25,0.25));

~cbox_checkbox = 60;

for (0, 31, { |i|

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	~cbox_checkbajo2.put(i,CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 150, 20, 20)).action={|val|
		if(val.value,{
				~cbox_sintetizadores.value(\bass);
				~cbox_bajo_seq2.put(i,~cbox_bass2)
			},
			{~cbox_bajo_seq2.put(i,nil)});
		});

	~cbox_checkbox = ~cbox_checkbox + a;

});
// borra steps
~cbox_delbass2=Button(~cbox_w,Rect(765,152,15,15));
~cbox_delbass2.states=[[" X ",Color.black,Color.red]];
~cbox_delbass2.action={|val|if(val.value==0,{

	"Cleared bass 2 steps!".inform;

	~cbox_bajo_seq2.put((0..31),nil);

	for(0, 31, {|i|
		~cbox_checkbajo2[i].value = 0;

	});

})};
//bass attack and release knobs
~cbox_bass2attknob=EZKnob(~cbox_w,Rect(785,151,81,17),nil,ControlSpec(0.01,0.5,\lin,0.001,0.05,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~cbox_bass2relknob=EZKnob(~cbox_w,Rect(870,151,81,17),nil,ControlSpec(0.05,4,\lin,0.001,0.5,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);

//ambiente
StaticText(~cbox_w,Rect(5,172,53,15)).string_("Pad:").stringColor_(Color(0.9,0.9,0.9)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.25,0.25,0.25));

~cbox_checkbox = 60;

for (0, 31, { |i|

	var checkvar = "~cbox_ambsteps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checkambiente.put(i,variable);

	~cbox_checkambiente[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 170, 20, 20)).action={|val| if(val.value,{~cbox_ambiente.put(i,~cbox_amb=Synth(\ambuno);)},{~cbox_ambiente.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;


});
// borra steps
~cbox_delamb=Button(~cbox_w,Rect(765,173,15,15));
~cbox_delamb.states=[[" X ",Color.black,Color.red]];
~cbox_delamb.action={|val|if(val.value==0,{

	"Cleared pad steps!".inform;

	~cbox_ambiente.put((0..31),nil);

	for(0, 31, {|i|
		~cbox_checkambiente[i].value = 0;

	});

})};
//ambiente attack and release knobs
~cbox_amb1attknob=EZKnob(~cbox_w,Rect(785,171,81,17),nil,ControlSpec(0.25,2,\lin,0.001,0.5,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~cbox_amb1relknob=EZKnob(~cbox_w,Rect(870,171,81,17),nil,ControlSpec(0.25,12,\lin,0.001,2,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);

//ambiente2
StaticText(~cbox_w,Rect(5,192,53,15)).string_("pad2:").stringColor_(Color(0.9,0.9,0.9)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.25,0.25,0.25));

~cbox_checkbox = 60;

for (0, 31, { |i|

	var checkvar = "~cbox_ambsteps2";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checkambiente2.put(i,variable);

	~cbox_checkambiente2[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 190, 20, 20)).action={|val| if(val.value,{~cbox_ambiente2.put(i,~cbox_amb2=Synth(\ambdos);)},{~cbox_ambiente2.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});
// borra steps
~cbox_delamb2=Button(~cbox_w,Rect(765,192,15,15));
~cbox_delamb2.states=[[" X ",Color.black,Color.red]];
~cbox_delamb2.action={|val|if(val.value==0,{

	"Cleared pad 2 steps!".inform;

	~cbox_ambiente2.put((0..31),nil);

	for(0, 31, {|i|
		~cbox_checkambiente2[i].value = 0;

	});

})};

//ambiente2 attack and release knobs
~cbox_amb2attknob=EZKnob(~cbox_w,Rect(785,191,81,17),nil,ControlSpec(0.25,2,\lin,0.001,0.25,\att),{|a| a.value;},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~cbox_amb2relknob=EZKnob(~cbox_w,Rect(870,191,81,17),nil,ControlSpec(0.25,12,\lin,0.001,4,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);

//acordes
StaticText(~cbox_w,Rect(5,212,53,15)).string_("Chords:").stringColor_(Color(0.9,0.9,0.9)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.25,0.25,0.25));

~cbox_checkbox = 60;

for (0, 31, { |i|

	var checkvar = "~cbox_sintesteps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checksinte.put(i,variable);

	~cbox_checksinte[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 210, 20, 20)).action={|val| if(val.value,{~cbox_sinte.put(i,~cbox_chord=Synth(\acordesuno);)},{~cbox_sinte.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});
//resetea secuencias sinte
~cbox_delsinte=Button(~cbox_w,Rect(765,212,15,15));
~cbox_delsinte.states=[[" X ",Color.black,Color.red]];
~cbox_delsinte.action={|val|if(val.value==0,{

	"Cleared chord steps!".inform;

	~cbox_sinte.put((0..31),nil);

	for(0, 31, {|i|
		~cbox_checksinte[i].value = 0;

	});

})};
//acordes attack and release knobs
~cbox_sinte1attknob=EZKnob(~cbox_w,Rect(785,211,81,17),nil,ControlSpec(0.01,1,\lin,0.001,0.01,\att),{|a| a.value;~cbox_synth.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~cbox_sinte1relknob=EZKnob(~cbox_w,Rect(870,211,81,17),nil,ControlSpec(0.05,8,\lin,0.001,1,\rel),{|a| a.value;~cbox_synth.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);


//Acordes2
StaticText(~cbox_w,Rect(5,232,53,15)).string_("Chords2:").stringColor_(Color(0.9,0.9,0.9)).font_(Font("Dejavu Sans",11,true)).align_(\left).background_(Color(0.25,0.25,0.25));

~cbox_checkbox = 60;

for (0, 31, { |i|

	var checkvar = "~cbox_sinte2steps";

	var a = ~cbox_checksteps[i%~cbox_checksteps.size];

	var variable = checkvar ++ i;

	~cbox_checksinte2.put(i,variable);

	~cbox_checksinte2[i] = CheckBox.new(~cbox_w,Rect(~cbox_checkbox, 230, 20, 20)).action={|val| if(val.value,{~cbox_sinte2.put(i,~cbox_chord2=Synth(\acordesdos);)},{~cbox_sinte2.put(i,nil)})};

	~cbox_checkbox = ~cbox_checkbox + a;

});
//resetea secuencias sinte
~cbox_delsinte2=Button(~cbox_w,Rect(765,232,15,15));
~cbox_delsinte2.states=[[" X ",Color.black,Color.red]];
~cbox_delsinte2.action={|val|if(val.value==0,{

	"Cleared guitChord steps!".inform;

	~cbox_sinte2.put((0..31),nil);

	for(0, 31, {|i|
		~cbox_checksinte2[i].value = 0;

	});

})};
//acordes 2 attack and release knobs
~cbox_sinte2attknob=EZKnob(~cbox_w,Rect(785,231,81,17),nil,ControlSpec(0.01,1,\lin,0.001,0.1,\att),{|a| a.value;~cbox_synth2.set(\att,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~cbox_sinte2relknob=EZKnob(~cbox_w,Rect(870,231,81,17),nil,ControlSpec(0.05,8,\lin,0.001,0.5,\rel),{|a| a.value;~cbox_synth2.set(\rel,a.value)},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
);
