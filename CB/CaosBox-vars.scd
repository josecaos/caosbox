////////////////////////////////////////////
//These are the global variables for CaosBox v1.1
///////////////////////////////////////////
(
// Files
~fecha=Date.getDate;
~filename=["c","a","o","s","b","o","x","_"];
~ftype=["loop-","hist-"];
~l=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","v","w","x","y","z"];
~n=["1","2","3","4","5","6","7","8","9","0"];
//General
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
~clock=TempoClock.tempo=94/60;
~indice=0;
~tiempos=0.25;
~autoreverbmix=[0,0.4,0.75];
~autodelaytime=[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1];
~autopitchrate=[0.5,1,1.5,2];
~autopitchdispersion=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
~autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~autograinsize=Array.series(100,0.01,0.005);
//GUI steps
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
//Automation divisors "Dont use 0 on these"
~divrev=1;
~divdel=1;
~divpitch=1;
~divgrain=1;
//bpm
~randtimes=[47,62,94,141,188];
//Instument function defaults
~b=nil;//kick
~t=nil;//snare
~h=nil;//hat
~b2=nil;//kick2
~t2=nil;//snare2
~h2=nil;//hat2
);