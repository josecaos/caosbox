# DevTest

Scripts de prueba manual. No forman parte del arranque de CaosBox ni del build.

## Activos

| Archivo | Para qué |
|---|---|
| `api-session-default.scd` | **Fixture de aceptación**: la sesión con la que se toca la API. Sirve para validar cada paso de la refactorización. |
| `test-methods.scd` | Humo de la fachada `CaosBox` (play, bpm, randomTime, steps, record, history). |
| `test-functions.scd` | Notas sueltas de SuperCollider (patrones, arrays). |
| `test-melodic.scd` | Notas sueltas de SuperCollider (afinaciones, Pbind). |

## legacy/

Scripts de la etapa pre-2.1: usan `~cbox_steps`, `~cbox_sintetizadores`, los Tdef de
instrumentos o globals que ya no existen. Se conservan como referencia, **no corren tal
cual**. Están aquí para no perder ideas de timbres/secuencias.

## Tests automáticos

La suite real vive en `Tests/` (`TestCaosTrack`, `TestCaosInstrument`, `TestCaosGear`) y
corre headless, sin server ni GUI. La receta está en
`dev-docs/01-analisis-v2.md` §8.3.
