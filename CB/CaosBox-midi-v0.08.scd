///written by @joseCao5
//29 Jun 14
////////////////////////////////////
//
//MIDI connection for a controller
//based on the fx map of the CaosBox GUI
//
////////////////////////////////////
//
//
MIDIIn.connectAll;
//conexion al controlador
//
(
MIDIIn.control={|src,chan,num,val|
	[chan,num,val].postln; //num   synth    key de tu controlador
                  switch(num,12,{~mast.set(\vol,val.explin(0,127,0.01,1))},
                             24,{~mast.set(\clampTime,val.linlin(0,127,0.01,1))},
                             25,{~mast.set(\relaxTime,val.linlin(0,127,0.01,1))},
                             24,{~mast.set(\limit,val.linlin(0,127,0.01,1))},
                             34,{~mastrev.set(\mix,val.linlin(0,127,0,1))},
                             35,{~mastrev.set(\room,val.explin(0,127,0.01,1.3))},
		                     36,{~mastrev.set(\damp,val.linexp(0,127,1,0.01))}
                             )
                         }
)
//~mast=Synth(\master);
//~mastrev=Synth(\aux1);
//~mastdel=Synth(\aux2);
//~mastpit=Synth(\aux3);
//~mastlowf=Synth(\lowfilt);
//~masthighf=Synth(\highfilt);
//~mastbandf=Synth(\bandfilt);
//~grains=Synth(\granulador);                   