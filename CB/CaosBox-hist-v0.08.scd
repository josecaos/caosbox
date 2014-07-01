//reWritten by @joseCao5
//taken from a workshop
//with Julian Rohruber & Alberto de Campo
//CNA Mexico City 2012
(
History.start;
//History.makeWin;

OSCdef(\hist, { |msg|
	//msg.postln;
	History.enter(msg[2].asString, msg[1]);
}, \hist).fix;
History.localOff;
//History.forwardFunc = { |code|
	//q.sendAll(\hist, \joseCao5, code);
};
);
//salva el historial
History.saveStory(~url +/+ "Histories/CaosBox-load-v0.08.scd")
//
//not finished yet