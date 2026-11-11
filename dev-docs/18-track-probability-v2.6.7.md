# Probabilidad de playback por pista (v2.6.7)

> API y GUI cerradas en v2.6.7.

## 1. Qué es y qué no es

Hay dos probabilidades distintas:

| Nombre | Dónde vive | Qué decide |
|---|---|---|
| `density` | `randPattern`, `fill` | qué steps se **escriben** en el patrón |
| `trackProbability` | `CaosTrack.probability` | si un step ya escrito **dispara** en esta pasada |

La densidad es generación y es destructiva. La probabilidad de playback no toca
el patrón: la grilla, los gates y los flams quedan igual.

```supercollider
CaosBox.trackProbability(\kick);        // consulta
CaosBox.trackProbability(\kick, 0.75);  // setea 75%
```

## 2. Semántica

- Cada step activo tiene una chance independiente de disparar.
- `1.0` es el default: siempre dispara.
- `0.0` nunca dispara, pero el patrón sigue dibujado.
- En melódicos, `advance` corre siempre; la línea no se desfasa cuando una nota
  se salta.
- En percusión, si el step falla no se llama a `play` y no se agenda el flam.
- Mute y solo tienen prioridad: primero se resuelve `isAudible` y recién después
  se tira la chance.
- `restorePattern`, `randPattern`, `fill` y los snapshots no modifican la
  probabilidad; es una propiedad de playback, no parte del patrón.
- Los valores son `0..1`, igual que `density`; la GUI los muestra como porcentaje
  entero `0..100`.

## 3. GUI

La grilla de pistas termina alineada con la columna del granulador, en `x = 930`.
Eso deja lugar a la derecha sin ensanchar la ventana:

```text
label        16..76
grid         80..926      (846 px)
route       930..1020     (90 px)
clear       1026..1042
M           1048..1064
S           1070..1086
R           1092..1108
P label     1114..1121
P box       1122..1156    (34 px)
%           1157..1164
```

- La grilla termina en 926, cuatro píxeles antes de la columna del granulador
  (930), para que la costura visual quede limpia.
- Los botones tienen 6 px de separación.
- `P` queda al final de la fila, después de R.
- El label `P` distingue la probabilidad del botón R.
- `P` es un `NumberBox` de 0 a 100, entero y editable, con `%` al lado.
- Muestra el valor real: 85 se ve 85, no un preset.
- La API sigue en `0..1`; la GUI convierte `85 -> 0.85`.
- Si `trackProbability` cambia por API, `CaosBoxGUI.trackProbabilityChanged`
  actualiza el `NumberBox`.
- El texto de todos los `NumberBox` usa el acento global, también mientras se
  escribe; antes algunos quedaban negros sobre el panel oscuro.
- La densidad de `randPattern` sigue sólo por API; el R button conserva su
  default `0.5`.
- No se ensancha la ventana; eso queda para v2.6.8.

## 4. Implementación

* `CaosTrack.probability` (getter) y `probability_` (setter); default `1.0`.
* `CaosTrack.prShouldPlay` resuelve la chance; 0 y 1 no consumen RNG.
* `CaosTrack.step` combina `isAudible` + `prShouldPlay` antes del trigger o del
  `play` de percusión.
* `CaosBox.trackProbability(track)` consulta.
* `CaosBox.trackProbability(track, 0..1)` setea y devuelve el valor nuevo.
* `CaosBox.prProbabilityChanged` avisa al registro de vista.
* `CaosBoxGUI.probabilityViews`, `addProbabilityView` y
  `trackProbabilityChanged`.
* `GUI/CaosBox-GUI_2.scd` crea el `NumberBox` de 0..100 y su `%`.
* Una pista desconocida o un valor fuera de rango avisan sin tocar nada.

## 5. Tests

* `TestCaosTrack`: default 1.0, setter, 0 no dispara pero avanza la línea
  melódica, 0 no toca percusión, 1 siempre dispara, el patrón no cambia.
* `TestCaosBox`: getter/setter, validación, y que la probabilidad sobreviva a
  `randPattern`/`restorePattern`.
* `TestCaosBoxGUI`: el `NumberBox` recibe el porcentaje correcto.
* Suite completa: **465 aserciones, 0 fallos**.

## 6. Pendiente

* Densidad de `randPattern` en GUI: sigue sólo por API.
* No hay automatización de la probabilidad ni persistencia entre entornos.
* La chance no cancela flams ya agendados, igual que mute.
