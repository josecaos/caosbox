CaosBox v2.5.2
------
**It's a not-so-common LiveCoding/AlgoRave music Secuencer/Processor for the CaosPercLib Class library, with a programming Interface and a GUI written in SuperCollider.**

#### You can download library here: [CaosPercLib](https://github.com/josecaos/caosperclib)
Download source or Stable version place the  'caosperclib' + 'caosbox' folders here:  
```
Platform.userExtensionDir
 ```

### Basic Use
- A Programming interface has been created to control the GUI.
- Example to start CaosBox:
```
    //instance  sequencer
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

##### License:
CaosBox is free software: you can redistribute it and/or modify it under
the terms of the **GNU General Public License, version 3 or later**
(GPL-3.0-or-later). See [LICENSE](LICENSE) and [NOTICE](NOTICE).

Versions up to **v2.3.5** remain under GPL-2.0. From **v2.4.0** onward the license is GPL-3.0-or-later, compatible with CaosPercLib (GPL-3.0).

If you distribute CaosBox or a modified version, you must keep the source available and preserve the copyright and license notices under the same license.

If you use CaosBox in a performance, release, class or research work, please credit **CaosBox by Carlos Hasbun (josecaos)** and link to this repository.
That credit is a community request, not an extra restriction on top of the GPL.