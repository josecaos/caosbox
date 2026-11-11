# Restaurar el patrón anterior (v2.6.4)

> Parte A del fill/restore. La parte B, el fill automático por loops, reutiliza
> este snapshot.

## 1. Objetivo

Poder volver al patrón que había en una pista justo antes del último
`CaosBox.randPattern`, sin recalcularlo desde el instrumento y sin perder los
flams. Es un undo de un solo nivel, pensado para performance.

## 2. El snapshot no necesita “saber el orden”

`CaosTrack` no guarda una lista de steps activos: guarda dos arrays fijos de
`size` posiciones.

```text
steps = [nil, instrumento, nil, instrumento, ...]
flams = [nil, nil, (amount: ...), nil, ...]
```

El índice **es** la posición en el patrón. Por eso el snapshot es simplemente:

```supercollider
(size: size, steps: steps.copy, flams: flams.copy)
```

Al restaurar se asignan ambos arrays completos por posición. No hay que ordenar
ni reconstruir los activos: los `nil` también vuelven a su lugar. La copia es
superficial; los valores de los steps (funciones, instrumentos) se conservan por
referencia, que es lo que queremos para que un step de percusión siga apuntando
al mismo instrumento que antes.

Se copian **steps y flams** juntos: si sólo se restauraran los gates, los dots de
flam quedarían desincronizados.

## 3. API

```supercollider
CaosBox.randPattern(\kick, density: 0.25);
CaosBox.restorePattern(\kick);
```

- `randPattern` guarda el snapshot **antes** de aplicar el patrón nuevo.
- `restorePattern` restaura ese snapshot y consume la historia.
- Ambas devuelven el `CaosTrack`.
- Si no hay historia, avisa y no toca la pista.
- `restorePattern` detiene la evolución periódica (`every`) para que el próximo
  loop no pise lo restaurado. Si se quiere seguir evolucionando, se vuelve a
  llamar `randPattern`.
- Las regeneraciones periódicas **no** reemplazan el snapshot: el “patrón
  anterior” sigue siendo el que había antes de la llamada inicial a
  `randPattern`.

## 4. Implementación

* `CaosTrack.snapshotPattern` devuelve el evento con `steps.copy` y `flams.copy`.
* `CaosTrack.restorePattern` valida el tamaño, asigna ambos arrays y notifica a
  la vista por cada posición (steps y flams).
* `CaosBox` guarda `lastPatterns` por pista; se captura en `randPattern` y se
  consume en `restorePattern`.
* `prClearRandPatterns` limpia también `lastPatterns` en `close` y al cargar un
  entorno nuevo.
* `restorePattern` elimina la entrada de `randPatterns` antes de restaurar.

## 5. Tests

* `TestCaosTrack`: snapshot conserva valores y posiciones, conserva flams, es una
  copia, notifica a la vista y rechaza snapshots de otro tamaño.
* `TestCaosBox`: restaura steps y flams, conserva el snapshot a través de loops
  periódicos, detiene la evolución y es seguro sin historia.
* Suite completa: **432 aserciones, 0 fallos**.

## 6. Pendiente

* Fill temporal automático por `loops`, reutilizando este snapshot.
* Botón de GUI para randomize/restore.
* El undo es de un nivel; no hay historial profundo ni redo.
