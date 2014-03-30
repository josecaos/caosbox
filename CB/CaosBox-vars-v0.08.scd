//written by @joseCao5
//CaosBox global variables
////////////////////////////////////////////
//this are the global variables of CaosBox
///////////////////////////////////////////
(//variables
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
//divisores automatizacion
~divrev=1;//no usar '0'
~divdel=1;//no usar '0'
~divpitch=1;//no usar '0'
~divgrain=1;//no usar '0'
~randtimes=[47,62,94,141,188];//igualar estos valores a la variable del reloj
);
