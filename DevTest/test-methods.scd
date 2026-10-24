x = CaosBox;
x.environment;
x.play;
x.stop;
x.bpm(25);
//
x.randomTime(true,true,[45,90,180,360]);
x.randomTime(false);
x.toggleMetric;
//
x.record;
x.stopRecording;
x.history(\start);
x.history(\stop);
//experimental // CaosBox.history(\load,"hist-caosbox_op63171226.scd");//name of localy saved file

x.freqAnalyzer(true);
x.freqAnalyzer(false);
//
~b = {Out.ar(54,CaosKick.ar(0.5,2,gate:1))};
CaosBox.setSteps(\kick);
CaosBox.setSteps(\kick,[4,12,20,28],true);
CaosBox.clearSteps(\kick,[1,2,3,9,10,11,17,18,19,25,26,27]);
CaosBox.clearSteps(\kick);
CaosBox.setSteps(\snare,[8,24]);
CaosBox.setSteps(\snare2,[8,13,19,24]);
CaosBox.setSteps(\hihats,[0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,29,30,31]);
CaosBox.setSteps(\bass,[0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,29,30,31]);

~h = {Out.ar(64,CaosHats.ar(0.01,1))};
