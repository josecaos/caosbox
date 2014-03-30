//written by @joseCao5 (mixfuckedup.net) on SuperCollider 3.6.3 | Linux
//11Dic13/18ene14 @ Puerto Morelos Q. Roo Mx.
//////////////////////////////////////////////////////////////////////
//CaosBox v 0.08
//////////////////////////////////////////////////////////////////////
(// * evalua todo en esta linea
s.waitForBoot{//
~url="/home/josecaos/.ssh/caosbox008/";//ajusta esta URL local por la de tu sistema
//////////////////////////////
//archivos complementarios
(~url +/+ "CB/CaosBox-vars-v0.08.scd").load;
(~url +/+ "CB/CaosBox-signal-v0.08.scd").load;
(~url +/+ "CB/CaosBox-synths-v0.08.scd").load;
(~url +/+ "CB/CaosBox-seq-v0.08.scd").load;
(~url +/+ "CaosBox_liveCodePad-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI_2-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI_3-v0.08.scd").load;
(~url +/+ "GUI/CaosBox-GUI_4-v0.08.scd").load;
(~url +/+ "CaosBox_liveCodePad-v0.08.scd").openOS;
});
//end of file
