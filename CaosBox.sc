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
				"\n => Class in development ... if you are having trouble booting sequencer,Refer to file 'CaosBox.scd' to use legacy boot".inform;
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

	*randomTime {|random = false|

		if(true or:{false} ,{

			switch(random,
			true,{^~botr.valueAction_(1)},
			false,{^~botr.valueAction_(0)})

			},{

		^"Use only 'true' or 'false'";
		});

	}

}