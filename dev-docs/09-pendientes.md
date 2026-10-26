# Pendientes después de v2.3.5

> Estado al cerrar la sesión del 2026-10-25. La base estructural y la GUI están
> cerradas; esto es lo que queda del análisis original más el backlog nuevo.
> Orden sugerido: bugs rápidos → timbre → docs/tests → GUI 5c.

## 1. Bugs rápidos (media hora)

- [x] **MIDI CC 11**: corregido a `\deltime`.
- [x] **B18 — `*close`**: ahora detiene sólo `\secuencias`, `\autor`, `\autod`,
      `\autop`, `\autog`, `\autolpf`, `\autohpf`, `\autobpf` y libera los
      `MIDIFunc`.
- [x] `CB/CaosBox-midi.scd` reescrito con `MIDIFunc.cc` (ver `11-fixes-v2.4.0.md`).

## 2. Timbre (los dos bugs diferidos del análisis)

- [x] **B4 — acorde**: variantes de SynthDef por acorde; `chordsArray` elige la
      primera al crear la voz.
- [x] **B5 — waveform**: variantes `ambuno_sin|tri|pulse`; `waveform` elige al crear.
- [ ] Segunda fase: cambiar acorde/waveform en caliente (hoy `set` no cambia el
      SynthDef; hay que recrear la voz).
- [ ] Revisar `bassCustom`/variantes `*Custom`: `~cbox_custom` se lee al cargar; evaluar
      si necesitan API de registro en vez de recarga.

## 3. Restos del Paso 5 (GUI como vista)

- [ ] **MIDI/automatización por registro**: el mapa ya usa `MIDIFunc`, pero sigue
      leyendo/escribiendo `~cbox_*fader`; falta pasarlo a `CaosBox.gui`/API.
- [ ] **A2 — arranque por scripts**: `~cbox_urls` sigue siendo parte del contrato;
      documentar o encapsular el orden en una API.
- [ ] **A8 — `CB/CaosBox-defaults.scd`**: sigue siendo registro/fábrica más que
      defaults; renombrar o documentar.
- [ ] **`guiAlpha`**: no-op en Wayland; dejar documentado como limitación.

## 4. Paso 6 (API, docs y tests)

- [x] `.schelp` inicial de las 8 clases en `HelpSource/Classes/`.
- [ ] README/API al día (créditos y versión ya están).
- [ ] CHANGELOG por versión (lo mantiene josecaos).
- [ ] Tests de integración con server/audio: la suite es headless.
- [ ] Limpieza de `DevTest/legacy` y ejemplos viejos.

## 5. Deuda menor del análisis

- [ ] A7: quedan bloques repetidos en `CaosGear` (menos que antes).
- [ ] `instance_id` sigue como `String` en algunos casos.
- [ ] Percusión custom que captura `out` en el closure no sigue el ruteo de pista
      (documentado); decidir si se resuelve con funciones que acepten `out`.
- [ ] `lineIn` es oneShot.

## 6. Backlog nuevo de GUI

- [ ] **Flam por step** (TU TODO): marca en el step + segundo disparo corto; va después
      de la GUI.
- [ ] Mute/solo por pista.
- [ ] Scroll y navegación por teclado en el bloque de pistas.
- [ ] Ruteo por step en percusión (si se quiere más allá del snapshot actual).
- [ ] Resize: hoy es escalado proporcional y las fuentes no escalan; evaluar breakpoints
      o tipografía fluida.
- [ ] `Scopes`: que el botón muestre estado activo cuando la ventana está abierta.

## 7. Deprecaciones

- [ ] Mantener `~cbox_tracks`, `~cbox_instruments`, `~cbox_b/t/h...`,
      `~cbox_randtimes` como alias hasta 3.0.0.
- [ ] Retirar los alias de datos en 3.0.0 y actualizar docs/historias.

## 8. Verificación rápida al empezar

```bash
HOME=/tmp/dsh_sc_home sclang /tmp/dsh_check_ext.scd      # compila
HOME=/tmp/dsh_sc_home sclang /tmp/dsh_run_all7.scd       # 286 aserciones
HOME=/tmp/dsh_sc_home sclang /tmp/dsh_syntax3.scd        # 14 .scd
```

> Nota: los scripts de `/tmp` son de la sesión; si no están, recrear el entorno
> headless con los symlinks de extensiones y los scripts de test.
