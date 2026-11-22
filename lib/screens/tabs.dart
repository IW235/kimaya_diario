import 'package:flutter/material.dart';

import '../common.dart';
import '../content.dart';
import '../state.dart';
import '../theme.dart';

// ------------------------------------------------------------------ Inicio
class InicioTab extends StatelessWidget {
  const InicioTab({super.key, required this.state, required this.goto});
  final AppState state;
  final void Function(int) goto;

  @override
  Widget build(BuildContext context) {
    final last = state.lastPage;
    final curiosity = kCuriosities[DateTime.now().day % kCuriosities.length];
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('¡Qué bueno verte!', style: K.title(14)),
      const SizedBox(height: 6),
      Text('Maya dejó una nota nueva para ti.', style: K.body(13, color: K.muted)),
      const SizedBox(height: 14),
      const _Hero(),
      const SizedBox(height: 14),
      const MayaNote(kHomeQuote, label: 'Nota de Maya · hoy'),
      SectionTitle('Las cuatro runas',
          trailing: state.rescued ? '1 de 4 despierta' : '0 de 4 despiertan'),
      RuneRow(firstActive: state.rescued),
      if (last != null) ...[
        const SectionTitle('Última página consultada'),
        PageTile(page: last, state: state),
      ],
      const SectionTitle('Continúa explorando'),
      PaperCard(
        color: K.mossLight,
        onTap: () => goto(3),
        child: const _Row('🐾', 'Las hermanas', 'Conoce a Falin, Mia y Kiara.'),
      ),
      PaperCard(
        color: K.mossLight,
        onTap: () => openPage(context, state, state.byKey('lugar_circulo_hongos')),
        child: const _Row('🍄', 'El círculo de hongos', 'El comienzo de una aventura inesperada.'),
      ),
      MayaNote(curiosity, label: 'Curiosidad del día'),
    ]);
  }
}

class _Row extends StatelessWidget {
  const _Row(this.emoji, this.title, this.sub);
  final String emoji, title, sub;
  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: K.body(15, color: K.night, w: FontWeight.w800)),
            Text(sub, style: K.body(12, color: K.muted)),
          ]),
        ),
      ]);
}

class _Hero extends StatelessWidget {
  const _Hero();
  @override
  Widget build(BuildContext context) => Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD5C493), width: 2),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF88C9AB), Color(0xFF609777), K.forest],
          ),
        ),
        child: Stack(children: [
          Positioned(
            top: 18,
            right: 30,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4D77E),
                boxShadow: [BoxShadow(color: Color(0xFFFFED9B), blurRadius: 28)],
              ),
            ),
          ),
          const Positioned(left: 26, bottom: 28, child: Text('🌳', style: TextStyle(fontSize: 48))),
          const Positioned(right: 30, bottom: 20, child: Text('🌲', style: TextStyle(fontSize: 56))),
          const Align(alignment: Alignment(0, -0.1), child: Text('🧚', style: TextStyle(fontSize: 36))),
          Positioned(
            left: 14,
            bottom: 10,
            child: Text('Un bosque que escucha lo que sentimos',
                style: K.serif(12, color: const Color(0xFFFFF9DF))),
          ),
        ]),
      );
}

// ------------------------------------------------------------------ Diario
class DiarioTab extends StatelessWidget {
  const DiarioTab({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
        Text('Diario de Maya', style: K.title(14)),
        const SizedBox(height: 6),
        Text('Capítulos cortos, en el orden en que ocurrieron.', style: K.body(13, color: K.muted)),
        const SizedBox(height: 12),
        if (!state.rescued)
          PaperCard(
            color: K.bramble,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Las raíces cubren los capítulos que cuentan el desenlace, para que no te los cuente antes de tiempo.',
                style: K.body(13, color: K.paper),
              ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: K.coral, foregroundColor: K.ink),
                onPressed: () => state.setProgress(Progress.rescued),
                child: const Text('Ya terminé la demo'),
              ),
            ]),
          ),
        for (final c in state.all('capitulo')) PageTile(page: c, state: state),
      ]);
}

// ------------------------------------------------------------------ Mundo
class MundoTab extends StatelessWidget {
  const MundoTab({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final regions = state.all('region');
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text('Mapa del Bosque', style: K.title(14)),
      const SizedBox(height: 6),
      Text('Toca una región para abrir su página.', style: K.body(13, color: K.muted)),
      const SizedBox(height: 12),
      _WorldMap(state: state, regions: regions),
      const SectionTitle('Regiones'),
      for (final r in regions) PageTile(page: r, state: state),
    ]);
  }
}

class _WorldMap extends StatelessWidget {
  const _WorldMap({required this.state, required this.regions});
  final AppState state;
  final List<DiaryPage> regions;

  @override
  Widget build(BuildContext context) => Container(
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [K.night, K.forest]),
        ),
        child: LayoutBuilder(builder: (context, bc) {
          final w = bc.maxWidth, h = bc.maxHeight;
          final center = Offset(w / 2, h / 2 - 6);
          // Sendero (izq.), Laguna (arriba), Copas (der.), Jardín (abajo)
          final spots = [
            Offset(56, h / 2 - 6),
            Offset(w / 2, 52),
            Offset(w - 56, h / 2 - 6),
            Offset(w / 2, h - 72),
          ];
          return Stack(clipBehavior: Clip.none, children: [
            Positioned.fill(child: CustomPaint(painter: _LinePainter(center, spots))),
            Positioned(
              left: center.dx - 38,
              top: center.dy - 38,
              child: Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: K.night,
                  border: Border.all(color: state.rescued ? K.gold : K.line, width: 3),
                  boxShadow: state.rescued ? [BoxShadow(color: K.gold.withValues(alpha: .5), blurRadius: 16)] : null,
                ),
                child: const Text('🍄', style: TextStyle(fontSize: 34)),
              ),
            ),
            for (var i = 0; i < regions.length && i < 4; i++)
              Positioned(
                left: spots[i].dx - 50,
                top: spots[i].dy - 36,
                width: 100,
                child: _Node(page: regions[i], state: state),
              ),
          ]);
        }),
      );
}

class _Node extends StatelessWidget {
  const _Node({required this.page, required this.state});
  final DiaryPage page;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final open = !page.locked;
    return GestureDetector(
      onTap: () => openPage(context, state, page),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: open ? K.forest : K.bramble,
            border: Border.all(color: open ? K.magic : K.magenta, width: 3),
            boxShadow: open ? [BoxShadow(color: K.magic.withValues(alpha: .5), blurRadius: 14)] : null,
          ),
          child: ClipOval(
            child: Opacity(
              opacity: open ? 1 : .55,
              child: page.image != null
                  ? Image.asset(page.image!,
                      width: 66, height: 66, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Text(page.emoji, style: const TextStyle(fontSize: 30)))
                  : Text(page.emoji, style: const TextStyle(fontSize: 30)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(page.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: K.body(10, color: K.paper, w: FontWeight.w800)),
      ]),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.center, this.spots);
  final Offset center;
  final List<Offset> spots;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < spots.length; i++) {
      final p = Paint()..style = PaintingStyle.stroke;
      if (i == 0) {
        p.strokeWidth = 4;
        p.color = K.magic;
      } else {
        p.strokeWidth = 3;
        p.color = K.rose.withValues(alpha: .45);
      }
      canvas.drawLine(center, spots[i], p);
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => true;
}

// ------------------------------------------------------------------ Archivo
class ArchivoTab extends StatelessWidget {
  const ArchivoTab({super.key, required this.state});
  final AppState state;

  Widget _list(List<DiaryPage> pages, {String? footer}) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final p in pages) PageTile(page: p, state: state),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(footer, textAlign: TextAlign.center, style: K.serif(13, color: K.muted)),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Column(children: [
          // Banner del Archivo (inspiración, p. 2): "Kimaya: El Bosque del
          // Eco / Diario del Bosque, Archivo de Maya · Vol. I".
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: K.gold, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/images/encabezado_diario_del_bosque.png',
                  width: double.infinity,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 96,
                    alignment: Alignment.center,
                    color: K.night,
                    child: Text('Kimaya: El Bosque del Eco',
                        style: K.title(11, color: K.paper)),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: K.card,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: K.forest,
              unselectedLabelColor: K.muted,
              indicatorColor: K.gold,
              labelStyle: K.body(13, w: FontWeight.w800),
              tabs: const [
                Tab(icon: Icon(Icons.pets), text: 'Personajes'),
                Tab(icon: Icon(Icons.landscape), text: 'Lugares'),
                Tab(icon: Icon(Icons.auto_awesome), text: 'Magia y objetos'),
                Tab(icon: Icon(Icons.bug_report), text: 'Criaturas'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(children: [
              _list(state.all('personaje')),
              // Lugares ya incluye Bosque, Círculo de hongos, Círculo
              // central, Sendero, Laguna, Copas y Jardín de la Bruma; no
              // se mezclan con las regiones del Mundo para no duplicar.
              _list(state.all('lugar')),
              _list(state.all('magia')),
              _list(
                [state.byKey('personaje_maya'), ...state.all('criatura')],
                footer: 'El bestiario crecerá cuando Maya vea más.',
              ),
            ]),
          ),
        ]),
      );
}
