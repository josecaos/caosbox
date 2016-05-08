///written by @joseCao5
//29 Jun 14
////////////////////////////////////
//MIDI connection for a controller
//based on the fx map of the CaosBox GUI
//mapped to a XsessionPro m-audio
////////////////////////////////////
//Conecta a todos los dispositivos de entrada MIDI
MIDIIn.connectAll;
//
(
MIDIIn.control={|src,chan,num,val| /*[src,chan,num,val].postln;//[num].postln;*/
	switch(num,12,{~mast.set(\vol,val.linlin(0,127,0,1));{~mastfader.value_(val/127);~num.value_(val/127)}.defer},
               26,{~mast.set(\below,val.linlin(0,127,0.01,1));{~mastfader2.value_(val/127);~num2.value_(val/127)}.defer},
               25,{~mast.set(\relaxTime,val.linlin(0,127,0.01,1));{~mastfader3.value_(val/127);~num3.value_(val/127)}.defer},
               24,{~mast.set(\limit,val.linlin(0,127,0.01,1));{~mastfader4.value_(val/127);~num4.value_(val/127)}.defer},
               29,{~mastrev.set(\mix,val.linlin(0,127,0.01,1));{~auxrfader.value_(val/127);~numr.value_(val/127)}.defer},
               28,{~mastrev.set(\room,val.linlin(0,127,0.01,1.3));{~auxroomfader.value_(val/127);~numroom.value_(val/127)}.defer},
		       27,{~mastrev.set(\damp,val.linlin(0,127,1,0.01));{~auxdfader.value_(val/127);~numd.value_(val/127)}.defer},
			   11,{~mastdel.set(\delaytime,val.explin(0,127,0,1));{~auxtfader.value_(val/127);~numt.value_(val/127)}.defer},
		       14,{~mastdel.set(\delfeed,val.linlin(0,127,0,1));{~auxffader.value_(val/127);~numf.value_(val/127)}.defer},
               36,{~mastpit.set(\pitch,val.linlin(0,127,0.1,4));{~auxpfader.value_(val/127);~nump.value_(val/127)}.defer},
               35,{~mastpit.set(\pitchDispersion,val.linlin(0,127,0.01,1));{~auxpdfader.value_(val/127);~numpd.value_(val/127)}.defer},
               34,{~mastpit.set(\timeDispersion,val.linlin(0,127,0.01,1));{~auxtdfader.value_(val/127);~numtd.value_(val/127)}.defer},
		       33,{~mastlowf.set(\cutfreq,val.linexp(0,127,20,20000));{~lowcfader.value_(val/127);~numf1.value_(val*157.4811)}.defer},
			   32,{~mastbandf.set(\cutfreq,val.linexp(0,127,20,20000));{~bandcfader.value_(val/127);~numf5.value_(val*157.4811)}.defer},
		       31,{~masthighf.set(\cutfreq,val.linexp(0,127,20,20000));{~highcfader.value_(val/127);~numf3.value_(val*157.4811)}.defer},
		       20,{~grains.set(\trigger,val.linlin(0,127,0.1,8));{~gfaders.x_(val/127)}.defer},
		       17,{~grains.set(\size,val.linlin(0,127,1,0.01));{~gfaders.y_(val/127)}.defer},
		       15,{~grains.set(\size,val.linlin(0,127,-1,-0.01));~grains.set(\trigger,val.linlin(0,127,-1,-0.01));
			             {~gfaders.y_(val/127);~gfaders.x_(val/127)}.defer
		           }
               )
            };
);
20000/127