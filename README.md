CaosBox v1.2
=======
It's a not-so-common LiveCoding/AlgoRave music GUI secuencer/processor for the CaosPercLib Pseudo-Class library, written in SuperCollider.

#### You can download library here: https://github.com/josecaos/caosperclib/releases
Unzip and place the - caosperclib-1.0 - folder here:  Platform.userExtensionDir;

### Use
- Moving along to v2.0 a programming interface has been created to control the GUI, still in progress, example to start CaosBox:
##
    //instance sequencer
    c = CaosBox;
    c.enviroment;

    c.play;
    c.bpm(194);
    c.freqAnalyzer(true);

    // instance an instrument
    k = CaosGear.new;
    k.kick();
    // Populate sequencer
    k.toTrack(Array.series(8,0,4);

    // Get to know all methods and variables
    CaosBox.browse;
    CaosGear.browse;

    c.stop;
##

##
    Improvise, have fun and algorave a lot.
##


##### Notes:
- No audio buffers, only synthesis. Without "caosperclib" won't work.
- Tested on SuperCollider 3.10.0 and below over Linux, Windows and OSX.
- Written by josecaos.xyz
