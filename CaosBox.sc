//Main Enviroment init
CaosBox {

	classvar s,url;

	*enviroment {

		~url = this.filenameSymbol.asString.dirname;

		^super.new.init;

	}

	init {

		s = Server.local;

		s.waitForBoot {

			(~url +/+ "CB/CaosBox-load.scd").load;

			fork{1.do({13.wait;

				//debug
				"\n => Class in development ... if you are having trouble booting sequencer, please refer to file 'CaosBox.scd' to use legacy boot".inform;
			})};

		};

	}

	*play {
		~bot.valueAction_(1);

		^"";
	}

	*bpm {|val|

		~numclock.value = val;

		~clock  = {TempoClock.tempo=~numclock.value/60};

		~clock.value;

		("+ BPM set to" + ~numclock.value).inform;

		^"";
	}

	*randomTime {|random = false, editBPM = false, bpmArray = #[47,62,94,141,188]|

		if(random == true or:{ random == false} ,{

			if(editBPM == true,{
				~randtimes = bpmArray;
			});

			switch(random,
				true,{~botr.valueAction_(1)},
				false,{~botr.valueAction_(0)});

			^"";

			},{

				^"Use only 'true' or 'false'";
		});

	}

	*metric {

		var v = ~botm;

		if(v.value == 0,{v.valueAction_(1)},{v.valueAction_(0)});

		^"";
	}

	*record {

		~recbot.valueAction_(1);

		^"";

	}

	*stopRecording {

		~recbot.valueAction_(0);

		^"";
	}

	*history {|state, name|

		if(state == \start or: {state == \stop} or: {state == \load}, {
			switch(state,
				\start, {History.start},
				\stop, {~hbutt.valueAction_(0)},
				\load, {History.loadStory(~url +/+ "Histories" +/+ name).play(verbose:true)}
			);

			^"";
			}, {

				^"Use only 'start' or 'stop' keys";

		});

	}

}