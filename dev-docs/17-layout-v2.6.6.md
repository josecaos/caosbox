# Ajuste de layout (v2.6.6)

> Cierre visual de la ventana de 1180: columnas de botones parejas y bloque inferior repartido sin dejar el hueco de la derecha.

## 1. Columnas de botones

Las cuatro columnas de cada fila ahora comparten ancho y separación:

```text
clear 1088
M     1108
S     1128
R     1148
...   1164 (fin)
```

- 16×16 cada una.
- 4 px entre `clear`, `M`, `S` y `R`.
- 16 px de margen derecho hasta 1180.
- El grupo queda alineado con el borde derecho del bloque inferior.

No cambió el ancho de la ventana ni el de las rejillas.

## 2. Bloque inferior

El diseño original de 1120 terminaba en `x = 1104`. Al pasar la ventana a 1180
quedaban 76 px libres a la derecha del granulador y del transporte.

En vez de mover cada control a mano, `CaosBoxGUI.scaleLowerSection` toma todos
los widgets con `top >= 400` y los remapea horizontalmente:

```text
x' = 16 + (x - 16) * (1164 - 16) / (1104 - 16)
w' = w * (1164 - 16) / (1104 - 16)
```

- Se conservan las proporciones internas de master, efectos, filtros,
  granulador y transporte.
- El margen final vuelve a ser 16 px.
- La parte superior (filas de pistas) no se toca; las columnas M/S/R ya están
  corregidas aparte.
- Es idempotente: si el borde derecho ya pasó 1104, no vuelve a escalar.

El llamado está al final de `GUI/CaosBox-GUI_4.scd`, antes de `themeLegacy` y
`makeResizable`, así que el resize fluido guarda los rects ya repartidos.

## 3. Verificación

- Geometría del bloque inferior probada en ventana oculta:
  `master` 16..311, `efectos` 324..672, `filtros` 685..917,
  `granulador` 930..1164.
- Una segunda llamada a `scaleLowerSection` deja los rects iguales.
- Botones: M 1108, S 1128, R 1148, fin 1164.
- Suite completa: **450 aserciones, 0 fallos**.

## 4. Pendiente

- Validar visualmente en la app real; los anchos se redondean a píxeles enteros.
- Los fuentes no escalan con el ancho, sólo los rectángulos.
