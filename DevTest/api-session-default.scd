////////////////////////////////////////////////////////////
// CaosBox v2.1.0 - Acceptance fixture: the API session
//
// Este es el script con el que josecaos toca el secuenciador desde el
// intérprete. Se guarda aquí como documentación y como prueba de regresión
// después de cada paso de la refactorización.
//
// Cómo usarlo: pegarlo de arriba a abajo en el SCIDE (con el servidor y la
// compilación ya listos). Ejercita:
//   - percusión estática construida reevaluando instrumentos + toTrack(..., false)
//   - el kit resultante: pasos pares por el bus 60 (HPF), impares por 62 (BPF)
//   - pistas melódicas (pad) con gate por step
//   - line in, y automatización de HPF y BPF
//
// Al agregar/cambiar cosas del API, actualizar este archivo también.
////////////////////////////////////////////////////////////

c = CaosBox
c.environment

c.play;
c.guiAlpha(0.5);
c.bpm(145);

g = CaosGear;

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

p = g.new;
p.pad(50,amp:0.1);
p.toTrack([0,16]);

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
// [ ] pad sonando en 0 y 16 — TODO: revisar la iteración de notas (paso 2)
// [ ] lineIn en los steps encendidos (requiere entrada de audio)
// [ ] autoFx(\hpf) y autoFx(\bpf) barriendo los buses 60-63
//
// Notas conocidas:
// - i.offTrack sin argumentos sólo apaga el step 0 (offTrack steps=0).
// - k.kick(50,...) al final no toca ningún paso: sólo define ~cbox_b para
//   los próximos toTrack.
