////////////////////////////////////////////
//Global variables for CaosBox v1.3
///////////////////////////////////////////
// General
~cbox_bombo=Array.fill(32,nil);
~cbox_tarola=Array.fill(32,nil);
~cbox_contras=Array.fill(32,nil);
~cbox_bombo2=Array.fill(32,nil);
~cbox_tarola2=Array.fill(32,nil);
~cbox_contras2=Array.fill(32,nil);
~cbox_bajo_seq=Array.fill(32,nil);
~cbox_bajo_seq2=Array.fill(32,nil);
~cbox_ambiente_seq=Array.fill(32,nil);
~cbox_ambiente_seq2=Array.fill(32,nil);
~cbox_sinte_seq=Array.fill(32,nil);
~cbox_sinte_seq2=Array.fill(32,nil);
~cbox_in=Array.fill(32,nil);
//
~cbox_indice=0;
~cbox_clock=TempoClock.tempo=126/60;
~cbox_tiempos=0.25;
// Fx automation values
~cbox_autoreverbmix=Array.series(4,0.01,0.24);
~cbox_autoreverbroom=[0];
~cbox_autoreverbdamp=[0];
//
~cbox_autodelaytime=Array.series(10,0.01,0.01);
~cbox_autodelayfeed=[0.1];
//
~cbox_autopitchrate=Array.series(8,0.5,0.5);
~cbox_autopitchdispersion=[0.01];
~cbox_autotimedispersion=[0];
//
~cbox_autograintrig=[0.04,0.08,0.16,0.32,0.64,1.28]*4;
~cbox_autograinsize=Array.series(100,0.01,0.005);
// bpm
~cbox_randtimes=[47,62,94,141,188];
// GUI steps
~cbox_checksteps = [20,20,20,30];
~cbox_checkbox = 60;
~cbox_checkbombo=Array.fill(32,nil);
~cbox_checktarola=Array.fill(32,nil);
~cbox_checkcontras=Array.fill(32,nil);
~cbox_checkbombo2=Array.fill(32,nil);
~cbox_checktarola2=Array.fill(32,nil);
~cbox_checkcontras2=Array.fill(32,nil);
~cbox_checkbajo=Array.fill(32,nil);
~cbox_checkbajo2=Array.fill(32,nil);
~cbox_checkambiente=Array.fill(32,nil);
~cbox_checkambiente2=Array.fill(32,nil);
~cbox_checksinte=Array.fill(32,nil);
~cbox_checksinte2=Array.fill(32,nil);
~cbox_checkin=Array.fill(32,nil);
~cbox_lightsteps=Array.fill(32,nil);
~cbox_lightpos = 61;
// Automation divisors "Dont use 0 on these"
~cbox_divrev=1;
~cbox_divdel=1;
~cbox_divpitch=1;
~cbox_divgrain=1;
// Instuments
~cbox_b=nil;//kick
~cbox_t=nil;//snare
~cbox_h=nil;//hat
~cbox_b2=nil;//kick2
~cbox_t2=nil;//snare2
~cbox_h2=nil;//hat2
// Dictionary for core functions.
~cbox_steps = Dictionary[
	\kick -> [~cbox_checkbombo,~cbox_bombo,~cbox_b],
	\snare -> [~cbox_checktarola,~cbox_tarola,~cbox_t],
	\hihats -> [~cbox_checkcontras,~cbox_contras,~cbox_h],
	\kick2 -> [~cbox_checkbombo2,~cbox_bombo2,~cbox_b2],
	\snare2 -> [~cbox_checktarola2,~cbox_tarola2,~cbox_t2],
	\hihats2 -> [~cbox_checkcontras2,~cbox_contras2,~cbox_h2],
	\bass -> [~cbox_checkbajo,~cbox_bajo_seq,~cbox_bass],
	\bass2 -> [~cbox_checkbajo2,~cbox_bajo_seq2,~cbox_bass2],
	\amb -> [~cbox_checkambiente,~cbox_ambiente_seq,~cbox_amb],
	\amb2 -> [~cbox_checkambiente2,~cbox_ambiente_seq2,~cbox_amb2],
	\chords -> [~cbox_checksinte,~cbox_sinte_seq,~cbox_chord],
	\chords2 -> [~cbox_checksinte2,~cbox_sinte_seq2,~cbox_chord2],
	\in -> [~cbox_checkin,~cbox_in,~cbox_entrada]
];
// Files
~cbox_fecha=Date.getDate;
~cbox_filename=["c","a","o","s","b","o","x","_"];
~cbox_ftype=["loop-","hist-"];
~cbox_l=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","v","w","x","y","z"];
~cbox_n=["1","2","3","4","5","6","7","8","9","0"];
//mainmelody
~cbox_mainmelody = CaosGear.new;
~cbox_degrees = Scale.minor.degrees;
//
// Optionals
"// Reading Optional Dependencies".inform;
// soporte para lcne-lib
~cbox_lcne = \LCNE.asClass;
switch(~cbox_lcne,
	nil, {
		"lcne-lib: Not Installed.".inform;
	},
	 {
		"lcne-lib: OK.".inform;
		(~cbox_url +/+ "opt/lcne-lib.scd").load;
	}
);
"// End optionals".inform;
//
