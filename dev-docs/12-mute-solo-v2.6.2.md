# Mute / solo por pista (v2.6.2)

> Estado: modelo, API, GUI y tests cerrados. `CHANGELOG.md`

## 1. Objetivo

Poder silenciar una pista sin borrar su patrón y aislar una o varias pistas en vivo,
sin tocar el ruteo. El estado vive en `CaosTrack`, no en la vista ni en el motor.

## 2. Decisiones

1. **Solo múltiple.** `CaosTrack.soloed` es un `IdentitySet` de pistas. Mientras no
   esté vacío, sólo suenan las pistas que pertenecen a él.
2. **Mute gana sobre solo.** `isAudible` se resuelve así:

   ```
   muted.not and: { soloed.isEmpty or: { soloed.includes(this) } }
   ```

   Una pista muteada y soleada sigue muteada; levantar el mute la vuelve a dejar
   audible si su solo sigue activo.
3. **El modelo no se detiene.** `step` siempre llama a `advance` en las pistas
   melódicas; el mute sólo evita el `trigger`. La línea sigue avanzando y al
   desmutear entra en el lugar que le corresponde. En percusión se salta el
   `play` completo (y por lo tanto también el flam).
4. **No corta notas en curso.** Mute y solo actúan sobre el próximo trigger; una
   nota melódica ya disparada sigue sonando hasta su release. La percusión no
   tiene nota sostenida, así que el efecto se siente en el step siguiente.
5. **La API es la puerta pública.** `CaosBox.mute(\kick, true)` y
   `CaosBox.solo(\bass, true)` actualizan el modelo y avisan a la vista. Devuelven
   el estado nuevo.
6. **Sin reflow.** Los botones M/S van a la derecha de la X de limpiar, con el mismo
   tamaño de 16×16 y los colores globales. No se reacomodan las columnas.

## 3. Modelo (`Classes/CaosTrack.sc`)

* `var <muted = false` y `var <solo = false`, con setters `muted_` / `solo_`
  (aceptan `nil` como `false`).
* `solo_` mantiene el `IdentitySet` de clase al día.
* `isAudible` es la única regla que consulta `step`.
* `*clearSolos` vacía el set. `CB/CaosBox-vars.scd` lo llama antes de crear las
  pistas: un entorno nuevo no hereda los solos de los objetos viejos (si no, las
  13 pistas nuevas quedarían en silencio porque el set tendría referencias
  anteriores).

## 4. API (`CaosBox.sc`)

```
CaosBox.mute(\kick, true);   // true
CaosBox.mute(\kick, false);  // false
CaosBox.solo(\bass, true);   // true
CaosBox.solo(\bass, false);  // false
```

Una pista desconocida devuelve un warning, igual que `CaosBox.route`.

## 5. GUI

* `GUI/CaosBox-GUI_2.scd`: `M` en `x = 1112`, `S` en `x = 1132`, ambos de 16×16 y
  a la derecha de `clear` (`x = 1088`). Comparten la paleta: inactivos con
  `gui.muted` sobre `gui.panel`, activos con `gui.accentText` sobre `gui.accent`.
* El listener de color de la fila repinta también los dos botones al cambiar el
  acento global.
* `Classes/CaosBoxGUI.sc`: registro `muteViews` / `soloViews`, más
  `trackStateChanged(track)` para refrescar los botones desde el modelo en AppClock.
* La ventana pasa de 1120 a **1180** px (`GUI/CaosBox-GUI.scd`) y
  `makeResizable` usa el mismo diseño (`GUI/CaosBox-GUI_4.scd`). Son **60 px** más
  que la versión anterior; el borrador de CHANGELOG dice 40, conviene corregirlo.

## 6. Tests

* `Tests/TestCaosTrack.sc`: defaults, mute, solo simple y múltiple, mute sobre solo,
  avance melódico sin trigger, percusión muteada, `nil`, `clearSolos` y limpieza del
  set en `tearDown` (35 aserciones nuevas).
* `Tests/TestCaosBox.sc`: contrato de `CaosBox.mute` / `CaosBox.solo`.
* `Tests/TestCaosBoxGUI.sc`: registro de vistas y refresco de botones con un botón
  falso (sin Qt), incluye `0.01.wait` para el `defer`.
* Suite completa: **398 aserciones, 0 fallos**.
* Prueba manual con ventana oculta: click en M mutea, click en S solea y silencia
  las demás, `CaosBox.solo` por API actualiza el botón, color global repinta los
  estados y todo vuelve al limpiar.

## 7. Pendiente / límites

* No hay atajos de teclado para mute/solo.
* El mute no cancela un flam ya agendado; el siguiente step de esa pista ya no
  dispara.
* La vista no ofrece un botón "clear solos"; se levantan uno por uno o con
  `CaosTrack.clearSolos` desde el intérprete.
