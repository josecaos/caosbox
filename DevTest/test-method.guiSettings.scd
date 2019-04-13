c = CaosBox;
c.enviroment();
c.enviroment(false);

c.play;
c.bpm(200);
c.freqAnalyzer(true);

h = CaosGear.new;
h.hihats();
h.toTrack(Array.series(16,0,2))


c.guiAlpha(0.5);
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