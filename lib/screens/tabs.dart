import 'package:flutter/material.dart';

import '../common.dart';
import '../content.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/kimaya_art.dart';

// ------------------------------------------------------------------ Inicio
class InicioTab extends StatelessWidget {
  const InicioTab({
    super.key,
    required this.state,
    required this.goto,
    required this.onSettings,
  });
  final AppState state;
  final void Function(int) goto;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final last = state.lastPage;
    final curiosity = kCuriosities[DateTime.now().day % kCuriosities.length];
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        KimayaHeader(onSettings: onSettings),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('¡Qué bueno verte!',
                      textAlign: TextAlign.center, style: K.title(16)),
                  const SizedBox(height: 5),
                  Text(
                    'Maya dejó una nota nueva para ti.',
                    textAlign: TextAlign.center,
                    style: K.body(14, color: K.muted),
                  ),
                  const SizedBox(height: 16),
                  const ForestHero(),
                  const SizedBox(height: 14),
                  const MayaNoteCard(kHomeQuote),
                  FantasySectionTitle(
                    'Las cuatro runas',
                    trailing: state.rescued
                        ? '1 de 4 despierta'
                        : '0 de 4 despiertan',
                  ),
                  FantasyRuneGrid(
                    firstActive: state.rescued,
                    onTap: () => goto(2),
                  ),
                  if (last != null) ...[
                    const FantasySectionTitle('Última página consultada'),
                    PageTile(page: last, state: state),
                  ],
                  const FantasySectionTitle('Continúa explorando'),
                  ResponsiveExploreGrid(
                    children: [
                      ExploreCard(
                        iconAsset: 'assets/images/icono_hermanas.png',
                        title: 'Las hermanas',
                        subtitle: 'Conoce a Falin, Mia y Kiara.',
                        onTap: () => goto(3),
                      ),
                      ExploreCard(
                        iconAsset: 'assets/images/icono_circulo_hongos.png',
                        title: 'El círculo de hongos',
                        subtitle: 'El comienzo de una aventura inesperada.',
                        onTap: () => openPage(
                          context,
                          state,
                          state.byKey('lugar_circulo_hongos'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MayaNoteCard(curiosity, label: 'Curiosidad del día'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ Diario
class DiarioTab extends StatelessWidget {
  const DiarioTab({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(16), children: [
        Text('Diario de Maya', style: K.title(14)),
        const SizedBox(height: 6),
        Text('Capítulos cortos, en el orden en que ocurrieron.',
            style: K.body(13, color: K.muted)),
        const SizedBox(height: 12),
        if (!state.rescued)
          PaperCard(
            color: K.bramble,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Las raíces cubren los capítulos que cuentan el desenlace, para que no te los cuente antes de tiempo.',
                style: K.body(13, color: K.paper),
              ),
              const SizedBox(height: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: K.coral, foregroundColor: K.ink),
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
      Text('Toca una región para abrir su página.',
          style: K.body(13, color: K.muted)),
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [K.night, K.forest]),
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
            Positioned.fill(
                child: CustomPaint(painter: _LinePainter(center, spots))),
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
                  border: Border.all(
                      color: state.rescued ? K.gold : K.line, width: 3),
                  boxShadow: state.rescued
                      ? [
                          BoxShadow(
                              color: K.gold.withValues(alpha: .5),
                              blurRadius: 16)
                        ]
                      : null,
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
            boxShadow: open
                ? [
                    BoxShadow(
                        color: K.magic.withValues(alpha: .5), blurRadius: 14)
                  ]
                : null,
          ),
          child: Opacity(
              opacity: open ? 1 : .55,
              child: Text(page.emoji, style: const TextStyle(fontSize: 30))),
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
              child: Text(footer,
                  textAlign: TextAlign.center,
                  style: K.serif(13, color: K.muted)),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Column(children: [
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
                Tab(text: 'Personajes'),
                Tab(text: 'Lugares'),
                Tab(text: 'Magia y objetos'),
                Tab(text: 'Criaturas'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(children: [
              _list(state.all('personaje')),
              _list([...state.all('lugar'), ...state.all('region')]),
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
