# CaosBox Changelog
###### Since August 12 2026 **Previous logging was not documentated** 

---
### TODOs:
- Melodic instruments should support an array in Out routing (Like persussion instruments).
- "Flam" for percussion:
    - Applied per step, not per track: shift-click (or right-click) marks the step with a small dot; the sequencer then triggers the function twice with a short delay (e.g., 1/64 to 1/32 of a beat).
- Mute/solo per track: two small buttons—very useful for live performance, and they don't interfere with routing. This requires a "muted" state in the model, where the sequencer skips the trigger (for melodic parts, it’s better to keep the sequence advancing).
- Probability (100/75/50/25) per track: allows for variation without altering the pattern itself—a great feature.
- Fill/randomize track: generative and destructive—ideal for a performance button.
---

# Changelog

- ### v2.5.2
    - Server/audio integration tests
        - Headless audio test
            - Tests/test-headless.scd
        - Audio test
            - Tests/test-audio.scd
        - New CaosBox.prSetView updates widgets into AppClock
            - play, pause, stop, bpm, randomTime, prPauseAutomations y prSyncMetricButton
            - record, toggleMetric
            - playhead
            - Optional action parameter for valueAction_ cases            
        - Cleanup test
            - Tests/test-cleanup.scd
        - .close update
            - Stops ~cbox_seq
            - Frees MIDI
            - Frees group / nodes with engine.free
            - Stops CaosBox's Tdefs only
            - Resets ~cbox_url to nil for a clean environment restart
            - onClose no longer recompiles or kills the server
                - Close only CB environment
        - Bugfix: .routeChanged updates PopUpMenu and crashes
            - Instrument creation affects GUI on AppClock with .prSetView
        - Stress tests
            - Tests/test-long-session.scd
            - Tests/test-stress-session.scd
            - Tests/test-stress-session-max.scd
            - Stress max test: 17/17 OK

- ### v2.5.1
    - Documentation:
        - Add Documentation for:
            - CaosBox
            - CaosGear
            - CaosTrack
            - CaosInstrument 
            - CaosEngine
            - CaosSequencer
            - CaosStepGrid
            - CaosBoxGUI
    - Midi mapping fixes
        - Filters: Remap filter knobs to match filter order in controller
        - Granulator: X crossfader (CC17/20), Y CC15; ranges match the GUI (4..32, 0.01..0.05)
    - Random color at startup
    - Bugfix: .prPauseAutomations does not touch filter automations
        - autolpf, autohpf and autobpf added  
    - Tests:
        - Add TestCaosBox for automation pause
        - Suite: 302 assertions

- ### v2.5.0
    - Update default MIDI mapping to MIDIFunc.cc
        - Update view
    - Bugfix: .close
        - Stop all sequences related to CaosBox correctly
        - Free MIDI
    - Instruments
        - Pad: Create pads with different waves to change 
        - Chords: Create synthjs with each possible chord on caosperclib class

- ### v2.4.0
    - Licence Upgrade

- ### v2.3.5
    - True resizable app window
    - Apply global color to SLider handles and knobs
    - Bugfix: Scopes window
        - Scope overlaps FreqScope when resized
        - Scope channel 1 not colored
    - Unify tag name colors

- ### v2.3.4
    - GUI improvements
        - Bigger default window
        - Contents rearrengement    
            - FX panel revamp
            - Moved BPM panel to transport panel
            - Apply active color to all elements
            - Buttons and sliders with new color palette
                - Inactive: Text with active color
                - Active: Background with active color

- ### v2.3.3
    - GUI aesthetics and usability improvements
        - Channels layout and spacing

- ### v2.3.2
    - GUI colored Socopes
    - New step grid layout for 32 steps
        - All channels
        - Remove Leds
            - Active step highlited in Channel lane
    - Add .route method
    - Add routing popup to melodic instruments
        - Attach to method .route

- ### v2.3.1
    - Color palette for GUI elements
        - background 
        - panel
        - text
        - muted
        - accent
        - accentText
        - cellOff
        - border
        - playheadColor
    - Freq Analyzer moved to floating window
        - Scope button
        - FreqScope Button

- ### v2.3.0
    - GUI
        - CaosBoxGUI
        - Global layout color
        - Tests for Resizable window
        - New Steps layout
            - Bass line test

- ### v2.2.0
    - New class:
        - CaosSequencer
            - Handles all sequencing and scheduling of events in one place
            - Fixed .play, .stop, .pause functionalities
            - Updated .randomTime and .toggleMetric 
        - TestCaosSequencer
            - 10 headless tests, 20 assertions

- ### v2.1.4
    - Add bus patching for percussion instruments
    - Update GUI names for Buses from CaosBox.engine.busIndex

- ### v2.1.3
    - Revamp CaosEngine
        - Bus map
            - Change bus patching from numbers to Keys
            - Signal groups to buses
    - SynthDefs: In.ar(in) with parametric bus routing
    - Attached Caos Engine to main CaosBox class instance
    - GUI routing popups generated by Bus map
    - New sequencer structure: CaosTrack, CaosSequencer, CaosEngine

- ### v2.1.2
    - Bugfix:
        - Discrepancy in \bass2 due to CaosPercLib update
        - Fixed all Synths arguments by name not by position
    - CaosGear:
        - Unified argument names for all instruments

- ### v2.1.1
    - Add new test file api-session-default.scd
    - New Classes:
        - CaosInstrument
            - Creates functions for percussion and synths for melodies
            - Iterates thru nnotes
            - \trigger modes for melodic synths
            - Bugfixes:
                - 'TooManyaNodes' and 'SynthNotFound' errors
        - TestCaosInstrument
    - Clean deprecated code and files

- ### v2.1.0
    - New Classes:
        - CaosTrack
            - Steps pattern model
            - View notifications through `onChange` callback
        - TestCaosTrack
            - 18 headless tests, 41 assertions (no Server, no GUI)
    - CaosBox.setSteps filters out-of-range steps instead of changing the input
    - Steps now live in ~cbox_tracks; GUI draws through CaosBox.setStep
    - Removed global variable ~cbox_steps and its 13 mirror step arrays

- ### v2.0.1
    - Bugfix: 
        - Silent bugs 
            - FX automation 
                - Use correct control names in fx automation
                - Make delay type selectable in aux2
                - Check pitch automation Tdef by its real name
                - HPF/BPF automation arrays
            - API validation
                - Read limiter value from its own numberbox
                - Keep clock restore as a function 
                - Align BPM display
                - randomTime

- ### v2.0.0
    - Bugfix: Method name is mispelled
        - .enviroment -> .environment
    - New architecture
        -  Create CaosEngine Class