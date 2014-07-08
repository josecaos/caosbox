//written by @joseCao5 on SuperCollider 3.6.3 | Linux
//mixfuckedup.net
//Dic2013/ene2014 @ Puerto Morelos Q. Roo Mx.
//////////////////////////////////////////////////////////////////////
//CaosBox v 0.08
// Para arrancar, evalua el siguiente texto: / To start, evaluate the next text:
//////////////////////////////////////////////////////////////////////
(
History.start;
s.waitForBoot{
	 ~url="/home/josecaos/.ssh/caosbox/";/* <--- Change for your local URL to caosbox folder*/
	(~url +/+ "CB/CaosBox-load-v0.08.scd").load};/* <-- don't change this one */
);
//
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
