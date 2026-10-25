(
c = CaosBox;
c.enviroment;
);
c.play;
c.bpm(60);
c.bpm(60*4);
c.bpm(60/2);
x = CaosGear.new;
x.bass2;
x.bass2(50,[0,2,4,5,7,9,11,12]+60);
x.toTrack(Array.series(16,0,2));
//
y = CaosGear.new;
y.bass;
y.bass([52]);
y.bass([52,54,56]);
y.toTrack(Array.series(32,0,1));
y.toTrack(Array.series(16,1,2),true);
//
z = CaosGear.new;
z.chords;
z.chords(52,seqType:\rand);
z.chords(56,seqType:\rand);
z.toTrack(Array.series(16,0,2));

c.openDefaults;

c.close;
//
[ 0, 2, 4, 5, 7, 9, 11 ]+48

Tdef(\bass).play
Tdef(\bass).stop