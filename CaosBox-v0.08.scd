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
	 ~url="/home/josecaos/.ssh/caosbox/";/* <--- Change for your local URL*/
	(~url +/+ "CB/CaosBox-load-v0.08.scd").load};/* <-- don't change this one */
);
//
///
////
///////////////////////////
//History
//This is a try to recover
//livecode sessions thru caosbox
//not yet finished, is not responding
//toGUI's movement values. 
//On the mean time
//keep improvising to infinity
////////////////////////////
History.loadStory(~url +/+ "Histories/hist-caosbox_h0hhh505140701.scd").play(verbose:true);
//end of file
