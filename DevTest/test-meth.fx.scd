c = CaosBox;
// c.browse;
c.enviroment;



c.fx(\reverb,arg1:0.65,arg2:0.95,arg3:0.9);
c.fx(\delay,arg1:0.5,arg2:0.5);
c.fx(\pitch,arg1:0.5,arg2:0.5,arg3:0.5);
c.fx(\grains,arg1:0.5,arg2:0.5);
c.fx(\master,arg1:1,arg2:1,arg3:0.45,arg4:0.425,arg5:0.95);

c.openDefaults;
~degrees = LCNE.dupOctave(Scale.hungarianMinor.degrees,4)