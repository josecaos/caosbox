(//CaosBox GUI v0.08 - percusiones, botones de contrl, bienvenida
~w=Window.new("CaosBox v0.08 #liveCodingMachine for Algorave music by @joseCao5",Rect.aboutPoint(Window.screenBounds.center,512,340),false).front.background=Color(0,0,0);//
~t1=StaticText(~w,Rect(5,12,53,15));//track1
~t1.string_("Bombo:").align_(\left).background_(Color(0.85,0.85,0.85));
//bombo steps
~bsteps1=CheckBox.new(~w,Rect(60,10,20,20)).action={|val|if(val.value,{~bombo.put(0,~b)},{~bombo.put(0,nil)})};
~bsteps2=CheckBox.new(~w,Rect(80,10,20,20)).action={|val|if(val.value,{~bombo.put(1,~b)},{~bombo.put(1,nil)})};
~bsteps3=CheckBox.new(~w,Rect(100,10,20,20)).action={|val|if(val.value,{~bombo.put(2,~b)},{~bombo.put(2,nil)})};
~bsteps4=CheckBox.new(~w,Rect(120,10,20,20)).action={|val|if(val.value,{~bombo.put(3,~b)},{~bombo.put(3,nil)})};
~bsteps5=CheckBox.new(~w,Rect(150,10,20,20)).action={|val|if(val.value,{~bombo.put(4,~b)},{~bombo.put(4,nil)})};
~bsteps6=CheckBox.new(~w,Rect(170,10,20,20)).action={|val|if(val.value,{~bombo.put(5,~b)},{~bombo.put(5,nil)})};
~bsteps7=CheckBox.new(~w,Rect(190,10,20,20)).action={|val|if(val.value,{~bombo.put(6,~b)},{~bombo.put(6,nil)})};
~bsteps8=CheckBox.new(~w,Rect(210,10,20,20)).action={|val|if(val.value,{~bombo.put(7,~b)},{~bombo.put(7,nil)})};
~bsteps9=CheckBox.new(~w,Rect(240,10,20,20)).action={|val|if(val.value,{~bombo.put(8,~b)},{~bombo.put(8,nil)})};
~bsteps10=CheckBox.new(~w,Rect(260,10,20,20)).action={|val|if(val.value,{~bombo.put(9,~b)},{~bombo.put(9,nil)})};
~bsteps11=CheckBox.new(~w,Rect(280,10,20,20)).action={|val|if(val.value,{~bombo.put(10,~b)},{~bombo.put(10,nil)})};
~bsteps12=CheckBox.new(~w,Rect(300,10,20,20)).action={|val|if(val.value,{~bombo.put(11,~b)},{~bombo.put(11,nil)})};
~bsteps13=CheckBox.new(~w,Rect(330,10,20,20)).action={|val|if(val.value,{~bombo.put(12,~b)},{~bombo.put(12,nil)})};
~bsteps14=CheckBox.new(~w,Rect(350,10,20,20)).action={|val|if(val.value,{~bombo.put(13,~b)},{~bombo.put(13,nil)})};
~bsteps15=CheckBox.new(~w,Rect(370,10,20,20)).action={|val|if(val.value,{~bombo.put(14,~b)},{~bombo.put(14,nil)})};
~bsteps16=CheckBox.new(~w,Rect(390,10,20,20)).action={|val|if(val.value,{~bombo.put(15,~b)},{~bombo.put(15,nil)})};
~bsteps17=CheckBox.new(~w,Rect(420,10,20,20)).action={|val|if(val.value,{~bombo.put(16,~b)},{~bombo.put(16,nil)})};
~bsteps18=CheckBox.new(~w,Rect(440,10,20,20)).action={|val|if(val.value,{~bombo.put(17,~b)},{~bombo.put(17,nil)})};
~bsteps19=CheckBox.new(~w,Rect(460,10,20,20)).action={|val|if(val.value,{~bombo.put(18,~b)},{~bombo.put(18,nil)})};
~bsteps20=CheckBox.new(~w,Rect(480,10,20,20)).action={|val|if(val.value,{~bombo.put(19,~b)},{~bombo.put(19,nil)})};
~bsteps21=CheckBox.new(~w,Rect(510,10,20,20)).action={|val|if(val.value,{~bombo.put(20,~b)},{~bombo.put(20,nil)})};
~bsteps22=CheckBox.new(~w,Rect(530,10,20,20)).action={|val|if(val.value,{~bombo.put(21,~b)},{~bombo.put(21,nil)})};
~bsteps23=CheckBox.new(~w,Rect(550,10,20,20)).action={|val|if(val.value,{~bombo.put(22,~b)},{~bombo.put(22,nil)})};
~bsteps24=CheckBox.new(~w,Rect(570,10,20,20)).action={|val|if(val.value,{~bombo.put(23,~b)},{~bombo.put(23,nil)})};
~bsteps25=CheckBox.new(~w,Rect(600,10,20,20)).action={|val|if(val.value,{~bombo.put(24,~b)},{~bombo.put(24,nil)})};
~bsteps26=CheckBox.new(~w,Rect(620,10,20,20)).action={|val|if(val.value,{~bombo.put(25,~b)},{~bombo.put(25,nil)})};
~bsteps27=CheckBox.new(~w,Rect(640,10,20,20)).action={|val|if(val.value,{~bombo.put(26,~b)},{~bombo.put(26,nil)})};
~bsteps28=CheckBox.new(~w,Rect(660,10,20,20)).action={|val|if(val.value,{~bombo.put(27,~b)},{~bombo.put(27,nil)})};
~bsteps29=CheckBox.new(~w,Rect(690,10,20,20)).action={|val|if(val.value,{~bombo.put(28,~b)},{~bombo.put(28,nil)})};
~bsteps30=CheckBox.new(~w,Rect(710,10,20,20)).action={|val|if(val.value,{~bombo.put(29,~b)},{~bombo.put(29,nil)})};
~bsteps31=CheckBox.new(~w,Rect(730,10,20,20)).action={|val|if(val.value,{~bombo.put(30,~b)},{~bombo.put(30,nil)})};
~bsteps32=CheckBox.new(~w,Rect(750,10,20,20)).action={|val|if(val.value,{~bombo.put(31,~b)},{~bombo.put(31,nil)})};			
//resetea secuencias bombo
~delbombo=Button(~w,Rect(765,12,15,15));
~delbombo.states=[[" X ",Color.black,Color.red]];
~delbombo.action={|val|if(val.value==0,{"Kick have been cleared!".postln;
										~bombo.put((0..31),nil);
										~bsteps1.value=0;~bsteps2.value=0;
										~bsteps3.value=0;~bsteps4.value=0;
										~bsteps5.value=0;~bsteps6.value=0;
										~bsteps7.value=0;~bsteps8.value=0;
										~bsteps9.value=0;~bsteps10.value=0;
										~bsteps11.value=0;~bsteps12.value=0;
										~bsteps13.value=0;~bsteps14.value=0;
										~bsteps15.value=0;~bsteps16.value=0;
										~bsteps17.value=0;~bsteps18.value=0;
										~bsteps19.value=0;~bsteps20.value=0;
										~bsteps21.value=0;~bsteps22.value=0;
										~bsteps23.value=0;~bsteps24.value=0;
										~bsteps25.value=0;~bsteps26.value=0;
										~bsteps27.value=0;~bsteps28.value=0;
										~bsteps29.value=0;~bsteps30.value=0;
										~bsteps31.value=0;~bsteps32.value=0;
										})};
//tarola steps
~t2=StaticText(~w,Rect(5,32,53,15));//track2
~t2.string_("Tarola:").align_(\left).background_(Color(0.85,0.85,0.85));
~tsteps1=CheckBox.new(~w,Rect(60,30,20,20)).action={|val|if(val.value,{~tarola.put(0,~t)},{~tarola.put(0,nil)})};
~tsteps2=CheckBox.new(~w,Rect(80,30,20,20)).action={|val|if(val.value,{~tarola.put(1,~t)},{~tarola.put(1,nil)})};
~tsteps3=CheckBox.new(~w,Rect(100,30,20,20)).action={|val|if(val.value,{~tarola.put(2,~t)},{~tarola.put(2,nil)})};
~tsteps4=CheckBox.new(~w,Rect(120,30,20,20)).action={|val|if(val.value,{~tarola.put(3,~t)},{~tarola.put(3,nil)})};
~tsteps5=CheckBox.new(~w,Rect(150,30,20,20)).action={|val|if(val.value,{~tarola.put(4,~t)},{~tarola.put(4,nil)})};
~tsteps6=CheckBox.new(~w,Rect(170,30,20,20)).action={|val|if(val.value,{~tarola.put(5,~t)},{~tarola.put(5,nil)})};
~tsteps7=CheckBox.new(~w,Rect(190,30,20,20)).action={|val|if(val.value,{~tarola.put(6,~t)},{~tarola.put(6,nil)})};
~tsteps8=CheckBox.new(~w,Rect(210,30,20,20)).action={|val|if(val.value,{~tarola.put(7,~t)},{~tarola.put(7,nil)})};
~tsteps9=CheckBox.new(~w,Rect(240,30,20,20)).action={|val|if(val.value,{~tarola.put(8,~t)},{~tarola.put(8,nil)})};
~tsteps10=CheckBox.new(~w,Rect(260,30,20,20)).action={|val|if(val.value,{~tarola.put(9,~t)},{~tarolao.put(9,nil)})};
~tsteps11=CheckBox.new(~w,Rect(280,30,20,20)).action={|val|if(val.value,{~tarola.put(10,~t)},{~tarola.put(10,nil)})};
~tsteps12=CheckBox.new(~w,Rect(300,30,20,20)).action={|val|if(val.value,{~tarola.put(11,~t)},{~tarola.put(11,nil)})};
~tsteps13=CheckBox.new(~w,Rect(330,30,20,20)).action={|val|if(val.value,{~tarola.put(12,~t)},{~tarola.put(12,nil)})};
~tsteps14=CheckBox.new(~w,Rect(350,30,20,20)).action={|val|if(val.value,{~tarola.put(13,~t)},{~tarola.put(13,nil)})};
~tsteps15=CheckBox.new(~w,Rect(370,30,20,20)).action={|val|if(val.value,{~tarola.put(14,~t)},{~tarola.put(14,nil)})};
~tsteps16=CheckBox.new(~w,Rect(390,30,20,20)).action={|val|if(val.value,{~tarola.put(15,~t)},{~tarola.put(15,nil)})};
~tsteps17=CheckBox.new(~w,Rect(420,30,20,20)).action={|val|if(val.value,{~tarola.put(16,~t)},{~tarola.put(16,nil)})};
~tsteps18=CheckBox.new(~w,Rect(440,30,20,20)).action={|val|if(val.value,{~tarola.put(17,~t)},{~tarola.put(17,nil)})};
~tsteps19=CheckBox.new(~w,Rect(460,30,20,20)).action={|val|if(val.value,{~tarola.put(18,~t)},{~tarola.put(18,nil)})};
~tsteps20=CheckBox.new(~w,Rect(480,30,20,20)).action={|val|if(val.value,{~tarola.put(19,~t)},{~tarola.put(19,nil)})};
~tsteps21=CheckBox.new(~w,Rect(510,30,20,20)).action={|val|if(val.value,{~tarola.put(20,~t)},{~tarola.put(20,nil)})};
~tsteps22=CheckBox.new(~w,Rect(530,30,20,20)).action={|val|if(val.value,{~tarola.put(21,~t)},{~tarola.put(21,nil)})};
~tsteps23=CheckBox.new(~w,Rect(550,30,20,20)).action={|val|if(val.value,{~tarola.put(22,~t)},{~tarola.put(22,nil)})};
~tsteps24=CheckBox.new(~w,Rect(570,30,20,20)).action={|val|if(val.value,{~tarola.put(23,~t)},{~tarola.put(23,nil)})};
~tsteps25=CheckBox.new(~w,Rect(600,30,20,20)).action={|val|if(val.value,{~tarola.put(24,~t)},{~tarola.put(24,nil)})};
~tsteps26=CheckBox.new(~w,Rect(620,30,20,20)).action={|val|if(val.value,{~tarola.put(25,~t)},{~tarola.put(25,nil)})};
~tsteps27=CheckBox.new(~w,Rect(640,30,20,20)).action={|val|if(val.value,{~tarola.put(26,~t)},{~tarola.put(26,nil)})};
~tsteps28=CheckBox.new(~w,Rect(660,30,20,20)).action={|val|if(val.value,{~tarola.put(27,~t)},{~tarola.put(27,nil)})};
~tsteps29=CheckBox.new(~w,Rect(690,30,20,20)).action={|val|if(val.value,{~tarola.put(28,~t)},{~tarola.put(28,nil)})};
~tsteps30=CheckBox.new(~w,Rect(710,30,20,20)).action={|val|if(val.value,{~tarola.put(29,~t)},{~tarola.put(29,nil)})};
~tsteps31=CheckBox.new(~w,Rect(730,30,20,20)).action={|val|if(val.value,{~tarola.put(30,~t)},{~tarola.put(30,nil)})};
~tsteps32=CheckBox.new(~w,Rect(750,30,20,20)).action={|val|if(val.value,{~tarola.put(31,~t)},{~tarola.put(31,nil)})};
//resetea secuencias tarola
~deltarola=Button(~w,Rect(765,32,15,15));
~deltarola.states=[[" X ",Color.black,Color.red]];
~deltarola.action={|val|if(val.value==0,{"Snare have been cleared!".postln;
										~tarola.put((0..31),nil);
										~tsteps1.value=0;~tsteps2.value=0;
										~tsteps3.value=0;~tsteps4.value=0;
										~tsteps5.value=0;~tsteps6.value=0;
										~tsteps7.value=0;~tsteps8.value=0;
										~tsteps9.value=0;~tsteps10.value=0;
										~tsteps11.value=0;~tsteps12.value=0;
										~tsteps13.value=0;~tsteps14.value=0;
										~tsteps15.value=0;~tsteps16.value=0;
										~tsteps17.value=0;~tsteps18.value=0;
										~tsteps19.value=0;~tsteps20.value=0;
										~tsteps21.value=0;~tsteps22.value=0;
										~tsteps23.value=0;~tsteps24.value=0;
										~tsteps25.value=0;~tsteps26.value=0;
										~tsteps27.value=0;~tsteps28.value=0;
										~tsteps29.value=0;~tsteps30.value=0;
										~tsteps31.value=0;~tsteps32.value=0;
										})};
//contratiempos
~t3=StaticText(~w,Rect(5,52,53,15));//track3
~t3.string_("HiHats:").align_(\left).background_(Color(0.85,0.85,0.85));
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
~t4=StaticText(~w,Rect(5,72,53,15));//track4
~t4.string_("bombo2:").align_(\left).background_(Color(0.85,0.85,0.85));
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
~t5=StaticText(~w,Rect(5,92,53,15));//track5
~t5.string_("tarola2:").align_(\left).background_(Color(0.85,0.85,0.85));
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
~t6=StaticText(~w,Rect(5,112,53,15));//track6
~t6.string_("HiHats2:").align_(\left).background_(Color(0.85,0.85,0.85));
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
~bot.action={|val|if(val.value==0,{Tdef(\secuencias).stop;Tdef(\pasos).stop;Tdef(\autor).stop;Tdef(\autod).stop;Tdef(\autop).stop;
										Tdef(\autog).stop;Tdef(\bass).stop;Tdef(\bass2).stop;~autobotr.value=0;~autobotd.value=0;
												~autobotp.value=0;~autobotg.value=0;~bott.value=0;"->You just Stopped caosBox<-".postcln},
        							{Tdef(\bass).play;Tdef(\bass2).play;Tdef(\secuencias).play;Tdef(\pasos).play;
        								"->Playing, please start LiveCoding<-".postcln})};
//record
StaticText(~w,Rect(790,635,130,15)).string_("REC/STOP REC:").align_(\center).background_(Color(0.65,0.65,0.65));
~recbot=Button(~w,Rect(790,650,130,25));
~recbot.states=[["record",Color.black,Color.green(0.35)],
        ["Stop recording",Color.white,Color.red]];
~recbot.action={|val|if(val.value==0,{s.stopRecording;"->Stoped Recording<-".postln},
        							{s.record;"->Recording<-".postcln})};
//borrar secuencias de percusiones
StaticText(~w,Rect(920,635,99,20)).string_("Clear Percs:").align_(\center).background_(Color(0.75,0.75,0.75));
~delsec=Button(~w,Rect(920,650,99,25));
~delsec.states=[[" X ",Color.green,Color.black]];
~delsec.action={|val|if(val.value==0,{"Percussions have been cleared!".postln;
									~bombo.put((0..31),nil);
									~tarola.put((0..31),nil);
									~contras.put((0..31),nil);
									~bombo2.put((0..31),nil);
									~tarola2.put((0..31),nil);
									~contras2.put((0..31),nil);										
									~bsteps1.value=0;~tsteps1.value=0;~hsteps1.value=0;~b2steps1.value=0;~t2steps1.value=0;~h2steps1.value=0;
~bsteps2.value=0;~tsteps2.value=0;~hsteps2.value=0;~b2steps2.value=0;~t2steps2.value=0;~h2steps2.value=0;
~bsteps3.value=0;~tsteps3.value=0;~hsteps3.value=0;~b2steps3.value=0;~t2steps3.value=0;~h2steps3.value=0;
~bsteps4.value=0;~tsteps4.value=0;~hsteps4.value=0;~b2steps4.value=0;~t2steps4.value=0;~h2steps4.value=0;
~bsteps5.value=0;~tsteps5.value=0;~hsteps5.value=0;~b2steps5.value=0;~t2steps5.value=0;~h2steps5.value=0;
~bsteps6.value=0;~tsteps6.value=0;~hsteps6.value=0;~b2steps6.value=0;~t2steps6.value=0;~h2steps6.value=0;
~bsteps7.value=0;~tsteps7.value=0;~hsteps7.value=0;~b2steps7.value=0;~t2steps7.value=0;~h2steps7.value=0;
~bsteps8.value=0;~tsteps8.value=0;~hsteps8.value=0;~b2steps8.value=0;~t2steps8.value=0;~h2steps8.value=0;
~bsteps9.value=0;~tsteps9.value=0;~hsteps9.value=0;~b2steps9.value=0;~t2steps9.value=0;~h2steps9.value=0;
~bsteps10.value=0;~tsteps10.value=0;~hsteps10.value=0;~b2steps10.value=0;~t2steps10.value=0;~h2steps10.value=0;
~bsteps11.value=0;~tsteps11.value=0;~hsteps11.value=0;~b2steps11.value=0;~t2steps11.value=0;~h2steps11.value=0;
~bsteps12.value=0;~tsteps12.value=0;~hsteps12.value=0;~b2steps12.value=0;~t2steps12.value=0;~h2steps12.value=0;
~bsteps13.value=0;~tsteps13.value=0;~hsteps13.value=0;~b2steps13.value=0;~t2steps13.value=0;~h2steps13.value=0;
~bsteps14.value=0;~tsteps14.value=0;~hsteps14.value=0;~b2steps14.value=0;~t2steps14.value=0;~h2steps14.value=0;
~bsteps15.value=0;~tsteps15.value=0;~hsteps15.value=0;~b2steps15.value=0;~t2steps15.value=0;~h2steps15.value=0;
~bsteps16.value=0;~tsteps16.value=0;~hsteps16.value=0;~b2steps16.value=0;~t2steps16.value=0;~h2steps16.value=0;									
~bsteps17.value=0;~tsteps17.value=0;~hsteps17.value=0;~b2steps17.value=0;~t2steps17.value=0;~h2steps17.value=0;
~bsteps18.value=0;~tsteps18.value=0;~hsteps18.value=0;~b2steps18.value=0;~t2steps18.value=0;~h2steps18.value=0;
~bsteps19.value=0;~tsteps19.value=0;~hsteps19.value=0;~b2steps19.value=0;~t2steps19.value=0;~h2steps19.value=0;
~bsteps20.value=0;~tsteps20.value=0;~hsteps20.value=0;~b2steps20.value=0;~t2steps20.value=0;~h2steps20.value=0;
~bsteps21.value=0;~tsteps21.value=0;~hsteps21.value=0;~b2steps21.value=0;~t2steps21.value=0;~h2steps21.value=0;
~bsteps22.value=0;~tsteps22.value=0;~hsteps22.value=0;~b2steps22.value=0;~t2steps22.value=0;~h2steps22.value=0;
~bsteps23.value=0;~tsteps23.value=0;~hsteps23.value=0;~b2steps23.value=0;~t2steps23.value=0;~h2steps23.value=0;
~bsteps24.value=0;~tsteps24.value=0;~hsteps24.value=0;~b2steps24.value=0;~t2steps24.value=0;~h2steps24.value=0;
~bsteps25.value=0;~tsteps25.value=0;~hsteps25.value=0;~b2steps25.value=0;~t2steps25.value=0;~h2steps25.value=0;	
~bsteps26.value=0;~tsteps26.value=0;~hsteps26.value=0;~b2steps26.value=0;~t2steps26.value=0;~h2steps26.value=0;
~bsteps27.value=0;~tsteps27.value=0;~hsteps27.value=0;~b2steps27.value=0;~t2steps27.value=0;~h2steps27.value=0;
~bsteps28.value=0;~tsteps28.value=0;~hsteps28.value=0;~b2steps28.value=0;~t2steps28.value=0;~h2steps28.value=0;
~bsteps29.value=0;~tsteps29.value=0;~hsteps29.value=0;~b2steps29.value=0;~t2steps29.value=0;~h2steps29.value=0;
~bsteps30.value=0;~tsteps30.value=0;~hsteps30.value=0;~b2steps30.value=0;~t2steps30.value=0;~h2steps30.value=0;
~bsteps31.value=0;~tsteps31.value=0;~hsteps31.value=0;~b2steps31.value=0;~t2steps31.value=0;~h2steps31.value=0;
~bsteps32.value=0;~tsteps32.value=0;~hsteps32.value=0;~b2steps32.value=0;~t2steps32.value=0;~h2steps32.value=0;									})};
//
(//Bienvenida
Task({|i|	
	var izq="x", der="+",crece=Array.new(32);
	var creseq=Pseq([0,1],31).asStream;
	i=0;
		1.do{nil;3.wait};
		31.do{ 
					if(i>=0,{crece.add(if(creseq.next==1,{izq},{der}));
							 crece.postln;
							 "CaosBox v0.08".rotate(i-5).postln});
				i=i+1;
				0.125.wait;
			 }; 
		1.do{crece.add(izq);crece.postln;"CaosBox v0.08".postln;0.01.wait};
		1.do{"Bienvenido/Welcome.".postln;
				play{
				var noise=[LFNoise0,LFNoise1,LFNoise2].choose;
				var linea=[XLine,Line].choose;
				EnvGen.ar(Env.perc(0.02,5),doneAction:2)*
				FreeVerb.ar(
					RHPF.ar(
						LFPulse.ar([{XLine.ar(120.10760.rand,10760.140.rand,rrand(1,8))}.dup(4),
							Phasor.kr(Impulse.kr(rrand(1,16)),1,119.10760.rand,120.10760.rand)],
								rrand(0.01,0.5),rrand(0.1,0.5),0.5)*
						noise.ar(2.32.rand),linea.ar(rrand(60,10760),rrand(10760,60),0.5),rrand(0.15,0.5)),
					linea.kr(0.01,0.5,2),1,0.025)!2};
					5.wait;};
		1.do{"CaosBox es una Maquina para hacer liveCoding con la CaosPercLib. \n"
				"CaosBox is an algorave liveCoding Machine for CaosPercLib.".postln;1.wait};
		1.do{"escrito/written: @joseCao5 web: http://www.mixfuckedup.net".postln;1.wait};
		1.do{"abierto/opened: CaosBox liveCodePad v008.scd".postln;0.25.wait}
		}).play;
);
);
