# CaosBox Changelog
###### Since August 12 2026 **Previous logging was not documentated** 

---
### TODOs:
- Revamp
┌─────────────────────────────────────────────┐
│ 5. GUI          CaosBoxGUI                  │  observa el modelo, no lo posee
├─────────────────────────────────────────────┤
│ 4. API          CaosBox (fachada)           │  la cara de livecoding
├─────────────────────────────────────────────┤
│ 3. SEQUENCE     CaosSequencer, CaosTrack    │  reloj, índice, despacho
├─────────────────────────────────────────────┤
│ 2. VOICE        CaosInstrument, CaosGear    │  instancias reales, estado en vars
├─────────────────────────────────────────────┤
│ 1. ENGINE       CaosEngine, CaosMixer       │  server, buses, grupos, SynthDefs
└─────────────────────────────────────────────┘

#	|   Fase    |    Qué toca     |  Rompe API   |
0	Higiene	rama v2, CHANGELOG, versión única, UnitTest base	no
1	Engine	CaosEngine + CaosMixer: buses con Bus.audio, grupos ordenados	no
2	Voice	CaosInstrument, CaosGear a instancias reales	sí (menor)
3	Sequence	CaosTrack + CaosSequencer headless, modelo dueño de los steps	interno
4	GUI	GUI como observador, se borran los ~cbox_check*	no
5	API + docs	fachada limpia, .schelp, README	sí
La 1 es la mejor puerta de entrada: es invisible desde afuera, es 100% testeable sin GUI, te da el andamio de UnitTest, y desacopla el ruteo — que es precondición para que los instrumentos de la fase 2 puedan elegir su salida sin números mágicos.

Los dos modos de secuencia
## \snapshot (step)
    - El step guarda una copia de los valores al momento de asignarlo. Cambiar el instrumento después no afecta los steps ya puestos. Es lo que tienes hoy en percusión.
## \live (fluid)
    - el step guarda una referencia al instrumento y lee sus valores al dispararse. Cambiar el instrumento afecta todo desde el siguiente step. Es lo que tienes hoy en bajos y sintes.

**Como son ortogonales al modelo de voz, el modo puede ser por step, no por pista. Eso ya es más de lo que hay hoy: kick en \live en los steps 0/4/8 mientras el step 14 queda congelado como fill.**


*sequences*
\free (fluid) — avanza con el reloj. Lo de hoy. Deriva contra la rejilla.
\trig (normal) — avanza al disparar. Deriva contra el conteo de steps activos.

Add MIDI triggering optional


- ### General Nodes
    - capas, 
    - fases, 
    - \snapshot/\live, 
    - \free/\trig, 
    - \dur, 
    - CaosGear + subclases, r
    - egistro con promoción, y ahora el 
    - modelo de fallos.

---

# Changelog


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