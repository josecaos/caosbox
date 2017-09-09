//////////////////////////////////////////////////////////////////////
//CaosBox v1.1
//////////////////
// Needs 'caosperclib': https://github.com/josecaos/caosperclib
// Install here: Platform.userExtensionDir;
// written by: @joseCao5 in Puerto Morelos Q. Roo Mx.
//////////////////////////////////////////////////////////////////////
// To start, evaluate the next function:
//////////////////////////////////////////////////////////////////////

(
// History.start;
s.waitForBoot{
	~url = thisProcess.nowExecutingPath.dirname;
	(~url +/+ "CB/CaosBox-load.scd").load;
};
);

///////////////////////////
//History
//This is a try to recover
//livecode sessions thru caosbox
//not yet finished as
//GUI movement values are not recorded, On the
//mean time is only saving written code,
//still some interesting information kept.
//keep improvising to infinity
////////////////////////////
//use this to load your recorded history files, recompile library first
History.loadStory(~url +/+ "Histories/hist-caosbox_5i3zb6140703.scd").play(verbose:true);
//
