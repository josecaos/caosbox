//CaosBox GUI file 1 - v2.3.3 - ventana, transporte, bienvenida
(
~cbox_w=Window.new(("CaosBox v" ++ CaosBox.version ++ " Live Coding Machine for Algorave Music") + " Today is " + ~cbox_fecha,Rect.aboutPoint(Window.screenBounds.center,560,430),false).background=Color(0,0,0);//
//
// las filas de pistas (percs + melodicos + LineIn) las construye GUI/CaosBox-GUI_2.scd
// con la rejilla nueva (5b)

// tempo
StaticText(~cbox_w,Rect(16,805,275,15)).string_("Beat:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.65,0.65,0.65));
~cbox_botm=Button(~cbox_w,Rect(16,820,135,25));
// la etiqueta dice el modo que se aplica al apretar (no el que corre ahora)
~cbox_botm.states=[["Thirds",Color.white,Color.green(0.35)],
	["Fourths",Color.black,Color.green(0.35)]];
~cbox_botm.action={|val|
	CaosBox.stepDur(if(val.value == 0, { 0.25 }, { 1/3 }));
	("->" + if(val.value == 0, {"Fourths"}, {"Thirds"}) + "<-").inform;
};
//tempo aleatorio (mismo criterio: la etiqueta es lo que pasa al apretar)
~cbox_botr=Button(~cbox_w,Rect(156,820,135,25));
~cbox_botr.states=[["Random Time",Color.black,Color.green(0.35)],
	["Regular Time",Color.white,Color.green(0.35)]];
~cbox_botr.action={|val| CaosBox.randomTime(val.value == 1) };
//
//play
StaticText(~cbox_w,Rect(301,805,339,15)).string_("PLAY/PAUSE:").font_(Font("DejaVu Sans",14,true)).align_(\center).background_(Color(0.5,0.5,0.5));
~cbox_bot=Button(~cbox_w,Rect(301,820,339,25));
~cbox_bot.states=[["=>",Color.black,Color.green],
	["Pause",Color.white,Color.red]];
~cbox_bot.action={|val|
	// el boton pausa (y play reanuda donde iba); el stop duro es CaosBox.stop
	if(val.value == 0, { CaosBox.pause }, { CaosBox.play });
};
// BPM (contenedor completo del bloque y numeros con el acento global)
StaticText(~cbox_w,Rect(650,805,100,15)).string_("BPM:").font_(Font("DejaVu Sans",11,true)).align_(\center).stringColor_(CaosBox.gui.muted);
~cbox_numclock=NumberBox(~cbox_w,Rect(650,820,100,25)).background_(CaosBox.gui.panel).align_(\center);
~cbox_numclock.normalColor_(CaosBox.gui.accent);
~cbox_numclock.typingColor_(CaosBox.gui.accentText);
~cbox_numclock.value=126;
~cbox_numclock.action={ CaosBox.bpm(~cbox_numclock.value) };
CaosBox.gui.addColorListener({|g|
	~cbox_numclock !? {|num|
		num.background_(g.panel);
		num.normalColor_(g.accent);
		num.typingColor_(g.accentText);
	};
});

//scopes: ventana flotante con FFT + osciloscopio
StaticText(~cbox_w,Rect(760,805,110,15)).string_("SCOPES:").font_(Font("DejaVu Sans",11,true)).align_(\center).stringColor_(CaosBox.gui.muted);
~cbox_scopeBot=Button(~cbox_w,Rect(760,820,110,25));
~cbox_scopeBot.states=[["Scopes",CaosBox.gui.text,CaosBox.gui.panel]];
~cbox_scopeBot.action={ CaosBox.gui.toggleFreqAnalyzer };
//record
~cbox_filea=[~cbox_n.choose,~cbox_l.choose,~cbox_n.choose,~cbox_l.choose];
~cbox_filename=~cbox_filename.add(~cbox_filea.stutter((1..2).choose).scramble.join);
//
StaticText(~cbox_w,Rect(882,805,108,15)).string_("Recording").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.65,0.65,0.65));
~cbox_recbot=Button(~cbox_w,Rect(882,820,108,25));
~cbox_recbot.states=[["Record",Color.green,Color(alpha:0.25)],
	["Stop Recording",Color.white,Color.red]];
~cbox_recbot.action={|val|if(val.value==0,{s.stopRecording;
	"->Stoped Recording<-".inform;
	~cbox_filename=["c","a","o","s","b","o","x","_",~cbox_filea.join,~cbox_l.choose,~cbox_n.choose];
},
{s.record(~cbox_url +/+ "Recorded" +/+  ~cbox_ftype[0] ++ ~cbox_filename.value.join ++ "-" ++ ~cbox_fecha.dayStamp ++ "-" ++ ~cbox_numclock.value ++ "bpm.aiff");
	"->Recording<-".inform})
};
//Historial
StaticText(~cbox_w,Rect(1000,805,104,15)).string_("History:").font_(Font("Dejavu Sans",11,true)).align_(\center).background_(Color(0.75,0.75,0.75));
~cbox_hbutt=Button(~cbox_w,Rect(1000,820,104,25));
~cbox_hbutt.states=[[" Save File ",Color.green,Color(alpha:0.25)]];
~cbox_hbutt.action={|val| var h=History; if(val.value==0,{"->History saved @ caosbox/Histories folder<-".inform;
	h.saveStory(~cbox_url +/+ "Histories" +/+ ~cbox_ftype[1] ++ ~cbox_filename.value.join ++ ~cbox_fecha.dayStamp ++ ".scd");
	h.stop; h.clear})};
);
