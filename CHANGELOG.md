# CaosBox Changelog
###### Since August 12 2026 **Previous logging was not documentated** 

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

#	Fase	Qué toca	Rompe API
0	Higiene	rama v2, CHANGELOG, versión única, UnitTest base	no
1	Engine	CaosEngine + CaosMixer: buses con Bus.audio, grupos ordenados	no
2	Voice	CaosInstrument, CaosGear a instancias reales	sí (menor)
3	Sequence	CaosTrack + CaosSequencer headless, modelo dueño de los steps	interno
4	GUI	GUI como observador, se borran los ~cbox_check*	no
5	API + docs	fachada limpia, .schelp, README	sí
La 1 es la mejor puerta de entrada: es invisible desde afuera, es 100% testeable sin GUI, te da el andamio de UnitTest, y desacopla el ruteo — que es precondición para que los instrumentos de la fase 2 puedan elegir su salida sin números mágicos.