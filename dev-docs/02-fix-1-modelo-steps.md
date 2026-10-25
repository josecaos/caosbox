# Fix 1 — Modelo de steps (`CaosTrack`)

> **Versión:** v2.1.0 · **Rama:** `dev-v2.0`
> **Commit:** `baea79a` — "New Classes: CaosTrack / TestCaosTrack"
> **Estado:** implementado, cableado y verificado en el árbol de trabajo. Pendiente el
> commit del cableado.
> **Riesgo en runtime:** el comportamiento observable se mantiene; los pasos ahora viven
> en `~cbox_tracks` y la GUI pasó a ser vista (ver §10).

---

## 1. Resumen

Se introdujo `CaosTrack`, una clase que **posee el patrón de 32 pasos de una pista** y
notifica cambios a quien lo mire. Es el primer paso para sacar el modelo de steps de la
GUI: hoy los `CheckBox` son la fuente de verdad y el secuenciador los lee directamente.

En este fix la clase queda **aislada**: no se usa aún desde `CaosBox.sc` ni desde los
`.scd`. El objetivo es tener el modelo correcto y probado antes de cablearlo.

Archivos:

| Archivo | Líneas | Contenido |
|---|---|---|
| `Classes/CaosTrack.sc` | 188 | modelo del patrón + modos + notificación |
| `Tests/TestCaosTrack.sc` | 278 | 18 métodos de test, 41 aserciones |

---

## 2. El problema que resuelve

| Síntoma hoy | Causa | Cómo lo encara `CaosTrack` |
|---|---|---|
| La GUI es el modelo: el secuenciador lee `~cbox_checkbajo[i].value` | los widgets son la fuente de verdad | el patrón vive en la clase; la vista se suscribe con `onChange` |
| Nada de la secuencia se puede probar sin GUI | el estado está en widgets | tests headless, sin GUI ni server |
| `CaosBox.setSteps` muta el array del usuario y trunca mal (B13) | `removeAt` sobre el argumento | `setIndices` filtra índices inválidos y nunca muta la entrada |
| `\snapshot`/`\live` existe pero es implícito y accidental | percusión copia la función, melódicos leen el global | el modo es **explícito** en la clase |
| Cada pista repite la misma lógica en 13 lugares | no había modelo común | una sola implementación de patrón |

---

## 3. Alcance

**Dentro:**

* `CaosTrack`: patrón de `size` pasos (32 por defecto), dos modos, lectura/escritura,
  limpieza, índices tolerantes, notificación `onChange`.
* `TestCaosTrack`: cobertura del contrato completo, 100 % headless.

**Fuera (a propósito):**

* Cableado a `~cbox_tracks`, GUI, `Tdef(\secuencias)`, `CaosBox.setStep*` → commits 2 y 3.
* `CaosInstrument` (voz), buses/Engine y reloj → pasos 2 a 4.
* Borrado de los arrays espejo (`~cbox_bombo`, `~cbox_*_seq`) → commit 3.

---

## 4. El contrato

```supercollider
CaosTrack.new(name, mode: \live, size, source)
```

| Miembro | Semántica |
|---|---|
| `name` | `Symbol` de la pista (`\kick`, `\bass`, …) |
| `mode` | `\snapshot` o `\live`; otro valor lanza `Error` |
| `size` | número de pasos; por defecto `defaultSize` (32) |
| `source` | bloque que resuelve el valor al marcar; **obligatorio** en `\snapshot` |
| `onChange` | bloque `{ |track, index, value| … }`, opcional |
| `at(i)` | valor del paso; `nil` si está apagado o fuera de rango |
| `put(i, value)` | escribe un valor literal |
| `putStep(i, on)` | `on` verdadero → resuelve `source` (snapshot) o `true` (live); si no, apaga |
| `clear([...])` | sin argumento limpia los `size` pasos |
| `setIndices([...], clearFirst: true)` | el viejo `setSteps`, con el input depurado |
| `toggle(i)` | invierte el paso |
| `count` / `indices` / `isEmpty` / `notEmpty` | lectura |
| `asArray` | copia del patrón (mutarla no afecta al track) |
| `isValidIndex(i)` | `Integer` en `0..size-1` |

Reglas:

1. **`\snapshot`** resuelve `source.value` **en el momento de marcar**. Cambiar la fuente
   después no altera los pasos ya puestos (percusión).
2. **`\live`** guarda solo el gate; el instrumento se resuelve al disparar (melódicos).
3. **Índices tolerantes**: `put(99, …)` se ignora, `at(-1)` → `nil`; nunca lanza por índice.
4. **No muta el input**: `setIndices` copia y filtra.
5. **Notificación**: una llamada a `onChange` por escritura; `clear` notifica paso a paso
   (así la vista puede apagar cada checkbox).

Ejemplo (lo que verá el cableado):

```supercollider
// percusión: el paso guarda la función que esté vigente al marcarlo
k = CaosTrack.new(\kick, \snapshot, 32, { ~cbox_b });
k.putStep(0, true);

// melódico: el paso solo abre el gate
b = CaosTrack.new(\bass, \live);
b.putStep(4, true);
```

---

## 5. Tests

`Tests/TestCaosTrack.sc` — 18 métodos, 41 aserciones:

* construcción: defaults (live/32), tamaño configurable, `\snapshot` sin `source` lanza,
  modo desconocido lanza.
* modos: live guarda `true`/`nil`; snapshot resuelve al asignar y no después; snapshot
  guarda funciones tal cual; `source` nulo deja el paso apagado.
* escritura: `putStep` acepta `1/0`; índices inválidos ignorados; `clear` de subconjunto y
  total; `setIndices` con y sin `clearFirst`; filtrado de inválidos; input intacto; `toggle`.
* lectura: `count`, `indices`, `isEmpty`, `asArray` es copia.
* vista: `onChange` recibe `(track, index, value)`; `clear` notifica los 4 pasos de un track
  de 4.

Resultado:

```
RUNNING UNIT TEST 'TestCaosTrack'
UNIT TESTS FOR 'TestCaosTrack' COMPLETED
There were no failures
FAILURES: 0 / PASSES: 41
```

---

## 6. Cómo correrlos

Desde el IDE: `TestCaosTrack.run` (o `UnitTest.gui`).

Headless (sin server ni GUI), con `HOME` aislado para no tocar la config real:

```bash
mkdir -p /tmp/sc_home/.local/share/SuperCollider/Extensions
ln -sfn "$PWD" /tmp/sc_home/.local/share/SuperCollider/Extensions/caosbox
ln -sfn ../caosperclib /tmp/sc_home/.local/share/SuperCollider/Extensions/caosperclib

cat > /tmp/run_tests.scd <<'SCD'
(
var r;
UnitTest.reportPasses = false;
r = Routine {
	TestCaosTrack.run;
	("FAILURES: " ++ UnitTest.failures.size).postln;
	("PASSES: " ++ UnitTest.passes.size).postln;
	if(UnitTest.failures.size > 0) { 1.exit };
	0.exit;
};
r.play(AppClock);
)
SCD
HOME=/tmp/sc_home sclang /tmp/run_tests.scd
```

(La receta completa, con el chequeo de compilación, está en
`dev-docs/01-analisis-v2.md` §8.3.)

---

## 7. Decisiones y por qué

* **Modo explícito** en vez de inferirlo de si hay `source`: se lee mejor y es el vocabulario
  del CHANGELOG; mañana el modo puede bajar a nivel de step sin cambiar la clase.
* **`onChange`** en vez de que la fachada toque widgets: el modelo no menciona la GUI y el
  día que haya TUI/MIDI se suscriben igual.
* **`size` por defecto resuelto en `init`**: en SuperCollider los valores por defecto de
  argumentos no admiten classvars (`size = defaultSize` no compila); la primera versión del
  archivo cayó en eso.
* **Sin dependencias**: nada de `Synth`, `Server`, `~cbox_*` ni `GUI`; por eso los tests
  corren en segundos y sin audio.

---

## 8. Historia / errata

* `a172082` ("Update README") incluyó una versión intermedia de `CaosTrack.sc` que
  **no compilaba** (classvar como default de argumento + `if` con dos bloques).
* `baea79a` trae la versión corregida junto con `TestCaosTrack.sc`. Verificado: el class
  library compila y los tests pasan.

---

## 9. Changelog sugerido (v2.1.0)

```markdown
### v2.1.0
- New Classes:
    - CaosTrack
        - Step pattern model (32 steps, \snapshot and \live modes)
        - View notification through onChange
        - Defensive index handling (no mutation of input arrays)
    - TestCaosTrack
        - 18 headless tests, 41 assertions (no Server, no GUI)
```

Nota: "Test Headless Sequencer" describe la meta, no lo que cubre este commit: los tests
prueban el **modelo de steps**, no el secuenciador (el secuenciador sigue atado a la GUI
hasta el cableado).

---

## 10. Cableado a la app

Se hizo en un solo commit para no dejar dos fuentes de verdad a medias (percusión en el
modelo y melódicos en los checkboxes entre commits).

| Archivo | Cambio |
|---|---|
| `CB/CaosBox-vars.scd` | `~cbox_tracks` (13 `CaosTrack`); se borran los 13 arrays de step y `~cbox_steps` |
| `CaosBox.sc` | `setSteps`/`clearSteps`/`randSteps` delegan en el track; nuevo `setStep(track, i, on)`; B13 resuelto (filtra índices, no muta el input) |
| `CB/CaosBox-seq.scd` | percusión lee `~cbox_tracks[track].at(i).play`; melódicos leen el gate con `.notNil`; se borran los `put` a los arrays espejo y las ramas `else` que apagaban checkboxes |
| `GUI/CaosBox-GUI.scd` | 6 pistas: acción `CaosBox.setStep(...)`, botón X `CaosBox.clearSteps(...)`, y registro `onChange` (modelo → checkbox) |
| `GUI/CaosBox-GUI_2.scd` | 6 pistas melódicas: mismo patrón; se conserva la creación anticipada del synth al marcar (se irá a la voz en el paso 2) |
| `GUI/CaosBox-GUI_3.scd` | `lineIn` con el mismo patrón |
| `CB/CaosBox-defaults.scd` | se quitan los `~cbox_*_seq.put` de `~cbox_sintetizadores` |

Eliminado: `~cbox_bombo`, `~cbox_tarola`, `~cbox_contras`, `~cbox_bombo2`, `~cbox_tarola2`,
`~cbox_contras2`, `~cbox_bajo_seq`, `~cbox_bajo_seq2`, `~cbox_ambiente_seq`,
`~cbox_ambiente_seq2`, `~cbox_sinte_seq`, `~cbox_sinte_seq2`, `~cbox_in_seq`, `~cbox_steps`.

Detalles que se conservaron a propósito:

* **Percusión snapshot**: el paso guarda la función vigente al marcarlo; redefinir `~cbox_b`
  después no toca los pasos ya puestos.
* **Melódicos live**: el paso es un gate; el instrumento se resuelve al disparar.
* **Creación anticipada**: al marcar `amb`, `chords`, `in` la GUI sigue creando el synth en
  el momento (como antes); el secuenciador también lo crea al disparar.
* **`Nil.set` es no-op**, así que un synth aún no inicializado no rompe el secuenciador
  (antes la rama equivalente hacía `put`/`set` sobre el mismo objeto).

Verificación hecha:

* Class library compila (con el repo cargado como extensión).
* Las 12 `.scd` parsean (`String:compile` sobre el archivo completo).
* `TestCaosTrack`: 41/41.
* Smoke test headless de la fachada: `setSteps([0,4,99], true)` → `[0,4]`;
  `setSteps([1,2])` → `[0,1,2,4]`; `clearSteps([4])` → `[0,1,2]`; `setStep(10)` → `[0,1,2,10]`;
  el paso guarda la función (`.value` devuelve el instrumento); `randSteps(3)` → 3 pasos;
  track desconocido informa sin romper.

Pendiente: validación de GUI y de oído por josecaos.

---

## 11. Siguiente

1. Validar en la app real (marcar steps, botones X, `toTrack`/`offTrack`, `randSteps`,
   automatizaciones) y commitear el cableado.
2. Limpieza: `CB/CaosBox-funcs.scd` sigue con funciones deprecated que referencian
   `~cbox_steps` (el archivo no está en `~cbox_urls`, o sea que no se carga; se borran en
   el commit de limpieza).
3. Paso 2 del plan: `CaosInstrument` para que la creación del synth salga de la GUI y
   `CaosGear` devuelva instancias.

Criterio de aceptación del paso 1 (recordatorio): misma API, misma GUI, mismo sonido, y el
secuenciador sin tocar widgets ni arrays de steps — cumplido en el árbol de trabajo.
