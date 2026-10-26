# Licencia v2.4.0: GPL-3.0-or-later

> Decisión: a partir de **v2.4.0**, CaosBox se distribuye bajo
> **GNU GPL v3.0 o posterior**. Las versiones hasta v2.3.5 quedan bajo GPL-2.0.
> Esto no es asesoría legal; si el proyecto crece o hay dudas, conviene una
> revisión profesional.

## Por qué

1. **Compatibilidad**: CaosPercLib ya está bajo GPL-3.0 y GPL-2.0-only es
   incompatible con GPL-3.0 para un trabajo combinado. Como CaosBox carga la
   librería en el mismo proceso de sclang, el conjunto no quedaba limpio.
2. **Copyleft**: GPL-3.0-or-later garantiza que quien distribuya CaosBox o una
   versión modificada mantenga el código disponible y los avisos de autoría.
3. **SuperCollider**: sus partes GPL-2+ son compatibles con GPL-3.
4. **Crédito**: la licencia obliga a conservar copyright y licencia; además se
   agregó un pedido de crédito/cita en README y NOTICE.

No se eligió AGPL porque por ahora no hay un servicio en red que justifique la
cláusula adicional; se puede reconsiderar si aparece un uso SaaS.

## Qué cambia

* `LICENSE`: texto oficial de GPL v3.
* `NOTICE`: copyright, resumen de la licencia, nota de que hasta v2.3.5 era
  GPL-2.0 y pedido de atribución (sin restricción extra).
* `README.md`: sección **License** y versión v2.4.0.
* Cabeceras `SPDX-License-Identifier: GPL-3.0-or-later` y copyright en
  `CaosBox.sc`, `CaosGear.sc` y las clases de `Classes/`.
* `CaosBox.version = "2.4.0"`.

## Qué no cambia

* **No es retroactivo**: las releases y tags `v1.2.2` y `v2.3.5` siguen con la
  licencia con la que se publicaron. El cambio aplica a v2.4.0 en adelante.
* No se agregan restricciones incompatibles con la GPL: el pedido de crédito es
  una norma de comunidad, no una condición adicional.
* No se toca CaosPercLib: ya está en GPL-3.0.

## Próximo al cerrar v2.4.0

* Actualizar `CHANGELOG.md` y README si cambia el alcance.
* Tag/release `v2.4.0` cuando estén los fixes de `dev-docs/09-pendientes.md`.
* Opcional: `CITATION.cff` si se quiere facilitar la cita académica.
* Opcional: SPDX en los `.scd` de `CB/` y `GUI/`.
