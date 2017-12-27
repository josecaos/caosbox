x = CaosBox;
x.enviroment;
x.play;
x.bpm(90);
//
x.randomTime(true,true,[10,100,200]);
x.randomTime(false);
x.metric;
//
x.record;
x.stopRecording;
x.history(\start);
x.history(\stop);
x.history(\load,"hist-caosbox_op63171226.scd");//name of locally saved file



//
~clear_steps.value(\kick);
~set_steps.value(\hihats);