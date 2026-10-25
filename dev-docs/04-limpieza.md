# Limpieza previa al paso 3

> **Versión:** v2.1.1 · **Rama:** `dev-v2.0`
> **Estado:** aplicado en el árbol de trabajo. Sin cambios de comportamiento sonoro.

---

## 1. Qué se eliminó

| Elemento | Motivo |
|---|---|
| `CB/CaosBox-funcs.scd` | No estaba en `~cbox_urls`: nunca se cargaba. Contenía copias deprecated de `setSteps`/`clearSteps`/`randSteps` que ya viven en `CaosBox`. |
| `~cbox_debug_mode` | Ya no se leía en ningún lado (los `postcln` de debug estaban en `~cbox_sintetizadores`, eliminado en el paso 2). |

## 2. Versión única

Había cinco versiones distintas en comentarios y títulos (`v1.3`, `v1.1`, `v1.3.3`,
`v2.0.2`, `v2.1.0`). Ahora:

```supercollider
CaosBox.version  // "2.1.1"
```

y de ahí la toman la ventana del GUI, la bienvenida de `CaosBox-load.scd` y los comentarios
de los `.scd`. Para un release futuro basta tocar ese classvar (el CHANGELOG lo mantiene
josecaos).

## 3. DevTest ordenado

Los scripts que usaban APIs eliminadas (`~cbox_steps`, `~cbox_sintetizadores`, Tdefs de
instrumentos, `c.enviroment`) se movieron a `DevTest/legacy/` en vez de borrarse: son notas
de timbres y secuencias que pueden servir de referencia.

Activos: `api-session-default.scd` (fixture de aceptación), `test-methods.scd` (humo de la
fachada), `test-functions.scd` y `test-melodic.scd` (notas de SC).
Ver `DevTest/README.md`.

## 4. CodePad actualizado

`CodePads/CaosBox_liveCodePad-default.scd` quedó reescrito para v2.1.1: instrumentos por
API (`CaosGear`), `toTrack`/`offTrack`, pasos desde el intérprete, FX y automatización.
Ya no usa `~cbox_bass`, `~cbox_amb` ni los Tdef de instrumentos.

## 5. Verificación

* Class library compila (con `CaosBox.version`).
* Los `.scd` parsean (incluido el CodePad nuevo).
* Suite: **177 aserciones, 0 fallos**.

## 6. Lo que queda a propósito

* `Classes/CaosEngine.sc` y `Tests/TestCaosEngine.sc`: son del paso 3 (engine/buses). Se
  reescriben o se retiran ahí.
* `GUI/CaosBox-GUI.scd`: el botón play tiene una rama muerta (`var bool = true`) y el
  secuenciador un `switch` que no hace nada; se limpian en el paso 4 (reloj/GUI).
* `CB/CaosBox-seq.scd`: las 13 lecturas por pista se sustituyen por la tabla de despacho en
  el paso 3.
