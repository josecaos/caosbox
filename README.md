CaosBox v1.2.1
------
**It's a not-so-common LiveCoding/AlgoRave music Secuencer/Processor for the CaosPercLib Class library, with a programming Interface and a GUI written in SuperCollider.**

#### You can download library here: https://github.com/josecaos/caosperclib
Unzip and place the  'caosperclib' + 'caosbox' folders here:  ``` Platform.userExtensionDir;```

### Use
- Moving towards v2.0 a programming interface has been created to control the GUI, still in progress, example to start CaosBox:
```
    //instance sequencer
    c = CaosBox;
    c.enviroment;
    //c.enviroment(false);//start without GUI(optional)

    c.play;
    c.bpm(194);
    c.freqAnalyzer(true);
    c.guiAlpha(0.5);//set GUI opacity if wanted

    // instance an instrument
    k = CaosGear.new;
    k.kick();
    // Populate sequencer
    k.toTrack(Array.series(8,0,4);

    // Get to know all methods and variables
    CaosBox.browse;
    CaosGear.browse;

    c.stop;
```
```
    Improvise, have fun and algorave a lot.
```
------

##### Notes:
- No audio buffers, only synthesis. Without "caosperclib" won't work.
- Tested on SuperCollider 3.10.0 and below over Linux, Windows and OSX.
- Written by [josecaos.xyz](https://josecaos.xyz)
