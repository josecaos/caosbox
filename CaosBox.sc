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


			// (~url +/+ "CB/CaosBox-load.scd").load;

			//debug
			"Class in development ... Refer to 'CaosBox.scd' to use legacy boot of CaosBox".inform;

		};

	}

}