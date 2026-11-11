# randPattern / evolución de patrones (v2.6.3)

> Estado: API, generador, reloj y tests cerrados. Sin GUI todavía. `CHANGELOG.md`

## 1. De dónde viene

La idea original era usar un Tdef externo que llamara `setSteps` cada cierto
tiempo para cambiar el patrón y dar la sensación de frases más largas. La
operación de base era correcta: **el patrón es dato mutable y el tiempo decide
cuándo se reemplaza**. El problema era el reloj externo: podía desfasarse con
`randomTime`, `pause`/`stop`, cambios de BPM o reinicios, y no tenía un dueño
claro.

v2.6.3 conserva la operación pero mueve el “cuándo” al `CaosSequencer`.

## 2. Decisiones

1. **Un solo dueño del tiempo.** La evolución se dispara desde
   `CaosSequencer.onLoop`, que avisa al cerrar una vuelta completa de `size`
   steps. No hay Tdef por pista ni un segundo reloj.
2. **Generador puro.** `CaosTrack.randomIndices(size, density)` devuelve los
   índices; no modifica la pista. `CaosBox.randPattern` lo aplica.
3. **Densidad probabilística.** `density` va de 0 a 1: cada step se enciende con
   esa probabilidad. No es el feature de probabilidad de playback del backlog.
4. **Destructivo y acotado.** Reemplaza los gates de la pista. En percusión, el
   `setIndices` de la pista también limpia todos sus flams, porque el patrón
   completo se reemplaza. En melódicos no toca notas, acordes ni secuencias de la
   voz.
5. **Periodicidad en vueltas.** `every: n` significa “cada `n` vueltas completas
   de `CaosSequencer`”. El primer patrón se aplica al instante; después se
   regenera al cerrar la vuelta `n`.
6. **API sin romper lo viejo.** `CaosBox.randSteps` y `CaosBox.setSteps` quedan
   intactos. `randPattern` es el nombre nuevo y `stopRandPattern` lo apaga.

## 3. API

```supercollider
// una vez, destructivo
CaosBox.randPattern(\kick, density: 0.5);

// se regenera cada 4 vueltas del secuenciador
CaosBox.randPattern(\kick, density: 0.25, every: 4);

// deja de regenerarse; el patrón actual queda
CaosBox.stopRandPattern(\kick);
```

`randPattern` y `stopRandPattern` devuelven el `CaosTrack`. Una llamada one-shot
no cancela una evolución ya activa: para eso está `stopRandPattern`.

## 4. Implementación

* `Classes/CaosTrack.sc`
  * `*randomIndices(size, density)` recorre los steps y devuelve un array de
    índices válidos sin repetir.
* `Classes/CaosSequencer.sc`
  * nuevo `onLoop` y `prNotifyLoop`;
  * `prStep` separa un paso de la espera, para poder testear el wrap sin reloj.
* `CaosBox.sc`
  * `randPatterns` guarda `(density, every, count)` por pista;
  * `randPattern` valida, aplica y registra la evolución;
  * `stopRandPattern` la quita;
  * `prRandPatternLoop` cuenta vueltas y regenera cuando corresponde;
  * `prClearRandPatterns` limpia el estado en `close` y al cargar un entorno nuevo.
* `CB/CaosBox-seq.scd` conecta `~cbox_seq.onLoop` con `CaosBox.prRandPatternLoop`.
* `CB/CaosBox-vars.scd` limpia el estado antes de crear las 13 pistas.

## 5. Tests

* `TestCaosTrack`: densidad 0/1, índices válidos y sin repetir.
* `TestCaosSequencer`: `onLoop` no dispara a mitad de vuelta y sí al hacer wrap.
* `TestCaosBox`: one-shot destructivo, limpieza de flams, gates melódicos,
  validación de `density`/`every`, regeneración cada N vueltas y
  `stopRandPattern`.
* Prueba de integración con un `CaosSequencer` real: 5 loops y el patrón se
  regeneró al cerrar cada vuelta.
* Suite completa: **416 aserciones, 0 fallos**.

## 6. Límites y pendiente

* No hay fill temporal que vuelva al patrón anterior; esta versión es
  randomize/evolución destructiva. El fill temporal necesita guardar/restaurar
  y se puede diseñar aparte.
* No hay botón de GUI todavía; entra en la segunda pasada de API/GUI.
* No hay semilla explícita; el generador usa el RNG del intérprete.
* `randSteps` sigue con su semántica vieja de N steps exactos (puede repetir
  índices); no se usó como base del generador nuevo.
