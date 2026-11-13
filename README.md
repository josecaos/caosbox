## CaosBox v2.7.3

**It's a not-so-common LiveCoding/AlgoRave music Secuencer/Processor for the CaosPercLib Class library, with a programming Interface and a GUI written in SuperCollider.**

#### You can download library here: [CaosPercLib](https://github.com/josecaos/caosperclib)

Download source or Stable version place the 'caosperclib' + 'caosbox' folders here:

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
    g = CaosGear.new;

    // instace a percussion instrument
    k = g.new;
    k.kick(\master);
    // Populate sequencer
    k.toTrack(Array.series(8,0,4));
    // or
    c.setSteps(\kick, Array.series(8,0,4));
    c.tracks[\kick].flam([0, 4], 0.1); //adds flam to selected steps
    c.repeater(\kick, [0, 4], repetitions:4, metric:1); // adds flam to selected steps

    // instance a melodic instrument
    p = g.new
    q = p.pad(\reverb, waveform: \sin);
    p.updateTimbre(waveform: \tri); // updates the instrument conserving previous arguments

    g.validChords(\chords);
    o = g.new;
    z = o.chords(\master,[60,63,67,71],\rand,[\M7,\m7,\mmaj7,'5aug7'],att:1,rel:3);
    z.updateTimbre(chord: '5dim7'); // stops chordsArray sequence and sets the chord with previous arguments

    // Get to know all methods and variables
    CaosBox.browse;
    CaosGear.browse;

    c.stop;
```
### MIDI control
```
CaosMIDI.devices;

// Connect specific device
CaosMIDI.connectOnly("USB X-Sessions");

// Connect an instrument to an external synth
// Percussions sends a value
CaosMIDI.attachOut(\kick, "CH345", 0, [28,36,38,39,41,43].choose);
// Melodic instruments send the sequenced scale
CasoMIDI.detachOut(\kick);
CaosMIDI.attachOut(\bass, "CH345", 0);

// Play caos instruments with external keyboard
CaosMIDI.attachIn(\bass, "MPK mini 3", 0);
CaosMIDI.detachIn(\bass);

// Detect MIDI inputs
CaosMIDI.monitor(true);


```


#### Improvise, have fun and algorave a lot.

---

##### Notes:

- No audio buffers, only synthesis. Without [caosperclib](https://github.com/josecaos/caosperclib) won't work.
- Tested on SuperCollider 3.12.0 and below over Linux, Windows and OSX.

##### Credits:

- CaosBox and CaosPercLib: [Carlos Hasbun](https://github.com/josecaos)
- v2.x refactor: pair-coded with [**DeepSeek**](https://www.deepseek.com/) (DeepSeek Harness agent, model deepseek-v4-flash)
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
