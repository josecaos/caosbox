(//CaosBox GUI 2 v0.1 - steps bajos, ambientes, sintetizadores
//bajo
StaticText(~w,Rect(5,132,53,15)).string_("Bass:").align_(\left).background_(Color(0.85,0.85,0.85));


// Help.gui
(
var	a = [20,20,20,30];

var	b = a[2%a];

var	d = 60;

var	e = d + b;

for (1, 32, { |i|

	i.postln;

	c = "~bassteps" + i;

	c = CheckBox.new(~w,Rect(d + b,130,20,20)).action={|val|if(val.value,{~bajo.put(i - 1,~bass=Synth(\bajouno);)},{~bajo.put(i - 1,nil)})};
	// a[1%a.size].postcln;
});

);

{var dos = [1,2,3,4]; 4.do(dos[20%dos.size].postcln)}.value


{var x = [1,2,3,4]; 4.do(x[20%x.size].postcln)}.value

{var x = [20,20,20,30]; x[4%x.size].postcln}.value

{z = [20,20,20,30]; z[20%z]}.value


/*~bassteps1=CheckBox.new(~w,Rect(60,130,20,20)).action={|val|if(val.value,{~bajo.put(0,~bass=Synth(\bajouno);)},{~bajo.put(0,nil)})};
~bassteps2=CheckBox.new(~w,Rect(80,130,20,20)).action={|val|if(val.value,{~bajo.put(1,~bass=Synth(\bajouno);)},{~bajo.put(1,nil)})};
~bassteps3=CheckBox.new(~w,Rect(100,130,20,20)).action={|val|if(val.value,{~bajo.put(2,~bass=Synth(\bajouno);)},{~bajo.put(2,nil)})};
~bassteps4=CheckBox.new(~w,Rect(120,130,20,20)).action={|val|if(val.value,{~bajo.put(3,~bass=Synth(\bajouno);)},{~bajo.put(3,nil)})};
~bassteps5=CheckBox.new(~w,Rect(150,130,20,20)).action={|val|if(val.value,{~bajo.put(4,~bass=Synth(\bajouno);)},{~bajo.put(4,nil)})};
~bassteps6=CheckBox.new(~w,Rect(170,130,20,20)).action={|val|if(val.value,{~bajo.put(5,~bass=Synth(\bajouno);)},{~bajo.put(5,nil)})};
~bassteps7=CheckBox.new(~w,Rect(190,130,20,20)).action={|val|if(val.value,{~bajo.put(6,~bass=Synth(\bajouno);)},{~bajo.put(6,nil)})};
~bassteps8=CheckBox.new(~w,Rect(210,130,20,20)).action={|val|if(val.value,{~bajo.put(7,~bass=Synth(\bajouno);)},{~bajo.put(7,nil)})};
~bassteps9=CheckBox.new(~w,Rect(240,130,20,20)).action={|val|if(val.value,{~bajo.put(8,~bass=Synth(\bajouno);)},{~bajo.put(8,nil)})};
~bassteps10=CheckBox.new(~w,Rect(260,130,20,20)).action={|val|if(val.value,{~bajo.put(9,~bass=Synth(\bajouno);)},{~bajo.put(9,nil)})};
~bassteps11=CheckBox.new(~w,Rect(280,130,20,20)).action={|val|if(val.value,{~bajo.put(10,~bass=Synth(\bajouno);)},{~bajo.put(10,nil)})};
~bassteps12=CheckBox.new(~w,Rect(300,130,20,20)).action={|val|if(val.value,{~bajo.put(11,~bass=Synth(\bajouno);)},{~bajo.put(11,nil)})};
~bassteps13=CheckBox.new(~w,Rect(330,130,20,20)).action={|val|if(val.value,{~bajo.put(12,~bass=Synth(\bajouno);)},{~bajo.put(12,nil)})};
~bassteps14=CheckBox.new(~w,Rect(350,130,20,20)).action={|val|if(val.value,{~bajo.put(13,~bass=Synth(\bajouno);)},{~bajo.put(13,nil)})};
~bassteps15=CheckBox.new(~w,Rect(370,130,20,20)).action={|val|if(val.value,{~bajo.put(14,~bass=Synth(\bajouno);)},{~bajo.put(14,nil)})};
~bassteps16=CheckBox.new(~w,Rect(390,130,20,20)).action={|val|if(val.value,{~bajo.put(15,~bass=Synth(\bajouno);)},{~bajo.put(15,nil)})};
~bassteps17=CheckBox.new(~w,Rect(420,130,20,20)).action={|val|if(val.value,{~bajo.put(16,~bass=Synth(\bajouno);)},{~bajo.put(16,nil)})};
~bassteps18=CheckBox.new(~w,Rect(440,130,20,20)).action={|val|if(val.value,{~bajo.put(17,~bass=Synth(\bajouno);)},{~bajo.put(17,nil)})};
~bassteps19=CheckBox.new(~w,Rect(460,130,20,20)).action={|val|if(val.value,{~bajo.put(18,~bass=Synth(\bajouno);)},{~bajo.put(18,nil)})};
~bassteps20=CheckBox.new(~w,Rect(480,130,20,20)).action={|val|if(val.value,{~bajo.put(19,~bass=Synth(\bajouno);)},{~bajo.put(19,nil)})};
~bassteps21=CheckBox.new(~w,Rect(510,130,20,20)).action={|val|if(val.value,{~bajo.put(20,~bass=Synth(\bajouno);)},{~bajo.put(20,nil)})};
~bassteps22=CheckBox.new(~w,Rect(530,130,20,20)).action={|val|if(val.value,{~bajo.put(21,~bass=Synth(\bajouno);)},{~bajo.put(21,nil)})};
~bassteps23=CheckBox.new(~w,Rect(550,130,20,20)).action={|val|if(val.value,{~bajo.put(22,~bass=Synth(\bajouno);)},{~bajo.put(22,nil)})};
~bassteps24=CheckBox.new(~w,Rect(570,130,20,20)).action={|val|if(val.value,{~bajo.put(23,~bass=Synth(\bajouno);)},{~bajo.put(23,nil)})};
~bassteps25=CheckBox.new(~w,Rect(600,130,20,20)).action={|val|if(val.value,{~bajo.put(24,~bass=Synth(\bajouno);)},{~bajo.put(24,nil)})};
~bassteps26=CheckBox.new(~w,Rect(620,130,20,20)).action={|val|if(val.value,{~bajo.put(25,~bass=Synth(\bajouno);)},{~bajo.put(25,nil)})};
~bassteps27=CheckBox.new(~w,Rect(640,130,20,20)).action={|val|if(val.value,{~bajo.put(26,~bass=Synth(\bajouno);)},{~bajo.put(26,nil)})};
~bassteps28=CheckBox.new(~w,Rect(660,130,20,20)).action={|val|if(val.value,{~bajo.put(27,~bass=Synth(\bajouno);)},{~bajo.put(27,nil)})};
~bassteps29=CheckBox.new(~w,Rect(690,130,20,20)).action={|val|if(val.value,{~bajo.put(28,~bass=Synth(\bajouno);)},{~bajo.put(28,nil)})};
~bassteps30=CheckBox.new(~w,Rect(710,130,20,20)).action={|val|if(val.value,{~bajo.put(29,~bass=Synth(\bajouno);)},{~bajo.put(29,nil)})};
~bassteps31=CheckBox.new(~w,Rect(730,130,20,20)).action={|val|if(val.value,{~bajo.put(30,~bass=Synth(\bajouno);)},{~bajo.put(30,nil)})};
~bassteps32=CheckBox.new(~w,Rect(750,130,20,20)).action={|val|if(val.value,{~bajo.put(31,~bass=Synth(\bajouno);)},{~bajo.put(31,nil)})};*/
//resetea secuencias Bajo
~delbass=Button(~w,Rect(765,132,15,15));
~delbass.states=[[" X ",Color.black,Color.red]];
~delbass.action={|val|if(val.value==0,{"Bass have been cleared!".postln;
										~bajo.put((0..31),nil);
										~bassteps1.value=0;~bassteps2.value=0;
										~bassteps3.value=0;~bassteps4.value=0;
										~bassteps5.value=0;~bassteps6.value=0;
										~bassteps7.value=0;~bassteps8.value=0;
										~bassteps9.value=0;~bassteps10.value=0;
										~bassteps11.value=0;~bassteps12.value=0;
										~bassteps13.value=0;~bassteps14.value=0;
										~bassteps15.value=0;~bassteps16.value=0;
										~bassteps17.value=0;~bassteps18.value=0;
										~bassteps19.value=0;~bassteps20.value=0;
										~bassteps21.value=0;~bassteps22.value=0;
										~bassteps23.value=0;~bassteps24.value=0;
										~bassteps25.value=0;~bassteps26.value=0;
										~bassteps27.value=0;~bassteps28.value=0;
										~bassteps29.value=0;~bassteps30.value=0;
										~bassteps31.value=0;~bassteps32.value=0;
										})};
//bajo attack and release knobs
~bass1attknob=EZKnob(~w,Rect(785,131,81,17),nil,ControlSpec(0.01,0.5,\lin,0.001,0.05,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~bass1relknob=EZKnob(~w,Rect(870,131,81,17),nil,ControlSpec(0.1,2,\lin,0.001,0.5,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
//bajo2
StaticText(~w,Rect(5,152,53,15)).string_("Bass2:").align_(\left).background_(Color(0.85,0.85,0.85));
~bass2teps1=CheckBox.new(~w,Rect(60,150,20,20)).action={|val|if(val.value,{~bajo2.put(0,~bass2=Synth(\bajodos);)},{~bajo2.put(0,nil)})};
~bass2teps2=CheckBox.new(~w,Rect(80,150,20,20)).action={|val|if(val.value,{~bajo2.put(1,~bass2=Synth(\bajodos);)},{~bajo2.put(1,nil)})};
~bass2teps3=CheckBox.new(~w,Rect(100,150,20,20)).action={|val|if(val.value,{~bajo2.put(2,~bass2=Synth(\bajodos);)},{~bajo2.put(2,nil)})};
~bass2teps4=CheckBox.new(~w,Rect(120,150,20,20)).action={|val|if(val.value,{~bajo2.put(3,~bass2=Synth(\bajodos);)},{~bajo2.put(3,nil)})};
~bass2teps5=CheckBox.new(~w,Rect(150,150,20,20)).action={|val|if(val.value,{~bajo2.put(4,~bass2=Synth(\bajodos);)},{~bajo2.put(4,nil)})};
~bass2teps6=CheckBox.new(~w,Rect(170,150,20,20)).action={|val|if(val.value,{~bajo2.put(5,~bass2=Synth(\bajodos);)},{~bajo2.put(5,nil)})};
~bass2teps7=CheckBox.new(~w,Rect(190,150,20,20)).action={|val|if(val.value,{~bajo2.put(6,~bass2=Synth(\bajodos);)},{~bajo2.put(6,nil)})};
~bass2teps8=CheckBox.new(~w,Rect(210,150,20,20)).action={|val|if(val.value,{~bajo2.put(7,~bass2=Synth(\bajodos);)},{~bajo2.put(7,nil)})};
~bass2teps9=CheckBox.new(~w,Rect(240,150,20,20)).action={|val|if(val.value,{~bajo2.put(8,~bass2=Synth(\bajodos);)},{~bajo2.put(8,nil)})};
~bass2teps10=CheckBox.new(~w,Rect(260,150,20,20)).action={|val|if(val.value,{~bajo2.put(9,~bass2=Synth(\bajodos);)},{~bajo2.put(9,nil)})};
~bass2teps11=CheckBox.new(~w,Rect(280,150,20,20)).action={|val|if(val.value,{~bajo2.put(10,~bass2=Synth(\bajodos);)},{~bajo2.put(10,nil)})};
~bass2teps12=CheckBox.new(~w,Rect(300,150,20,20)).action={|val|if(val.value,{~bajo2.put(11,~bass2=Synth(\bajodos);)},{~bajo2.put(11,nil)})};
~bass2teps13=CheckBox.new(~w,Rect(330,150,20,20)).action={|val|if(val.value,{~bajo2.put(12,~bass2=Synth(\bajodos);)},{~bajo2.put(12,nil)})};
~bass2teps14=CheckBox.new(~w,Rect(350,150,20,20)).action={|val|if(val.value,{~bajo2.put(13,~bass2=Synth(\bajodos);)},{~bajo2.put(13,nil)})};
~bass2teps15=CheckBox.new(~w,Rect(370,150,20,20)).action={|val|if(val.value,{~bajo2.put(14,~bass2=Synth(\bajodos);)},{~bajo2.put(14,nil)})};
~bass2teps16=CheckBox.new(~w,Rect(390,150,20,20)).action={|val|if(val.value,{~bajo2.put(15,~bass2=Synth(\bajodos);)},{~bajo2.put(15,nil)})};
~bass2teps17=CheckBox.new(~w,Rect(420,150,20,20)).action={|val|if(val.value,{~bajo2.put(16,~bass2=Synth(\bajodos);)},{~bajo2.put(16,nil)})};
~bass2teps18=CheckBox.new(~w,Rect(440,150,20,20)).action={|val|if(val.value,{~bajo2.put(17,~bass2=Synth(\bajodos);)},{~bajo2.put(17,nil)})};
~bass2teps19=CheckBox.new(~w,Rect(460,150,20,20)).action={|val|if(val.value,{~bajo2.put(18,~bass2=Synth(\bajodos);)},{~bajo2.put(18,nil)})};
~bass2teps20=CheckBox.new(~w,Rect(480,150,20,20)).action={|val|if(val.value,{~bajo2.put(19,~bass2=Synth(\bajodos);)},{~bajo2.put(19,nil)})};
~bass2teps21=CheckBox.new(~w,Rect(510,150,20,20)).action={|val|if(val.value,{~bajo2.put(20,~bass2=Synth(\bajodos);)},{~bajo2.put(20,nil)})};
~bass2teps22=CheckBox.new(~w,Rect(530,150,20,20)).action={|val|if(val.value,{~bajo2.put(21,~bass2=Synth(\bajodos);)},{~bajo2.put(21,nil)})};
~bass2teps23=CheckBox.new(~w,Rect(550,150,20,20)).action={|val|if(val.value,{~bajo2.put(22,~bass2=Synth(\bajodos);)},{~bajo2.put(22,nil)})};
~bass2teps24=CheckBox.new(~w,Rect(570,150,20,20)).action={|val|if(val.value,{~bajo2.put(23,~bass2=Synth(\bajodos);)},{~bajo2.put(23,nil)})};
~bass2teps25=CheckBox.new(~w,Rect(600,150,20,20)).action={|val|if(val.value,{~bajo2.put(24,~bass2=Synth(\bajodos);)},{~bajo2.put(24,nil)})};
~bass2teps26=CheckBox.new(~w,Rect(620,150,20,20)).action={|val|if(val.value,{~bajo2.put(25,~bass2=Synth(\bajodos);)},{~bajo2.put(25,nil)})};
~bass2teps27=CheckBox.new(~w,Rect(640,150,20,20)).action={|val|if(val.value,{~bajo2.put(26,~bass2=Synth(\bajodos);)},{~bajo2.put(26,nil)})};
~bass2teps28=CheckBox.new(~w,Rect(660,150,20,20)).action={|val|if(val.value,{~bajo2.put(27,~bass2=Synth(\bajodos);)},{~bajo2.put(27,nil)})};
~bass2teps29=CheckBox.new(~w,Rect(690,150,20,20)).action={|val|if(val.value,{~bajo2.put(28,~bass2=Synth(\bajodos);)},{~bajo2.put(28,nil)})};
~bass2teps30=CheckBox.new(~w,Rect(710,150,20,20)).action={|val|if(val.value,{~bajo2.put(29,~bass2=Synth(\bajodos);)},{~bajo2.put(29,nil)})};
~bass2teps31=CheckBox.new(~w,Rect(730,150,20,20)).action={|val|if(val.value,{~bajo2.put(30,~bass2=Synth(\bajodos);)},{~bajo2.put(30,nil)})};
~bass2teps32=CheckBox.new(~w,Rect(750,150,20,20)).action={|val|if(val.value,{~bajo2.put(31,~bass2=Synth(\bajodos);)},{~bajo2.put(31,nil)})};
//resetea secuencias bajo2
~delbass=Button(~w,Rect(765,152,15,15));
~delbass.states=[[" X ",Color.black,Color.red]];
~delbass.action={|val|if(val.value==0,{"Bass have been cleared!".postln;
										~bajo2.put((0..31),nil);
										~bass2teps1.value=0;~bass2teps2.value=0;
										~bass2teps3.value=0;~bass2teps4.value=0;
										~bass2teps5.value=0;~bass2teps6.value=0;
										~bass2teps7.value=0;~bass2teps8.value=0;
										~bass2teps9.value=0;~bass2teps10.value=0;
										~bass2teps11.value=0;~bass2teps12.value=0;
										~bass2teps13.value=0;~bass2teps14.value=0;
										~bass2teps15.value=0;~bass2teps16.value=0;
										~bass2teps17.value=0;~bass2teps18.value=0;
										~bass2teps19.value=0;~bass2teps20.value=0;
										~bass2teps21.value=0;~bass2teps22.value=0;
										~bass2teps23.value=0;~bass2teps24.value=0;
										~bass2teps25.value=0;~bass2teps26.value=0;
										~bass2teps27.value=0;~bass2teps28.value=0;
										~bass2teps29.value=0;~bass2teps30.value=0;
										~bass2teps31.value=0;~bass2teps32.value=0;
										})};
//bass attack and release knobs
~bass2attknob=EZKnob(~w,Rect(785,151,81,17),nil,ControlSpec(0.01,0.5,\lin,0.001,0.05,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~bass2relknob=EZKnob(~w,Rect(870,151,81,17),nil,ControlSpec(0.05,4,\lin,0.001,0.5,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
//ambiente
StaticText(~w,Rect(5,172,53,15)).string_("Pad:").align_(\left).background_(Color(0.85,0.85,0.85));
~ambsteps1=CheckBox.new(~w,Rect(60,170,20,20)).action={|val|if(val.value,{~ambiente.put(0,~amb=Synth(\ambuno);)},{~ambiente.put(0,nil)})};
~ambsteps2=CheckBox.new(~w,Rect(80,170,20,20)).action={|val|if(val.value,{~ambiente.put(1,~amb=Synth(\ambuno);)},{~ambiente.put(1,nil)})};
~ambsteps3=CheckBox.new(~w,Rect(100,170,20,20)).action={|val|if(val.value,{~ambiente.put(2,~amb=Synth(\ambuno);)},{~ambiente.put(2,nil)})};
~ambsteps4=CheckBox.new(~w,Rect(120,170,20,20)).action={|val|if(val.value,{~ambiente.put(3,~amb=Synth(\ambuno);)},{~ambiente.put(3,nil)})};
~ambsteps5=CheckBox.new(~w,Rect(150,170,20,20)).action={|val|if(val.value,{~ambiente.put(4,~amb=Synth(\ambuno);)},{~ambiente.put(4,nil)})};
~ambsteps6=CheckBox.new(~w,Rect(170,170,20,20)).action={|val|if(val.value,{~ambiente.put(5,~amb=Synth(\ambuno);)},{~ambiente.put(5,nil)})};
~ambsteps7=CheckBox.new(~w,Rect(190,170,20,20)).action={|val|if(val.value,{~ambiente.put(6,~amb=Synth(\ambuno);)},{~ambiente.put(6,nil)})};
~ambsteps8=CheckBox.new(~w,Rect(210,170,20,20)).action={|val|if(val.value,{~ambiente.put(7,~amb=Synth(\ambuno);)},{~ambiente.put(7,nil)})};
~ambsteps9=CheckBox.new(~w,Rect(240,170,20,20)).action={|val|if(val.value,{~ambiente.put(8,~amb=Synth(\ambuno);)},{~ambiente.put(8,nil)})};
~ambsteps10=CheckBox.new(~w,Rect(260,170,20,20)).action={|val|if(val.value,{~ambiente.put(9,~amb=Synth(\ambuno);)},{~ambiente.put(9,nil)})};
~ambsteps11=CheckBox.new(~w,Rect(280,170,20,20)).action={|val|if(val.value,{~ambiente.put(10,~amb=Synth(\ambuno);)},{~ambiente.put(10,nil)})};
~ambsteps12=CheckBox.new(~w,Rect(300,170,20,20)).action={|val|if(val.value,{~ambiente.put(11,~amb=Synth(\ambuno);)},{~ambiente.put(11,nil)})};
~ambsteps13=CheckBox.new(~w,Rect(330,170,20,20)).action={|val|if(val.value,{~ambiente.put(12,~amb=Synth(\ambuno);)},{~ambiente.put(12,nil)})};
~ambsteps14=CheckBox.new(~w,Rect(350,170,20,20)).action={|val|if(val.value,{~ambiente.put(13,~amb=Synth(\ambuno);)},{~ambiente.put(13,nil)})};
~ambsteps15=CheckBox.new(~w,Rect(370,170,20,20)).action={|val|if(val.value,{~ambiente.put(14,~amb=Synth(\ambuno);)},{~ambiente.put(14,nil)})};
~ambsteps16=CheckBox.new(~w,Rect(390,170,20,20)).action={|val|if(val.value,{~ambiente.put(15,~amb=Synth(\ambuno);)},{~ambiente.put(15,nil)})};
~ambsteps17=CheckBox.new(~w,Rect(420,170,20,20)).action={|val|if(val.value,{~ambiente.put(16,~amb=Synth(\ambuno);)},{~ambiente.put(16,nil)})};
~ambsteps18=CheckBox.new(~w,Rect(440,170,20,20)).action={|val|if(val.value,{~ambiente.put(17,~amb=Synth(\ambuno);)},{~ambiente.put(17,nil)})};
~ambsteps19=CheckBox.new(~w,Rect(460,170,20,20)).action={|val|if(val.value,{~ambiente.put(18,~amb=Synth(\ambuno);)},{~ambiente.put(18,nil)})};
~ambsteps20=CheckBox.new(~w,Rect(480,170,20,20)).action={|val|if(val.value,{~ambiente.put(19,~amb=Synth(\ambuno);)},{~ambiente.put(19,nil)})};
~ambsteps21=CheckBox.new(~w,Rect(510,170,20,20)).action={|val|if(val.value,{~ambiente.put(20,~amb=Synth(\ambuno);)},{~ambiente.put(20,nil)})};
~ambsteps22=CheckBox.new(~w,Rect(530,170,20,20)).action={|val|if(val.value,{~ambiente.put(21,~amb=Synth(\ambuno);)},{~ambiente.put(21,nil)})};
~ambsteps23=CheckBox.new(~w,Rect(550,170,20,20)).action={|val|if(val.value,{~ambiente.put(22,~amb=Synth(\ambuno);)},{~ambiente.put(22,nil)})};
~ambsteps24=CheckBox.new(~w,Rect(570,170,20,20)).action={|val|if(val.value,{~ambiente.put(23,~amb=Synth(\ambuno);)},{~ambiente.put(23,nil)})};
~ambsteps25=CheckBox.new(~w,Rect(600,170,20,20)).action={|val|if(val.value,{~ambiente.put(24,~amb=Synth(\ambuno);)},{~ambiente.put(24,nil)})};
~ambsteps26=CheckBox.new(~w,Rect(620,170,20,20)).action={|val|if(val.value,{~ambiente.put(25,~amb=Synth(\ambuno);)},{~ambiente.put(25,nil)})};
~ambsteps27=CheckBox.new(~w,Rect(640,170,20,20)).action={|val|if(val.value,{~ambiente.put(26,~amb=Synth(\ambuno);)},{~ambiente.put(26,nil)})};
~ambsteps28=CheckBox.new(~w,Rect(660,170,20,20)).action={|val|if(val.value,{~ambiente.put(27,~amb=Synth(\ambuno);)},{~ambiente.put(27,nil)})};
~ambsteps29=CheckBox.new(~w,Rect(690,170,20,20)).action={|val|if(val.value,{~ambiente.put(28,~amb=Synth(\ambuno);)},{~ambiente.put(28,nil)})};
~ambsteps30=CheckBox.new(~w,Rect(710,170,20,20)).action={|val|if(val.value,{~ambiente.put(29,~amb=Synth(\ambuno);)},{~ambiente.put(29,nil)})};
~ambsteps31=CheckBox.new(~w,Rect(730,170,20,20)).action={|val|if(val.value,{~ambiente.put(30,~amb=Synth(\ambuno);)},{~ambiente.put(30,nil)})};
~ambsteps32=CheckBox.new(~w,Rect(750,170,20,20)).action={|val|if(val.value,{~ambiente.put(31,~amb=Synth(\ambuno);)},{~ambiente.put(31,nil)})};
//resetea secuencias ambiente
~delbass=Button(~w,Rect(765,172,15,15));
~delbass.states=[[" X ",Color.black,Color.red]];
~delbass.action={|val|if(val.value==0,{"Synth have been cleared!".postln;
										~ambiente.put((0..31),nil);
										~ambsteps1.value=0;~ambsteps2.value=0;
										~ambsteps3.value=0;~ambsteps4.value=0;
										~ambsteps5.value=0;~ambsteps6.value=0;
										~ambsteps7.value=0;~ambsteps8.value=0;
										~ambsteps9.value=0;~ambsteps10.value=0;
										~ambsteps11.value=0;~ambsteps12.value=0;
										~ambsteps13.value=0;~ambsteps14.value=0;
										~ambsteps15.value=0;~ambsteps16.value=0;
										~ambsteps17.value=0;~ambsteps18.value=0;
										~ambsteps19.value=0;~ambsteps20.value=0;
										~ambsteps21.value=0;~ambsteps22.value=0;
										~ambsteps23.value=0;~ambsteps24.value=0;
										~ambsteps25.value=0;~ambsteps26.value=0;
										~ambsteps27.value=0;~ambsteps28.value=0;
										~ambsteps29.value=0;~ambsteps30.value=0;
										~ambsteps31.value=0;~ambsteps32.value=0;
										})};
//ambiente attack and release knobs
~amb1attknob=EZKnob(~w,Rect(785,171,81,17),nil,ControlSpec(0.25,2,\lin,0.001,0.5,\att),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~amb1relknob=EZKnob(~w,Rect(870,171,81,17),nil,ControlSpec(0.25,12,\lin,0.001,2,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);

//ambiente2
StaticText(~w,Rect(5,192,53,15)).string_("pad2:").align_(\left).background_(Color(0.85,0.85,0.85));
~amb2steps1=CheckBox.new(~w,Rect(60,190,20,20)).action={|val|if(val.value,{~ambiente2.put(0,~amb2=Synth(\ambdos);)},{~ambiente2.put(0,nil)})};
~amb2steps2=CheckBox.new(~w,Rect(80,190,20,20)).action={|val|if(val.value,{~ambiente2.put(1,~amb2=Synth(\ambdos);)},{~ambiente2.put(1,nil)})};
~amb2steps3=CheckBox.new(~w,Rect(100,190,20,20)).action={|val|if(val.value,{~ambiente2.put(2,~amb2=Synth(\ambdos);)},{~ambiente2.put(2,nil)})};
~amb2steps4=CheckBox.new(~w,Rect(120,190,20,20)).action={|val|if(val.value,{~ambiente2.put(3,~amb2=Synth(\ambdos);)},{~ambiente2.put(3,nil)})};
~amb2steps5=CheckBox.new(~w,Rect(150,190,20,20)).action={|val|if(val.value,{~ambiente2.put(4,~amb2=Synth(\ambdos);)},{~ambiente2.put(4,nil)})};
~amb2steps6=CheckBox.new(~w,Rect(170,190,20,20)).action={|val|if(val.value,{~ambiente2.put(5,~amb2=Synth(\ambdos);)},{~ambiente2.put(5,nil)})};
~amb2steps7=CheckBox.new(~w,Rect(190,190,20,20)).action={|val|if(val.value,{~ambiente2.put(6,~amb2=Synth(\ambdos);)},{~ambiente2.put(6,nil)})};
~amb2steps8=CheckBox.new(~w,Rect(210,190,20,20)).action={|val|if(val.value,{~ambiente2.put(7,~amb2=Synth(\ambdos);)},{~ambiente2.put(7,nil)})};
~amb2steps9=CheckBox.new(~w,Rect(240,190,20,20)).action={|val|if(val.value,{~ambiente2.put(8,~amb2=Synth(\ambdos);)},{~ambiente2.put(8,nil)})};
~amb2steps10=CheckBox.new(~w,Rect(260,190,20,20)).action={|val|if(val.value,{~ambiente2.put(9,~amb2=Synth(\ambdos);)},{~ambiente2.put(9,nil)})};
~amb2steps11=CheckBox.new(~w,Rect(280,190,20,20)).action={|val|if(val.value,{~ambiente2.put(10,~amb2=Synth(\ambdos);)},{~ambiente2.put(10,nil)})};
~amb2steps12=CheckBox.new(~w,Rect(300,190,20,20)).action={|val|if(val.value,{~ambiente2.put(11,~amb2=Synth(\ambdos);)},{~ambiente2.put(11,nil)})};
~amb2steps13=CheckBox.new(~w,Rect(330,190,20,20)).action={|val|if(val.value,{~ambiente2.put(12,~amb2=Synth(\ambdos);)},{~ambiente2.put(12,nil)})};
~amb2steps14=CheckBox.new(~w,Rect(350,190,20,20)).action={|val|if(val.value,{~ambiente2.put(13,~amb2=Synth(\ambdos);)},{~ambiente2.put(13,nil)})};
~amb2steps15=CheckBox.new(~w,Rect(370,190,20,20)).action={|val|if(val.value,{~ambiente2.put(14,~amb2=Synth(\ambdos);)},{~ambiente2.put(14,nil)})};
~amb2steps16=CheckBox.new(~w,Rect(390,190,20,20)).action={|val|if(val.value,{~ambiente2.put(15,~amb2=Synth(\ambdos);)},{~ambiente2.put(15,nil)})};
~amb2steps17=CheckBox.new(~w,Rect(420,190,20,20)).action={|val|if(val.value,{~ambiente2.put(16,~amb2=Synth(\ambdos);)},{~ambiente2.put(16,nil)})};
~amb2steps18=CheckBox.new(~w,Rect(440,190,20,20)).action={|val|if(val.value,{~ambiente2.put(17,~amb2=Synth(\ambdos);)},{~ambiente2.put(17,nil)})};
~amb2steps19=CheckBox.new(~w,Rect(460,190,20,20)).action={|val|if(val.value,{~ambiente2.put(18,~amb2=Synth(\ambdos);)},{~ambiente2.put(18,nil)})};
~amb2steps20=CheckBox.new(~w,Rect(480,190,20,20)).action={|val|if(val.value,{~ambiente2.put(19,~amb2=Synth(\ambdos);)},{~ambiente2.put(19,nil)})};
~amb2steps21=CheckBox.new(~w,Rect(510,190,20,20)).action={|val|if(val.value,{~ambiente2.put(20,~amb2=Synth(\ambdos);)},{~ambiente2.put(20,nil)})};
~amb2steps22=CheckBox.new(~w,Rect(530,190,20,20)).action={|val|if(val.value,{~ambiente2.put(21,~amb2=Synth(\ambdos);)},{~ambiente2.put(21,nil)})};
~amb2steps23=CheckBox.new(~w,Rect(550,190,20,20)).action={|val|if(val.value,{~ambiente2.put(22,~amb2=Synth(\ambdos);)},{~ambiente2.put(22,nil)})};
~amb2steps24=CheckBox.new(~w,Rect(570,190,20,20)).action={|val|if(val.value,{~ambiente2.put(23,~amb2=Synth(\ambdos);)},{~ambiente2.put(23,nil)})};
~amb2steps25=CheckBox.new(~w,Rect(600,190,20,20)).action={|val|if(val.value,{~ambiente2.put(24,~amb2=Synth(\ambdos);)},{~ambiente2.put(24,nil)})};
~amb2steps26=CheckBox.new(~w,Rect(620,190,20,20)).action={|val|if(val.value,{~ambiente2.put(25,~amb2=Synth(\ambdos);)},{~ambiente2.put(25,nil)})};
~amb2steps27=CheckBox.new(~w,Rect(640,190,20,20)).action={|val|if(val.value,{~ambiente2.put(26,~amb2=Synth(\ambdos);)},{~ambiente2.put(26,nil)})};
~amb2steps28=CheckBox.new(~w,Rect(660,190,20,20)).action={|val|if(val.value,{~ambiente2.put(27,~amb2=Synth(\ambdos);)},{~ambiente2.put(27,nil)})};
~amb2steps29=CheckBox.new(~w,Rect(690,190,20,20)).action={|val|if(val.value,{~ambiente2.put(28,~amb2=Synth(\ambdos);)},{~ambiente2.put(28,nil)})};
~amb2steps30=CheckBox.new(~w,Rect(710,190,20,20)).action={|val|if(val.value,{~ambiente2.put(29,~amb2=Synth(\ambdos);)},{~ambiente2.put(29,nil)})};
~amb2steps31=CheckBox.new(~w,Rect(730,190,20,20)).action={|val|if(val.value,{~ambiente2.put(30,~amb2=Synth(\ambdos);)},{~ambiente2.put(30,nil)})};
~amb2steps32=CheckBox.new(~w,Rect(750,190,20,20)).action={|val|if(val.value,{~ambiente2.put(31,~amb2=Synth(\ambdos);)},{~ambiente2.put(31,nil)})};
//resetea secuencias ambiente2
~delamb2=Button(~w,Rect(765,192,15,15));
~delamb2.states=[[" X ",Color.black,Color.red]];
~delamb2.action={|val|if(val.value==0,{"Synth have been cleared!".postln;
										~ambiente2.put((0..31),nil);
										~amb2steps1.value=0;~amb2steps2.value=0;
										~amb2steps3.value=0;~amb2steps4.value=0;
										~amb2steps5.value=0;~amb2steps6.value=0;
										~amb2steps7.value=0;~amb2steps8.value=0;
										~amb2steps9.value=0;~amb2steps10.value=0;
										~amb2steps11.value=0;~amb2steps12.value=0;
										~amb2steps13.value=0;~amb2steps14.value=0;
										~amb2steps15.value=0;~amb2steps16.value=0;
										~amb2steps17.value=0;~amb2steps18.value=0;
										~amb2steps19.value=0;~amb2steps20.value=0;
										~amb2steps21.value=0;~amb2steps22.value=0;
										~amb2steps23.value=0;~amb2steps24.value=0;
										~amb2steps25.value=0;~amb2steps26.value=0;
										~amb2steps27.value=0;~amb2steps28.value=0;
										~amb2steps29.value=0;~amb2steps30.value=0;
										~amb2steps31.value=0;~amb2steps32.value=0;
										})};
//ambiente2 attack and release knobs
~amb2attknob=EZKnob(~w,Rect(785,191,81,17),nil,ControlSpec(0.25,2,\lin,0.001,0.25,\att),{|a| a.value;},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
~amb2relknob=EZKnob(~w,Rect(870,191,81,17),nil,ControlSpec(0.25,12,\lin,0.001,4,\rel),{|a| a.value},unitWidth:25,layout:\horz).setColors(Color.grey,Color.black, Color.green(0.9),Color.grey, Color.black, Color.yellow);
//acordes
StaticText(~w,Rect(5,212,53,15)).string_("Chords:").align_(\left).background_(Color(0.85,0.85,0.85));
~sintesteps1=CheckBox.new(~w,Rect(60,210,20,20)).action={|val|if(val.value,{~sinte.put(0,~chord=Synth(\acordesuno))},{~sinte.put(0,nil)})};
~sintesteps2=CheckBox.new(~w,Rect(80,210,20,20)).action={|val|if(val.value,{~sinte.put(1,~chord=Synth(\acordesuno))},{~sinte.put(1,nil)})};
~sintesteps3=CheckBox.new(~w,Rect(100,210,20,20)).action={|val|if(val.value,{~sinte.put(2,~chord=Synth(\acordesuno))},{~sinte.put(2,nil)})};
~sintesteps4=CheckBox.new(~w,Rect(120,210,20,20)).action={|val|if(val.value,{~sinte.put(3,~chord=Synth(\acordesuno))},{~sinte.put(3,nil)})};
~sintesteps5=CheckBox.new(~w,Rect(150,210,20,20)).action={|val|if(val.value,{~sinte.put(4,~chord=Synth(\acordesuno))},{~sinte.put(4,nil)})};
~sintesteps6=CheckBox.new(~w,Rect(170,210,20,20)).action={|val|if(val.value,{~sinte.put(5,~chord=Synth(\acordesuno))},{~sinte.put(5,nil)})};
~sintesteps7=CheckBox.new(~w,Rect(190,210,20,20)).action={|val|if(val.value,{~sinte.put(6,~chord=Synth(\acordesuno))},{~sinte.put(6,nil)})};
~sintesteps8=CheckBox.new(~w,Rect(210,210,20,20)).action={|val|if(val.value,{~sinte.put(7,~chord=Synth(\acordesuno))},{~sinte.put(7,nil)})};
~sintesteps9=CheckBox.new(~w,Rect(240,210,20,20)).action={|val|if(val.value,{~sinte.put(8,~chord=Synth(\acordesuno))},{~sinte.put(8,nil)})};
~sintesteps10=CheckBox.new(~w,Rect(260,210,20,20)).action={|val|if(val.value,{~sinte.put(9,~chord=Synth(\acordesuno))},{~sinte.put(9,nil)})};
~sintesteps11=CheckBox.new(~w,Rect(280,210,20,20)).action={|val|if(val.value,{~sinte.put(10,~chord=Synth(\acordesuno))},{~sinte.put(10,nil)})};
~sintesteps12=CheckBox.new(~w,Rect(300,210,20,20)).action={|val|if(val.value,{~sinte.put(11,~chord=Synth(\acordesuno))},{~sinte.put(11,nil)})};
~sintesteps13=CheckBox.new(~w,Rect(330,210,20,20)).action={|val|if(val.value,{~sinte.put(12,~chord=Synth(\acordesuno))},{~sinte.put(12,nil)})};
~sintesteps14=CheckBox.new(~w,Rect(350,210,20,20)).action={|val|if(val.value,{~sinte.put(13,~chord=Synth(\acordesuno))},{~sinte.put(13,nil)})};
~sintesteps15=CheckBox.new(~w,Rect(370,210,20,20)).action={|val|if(val.value,{~sinte.put(14,~chord=Synth(\acordesuno))},{~sinte.put(14,nil)})};
~sintesteps16=CheckBox.new(~w,Rect(390,210,20,20)).action={|val|if(val.value,{~sinte.put(15,~chord=Synth(\acordesuno))},{~sinte.put(15,nil)})};
~sintesteps17=CheckBox.new(~w,Rect(420,210,20,20)).action={|val|if(val.value,{~sinte.put(16,~chord=Synth(\acordesuno))},{~sinte.put(16,nil)})};
~sintesteps18=CheckBox.new(~w,Rect(440,210,20,20)).action={|val|if(val.value,{~sinte.put(17,~chord=Synth(\acordesuno))},{~sinte.put(17,nil)})};
~sintesteps19=CheckBox.new(~w,Rect(460,210,20,20)).action={|val|if(val.value,{~sinte.put(18,~chord=Synth(\acordesuno))},{~sinte.put(18,nil)})};
~sintesteps20=CheckBox.new(~w,Rect(480,210,20,20)).action={|val|if(val.value,{~sinte.put(19,~chord=Synth(\acordesuno))},{~sinte.put(19,nil)})};
~sintesteps21=CheckBox.new(~w,Rect(510,210,20,20)).action={|val|if(val.value,{~sinte.put(20,~chord=Synth(\acordesuno))},{~sinte.put(20,nil)})};
~sintesteps22=CheckBox.new(~w,Rect(530,210,20,20)).action={|val|if(val.value,{~sinte.put(21,~chord=Synth(\acordesuno))},{~sinte.put(21,nil)})};
~sintesteps23=CheckBox.new(~w,Rect(550,210,20,20)).action={|val|if(val.value,{~sinte.put(22,~chord=Synth(\acordesuno))},{~sinte.put(22,nil)})};
~sintesteps24=CheckBox.new(~w,Rect(570,210,20,20)).action={|val|if(val.value,{~sinte.put(23,~chord=Synth(\acordesuno))},{~sinte.put(23,nil)})};
~sintesteps25=CheckBox.new(~w,Rect(600,210,20,20)).action={|val|if(val.value,{~sinte.put(24,~chord=Synth(\acordesuno))},{~sinte.put(24,nil)})};
~sintesteps26=CheckBox.new(~w,Rect(620,210,20,20)).action={|val|if(val.value,{~sinte.put(25,~chord=Synth(\acordesuno))},{~sinte.put(25,nil)})};
~sintesteps27=CheckBox.new(~w,Rect(640,210,20,20)).action={|val|if(val.value,{~sinte.put(26,~chord=Synth(\acordesuno))},{~sinte.put(26,nil)})};
~sintesteps28=CheckBox.new(~w,Rect(660,210,20,20)).action={|val|if(val.value,{~sinte.put(27,~chord=Synth(\acordesuno))},{~sinte.put(27,nil)})};
~sintesteps29=CheckBox.new(~w,Rect(690,210,20,20)).action={|val|if(val.value,{~sinte.put(28,~chord=Synth(\acordesuno))},{~sinte.put(28,nil)})};
~sintesteps30=CheckBox.new(~w,Rect(710,210,20,20)).action={|val|if(val.value,{~sinte.put(29,~chord=Synth(\acordesuno))},{~sinte.put(29,nil)})};
~sintesteps31=CheckBox.new(~w,Rect(730,210,20,20)).action={|val|if(val.value,{~sinte.put(30,~chord=Synth(\acordesuno))},{~sinte.put(30,nil)})};
~sintesteps32=CheckBox.new(~w,Rect(750,210,20,20)).action={|val|if(val.value,{~sinte.put(31,~chord=Synth(\acordesuno))},{~sinte.put(31,nil)})};
//resetea secuencias sinte
~delsinte=Button(~w,Rect(765,212,15,15));
~delsinte.states=[[" X ",Color.black,Color.red]];
~delsinte.action={|val|if(val.value==0,{"Chords have been cleared!".postln;
										~sinte.put((0..31),nil);
										~sintesteps1.value=0;~sintesteps2.value=0;
										~sintesteps3.value=0;~sintesteps4.value=0;
										~sintesteps5.value=0;~sintesteps6.value=0;
										~sintesteps7.value=0;~sintesteps8.value=0;
										~sintesteps9.value=0;~sintesteps10.value=0;
										~sintesteps11.value=0;~sintesteps12.value=0;
										~sintesteps13.value=0;~sintesteps14.value=0;
										~sintesteps15.value=0;~sintesteps16.value=0;
										~sintesteps17.value=0;~sintesteps18.value=0;
										~sintesteps19.value=0;~sintesteps20.value=0;
										~sintesteps21.value=0;~sintesteps22.value=0;
										~sintesteps23.value=0;~sintesteps24.value=0;
										~sintesteps25.value=0;~sintesteps26.value=0;
										~sintesteps27.value=0;~sintesteps28.value=0;
										~sintesteps29.value=0;~sintesteps30.value=0;
										~sintesteps31.value=0;~sintesteps32.value=0;
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
