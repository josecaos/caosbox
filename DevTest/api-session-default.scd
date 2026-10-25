////////////////////////////////////////////////////////////
// CaosBox v2.1.0 - Acceptance fixture: the API session
//
// Este es el script con el que josecaos toca el secuenciador desde el
// intérprete. Se guarda aquí como documentación y como prueba de regresión
// después de cada paso de la refactorización.
//
////////////////////////////////////////////////////////////

c = CaosBox;
c.environment;
// espera arranque y GUI:
c.play;
c.guiAlpha(0.5);
c.bpm(60);

g = CaosGear;

//// Percussion synths
k = g.new;
k.kick();
k.toTrack([0,4,8,12,16,20,24,28], true);
k.kick(58,0.01,0.1);
k.toTrack([0,14,15,16], false);
k.kick(60,0.01,0.1);
k.toTrack(Array.series(32,0,1));
k.kick(62,0.01,0.2);
k.toTrack(Array.series(16,1,2));
k.kick(50,0.01,0.5);

h = g.new;
h.hihats();
h.toTrack([0,4,8,12,16,20,24,28]+2, true);
h.hihats([60,62],att:0.01,rel:0.05,amp1:1);
h.toTrack([0,4,8,12,16,20,24,28], false);

t = g.new;
t.snare();
t.toTrack([0,8,16,24], true);
t.snare(60);
t.toTrack([6,22], true);

/// melodic synths

// melody degrees
m = g.new;
x = m.melody(LCNE.dupOctave(Scale.minor.degrees, 3), 48);

b = g.new;
b.bass(62);
b.bass(62,seqType:\rand);
c.setSteps(\bass);
b.bass(50,x,\seq);
b.bass(60,x/2,\rand,0.1,2,40,12920,0.01);

e = g.new;
e.bass2(50);
e.bass2(58,x,\rand,0.5,1,0.5,40,12920,0.5);
c.setSteps(\bass2);

p = g.new;
p.pad(52,x/2,\rand,\pulse,0.25,2,amp:0.01);
p.toTrack(Array.series(8,0,4));
p.offTrack([0,16]);

r = g.new;
r.pad2(52,x/3,\rand,0.5,4,amp1:0.001,amp2:0.001);
r.toTrack(Array.series(8,2,4));
r.offTrack([0,16]);

v = g.new;
v.chords(50,x,\rand,att:0.25,rel:3,amp:0.005);
v.toTrack(Array.series(8,0,4));
v.offTrack([0,16]);

y = g.new;
y.chords2(50,x/2,\rand,[\Mmaj7,\m,\M,\m],0.01,2,amp:0.05);
y.toTrack(Array.series(8,2,4));
y.offTrack([0,16]);

i = g.new;
i.lineIn(50);
i.toTrack();
c.setSteps(\in);// opcion para agregar steps
i.offTrack;

c.autoFx(\hpf,true,\normal, Array.series(20,100,500), [0.15,0.25,0.35,0.5,0.75,0.9,1]);
c.autoFx(\bpf,true,\normal, Array.series(15,1000,500), [0.15,0.25,0.35,0.5,0.75,0.9,1]);

// ---------------------------------------------------------------
// Qué observar (checklist de aceptación)
// ---------------------------------------------------------------
// [ ] kick: pares con timbre de kick(60) por HPF, impares con kick(62) por BPF
// [ ] hihats alimentando HPF y BPF (out [60,62] escribe dos pares)
// [ ] snare sólo en 6 y 22 (el segundo toTrack reemplaza)
// [ ] pad sonando en 0 y 16: una voz nueva (nota siguiente) por trigger
// [ ] lineIn en los steps encendidos (requiere entrada de audio)
// [ ] autoFx(\hpf) y autoFx(\bpf) barriendo los buses 60-63
//
// Notas conocidas:
// - i.offTrack sin argumentos saca la pista completa (desde v2.1.1).
// - k.kick(50,...) al final no toca ningún paso: sólo define ~cbox_b para
//   los próximos toTrack.
