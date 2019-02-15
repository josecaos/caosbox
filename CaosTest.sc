CaosTest : CaosBox {

	*new {

		"New test".inform;
		^super.new;

	}

	self {

		var i = 	thisProcess.methodReferences;
		^"My variable is: " + i;

	}



}