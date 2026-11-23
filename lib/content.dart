/// Contenido integrado del diario (funciona sin conexión).
/// Los textos salen de "Aplicación Móvil Kimaya"; los capítulos 1, 4 y 7 son
/// borradores mínimos para que el equipo de narrativa los reemplace.
class DiaryPage {
  const DiaryPage({
    required this.key,
    required this.category,
    required this.title,
    this.emoji = '🌿',
    this.body = '',
    this.note,
    this.spoiler = false,
    this.locked = false,
    this.order = 0,
    this.meta = const {},
    this.lists = const {},
    this.image,
    this.heroImage,
    this.emblem,
  });

  final String key, category, title, emoji, body;
  final String? note;
  final bool spoiler; // se cubre hasta que el lector diga que terminó la demo
  final bool locked; // región/registro que sigue "Por descubrir"
  final int order;
  final Map<String, String> meta;
  final Map<String, List<String>> lists;
  // Imagen del asset (assets/images/…). `image` es la miniatura de la lista
  // y `heroImage` la imagen grande de la ficha; si falta, se usa el emoji.
  // `emblem` es un emblema opcional (p. ej. Jardín de la Bruma).
  final String? image, heroImage, emblem;

  DiaryPage copyWith({String? title, String? body, String? note}) => DiaryPage(
        key: key,
        category: category,
        title: title ?? this.title,
        emoji: emoji,
        body: body ?? this.body,
        note: note ?? this.note,
        spoiler: spoiler,
        locked: locked,
        order: order,
        meta: meta,
        lists: lists,
        image: image,
        heroImage: heroImage,
        emblem: emblem,
      );
}

const kHomeQuote =
    'El bosque no inventa lo que llevas dentro. Solo hace que sea más difícil ignorarlo.';

const kCuriosities = [
  'Hoy las raíces están inquietas. Eso suele significar que alguien tomó una decisión apresurada… Falin, te estoy mirando.',
  'Encontré una pluma que brilla en la oscuridad. No es útil, pero la voy a guardar para siempre.',
  'Las perritas siempre inclinan la cabeza cuando les hablo. Creo que así escuchan mejor.',
];

DiaryPage _chap(int n, String title, String emoji, String body,
        {String? note, bool spoiler = false}) =>
    DiaryPage(
      key: 'capitulo_${n.toString().padLeft(2, '0')}',
      category: 'capitulo',
      order: n,
      title: title,
      emoji: emoji,
      body: body,
      note: note,
      spoiler: spoiler,
    );

final kPages = <DiaryPage>[
  // ---------------- Capítulos ----------------
  _chap(1, 'Una mañana como cualquier otra', '☀️',
      'Falin, Mia y Kiara pasaban la mañana como casi todas: juntas, entre juegos y pequeñas discusiones. Nada anunciaba que ese día el mundo se abriría bajo sus patas.'),
  _chap(2, 'La pelota entre los árboles', '⚽',
      'La pelota rodó hasta el viejo tronco y se perdió entre los árboles. Ninguna de las tres imaginaba que el círculo despertaría.'),
  _chap(3, 'El círculo de hongos', '🍄',
      'Los círculos de hongos son portales antiguos que casi siempre duermen. Para despertar necesitan un objeto que cruce primero, seres unidos por un vínculo y una emoción intensa. La pelota cruzó; después entraron las tres, con curiosidad, entusiasmo y preocupación.'),
  _chap(4, 'La caída', '🌀',
      'El círculo las envolvió y el suelo dejó de ser suelo. Cuando la caída terminó, el aire olía a hojas húmedas y a algo que parecía escucharlas.'),
  _chap(5, 'El bosque que escucha', '👂',
      'El bosque reacciona a los sentimientos de quienes lo atraviesan. No lee pensamientos ni crea emociones nuevas: las percibe y les da forma. No es bueno ni malo; es un espejo que amplifica lo que encuentra.',
      note: kHomeQuote),
  _chap(6, 'La aparición del Zarzal', '🥀',
      'El Zarzal Sombrío se alimenta del miedo, la culpa, la desconfianza y los conflictos sin resolver. Se manifiesta con raíces oscuras, espinas, flores marchitas y susurros que exageran las dudas.',
      note:
          'El Zarzal nunca dice una mentira completa. Toma un miedo verdadero y lo hace crecer hasta que ocupa todo el camino. Se dice que nació de habitantes anteriores, otros dicen que fue la ruptura entre los guardianes primigenios, pero nadie conoce la historia verdadera.'),
  _chap(7, 'La desaparición de Kiara', '❓',
      'Entre raíces y sombras, Kiara dejó de estar con sus hermanas. Falin y Mia se quedaron en el círculo, sin saber por dónde empezar.'),
  _chap(8, 'La guardiana del círculo', '🧚',
      'Maya es una pequeña hada encargada de proteger el círculo central y registrar los cambios del bosque. Conoce muchas reglas, pero no todas: algunas páginas de su diario han desaparecido.'),
  _chap(9, 'El Sendero de las Raíces', '🌱',
      'La conexión con el sendero está demasiado dañada para que crucen las dos hermanas a la vez. Una cruza; la otra mantiene abierto el vínculo desde el círculo.',
      note:
          'Sola en el sendero, quizá. Pero nunca estarán solas mientras crean una en la otra.'),
  _chap(10, 'El rescate', '🔓',
      'La hermana que cruzó asciende por saltos de precisión hasta encontrar a Kiara rodeada de raíces oscuras. Desde el círculo, la otra mantiene la conexión: la luz recorre el sendero, debilita las raíces y libera a Kiara, que reconoce el esfuerzo de ambas.',
      spoiler: true),
  _chap(11, 'La primera runa', '✦',
      'Las tres hermanas se reúnen frente al círculo y la energía recuperada en el Sendero de las Raíces activa la primera runa. Las otras tres siguen apagadas.',
      spoiler: true),
  _chap(12, 'Tres caminos pendientes', '🛤️',
      'Una conexión ha despertado, pero el círculo sigue incompleto. Quedan tres caminos por recorrer.',
      note:
          'El bosque todavía guarda tres caminos… y sospecho que ninguno permitirá que pasen sin cambiar.',
      spoiler: true),

  // ---------------- Regiones ----------------
  const DiaryPage(
    key: 'region_sendero',
    category: 'region',
    title: 'Sendero de las Raíces',
    emoji: '🌱',
    image: 'assets/images/sendero_de_las_raices.png',
    heroImage: 'assets/images/sendero_de_las_raices.png',
    order: 1,
    meta: {
      'Estado': 'Jugable en la demo',
      'Runa': 'Raíces',
      'Tema': 'Constancia, impulso y consecuencias de actuar',
    },
    body:
        'Un camino ascendente de plataformas y saltos de precisión. Cada salto fallido cuesta altura, y cada decisión tiene consecuencias.',
    lists: {
      'Peligros conocidos': ['Caídas', 'Raíces oscuras del Zarzal'],
    },
    note:
        'Hoy las raíces están inquietas. Eso suele significar que alguien tomó una decisión apresurada…',
  ),
  const DiaryPage(
    key: 'region_laguna',
    category: 'region',
    title: 'Laguna de los Reflejos',
    emoji: '💧',
    image: 'assets/images/laguna_de_los_reflejos.png',
    heroImage: 'assets/images/laguna_de_los_reflejos.png',
    emblem: 'assets/images/emblema_niebla_encantada.png',
    order: 2,
    locked: true,
    note:
        'Sus aguas no siempre muestran el rostro de quien se asoma. En ocasiones reflejan aquello que esa persona teme llegar a convertirse.',
  ),
  const DiaryPage(
    key: 'region_copas',
    category: 'region',
    title: 'Copas del Susurro',
    emoji: '🍃',
    image: 'assets/images/copas_del_susurro.png',
    heroImage: 'assets/images/copas_del_susurro.png',
    emblem: 'assets/images/emblema_niebla_encantada.png',
    order: 3,
    locked: true,
    note:
        'En la parte más alta del bosque, las hojas conservan palabras que nadie se atrevió a decir por miedo a no ser entendido o escuchado.',
  ),
  const DiaryPage(
    key: 'region_jardin',
    category: 'region',
    title: 'Jardín de la Bruma',
    emoji: '🌫️',
    image: 'assets/images/jardin_de_la_bruma.png',
    heroImage: 'assets/images/jardin_de_la_bruma.png',
    emblem: 'assets/images/emblema_niebla_encantada.png',
    order: 4,
    locked: true,
    note: 'No sigas una voz si no puedes ver quién llama.',
  ),

  // ---------------- Personajes ----------------
  const DiaryPage(
    key: 'personaje_falin',
    category: 'personaje',
    title: 'Falin',
    emoji: '🐕',
    image: 'assets/images/retrato_falin.png',
    heroImage: 'assets/images/personaje_falin.png',
    meta: {
      'Especie': 'Border Collie',
      'Posición': 'La menor de las tres',
      'Papel': 'Jugable en la demo',
      'Personalidad': 'Atlética, valiente, enérgica e impulsiva',
      'Relación':
          'Cree que ser la primera en avanzar es su manera de proteger a sus hermanas.',
    },
    body:
        'Falin suele actuar antes de pensar porque confía en su capacidad para reaccionar ante cualquier problema. Su mayor temor es descubrir que su impulso pueda lastimar a alguien que quiere.',
    lists: {
      'Fortalezas': [
        'Determinación',
        'Valentía',
        'Energía',
        'Actúa bajo presión'
      ],
      'Dificultades': [
        'Impaciencia',
        'Exceso de confianza',
        'No sabe cuándo detenerse'
      ],
    },
    note:
        'Falin mira una montaña y piensa inmediatamente en llegar a la cima. Todavía está aprendiendo que observar y disfrutar el camino también forma parte del viaje.',
  ),
  const DiaryPage(
    key: 'personaje_mia',
    category: 'personaje',
    title: 'Mia',
    emoji: '🐩',
    image: 'assets/images/retrato_mia.png',
    heroImage: 'assets/images/personaje_mia.png',
    meta: {
      'Especie': 'Schnauzer miniatura',
      'Papel': 'Jugable en la demo',
      'Personalidad': 'Curiosa, sensible, observadora y cuidadosa',
      'Relación': 'Teme que sus hermanas no consideren importantes sus ideas.',
    },
    body:
        'Mia percibe detalles que otras personas ignoran, pero algunas veces duda antes de compartir lo que sabe. Su arco consiste en confiar en sus capacidades y hacerse escuchar sin necesitar demostrar que puede hacerlo todo sola.',
    lists: {
      'Fortalezas': [
        'Observación',
        'Sensibilidad',
        'Curiosidad',
        'Detecta cambios'
      ],
      'Dificultades': [
        'Inseguridad',
        'Temor a equivocarse',
        'Guarda silencio si se siente ignorada',
        'Temor a no ser suficiente'
      ],
    },
    note:
        'Mia escucha cosas que el bosque apenas empieza a pronunciar. El problema es que no siempre confía en su propia voz.',
  ),
  const DiaryPage(
    key: 'personaje_kiara',
    category: 'personaje',
    title: 'Kiara',
    emoji: '🐶',
    image: 'assets/images/retrato_kiara.png',
    heroImage: 'assets/images/personaje_kiara.png',
    meta: {
      'Especie': 'Schnauzer mediana',
      'Posición': 'La mayor de las tres',
      'Papel': 'No jugable en la demo',
      'Personalidad': 'Inteligente, prudente, paciente y protectora',
      'Relación':
          'Intenta detener las discusiones y evitar que sus hermanas corran riesgos.',
    },
    body:
        'Kiara se considera responsable de sus hermanas. Su deseo de protegerlas también puede convertirse en una dificultad: a veces resuelve los problemas de las demás en lugar de dejar que aprendan por sí mismas.',
    lists: {
      'Fortalezas': [
        'Experiencia',
        'Prudencia',
        'Empatía',
        'Mantiene unida a la familia'
      ],
      'Dificultades': [
        'Exceso de responsabilidad',
        'Miedo a no poder proteger',
        'Oculta sus preocupaciones'
      ],
    },
    note:
        'Quienes cuidan de todos suelen olvidar que también tienen derecho a sentir miedo y ser cuidados.',
  ),
  const DiaryPage(
    key: 'personaje_maya',
    category: 'personaje',
    title: 'Maya',
    emoji: '🧚',
    image: 'assets/images/retrato_maya.png',
    heroImage: 'assets/images/personaje_maya.png',
    meta: {
      'Especie': 'Hada guardiana',
      'Función': 'Protectora del círculo y narradora del diario',
    },
    body:
        'Maya conoce las reglas del Bosque del Eco, pero ha perdido parte de sus registros y memoria por el crecimiento del Zarzal Sombrío. Sus páginas combinan información, recuerdos, teorías y comentarios personales.',
    lists: {
      'Personalidad': [
        'Amable y expresiva',
        'Algo desordenada',
        'Responsable ante el peligro',
        'Curiosa del mundo humano'
      ],
      'Limitaciones': [
        'No se aleja del círculo',
        'Su magia se debilita en zonas corrompidas',
        'No supera las pruebas por los visitantes',
        'No sabe cómo nació el Zarzal'
      ],
    },
    note:
        'Sí, yo también tengo una página. No, no es vanidad. Un buen archivo debe ser completo.',
  ),
  const DiaryPage(
    key: 'personaje_zarzal',
    category: 'personaje',
    title: 'Zarzal Sombrío',
    emoji: '🥀',
    image: 'assets/images/retrato_zarzal_sombrio.png',
    heroImage: 'assets/images/retrato_zarzal_sombrio.png',
    meta: {
      'Clasificación': 'Fenómeno mágico desconocido',
      'Nivel de riesgo': 'Variable',
    },
    body:
        'El Zarzal responde a emociones negativas y las convierte en obstáculos físicos. No se conoce si posee inteligencia propia. Su forma definitiva sigue sin mostrarse: solo raíces y sombras.',
    lists: {
      'Se manifiesta como': [
        'Raíces oscuras',
        'Espinas',
        'Flores marchitas',
        'Sombras entre los árboles',
        'Criaturas cubiertas por ramas',
        'Caminos que cambian',
        'Susurros'
      ],
    },
    note: 'El Zarzal nunca dice una mentira completa.',
  ),

  // ---------------- Lugares ----------------
  // Diseño como las fichas de personajes (imagen, Estado, descripción,
  // rasgos/peligros y Nota de Maya). El Bosque del Eco es la ventana de
  // ejemplo; las demás siguen ese modelo (instrucciones, pp. 5-8).
  const DiaryPage(
    key: 'lugar_bosque',
    category: 'lugar',
    title: 'Bosque del Eco',
    emoji: '🌲',
    image: 'assets/images/lugar_bosque_del_eco.png',
    heroImage: 'assets/images/lugar_bosque_del_eco.png',
    meta: {'Estado': 'Disponible'},
    body:
        'Un mundo mágico conectado con otros lugares mediante círculos de hongos, árboles huecos y símbolos antiguos. Recibe su nombre porque reacciona a los sentimientos de quienes lo atraviesan: la confianza ilumina caminos, la esperanza muestra plantas escondidas, el miedo hace crecer raíces y espinas, la inseguridad cubre el sendero de niebla y las discusiones dividen el camino.',
    lists: {
      'Rasgos del lugar': ['Vivo', 'Sensible', 'Cambia con las emociones'],
    },
    note: kHomeQuote,
  ),
  const DiaryPage(
    key: 'lugar_circulo_hongos',
    category: 'lugar',
    title: 'Círculo de hongos',
    emoji: '🍄',
    image: 'assets/images/circulo_de_hongos.png',
    heroImage: 'assets/images/circulo_de_hongos.png',
    body:
        'Portales antiguos que conectan el Bosque del Eco con otros mundos. Para activarse necesitan un objeto que cruce primero, seres vivos unidos por un vínculo emocional y una emoción suficientemente intensa.',
    lists: {
      'Rasgos del lugar': [
        'Portales',
        'Vínculo emocional',
        'Requiere un objeto'
      ],
    },
    note:
        'Los círculos no solo abren caminos, también ponen a prueba lo que los une.',
  ),
  const DiaryPage(
    key: 'lugar_circulo_central',
    category: 'lugar',
    title: 'Círculo central',
    emoji: '⭕',
    image: 'assets/images/lugar_circulo_central.png',
    heroImage: 'assets/images/circulo_central_descripcion.png',
    body:
        'El punto al que llegan las tres hermanas y el único lugar desde el que pueden regresar a casa. El Zarzal debilitó sus cuatro runas y cerró las conexiones que permitirían activarlo por completo.',
    lists: {
      'Rasgos del lugar': [
        'Punto de retorno',
        'Cuatro runas',
        'Conexión bloqueada'
      ],
    },
    note:
        'Regresar a casa todavía es posible… pero primero debemos recuperar el equilibrio.',
  ),
  const DiaryPage(
    key: 'lugar_sendero_raices',
    category: 'lugar',
    title: 'Sendero de las Raíces',
    emoji: '🌱',
    image: 'assets/images/sendero_de_las_raices.png',
    heroImage: 'assets/images/sendero_de_las_raices.png',
    meta: {
      'Estado': 'Jugable en la demo',
      'Runa': 'Raíces',
      'Tema': 'Constancia, impulso y consecuencias de actuar',
    },
    body:
        'Un camino ascendente de plataformas y saltos de precisión. Cada salto fallido cuesta altura, y cada decisión tiene consecuencias.',
    lists: {
      'Peligros conocidos': ['Caídas', 'Raíces oscuras del Zarzal'],
    },
    note:
        'Hoy las raíces están inquietas. Eso suele significar que alguien tomó una decisión apresurada…',
  ),
  const DiaryPage(
    key: 'lugar_laguna_reflejos',
    category: 'lugar',
    title: 'Laguna de los Reflejos',
    emoji: '💧',
    image: 'assets/images/lugar_laguna_reflejos.png',
    heroImage: 'assets/images/laguna_de_los_reflejos.png',
    emblem: 'assets/images/emblema_niebla_encantada.png',
    meta: {'Estado': 'Por descubrir'},
    locked: true,
    note:
        'Sus aguas no siempre muestran el rostro de quien se asoma. En ocasiones reflejan aquello que esa persona teme llegar a convertirse.',
  ),
  const DiaryPage(
    key: 'lugar_copas_susurros',
    category: 'lugar',
    title: 'Copas del Susurro',
    emoji: '🍃',
    image: 'assets/images/lugar_copas_susurros.png',
    heroImage: 'assets/images/copas_del_susurro.png',
    emblem: 'assets/images/emblema_niebla_encantada.png',
    meta: {'Estado': 'Por descubrir'},
    locked: true,
    note:
        'En la parte más alta del bosque, las hojas conservan palabras que nadie se atrevió a decir por miedo a no ser entendido o escuchado.',
  ),
  const DiaryPage(
    key: 'lugar_jardin_bruma',
    category: 'lugar',
    title: 'Jardín de la Bruma',
    emoji: '🌫️',
    image: 'assets/images/jardin_de_la_bruma.png',
    heroImage: 'assets/images/jardin_de_la_bruma.png',
    emblem: 'assets/images/emblema_niebla_encantada.png',
    meta: {'Estado': 'Por descubrir'},
    locked: true,
    body:
        'Un jardín oculto donde la bruma nunca se disipa. Sus senderos cambian, las formas se confunden y los recuerdos parecen mezclarse con el paisaje. Dicen que aquí habitan las palabras que nadie se atrevió a decir.',
    lists: {
      'Peligros conocidos': [
        'Confusión',
        'Ecos del pasado',
        'Senderos cambiantes'
      ],
    },
    note: 'No sigas una voz si no puedes ver quién llama.',
  ),

  // ---------------- Magia y objetos ----------------
  const DiaryPage(
    key: 'magia_pelota',
    category: 'magia',
    title: 'La pelota',
    emoji: '⚽',
    image: 'assets/images/pelota_roja_escena.png',
    heroImage: 'assets/images/pelota_roja_escena.png',
    body:
        'El primer detonante. Cruzó el círculo antes que nadie y lo despertó.',
    note: 'Parece solo una pelota… pero fue la chispa que puso en marcha todo.',
  ),
  const DiaryPage(
    key: 'magia_runas',
    category: 'magia',
    title: 'Las cuatro runas',
    emoji: '✦',
    image: 'assets/images/cuatro_runas_escena.png',
    heroImage: 'assets/images/cuatro_runas_escena.png',
    body:
        'Cada runa está vinculada con una región distinta. Para regresar a casa, las hermanas deberán restaurar las cuatro conexiones.',
    lists: {
      'Runas': ['Raíces', 'Laguna', 'Copas', 'Bruma'],
    },
  ),
  const DiaryPage(
    key: 'magia_portales',
    category: 'magia',
    title: 'Los portales',
    emoji: '🌀',
    image: 'assets/images/portales_escena.png',
    heroImage: 'assets/images/portales_escena.png',
    body:
        'Pasajes antiguos entre mundos. Normalmente duermen, y solo despiertan cuando se juntan las tres condiciones.',
  ),
  const DiaryPage(
    key: 'magia_diario',
    category: 'magia',
    title: 'El diario de Maya',
    emoji: '📖',
    image: 'assets/images/diario_de_maya_escena.png',
    heroImage: 'assets/images/diario_de_maya_escena.png',
    body:
        'Es donde estás ahora. Algunas páginas antiguas han desaparecido y Maya no recuerda cómo.',
    note:
        'Algunas páginas están completas. Otras… bueno, será mejor que las descubramos juntos.',
  ),
  const DiaryPage(
    key: 'magia_raices',
    category: 'magia',
    title: 'Las raíces corrompidas',
    emoji: '🕸️',
    image: 'assets/images/raices_corrompidas_escena.png',
    heroImage: 'assets/images/raices_corrompidas_escena.png',
    body:
        'Una manifestación del Zarzal. Toman un miedo verdadero y lo hacen crecer hasta ocupar todo el camino.',
  ),

  // ---------------- Criaturas (registro incompleto) ----------------
  const DiaryPage(
      key: 'criatura_1',
      category: 'criatura',
      title: 'Registro incompleto',
      emoji: '🌫️',
      image: 'assets/images/registro_incompleto_01_conejo.png',
      heroImage: 'assets/images/pagina_diario_niebla_lavanda.png',
      locked: true),
  const DiaryPage(
      key: 'criatura_2',
      category: 'criatura',
      title: 'Registro incompleto',
      emoji: '🌫️',
      image: 'assets/images/registro_incompleto_02_ave.png',
      heroImage: 'assets/images/pagina_diario_niebla_lavanda.png',
      locked: true),
  const DiaryPage(
      key: 'criatura_3',
      category: 'criatura',
      title: 'Registro incompleto',
      emoji: '🌫️',
      image: 'assets/images/registro_incompleto_03_lobo.png',
      heroImage: 'assets/images/pagina_diario_niebla_lavanda.png',
      locked: true),
];
