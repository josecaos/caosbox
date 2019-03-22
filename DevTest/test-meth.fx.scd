(
c = CaosBox;
c.enviroment;
);

k = CaosGear.new;
k.kick;
k.toTrack([0,2,3,4,6,7,8,11,24]+4);

x = CaosGear.new;
x.bass;
x.toTrack([0,2,3,4,6,7,8,11,24]+4);
x.instance_id_("Kick");
x.instance_id;

c.fx(\reverb,arg1:0.65,arg2:0.95,arg3:0.9);
c.fx(\delay,arg1:0.5,arg2:0.5);
c.fx(\pitch,arg1:0.5,arg2:0.5,arg3:0.5);
c.fx(\grains,arg1:0.5,arg2:0.5);
c.fx(\master,arg1:1,arg2:1,arg3:0.45,arg4:0.425,arg5:0.95);

c.openDefaults;
~degrees = LCNE.dupOctave(Scale.hungarianMinor.degrees,4)

//
ClassBrowser.initGUI;