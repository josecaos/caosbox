//written by @joseCao5
//////////////////////////////////////////////////////////////////////
//CaosBox
// Para arrancar, evalua la siguiente función: / To start, evaluate the next function:
//////////////////////////////////////////////////////////////////////
(
// History.start;
s.waitForBoot{
	~url = thisProcess.nowExecutingPath.dirname;
	(~url +/+ "CB/CaosBox-load.scd").load
};
);
//
// CaosBox works with 'caosperclib' (https://github.com/josecaos/caosperclib) Install here: Platform.userExtensionDir;
///
////
///////////////////////////
//History
//This is a try to recover
//livecode sessions thru caosbox
//not yet finished, is not recording
//GUI movement values,On the
//mean time is only saving from written data
//still some interesting information.
//keep improvising to infinity
////////////////////////////
//use this to load your recorded history files, recompile library first
History.loadStory(~url +/+ "Histories/hist-caosbox_5i3zb6140703.scd").play(verbose:true);
//end of file
