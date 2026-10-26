CaosBox v2.3.3
------
**It's a not-so-common LiveCoding/AlgoRave music Secuencer/Processor for the CaosPercLib Class library, with a programming Interface and a GUI written in SuperCollider.**

#### You can download library here: [CaosPercLib](https://github.com/josecaos/caosperclib)
Download source or Stable version place the  'caosperclib' + 'caosbox' folders here:  
```
Platform.userExtensionDir
 ```

### Basic Use
- Moving towards v2.0 a programming interface has been created to control the GUI, still in progress, example to start CaosBox:
```
    //instance sequencer
    c = CaosBox;
    c.environment;
    //c.environment(false);//start headless without GUI(optional)

    c.play;
    c.bpm(194);
    c.freqAnalyzer(true);
    c.guiAlpha(0.5);//set GUI opacity if wanted

    // instance an instrument
    k = CaosGear.new;
    k.kick();
    // Populate sequencer
    k.toTrack(Array.series(8,0,4));

    // Get to know all methods and variables
    CaosBox.browse;
    CaosGear.browse;

    c.stop;
```

#### Improvise, have fun and algorave a lot.

------

##### Notes:
- No audio buffers, only synthesis. Without [caosperclib](https://github.com/josecaos/caosperclib) won't work.
- Tested on SuperCollider 3.12.0 and below over Linux, Windows and OSX.

##### Credits:
- CaosBox and CaosPercLib: [Carlos Hasbun](https://github.com/josecaos)
- v2.x refactor and GUI: pair-coded with [**DeepSeek**](https://www.deepseek.com/) (DeepSeek Harness agent, model deepseek-v4-flash)
- All architecture, design, and final code from [josecaos](https://josecaos.xyz)
- Thanks to [WAD Agency](https://wad.mx) for the endorsment and project's support
