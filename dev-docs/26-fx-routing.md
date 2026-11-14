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

## 4. Orden de ejecución

`In.ar` de SuperCollider solo lee un bus si otro nodo lo escribió antes en el
mismo bloque; si no, devuelve cero. Por eso una ruta hacia atrás (por ejemplo
`reverb -> delay`, con delay antes que reverb) se silenciaba.

Después de cada `fxRoute` se calcula el orden topológico del grafo y se mueven
los Synths del grupo `\fx` con `moveToHead`/`moveAfter`. Todas las aristas quedan
hacia adelante, así que `In.ar` ve el bus tocado y no se agrega latencia.

## 5. GUI

- **Reverb, Delay y Pitch**: selector nuevo arriba de los sliders, debajo del
  label. Se redujo la altura de los sliders (~20 px) para hacer lugar.
- **LPF, HPF, BPF y Grains**: las listas se completaron con todos los FX menos
  el propio y master.
- Etiquetas cortas (`Master`, `Reverb`, `Delay`, `Pitch`, `LPF`, `HPF`, `BPF`,
  `Grains`) por el ancho de los paneles.
- Al elegir una ruta inválida, el popup vuelve a la ruta actual.
- La API también actualiza la GUI: `fxRoute` llama `fxRouteChanged`, y `route`
  sigue llamando `routeChanged`. Los popups se registran con `addRoute` /
  `addFxRoute`.

## 6. Implementación

- `CaosBox`: `fxNames`, `fxRoutes`, `fxRoute`, `fxDestinations`, `prFxSynth`,
  `prFxRouteWouldCycle`, `prFxOrder`, `prReorderFx`.
- `fxRoute` cambia `\out` del Synth del FX, guarda el estado, reordena y avisa a
  la GUI.
- `fxRoutes` se reinicia en `init` y en `close`.
- GUI: los selectores de filtros/granulador ahora llaman a la API; los nuevos
  selectores de reverb/delay/pitch usan la misma ruta.

## 7. Tests

- Validación de ciclos, self-routing, master terminal y rutas por defecto.
- Orden topológico de cadenas y detección de ciclos sin server.
- `routeChanged` y `fxRouteChanged` actualizan el popup.
- Suite completa: **646 aserciones, 0 fallos**.
- Sintaxis de `GUI/CaosBox-GUI_3.scd` y `GUI/CaosBox-GUI_4.scd` verificada con
  `compileFile`.

## 8. Pendiente

- Probar la GUI con audio real y ajustar coordenadas si hace falta.
- Instancias múltiples de FX (en espera por tamaño).
- Feedback controlado con bus de retorno atenuado y limitador.
- Persistencia de rutas entre re-evaluaciones del environment.
- `fx`/`autoFx` siguen siendo parámetros y automatización; no rutean.

## 9. Notas

- Al encadenar reverb/delay conviene revisar el `mix` para no duplicar señal
  seca.
- Un destino puede recibir también pistas; es el comportamiento normal de un
  send/return.
- No se tocó el CHANGELOG.
