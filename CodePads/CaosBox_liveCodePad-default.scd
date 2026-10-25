////////////////////////////////////////////////////////////
// CaosBox v2.1.1 - liveCodePad por defecto
//
// Bloques para evaluar en vivo (Cmd+Enter en el SCIDE).
//
// Percusión: cada step guarda el timbre vigente al marcarlo (snapshot).
//            Volver a llamar a un método y hacer toTrack re-sella esos steps.
// Melódicos: cada trigger crea una voz nueva (CaosPercLib usa envolventes
//            percusivas); la nota avanza con el reloj y se lee al disparar.
//
// API: CaosBox (fachada), CaosGear (instrumentos), ~cbox_tracks (patrones).
////////////////////////////////////////////////////////////

// --- 1. arranque -------------------------------------------------
c = CaosBox;
c.environment;
c.play;
c.bpm(145);

// --- 2. melodías (arrays de notas) -------------------------------
~escala = CaosGear.new.melody([0, 3, 5, 7, 10], 60);
~escalaAncha = CaosGear.new.melody(Scale.minor.degrees, 48);

// --- 3. percusión ------------------------------------------------
k = CaosGear.new;
k.kick();
k.toTrack([0, 4, 8, 12, 16, 20, 24, 28], true);
k.kick(62, 0.01, 0.2);
k.toTrack([0, 14, 15, 16], false);// agrega y re-sella esos steps

t = CaosGear.new;
t.snare(60);
t.toTrack([4, 12, 20, 28], true);

h = CaosGear.new;
h.hihats();
h.toTrack(Array.series(32, 1, 2), true);// impares

// --- 4. melódicos (voz one-shot por trigger) ----------------------
b = CaosGear.new;
b.bass(50, ~escalaAncha, \seq, att: 0.01, rel: 0.4);
b.toTrack([0, 3, 6, 8, 11, 14]);

p = CaosGear.new;
p.pad(50, ~escala, \seq, att: 0.5, rel: 2, amp: 0.15);
p.toTrack([0, 8, 16, 24]);

ch = CaosGear.new;
ch.chords(50, ~escala, \seq, amp: 0.1);
ch.toTrack([2, 10, 18, 26]);

// --- 5. reemplazar un instrumento en caliente ---------------------
// entra en el siguiente trigger de su pista; la voz vieja se libera
p.pad(50, ~escala.reverse, \seq, att: 0.25, rel: 1, amp: 0.2);
ch.chords(50, [0, 4, 7, 11], \rand);

// --- 6. steps desde el intérprete ---------------------------------
c.setSteps(\kick, [0, 4, 8]);      // reemplaza el patrón
c.setSteps(\kick, [12], false);    // agrega sin borrar
c.clearSteps(\kick, [0]);          // apaga steps puntuales
c.randSteps(\kick, 6);             // seis steps al azar
c.clearSteps(\kick);               // apaga toda la pista
t.offTrack;                        // saca el snare de su pista

// --- 7. FX y automatización ---------------------------------------
c.fx(\reverb, 0.35, 0.6, 0.2);
c.fx(\delay, 0.25, 0.4);
c.autoFx(\hpf, true, \normal, Array.series(20, 100, 500), [0.2, 0.4, 0.7, 0.9]);
c.autoFx(\hpf, false);

// --- 8. apagar -----------------------------------------------------
c.stop;
c.close;// reinicia el server y libera todo
