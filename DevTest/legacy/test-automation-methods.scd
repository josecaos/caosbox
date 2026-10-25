c = CaosBox;
c.enviroment;

c.play;
c.bpm(115);
// Automation test
z = [0,0.1,0.2,0.3,0.4,0.5,0.6];
c.auto(\reverb,true,\fast,z,z,z);
c.auto(\reverb,false);
c.auto(\reverb);
//
t = [0,0.1,0.2,0.3,0.4,0.5,0.6];
f = [0.1,2,3,4];
c.auto(\delay,true,\slow,t,f);
c.auto(\delay,false);
//
p = [0,0.1,0.2,0.3,0.4,0.5,0.6];
c.auto(\pitch,true,\fast,p,p,p);
c.auto(\pitch,false);
//
g = [0,0.1,0.2,0.3,0.4,0.5,0.6];
h = [0,0.1,0.2,0.3,0.4,0.5,0.6];
c.auto(\grains,true,\fast,g,h);
c.auto(\grains,false);

//
c.stop;

0.asArray
[0,2,3,4,5,6,7,8,9].asArray
Tdef.gui;