////////////////////////////////////////////////////////////
// CaosBox v2.6.6 - The API session
//
// Este es el código con el que josecaos toca el secuenciador desde el
// intérprete. Se guarda aquí como documentación y como prueba de regresión
// después de cada paso de la refactorización.
//
Platform.userExtensionDir
CaosBox.browse;
CaosBoxGUI.colorAliases // Colores posibles para interfaz
CaosBox.gui.color(\green); // Aplica color opcional para la GUI antes comenzar
//

c = CaosBox;
c.environment; //inicializa
// c.environment(false); //inicializa Headless
// Wait for GUI boot:
c.play;
c.pause;
c.stop;
c.bpm(18);
c.freqAnalyzer(true);
c.guiAlpha(0.5);
//
g = CaosGear;
// available options
g.waveforms;
g.chordVariants;
g.validChords(\chords);
g.validChords(\chords2);
//// Percussion synths
k = g.new;
k.kick();
k.kick(amp1: 1,amp2:1);
k.kick([50,64]);
k.toTrack([0,4,8,12,16,20,24,28], true);
c.tracks[\kick].flam([0,16],0.25,2);
c.tracks[\kick].removeFlam([0,16]);
k.kick(\master,0.01,0.5);
k.toTrack([0,14,15,16], false);
k.kick(\lpf,0.01,0.1);
k.toTrack(Array.series(32,0,1));
k.kick(\hpf,0.01,0.2);
k.toTrack(Array.series(16,1,2));
c.setSteps(\kick, Array.series(16,0,2), false);
c.tracks[\kick].flam([0,16],1,4)
c.tracks[\kick].flam([4,8],0.5,2)
c.tracks[\kick].removeFlam(8);
k.kick(50,0.01,0.5);
k.kick(\pitch,0.1,0.125);
k.offTrack();
c.repeater(\kick,[0,16],1);
c.repeater(\kick,[0,16],4);
c.tracks[\kick].repeater([4,18,20,22,24], 8, 1/2);
c.tracks[\kick].repeater([4,18,20,22,24], 4, 1/4);

h = g.new;
h.hihats();
h.hihats(\master,0.01,0.1,9820,0.5,1,1,0.25);
h.toTrack([0,4,8,12,16,20,24,28]+2, true);
c.tracks[\hihats].flam([0,8,12,20,28]+2,0.5,2);
c.tracks[\hihats].removeFlam([4,12,20,28]+2);
h.hihats([\reverb],att:0.01,rel:0.75,amp1:1);
h.hihats([\master,\reverb,\grains],att:0.01,rel:0.05,amp1:1);
h.toTrack([0,4,8,12,16,20,24,28], false);
h.offTrack();
c.setSteps(\hihats);

t = g.new;
t.snare();
t.snare(\master,0.01,0.015);
t.toTrack([0,8,16,24], true);
t.snare(60);
t.snare(60,0.01,0.125,136,0.125,1,0.25,0.125,[0.12,-0.12]);
t.toTrack(Array, true);
t.offTrack();
/// melodic synths
c.freqAnalyzer(true);
// melody degrees
m = g.new;
x = m.melody(LCNE.dupOctave(Scale.minor.degrees, 3), 48);

b = g.new;
b.bass(\hpf,[60,60,60,63,60,60,60,72]/2,seqType:\rand,att:0.015,rel:0.25,filtMaxFreq: 120,filtTime:0.25,amp1:0.25,amp2:0.025);
c.setSteps(\bass,Array.series(8,0,4));
b.bass(\master,x,\seq);
b.bass(\master,x/2,\rand,0.1,2,40,12920,0.01);
b.bass(\grains,x/2,\rand,0.1,2,40,12920,0.01);
b.offTrack();
c.route(\bass, \master);


e = g.new;
e.bass2(\master);
e.bass2(\lpf,x,\rand,0.5,1,0.5,40,12920,0.5);
c.setSteps(\bass2);

p = g.new;
p.pad(\reverb,x/2,\rand,\pulse,0.25,2,amp:0.01);
p.toTrack(Array.series(8,0,4));
p.offTrack([0,16]);
// g.waveforms;
p.updateTimbre(waveform: \pulse);

r = g.new;
r.pad2(\reverb,x/3,\rand,0.5,4,amp1:0.001,amp2:0.001);
r.toTrack(Array.series(8,2,4));
r.offTrack([0,16]);

v = g.new;
v.chords(\master,x,\rand,att:0.25,rel:3,amp:0.005);
v.toTrack(Array.series(4,0,8));
g.validChords(\chords); //print valid chords for the \chords instrument
v.chords(\master,x,\rand,[\M7,\m7,\mmaj7,\Mmaj7,'5aug7'],att:0.25,rel:2,amp:0.005);
v.chords(\master,[60,67],\seq, g.validChords(\chords),att:0.25,rel:4,amp:0.005);
v.offTrack([0,16]);
z = v.chords(\hpf,x,\rand,[\M7,\m7,\mmaj7,\Mmaj7,'5aug7'],att:1,rel:2,amp:0.005);
g.validChords(\chords);
z.updateTimbre(chord: 'M');
z.updateTimbre(chord: '5dim7');
z.updateTimbre(chord: '5aug7');

y = g.new;
y.chords2(\master,x/2,\rand,[\Mmaj7,\m,\M,\m],0.01,2,amp:0.05);
y.chords2(\reverb,x,\rand,[\Mmaj7,\m,\M,\m],0.01,4,amp:0.025);
y.toTrack(Array.series(8,2,4));
y.offTrack();

i = g.new;
i.lineIn(\master);
i.toTrack();
c.setSteps(\in);// opcion para agregar steps
i.offTrack;

c.autoFx(\hpf,true,\slow, Array.series(20,100,750), [0.5,0.35,0.5,0.75,0.9,1]);
c.autoFx(\lpf,true,\normal, Array.series(15,1000,500), [0.15,0.25,0.35,0.5,0.75,0.9,1]);
c.autoFx(\bpf,true,\normal, Array.series(15,1000,500), [0.15,0.25,0.35,0.5,0.75,0.9,1]);
c.autoFx(\grains,true,\normal, [1,0.95,0.9,0.85],[1,0.95,0.9,0.85]);
c.autoFx(\delay,true,\fast, [1,0.95,0.9,0.85]*0.1,[0.125,0.25,0.5,0.75,1]);
c.autoFx(\pitch,true,\slowest,[0.43,1, 0.45, 0.43],0,0);

c.bpm(20);
c.randomTime(true, true, [126/2,126]);
c.randomTime(true, true, [10,20,30,40,50,60,70,80,90,100]);
c.randomTime(false, false, [10,20,30,40,50,60,70,80,90,100]);
c.toggleMetric();

c.randPattern(\kick, density: 0.5);
c.randPattern(\kick, density: 0.35, every: 4);
c.stopRandPattern(\kick);
c.fill(\snare, density: 0.15);
c.fill(\hihats, density: 0.6, loops: 2);
//
c.restorePattern(\kick);
c.restorePattern(\snare);

// MIDI tests
c = CaosBox;
c.environment;

CaosBox.play;

CaosMIDI.devices;
CaosMIDI.connectOnly("USB X-Session");
//
CaosMIDI.detachOut(\bass);
CaosMIDI.attachOut(\kick, "CH345", 0, [28,36,38,39,41,43].choose);

CaosMIDI.detachOut(\kick);
CaosMIDI.attachOut(\bass, "CH345",0,velocity:127);
CaosMIDI.attachOut(\bass, "CH345", 0, [28,36,38,39,41,43].choose, 127);
//

CaosMIDI.attachOut(\bass, "CH345", 0); // nota actual
CaosMIDI.attachOut(\kick, "CH345", 0, note: 72);
CaosBox.stop; // panic
//
CaosMIDI.monitor(true);

c.stop;

c.browse;
c.version
c.prPauseAutomations
c.voices

