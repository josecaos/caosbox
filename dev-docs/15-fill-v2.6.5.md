# Fill temporal (v2.6.5)

> Parte B del fill/restore. Reutiliza el snapshot y la notificación de `restorePattern` de v2.6.4.

## 1. Objetivo

Aplicar un patrón random durante una cantidad acotada de vueltas y volver solo al
patrón que había antes, sin que el usuario tenga que acordarse de restaurar.

```supercollider
CaosBox.fill(\kick, density: 0.75);          // 1 vuelta
CaosBox.fill(\kick, density: 0.75, loops: 2); // 2 vueltas
```

## 2. Decisiones

1. **Se aplica al instante.** El fill reemplaza los gates apenas se llama; no
   espera al próximo loop para sonar.
2. **El base es el patrón del momento de la llamada.** Se guarda un snapshot
   completo (`steps` + `flams`) en `fills` y también en `lastPatterns`, así
   `restorePattern` puede cancelarlo a mano.
3. **Cuenta vueltas completas.** Si `fill` se llama a mitad de una vuelta, esa
   vuelta parcial termina primero y recién después empiezan a contar las
   `loops`. Se guarda un flag `armed` en la entrada del fill.
4. **Un fill por pista.** Si ya hay uno activo, la llamada avisa y no toca nada.
   Para cortarlo antes: `restorePattern`.
5. **El fill manda sobre la evolución periódica.** Al empezar, elimina el
   `randPattern` periódico de esa pista para que no lo pise. Ese `every` no se
   reanuda solo: si se quiere, se vuelve a llamar `randPattern`.
6. **`randPattern` cancela el fill.** Un random manual toma el base del fill como
   historial y aplica el patrón nuevo; no deja el fill anterior agendado.
7. **Auto-restore limpia la historia.** Cuando el fill termina solo, el snapshot
   se consume; `restorePattern` posterior ya no tiene nada que restaurar.
8. **Si el secuenciador está parado**, el fill queda aplicado hasta que arranque
   y cierren las vueltas, o hasta `restorePattern`.

## 3. API

```supercollider
CaosBox.fill(\kick, density: 0.75);
CaosBox.fill(\kick, density: 0.75, loops: 2);
CaosBox.restorePattern(\kick);  // corta el fill y vuelve al base
```

- `density`: 0..1, igual que `randPattern`.
- `loops`: entero positivo, default 1.
- `fill` y `restorePattern` devuelven el `CaosTrack`.
- No hay `stopFill` separado: `restorePattern` es el corte explícito.

## 4. Implementación

* `CaosBox` guarda `fills[track] = (snapshot, loops, count, armed)`.
* `prFillTick` procesa cada vuelta; el `armed` ignora la primera vuelta parcial.
* `prRandPatternLoop` procesa primero los fills y después los `randPatterns`
  periódicos. En la práctica no coexisten en la misma pista porque `fill` elimina
  la evolución periódica.
* `prClearRandPatterns` limpia `randPatterns`, `lastPatterns` y `fills` en
  `close` y al cargar un entorno nuevo.
* `restorePattern` elimina `fills` y `randPatterns` antes de restaurar.

## 5. Interacciones

| Acción durante un fill | Resultado |
|---|---|
| `restorePattern` | corta el fill y vuelve al base |
| `randPattern` | cancela el fill; el base del fill queda como historial |
| otro `fill` | avisa y no cambia nada |
| `stopRandPattern` | no afecta al fill |
| `prRandPatternLoop` | cuenta la vuelta o restaura al llegar a `loops` |

## 6. Tests

* `TestCaosBox`: fill de una vuelta, de varias, corte manual, cancelación por
  `randPattern`, parada de la evolución periódica, validación de `loops` y
  alineación desde mitad de vuelta.
* Suite completa: **443 aserciones, 0 fallos**.
* Integración con un `CaosSequencer` real: después de 5 loops el patrón volvió
  al base.

## 7. Pendiente

* El botón R de v2.6.6 cubre `randPattern`/`restorePattern`; un botón propio para
  `fill` sigue pendiente.
* No hay fills paralelos en varias pistas coordinados como una sola sección.
* No hay un contador visible de vueltas restantes del fill.
