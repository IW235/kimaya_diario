# Kimaya: Diario del Bosque del Eco

Aplicación complementaria desarrollada en Flutter para consultar el diario,
los personajes, los lugares, la magia y el progreso narrativo del videojuego
**Kimaya: El Bosque del Eco**.

La aplicación funciona como un archivo de Maya y presenta su contenido con una
interfaz de fantasía inspirada en el bosque, utilizando ilustraciones pixel art,
paneles de pergamino y estados de contenido bloqueado.

## Funciones principales

1. **Diario narrativo:** presenta doce capítulos en el orden en que suceden los
   acontecimientos del juego.
2. **Control de progreso:** permite indicar si el usuario todavía no juega la
   demo o si ya rescató a Kiara.
3. **Mapa del mundo:** muestra las cuatro regiones conectadas con el círculo de
   hongos central y permite abrir la ficha de cada región.
4. **Archivo temático:** organiza fichas de Personajes, Lugares, Magia y objetos
   y Criaturas.
5. **Contenido adaptable:** actualiza estados, miniaturas y capítulos visibles de
   acuerdo con el progreso guardado localmente.

## Navegación

- **Inicio:** resumen del diario, runas, última página visitada y accesos
  recomendados.
- **Diario:** lista de los doce capítulos narrativos.
- **Mundo:** mapa de regiones con el círculo de hongos como nodo central.
- **Archivo:** fichas de personajes, lugares, magia, objetos y criaturas.
- **Ajustes y créditos:** acceso mediante el engrane ubicado en la esquina
  superior derecha del banner.

El botón del hada también se encuentra en la esquina superior derecha del
encabezado, junto al acceso de Ajustes y créditos.

## Capítulos bloqueados y progreso

Los capítulos 10, 11 y 12 permanecen cubiertos para evitar revelar el desenlace
antes de tiempo. Mientras están bloqueados:

- muestran en el centro la ilustración `pagina_diario_niebla_lavanda.png`;
- utilizan un panel morado con el título del capítulo, candado, estado
  **Por descubrir** y un mensaje de registro;
- incluyen el botón **Ya terminé la demo**.

Al seleccionar ese botón, el progreso cambia a `rescued`, se desbloquean los
capítulos y se muestran sus miniaturas definitivas:

- Capítulo 10: puerta ancestral con candado mágico.
- Capítulo 11: cristal púrpura entre espinas.
- Capítulo 12: llave mágica entre enredaderas moradas.

El progreso y la última página consultada se almacenan con
`shared_preferences`. La aplicación también puede consultar contenido remoto de
solo lectura mediante Supabase y conserva el contenido integrado cuando no hay
conexión.

## Recursos visuales

Los recursos se encuentran en:

- `assets/images/`: ilustraciones, retratos, emblemas y miniaturas.
- `assets/video/inicio_app.mp4`: video de la pantalla de bienvenida.

Las imágenes se presentan con `BoxFit.cover` o `BoxFit.contain` según su función,
para adaptarse a diferentes resoluciones sin deformarse.

## Requisitos

- Flutter compatible con Dart `>=3.4.0 <4.0.0`.
- Chrome, Android Studio/Xcode o un dispositivo compatible con Flutter.

## Ejecución

```bash
flutter pub get
flutter run -d chrome
```

Para generar la versión web:

```bash
flutter build web
```

## Estructura principal

```text
lib/
├── main.dart              # Inicialización de la aplicación
├── content.dart           # Capítulos y fichas integradas
├── state.dart             # Progreso, persistencia y sincronización
├── common.dart            # Componentes y ventanas de detalle
├── screens/               # Pantallas y pestañas principales
└── widgets/               # Encabezados y componentes visuales
```
