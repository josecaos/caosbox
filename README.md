CaosBox v1.1
=======
It's a not-so-common LiveCoding/AlgoRave music GUI secuencer/processor for the CaosPercLib Pseudo-Class library, written in SuperCollider.

#### You can download library here: https://github.com/josecaos/caosperclib/releases
Unzip and place the - caosperclib-1.0 - folder here:  Platform.userExtensionDir;

### New use
- Moving along to V2.0 a programming interface has been created to control the GUI, still in progress, example to start CaosBox:
##
    //instance sequencer
    c = CaosBox;
    c.enviroment;

    c.play;
    c.bpm(194);
    c.frequencyAnalyzer(true);
    
    // instance an instrument
    k = CaosGear.new;
    k.kick();
    
    // Populate sequencer
    c.setSteps(\kick,Array.series(8,0,4));

    //etc...

    c.stop;
##

#### Legacy use:
 - Improvising;
 - By changing ##the library arguments in CaosBox_liveCodePad-default.scd file you can route and give shape to the signal. Sequence, mix and automate in the GUI, Each percussion function on the GUI sequencer acts as one independent node in server memory, this box was made for LiveCoding. }:]

##
    ->1- Open file CaosBox.scd and evaluate the indicated text:
	+ welcome sound, GUI and CaosBox_liveCodePad-default.scd file automatically opens.
##
    ->2- First: Go to CaosBox_liveCodePad-default.scd, manipulate the Class arguments within functions or Tdefs and evaluate them:
	+ so you can route and change sound qualities.
##
    ->3- Then: Go to CaosBox GUI:
	+ start filling the checkbox sequencer on its respective instrument channel and alter the signal route with faders and buttons.
##
    ->4- Improvise, have fun and algorave a lot.
##


##### Notes:
- Right now you can mix New & Legacy uses.
- No audio buffers, only synthesis. Without "caosperclib" won't work.
- Tested on SuperCollider 3.8.0 and below over Linux, Windows and OSX.
- Written by josecaos.xyz
