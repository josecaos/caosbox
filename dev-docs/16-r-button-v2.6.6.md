# Botón R: random / restore (v2.6.6)

> El botón no introduce una base nueva: usa el historial de un nivel que ya existía en `restorePattern`. ON randomiza, OFF restaura.

## 1. Decisión

Un único botón por pista, `R`, de 16×16, a la derecha de M/S:

```text
clear 1088
M     1108
S     1128
R     1148  → 16×16, termina en 1164
```

Las cuatro columnas tienen 4 px entre sí. La ventana sigue en 1180; quedan 16 px
de margen y no hay reflow.

## 2. Comportamiento

- **OFF → click**: `CaosBox.randPattern(track)` con `density: 0.5` y sin
  `every`. El botón pasa a ON.
- **ON → click**: `CaosBox.restorePattern(track)`. Vuelve al patrón anterior y
  el botón pasa a OFF.
- Para volver a randomizar hay que apagar y volver a encender. Así cada ciclo
  ON/OFF usa un único nivel de historial y siempre se puede volver al base de
  ese ciclo.
- No se cambió `randPattern`/`restorePattern`: el botón es una vista del mismo
  contrato de la API.

## 3. Sincronización

`CaosBox.hasPatternHistory(track)` indica si hay algo para restaurar. El botón
inicializa su estado con esa consulta y `CaosBoxGUI.trackPatternChanged` lo
actualiza cuando `randPattern`, `restorePattern` o `fill` cambian la historia.

- Si el random vino por API, el botón se enciende.
- Si el restore vino por API, el botón se apaga.
- Si un `fill` está activo, también hay historial y el botón queda ON; apagarlo
  llama a `restorePattern`, que corta el fill y vuelve a su base.

## 4. Implementación

* `CaosBox.hasPatternHistory` consulta `lastPatterns`.
* `CaosBox.prPatternStateChanged` avisa al registro de vista.
* `CaosBoxGUI.randomViews`, `addRandomView` y `trackPatternChanged`.
* `GUI/CaosBox-GUI_2.scd` crea el `Button` de dos estados y lo registra.
* El listener de color global repinta el estado inactivo/activo con
  `gui.muted`/`gui.accentText` y `gui.panel`/`gui.accent`.

## 5. Tests

* `TestCaosBox`: historial después de `randPattern`, `restorePattern` y `fill`.
* `TestCaosBoxGUI`: registro de la vista y refresco ON/OFF con un botón falso.
* Suite completa: **450 aserciones, 0 fallos**.
* Prueba manual con ventana oculta: R OFF → random y ON; R ON → restaura el
  patrón base y queda OFF.

## 6. Límites

* No hay botón separado para `fill` ni para elegir densidad/`loops`.
* Sigue siendo un historial de un nivel: el botón no apila randomizaciones.
* Para re-randomizar hay que hacer OFF/ON; no se puede tirar R repetidamente sin
  restaurar entre medio.
