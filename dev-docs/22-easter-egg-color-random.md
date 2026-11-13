# Easter egg: color aleatorio al tempo

## 1. Idea

Un ciclo de color que acompaña la performance sin tocar la música. Se enciende
con una llamada encadenada sobre la vista:

```supercollider
CaosBox.gui.color.randomColor(true);   // arranca
CaosBox.gui.color.randomColor(false);  // detiene (deja el color actual)
```

El cambio es un par `(color, beats)`: acento nuevo y cuántos beats esperar el
siguiente. Corre sobre `TempoClock.default`, el mismo reloj que mueve
`Tdef(\secuencias)`, así que sigue el BPM y también el tiempo aleatorio.

Apagado no cuesta nada: no hay Task, no hay listeners nuevos y el step del
secuenciador no gana ni una línea.

## 2. API

```supercollider
CaosBox.gui.color.randomColor(true);
CaosBox.gui.color.randomColor(false);
CaosBox.gui.color.randomColor;    // sin argumento también arranca
```

- `color` sin argumento devuelve la vista, por eso `color.randomColor(...)`
  encadena sin tocar el acento ni avisar de un color inválido.
- `randomColor` devuelve la vista para seguir encadenando. `random` queda como
  alias corto de la forma original.
- Encender dos veces reinicia el ciclo (no duplica el Task).
- Apagar dos veces no rompe nada.
- Al apagar no se restaura el acento anterior: queda el último color, como un
  selector de color que se deja donde gustó.
- `CaosBox.close` lo apaga para no dejar un Task pintando vistas muertas.

## 3. Diseño

**Task, no Tdef.** Es una secuencia de vista, no una línea musical. Un Task
propio de `CaosBoxGUI` no aparece en `Tdef.all`, no compite por nombres y lo
libera el mismo objeto que lo creó. Las esperas son beats porque el Task se
reproduce sobre `TempoClock.default` (mismo comportamiento que un Tdef en ese
reloj).

**Paso puro.** `CaosBoxGUI.randomColorStep` devuelve `(color: ..., beats: ...)`
sin tocar reloj ni GUI. Así el contrato se testea headless y el Task sólo
compone: elige paso, repinta, espera.

- Colores: toda la paleta menos `\grey` y `\gray`.
- Esperas: `0.5`, `1`, `2` o `4` beats, con pesos `0.12, 0.33, 0.35, 0.20`.
- El repintado se hace con `.defer(0)` porque el Task no corre en AppClock.

**Costo.** Encendido, cada cambio llama `prRefresh` (redibuja las grillas y
reaplica el acento en botones, sliders, labels y popups). Es el mismo trabajo que
ya hace `CaosBox.gui.color(...)`; a una frecuencia de 0.5 a 4 beats no compite
con el audio. Apagado, el método no existe en el camino caliente.

**Cierre.** `CaosBox.close` apaga el ciclo antes de soltar el engine, por el
mismo motivo por el que detiene los Tdefs: no dejar callbacks vivos contra
widgets que ya no existen.

## 4. Implementación

- `Classes/CaosBoxGUI.sc`
  - `colorRandomTask`.
  - `randomColor(active)` → `prStartColorRandom` / `prStopColorRandom`.
  - `random(active)`: alias corto.
  - `*randomColorStep`.
  - `color(nil)` es no-op (devuelve la vista).
- `CaosBox.sc`
  - `close` apaga el ciclo con `guiRegistry !? { |gui| gui.randomColor(false) }`.
- `Tests/TestCaosBoxGUI.sc`
  - encadenado sin argumento, contrato color+beats, arranque/parada e
    idempotencia, y que el Task use `TempoClock.default`.

## 5. Tests

- `TestCaosBoxGUI`: 24 aserciones nuevas.
- Suite completa: **583 aserciones, 0 fallos**.
- Smoke headless: con el ciclo activo el acento cambia; al apagarlo dejan de
  llegar cambios; `CaosBox.close` libera el Task.

## 6. Detalles

- Cambiar el BPM no reprograma la espera en curso: el `wait` ya agendado
  conserva su tiempo y el tempo nuevo se nota en el cambio siguiente. Es el
  comportamiento normal de un `wait` en SC y no vale la pena corregirlo para un
  easter egg.
- No está en `HelpSource`: la idea es que se descubra. Si se quiere oficializar,
  alcanza con agregar `method:: randomColor` a `CaosBoxGUI.schelp` y una línea al
  CHANGELOG.
- Línea sugerida para el CHANGELOG:

  ```text
  - Easter egg: CaosBox.gui.color.randomColor(true) cambia el acento al tempo.
  ```

## 7. Pendiente

- Nada urgente. Si gusta, se puede sumar un atajo de teclado o un botón oculto
  en la GUI; por ahora la API encadenada es todo el easter egg.
