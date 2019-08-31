////////////////////////////////////
//MIDI connection for a controller
//based on the fx map of the CaosBox GUI
//Default: mapped to a XsessionPro m-audio
////////////////////////////////////
//All MIDI inputs
MIDIIn.connectAll;
//
(
MIDIIn.control={|src,chan,num,val|
	switch(num,12,{~cbox_mast.set(\vol,val.linlin(0,127,0,1));{~cbox_mastfader.value_(val/127);~cbox_num.value_(val/127)}.defer},
		26,{~cbox_mast.set(\below,val.linlin(0,127,0.01,1));{~cbox_mastfader2.value_(val/127);~cbox_num2.value_(val/127)}.defer},
		25,{~cbox_mast.set(\relaxTime,val.linlin(0,127,0.01,1));{~cbox_mastfader3.value_(val/127);~cbox_num3.value_(val/127)}.defer},
		24,{~cbox_mast.set(\limit,val.linlin(0,127,0.01,1));{~cbox_mastfader4.value_(val/127);~cbox_num4.value_(val/127)}.defer},
		29,{~cbox_mastrev.set(\mix,val.linlin(0,127,0.01,1));{~cbox_auxrfader.value_(val/127);~cbox_numr.value_(val/127)}.defer},
		28,{~cbox_mastrev.set(\room,val.linlin(0,127,0.01,1.3));{~cbox_auxroomfader.value_(val/127);~cbox_numroom.value_(val/127)}.defer},
		27,{~cbox_mastrev.set(\damp,val.linlin(0,127,1,0.01));{~cbox_auxdfader.value_(val/127);~cbox_numd.value_(val/127)}.defer},
		11,{~cbox_mastdel.set(\delaytime,val.linlin(0,127,0,1));{~cbox_auxtfader.value_(val/127);~cbox_numt.value_(val/127)}.defer},
		14,{~cbox_mastdel.set(\delfeed,val.linlin(0,127,0,1));{~cbox_auxffader.value_(val/127);~cbox_numf.value_(val/127)}.defer},
		36,{~cbox_mastpit.set(\pitch,val.linlin(0,127,0.01,4));{~cbox_auxpfader.value_(val/127);~cbox_nump.value_(val/127)}.defer},
		35,{~cbox_mastpit.set(\pitchDispersion,val.linlin(0,127,0.01,1));{~cbox_auxpdfader.value_(val/127);~cbox_numpd.value_(val/127)}.defer},
		34,{~cbox_mastpit.set(\timeDispersion,val.linlin(0,127,0.01,1));{~cbox_auxtdfader.value_(val/127);~cbox_numtd.value_(val/127)}.defer},
		33,{~cbox_mastlowf.set(\cutfreq,val.linexp(0,127,20,20000));{~cbox_lowcfader.value_(val/127);~cbox_numf1.value_(val*157.4811)}.defer},
		32,{~cbox_mastbandf.set(\cutfreq,val.linexp(0,127,20,20000));{~cbox_bandcfader.value_(val/127);~cbox_numf5.value_(val*157.4811)}.defer},
		31,{~cbox_masthighf.set(\cutfreq,val.linexp(0,127,20,20000));{~cbox_highcfader.value_(val/127);~cbox_numf3.value_(val*157.4811)}.defer},
		20,{~cbox_grains.set(\trigger,val.linlin(0,127,0.1,8));{~cbox_gfaders.x_(val/127)}.defer},
		17,{~cbox_grains.set(\size,val.linlin(0,127,1,0.01));{~cbox_gfaders.y_(val/127)}.defer},
		15,{~cbox_grains.set(\size,val.linlin(0,127,-1,-0.01));~cbox_grains.set(\trigger,val.linlin(0,127,-1,-0.01));{~cbox_gfaders.y_(val/127);~cbox_gfaders.x_(val/127)}.defer
		}
	)
};
);