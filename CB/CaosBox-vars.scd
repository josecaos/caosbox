////////////////////////////////////////////
//Global variables for CaosBox v1.1
///////////////////////////////////////////
// General
~bombo=Array.fill(32,nil);
~tarola=Array.fill(32,nil);
~contras=Array.fill(32,nil);
~bombo2=Array.fill(32,nil);
~tarola2=Array.fill(32,nil);
~contras2=Array.fill(32,nil);
~bajo=Array.fill(32,nil);
~bajo2=Array.fill(32,nil);
~ambiente=Array.fill(32,nil);
~ambiente2=Array.fill(32,nil);
~sinte=Array.fill(32,nil);
~sinte2=Array.fill(32,nil);
~in=Array.fill(32,nil);
//
~indice=0;
~clock=TempoClock.tempo=126/60;
~tiempos=0.25;
// Fx automation values
~autoreverbmix=Array.series(4,0.01,0.24);
~autoreverbroom=[0];
~autoreverbdamp=[0];
//
~autodelaytime=Array.series(10,0.01,0.01);
~autodelayfeed=[0.1];
//
~autopitchrate=Array.series(8,0.5,0.5);
~autopitchdispersion=[0.01];
~autotimedispersion=[0];
//
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.005);
// bpm
~randtimes=[47,62,94,141,188];
// GUI steps
~checksteps = [20,20,20,30];
~checkbox = 60;
~checkbombo=Array.fill(32,nil);
~checktarola=Array.fill(32,nil);
~checkcontras=Array.fill(32,nil);
~checkbombo2=Array.fill(32,nil);
~checktarola2=Array.fill(32,nil);
~checkcontras2=Array.fill(32,nil);
~checkbajo=Array.fill(32,nil);
~checkbajo2=Array.fill(32,nil);
~checkambiente=Array.fill(32,nil);
~checkambiente2=Array.fill(32,nil);
~checksinte=Array.fill(32,nil);
~checksinte2=Array.fill(32,nil);
~checkin=Array.fill(32,nil);
~lightsteps=Array.fill(32,nil);
~lightpos = 61;
// Automation divisors "Dont use 0 on these"
~divrev=1;
~divdel=1;
~divpitch=1;
~divgrain=1;
// Instuments
~b=nil;//kick
~t=nil;//snare
~h=nil;//hat
~b2=nil;//kick2
~t2=nil;//snare2
~h2=nil;//hat2
// Array for core functions.
~steps = Dictionary[
	\kick -> [~checkbombo,~bombo,~b],
	\snare -> [~checktarola,~tarola,~t],
	\hihats -> [~checkcontras,~contras,~h],
	\kick2 -> [~checkbombo2,~bombo2,~b2],
	\snare2 -> [~checktarola2,~tarola2,~t2],
	\hihats2 -> [~checkcontras2,~contras2,~h2],
	\bass -> [~checkbajo,~bajo,~bass],
	\bass2 -> [~checkbajo2,~bajo2,~bass2],
	\amb -> [~checkambiente,~ambiente,~amb],
	\amb2 -> [~checkambiente2,~ambiente2,~amb2],
	\chords -> [~checksinte,~sinte,~chord],
	\chords2 -> [~checksinte2,~sinte2,~chord2],
	\in -> [~checkin,~in,~entrada]
];
// Files
~fecha=Date.getDate;
~filename=["c","a","o","s","b","o","x","_"];
~ftype=["loop-","hist-"];
~l=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","v","w","x","y","z"];
~n=["1","2","3","4","5","6","7","8","9","0"];
//mainmelody
~mainmelody = CaosGear.new;
~degrees = Scale.minor.degrees;
// soporte para lcne-lib
~lcne = 'LCNE'.asClass;
switch(~lcne,
	nil, {
		"lcne-lib: OK.".inform;
		"3 Octaves melody".inform  + ~degrees = LCNE.dupOctave(~degrees,3);
	},
	{
		"lcne-lib: Not Installed.".inform;
	}
);
