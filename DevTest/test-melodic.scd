(
~tonality = {

}
~melodic_intervals = {

}
~arpeggio = {

}
);

//
s.boot;
Scale.directory;
Tuning.directory;
t = Tuning.young;
t.semitones;
t.size;
t.ratios;

~arp = Pbind(\scale, Scale.major(t), \degree, Pseq((0..19) ++ (18..0) ++ [\rest], inf), \dur, 0.1);
~arp.play;
~arp.stop;

(
a = Pbind(\x, Pseq([1, 2, 3],inf), \y, Prand([100, 300, 200], inf), \zzz, 99);
x = a.asStream;
)

x.next(()); // pass in an event ()

//

a = {Scale.directory.find([Scale.iraq])};
a = {Scale.directory};
a.value;

x = {Scale.iraq.degrees(Tuning.et(12))};
x.value;