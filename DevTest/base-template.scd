// Track 1 para split con Nsk8
c = CaosBox;
x = CaosSampler;
// setup
c.enviroment;
c.play();
c.freqAnalyzer(true);
c.bpm(115);
c.guiAlpha(0.5);
//instruments
g.CaosGear;
// step aregument instruments
//Kick
k = g.new;
k.kick();//add args
// snare
t = g.new;
t.snare();
//
// hihats
h = g.new;
h.hihats();
// Real time argument instruments
//Melody ::: Use Custom degrees
~melody_1 = m.melody(Scale.minor,48);// Use SC Scale library
~melody_1 = m.melody([0,3,6,9,10],48);//custom degrees
//Melody ::: Use LCNE library to duplicate Octaves ::: third party
~melody_extended = m.melody(LCNE.dupOctave(Scale.minor,3),48);
//Bass
b = g.new;
b.bass;
b.bass(50,~melody_extended);
//Bass2
~b2 = g.new;
~b2.bass2;
~b2.bass(50,~melody_extended);
//
// TODO: Continuar con los demas instrumentos