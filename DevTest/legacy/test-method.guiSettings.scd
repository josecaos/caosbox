c = CaosBox;
c.enviroment();
c.enviroment(false);//start without gui

c.play;
c.bpm(200);
c.freqAnalyzer(true);

h = CaosGear.new;
h.hihats();
h.hihats(amp1:1, amp2:1);
h.hihats(amp1:0.25, amp2:0.25);
h.toTrack(Array.series(16,0,2))
h.toTrack(Array.series(8,0,4))

c.guiAlpha(0.5);
c.guiState(false);
c.guiState(true)

//Deprecated method
// c.guiSettings;
// c.guiSettings(0.4,false);
// c.guiSettings(visibility:true);
// c.guiSettings(0.2,visibility:false);

Window.browse
Window.allWindows
~w.visible
~w.alpha_(0.6);
~w.fullScreen(true)
~w.userCanClose_(false);
~w.close;
~w.front;
~w.isClosed
~w.fullScreen()
~w.endFullScreen()