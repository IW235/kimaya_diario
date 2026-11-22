# Mapa de imágenes — Kimaya: El Bosque del Eco

Imágenes tomadas de `~/Downloads/images/` en el Mac de Genaro y copiadas a
`assets/images/` con nombres limpios en snake_case (sin espacios ni acentos).
Solo se renombraron los archivos que tenían espacios o mayúsculas; el resto
conserva su nombre original.

## Renombradas

| Nombre original en Descargas/images | Nombre en el repo (`assets/images/`) |
| --- | --- |
| `Ruinas del jardín entre la niebla.png` | `jardin_de_la_bruma.png` |
| `Emblema de niebla encantada.png` | `emblema_niebla_encantada.png` |
| `CirculoCentralDescripcion.png` | `circulo_central_descripcion.png` |

## Sin cambio de nombre

`lugar_bosque_del_eco.png`, `lugar_circulo_central.png`,
`lugar_laguna_reflejos.png`, `lugar_copas_susurros.png`,
`circulo_de_hongos.png`, `laguna_de_los_reflejos.png`,
`copas_del_susurro.png`, `sendero_de_las_raices.png`,
`retrato_falin.png`, `retrato_mia.png`, `retrato_kiara.png`,
`retrato_maya.png`, `retrato_zarzal_sombrio.png`,
`personaje_falin.png`, `personaje_mia.png`, `personaje_kiara.png`,
`personaje_maya.png`, `maya_retrato.png`, `maya_retrato_sin_fondo.png`,
`maya_escena.png`, `encabezado_diario_del_bosque.png`,
`pelota_roja_escena.png`, `cuatro_runas_escena.png`,
`portales_escena.png`, `diario_de_maya_escena.png`,
`raices_corrompidas_escena.png`, `diario_de_maya.png`,
`portal_magico.png`, `raices_corrompidas.png`,
`registro_incompleto_01_conejo.png`, `registro_incompleto_02_ave.png`,
`registro_incompleto_03_lobo.png`.

## Uso en el código

- `encabezado_diario_del_bosque.png`: banner superior de la pantalla Archivo.
- `retrato_*.png`: miniatura cuadrada en las tarjetas de la lista (Archivo).
- `personaje_*.png`: retrato con marco en la ficha de detalle del personaje.
  Zarzal no tiene `personaje_*.png`; usa su `retrato_zarzal_sombrio.png`.
- `lugar_*.png`: miniatura en la lista de Lugares.
- `circulo_de_hongos.png`, `laguna_de_los_reflejos.png`,
  `copas_del_susurro.png`, `sendero_de_las_raices.png`,
  `jardin_de_la_bruma.png`, `circulo_central_descripcion.png`:
  imagen principal (escena ancha) en la ficha de detalle de cada lugar.
- `emblema_niebla_encantada.png`: emblema del Jardín de la Bruma, visible en
  su ficha junto al título "Emblema de niebla encantada".
- `*_escena.png`: imagen principal en la ficha de cada objeto de Magia y objetos.
- `maya_retrato_sin_fondo.png`: retrato pequeño junto a cada Nota de Maya.
- `registro_incompleto_0*.png`: asignados a las tres criaturas (registro
  incompleto), pero siguen ocultos mientras estén bloqueadas ("Por descubrir").
- `diario_de_maya.png`, `portal_magico.png`, `raices_corrompidas.png`,
  `maya_escena.png`: copiados al repo como respaldo; no se usan todavía en
  ninguna pantalla (las escenas `*_escena.png` son las que se muestran).

Si una imagen no carga, la app muestra el emoji anterior como fallback.
