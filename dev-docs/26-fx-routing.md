# Ruteo de FX

## 1. Objetivo

Poder mandar cualquier FX a cualquier otro FX o al master, sin self-routing y
sin ciclos. Hasta ahora el ruteo de FX existía solo en la GUI, hardcodeado para
filtros y granulador; pitch, delay y reverb no tenían selector.

## 2. API

```supercollider
CaosBox.fxRoute(\pitch, \delay);
CaosBox.fxRoute(\delay, \reverb);
CaosBox.fxRoute(\reverb, \grains);

CaosBox.fxRoute(\pitch);          // consulta -> \delay
CaosBox.fxRoutes;                 // rutas explícitas
CaosBox.fxNames;                  // los siete FX
CaosBox.fxDestinations;           // \master + fxNames
```

- Todos los FX van a `\master` por defecto.
- `\master` es terminal: no se puede rutear y mantiene su salida fija 0/1 con
  compresor y limitador.
- Self-routing y ciclos se rechazan; `fxRoute` devuelve `nil` y no cambia el
  Synth.
- Si una ruta no está en `fxRoutes`, se asume `\master`.

## 3. Validación de ciclos

Con `pitch -> delay -> reverb -> grains`, un `grains -> pitch` se detecta porque
al seguir la cadena desde el destino se vuelve a encontrar el origen. El chequeo
es puro y se prueba con diccionarios, sin server.

## 4. GUI

- **Reverb, Delay y Pitch**: selector nuevo arriba de los sliders, debajo del
  label. Se redujo la altura de los sliders (~20 px) para hacer lugar.
- **LPF, HPF, BPF y Grains**: las listas se completaron con todos los FX menos
  el propio y master.
- Etiquetas cortas (`Master`, `Reverb`, `Delay`, `Pitch`, `LPF`, `HPF`, `BPF`,
  `Grains`) por el ancho de los paneles.
- Al elegir una ruta inválida, el popup vuelve a la ruta actual.

## 5. Implementación

- `CaosBox`: `fxNames`, `fxRoutes`, `fxRoute`, `fxDestinations`, `prFxSynth`,
  `prFxRouteWouldCycle`.
- `fxRoute` cambia `\out` del Synth del FX y guarda el estado.
- `fxRoutes` se reinicia en `init` y en `close`.
- GUI: los selectores de filtros/granulador ahora llaman a la API; los nuevos
  selectores de reverb/delay/pitch usan la misma ruta.

## 6. Tests

- Validación de ciclos, self-routing, master terminal y rutas por defecto.
- Suite completa: **638 aserciones, 0 fallos**.
- Sintaxis de `GUI/CaosBox-GUI_3.scd` y `GUI/CaosBox-GUI_4.scd` verificada con
  `compileFile`.

## 7. Pendiente

- Probar la GUI con audio real y ajustar coordenadas si hace falta.
- Instancias múltiples de FX (en espera por tamaño).
- Feedback controlado con bus de retorno atenuado y limitador.
- Persistencia de rutas entre re-evaluaciones del environment.
- `fx`/`autoFx` siguen siendo parámetros y automatización; no rutean.

## 8. Notas

- Al encadenar reverb/delay conviene revisar el `mix` para no duplicar señal
  seca.
- Un destino puede recibir también pistas; es el comportamiento normal de un
  send/return.
- No se tocó el CHANGELOG.
