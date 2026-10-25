////////////////////////////////////////////
//Global variables for CaosBox v2.1.1
///////////////////////////////////////////
// General
~cbox_indice=0;
TempoClock.tempo = 126/60;
~cbox_clock={ TempoClock.tempo = (if(~cbox_numclock.notNil,{~cbox_numclock.value},{126}))/60 };
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
//
~cbox_autolpffreq=Array.exprand(10,20,20000);
~cbox_autolpfband=Array.exprand(10,0.1,1);
~cbox_autohpffreq=Array.exprand(10,20,20000);
~cbox_autohpfband=Array.exprand(10,0.1,1);
~cbox_autobpffreq=Array.exprand(10,20,20000);
~cbox_autobpfband=Array.exprand(10,0.1,1);
// gui filter controls
// ~cbox_fmaxmin=ControlSpec(20,20000,\exponential,1,20000);
// ~cbox_rqmaxmin=ControlSpec(0.01,1,\lin,0.01,1);
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
~cbox_divlpf=1;
~cbox_divhpf=1;
~cbox_divbpf=1;
// Instuments
~cbox_b=nil;//kick
~cbox_t=nil;//snare
~cbox_h=nil;//hat
~cbox_b2=nil;//kick2
~cbox_t2=nil;//snare2
~cbox_h2=nil;//hat2
// Instruments (voices) registry: track -> CaosInstrument
~cbox_instruments = Dictionary.new;
// Step patterns (model, see Classes/CaosTrack.sc):
//   \snapshot stores the value resolved when the step is set (percussion)
//   \live stores only the gate and resolves the instrument at trigger time
~cbox_tracks = Dictionary[
	\kick -> CaosTrack.new(\kick, \snapshot, 32, { ~cbox_b }),
	\snare -> CaosTrack.new(\snare, \snapshot, 32, { ~cbox_t }),
	\hihats -> CaosTrack.new(\hihats, \snapshot, 32, { ~cbox_h }),
	\kick2 -> CaosTrack.new(\kick2, \snapshot, 32, { ~cbox_b2 }),
	\snare2 -> CaosTrack.new(\snare2, \snapshot, 32, { ~cbox_t2 }),
	\hihats2 -> CaosTrack.new(\hihats2, \snapshot, 32, { ~cbox_h2 }),
	\bass -> CaosTrack.new(\bass, \live, 32),
	\bass2 -> CaosTrack.new(\bass2, \live, 32),
	\amb -> CaosTrack.new(\amb, \live, 32),
	\amb2 -> CaosTrack.new(\amb2, \live, 32),
	\chords -> CaosTrack.new(\chords, \live, 32),
	\chords2 -> CaosTrack.new(\chords2, \live, 32),
	\in -> CaosTrack.new(\in, \live, 32)
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
// Optionals
"// Reading Optional Dependencies".inform;
// soporte para lcne-lib
~cbox_lcne = \LCNE.asClass;
switch(~cbox_lcne,
	nil, {
		"lcne-lib: Not Installed.".inform;
	},
	 {
		(~cbox_url +/+ "opt/lcne-lib.scd").load;
		"lcne-lib: OK.".inform;
	}
);
"// End optionals".inform;