import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'content.dart';
import 'state.dart';
import 'theme.dart';

const _covers = [
  'El Zarzal cubre este registro.',
  'Maya aún no ha visitado este lugar.',
  'Se escucha algo detrás de la niebla.',
];
String coverText(String key) =>
    _covers[key.codeUnits.fold<int>(0, (a, b) => a + b) % _covers.length];

/// Mantiene una ilustración completa y rellena los espacios sobrantes con
/// una extensión desenfocada de la misma imagen, sin deformar el original.
class ArtworkBackdrop extends StatelessWidget {
  const ArtworkBackdrop({
    super.key,
    required this.asset,
    required this.child,
  });

  final String asset;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.low,
                ),
              ),
            ),
          ),
          const ColoredBox(color: Color(0x33001410)),
          child,
        ],
      );
}

/// Imagen de un asset con fallback al emoji si no carga (o si no hay imagen).
/// `boxFit` permite recortar escenas anchas y retratos cuadrados igual.
class PageImage extends StatelessWidget {
  const PageImage(this.page,
      {super.key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.borderRadius = 12});
  final DiaryPage page;
  final double? width, height;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final src = page.image;
    if (src == null) {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFC5D8B7),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(page.emoji, style: const TextStyle(fontSize: 24)),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        src,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFC5D8B7),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Text(page.emoji, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}

/// Imagen grande de la ficha (heroImage si existe, si no image).
class HeroImage extends StatelessWidget {
  const HeroImage(this.page, {super.key, this.height = 210});
  final DiaryPage page;
  final double height;

  @override
  Widget build(BuildContext context) {
    final src = page.heroImage ?? page.image;
    if (src == null) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: K.gold, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          src,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: double.infinity,
            height: height,
            alignment: Alignment.center,
            color: K.mossLight,
            child: Text(page.emoji, style: const TextStyle(fontSize: 48)),
          ),
        ),
      ),
    );
  }
}

/// Badge verde tipo "Jugable en la demo" / "No jugable en la demo".
class Badge extends StatelessWidget {
  const Badge(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: dark ? K.forest : const Color(0xFF2F624C),
          borderRadius: BorderRadius.circular(999),
        ),
        child:
            Text(text, style: K.body(11, color: K.paper, w: FontWeight.w800)),
      );
}

class PaperCard extends StatelessWidget {
  const PaperCard({super.key, required this.child, this.color, this.onTap});
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: color ?? K.card,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: K.line),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: const EdgeInsets.all(14), child: child),
          ),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(text, style: K.title(11))),
            if (trailing != null)
              Text(trailing!, style: K.body(12, color: K.muted)),
          ],
        ),
      );
}

class Pill extends StatelessWidget {
  const Pill(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: const Color(0xFFDCE9D4),
            borderRadius: BorderRadius.circular(999)),
        child: Text(text,
            style:
                K.body(12, color: const Color(0xFF365C47), w: FontWeight.w800)),
      );
}

/// Bloque tipo papel con la voz de Maya, con su retrato a un lado.
class MayaNote extends StatelessWidget {
  const MayaNote(this.text, {super.key, this.label = 'Nota de Maya'});
  final String text, label;

  @override
  Widget build(BuildContext context) => PaperCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/maya_retrato_sin_fondo.png',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Text('🧚', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: K.body(12, color: K.moss, w: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('“$text”', style: K.serif(15)),
                  const SizedBox(height: 6),
                  Text('— Maya, guardiana del círculo',
                      style: K.body(11, color: K.muted)),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Página dañada: así se ve lo que sigue "Por descubrir" (no es un botón apagado).
class Cover extends StatelessWidget {
  const Cover(this.text, {super.key, this.title});

  final String text;
  final String? title;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [K.bramble, K.violet]),
        ),
        child: Column(children: [
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: K.title(15, color: K.paper),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: K.magenta.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: K.magenta, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded, color: K.paper, size: 19),
                  const SizedBox(width: 8),
                  Text('Por descubrir',
                      style: K.body(13, color: K.paper, w: FontWeight.w800)),
                ],
              ),
            ),
          ] else ...[
            const Text('🕸️', style: TextStyle(fontSize: 34)),
            const SizedBox(height: 10),
            Text('Por descubrir', style: K.title(11, color: K.rose)),
          ],
          const SizedBox(height: 10),
          Text(text,
              textAlign: TextAlign.center, style: K.body(14, color: K.paper)),
        ]),
      );
}

/// Cuatro runas. El estado se marca con color Y forma (dorado + check / apagada + candado).
class RuneRow extends StatelessWidget {
  const RuneRow({super.key, required this.firstActive});
  final bool firstActive;
  static const _runes = [
    ('✦', 'Raíces'),
    ('◇', 'Laguna'),
    ('⌁', 'Copas'),
    ('❋', 'Bruma')
  ];

  @override
  Widget build(BuildContext context) => Row(children: [
        for (var i = 0; i < 4; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
              child: Semantics(
                label:
                    'Runa ${_runes[i].$2}, ${i == 0 && firstActive ? "despierta" : "apagada"}',
                child: _Rune(
                    glyph: _runes[i].$1,
                    name: _runes[i].$2,
                    on: i == 0 && firstActive),
              ),
            ),
          ),
      ]);
}

class _Rune extends StatelessWidget {
  const _Rune({required this.glyph, required this.name, required this.on});
  final String glyph, name;
  final bool on;
  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: on ? const Color(0xFFF5E3A7) : const Color(0xFFE9E0C4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: on ? K.gold : K.line, width: on ? 2 : 1),
            boxShadow: on
                ? [
                    BoxShadow(
                        color: K.gold.withValues(alpha: .45), blurRadius: 14)
                  ]
                : null,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(glyph,
                style: TextStyle(
                    fontSize: 24,
                    color: on
                        ? const Color(0xFFA47C22)
                        : const Color(0xFF819087))),
            Text(name, style: K.body(10, color: K.muted, w: FontWeight.w700)),
            Icon(on ? Icons.check_circle : Icons.lock_outline,
                size: 13,
                color: on ? const Color(0xFFA47C22) : const Color(0xFF819087)),
          ]),
        ),
      );
}

class PageTile extends StatelessWidget {
  const PageTile({super.key, required this.page, required this.state});
  final DiaryPage page;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final covered = page.locked || state.hidden(page);
    final isChapter = page.category == 'capitulo';
    final title = covered && isChapter
        ? 'Capítulo ${page.order}'
        : (isChapter ? '${page.order}. ${page.title}' : page.title);
    final sub = covered
        ? coverText(page.key)
        : (page.body.isNotEmpty
            ? page.body
            : (page.meta['Papel'] ?? page.meta['Estado'] ?? ''));
    // Badge como en la inspiración: "Jugable en la demo" / "No jugable en la
    // demo" (Papel) o el Estado del lugar. Zarzal usa su estado ("Activo").
    final badge = covered
        ? null
        : (page.meta['Papel'] ??
            page.meta['Estado'] ??
            (page.key == 'personaje_zarzal' ? 'Activo' : null));
    return PaperCard(
      color: covered ? K.bramble : K.card,
      onTap: () => openPage(context, state, page),
      child: Row(children: [
        if (covered)
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: K.violet, borderRadius: BorderRadius.circular(10)),
            child: page.emblem != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      page.emblem!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text('🌫️', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                  )
                : const Text('🌫️', style: TextStyle(fontSize: 24)),
          )
        else
          PageImage(page, width: 64, height: 64, borderRadius: 10),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                child: Text(title,
                    style: K.body(15,
                        color: covered ? K.paper : K.night,
                        w: FontWeight.w800)),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Badge(badge),
              ],
            ]),
            if (sub.isNotEmpty)
              Text(sub,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: K.body(12,
                      color: covered ? const Color(0xFFD9C6E0) : K.muted)),
          ]),
        ),
        Icon(Icons.chevron_right, color: covered ? K.rose : K.moss),
      ]),
    );
  }
}

void openPage(BuildContext context, AppState state, DiaryPage page) {
  state.visit(page.key);
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_) => DetailScreen(state: state, page: state.resolve(page))),
  );
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.state, required this.page});
  final AppState state;
  final DiaryPage page;

  @override
  Widget build(BuildContext context) {
    final locked = page.locked;
    final spoiler = state.hidden(page);
    final covered = locked || spoiler;
    if (!covered && page.key == 'lugar_bosque') {
      return _BosqueEcoScreen(page: page);
    }
    const illustratedPages = {
      'lugar_circulo_hongos',
      'lugar_circulo_central',
      'lugar_sendero_raices',
      'magia_pelota',
      'magia_runas',
      'magia_portales',
      'magia_diario',
      'magia_raices',
    };
    if (!covered && illustratedPages.contains(page.key)) {
      return _IllustratedArchiveScreen(
        page: page,
        status: state.statusFor(page) ?? page.meta['Estado'],
      );
    }
    const profilePages = {
      'personaje_falin',
      'personaje_mia',
      'personaje_kiara',
      'personaje_maya',
      'personaje_zarzal',
    };
    if (!covered && profilePages.contains(page.key)) {
      return _CharacterDetailScreen(
        page: page,
        status: state.statusFor(page) ?? 'Disponible',
      );
    }
    final status = state.statusFor(page);
    final heading = covered && page.category == 'capitulo'
        ? 'Capítulo ${page.order}'
        : page.title;
    final coveredImage =
        page.emblem ?? (page.category == 'criatura' ? page.heroImage : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(heading,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: K.title(11, color: K.paper)),
      ),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        // Imagen grande de la ficha (inspiración pp. 4, 7-8, 10). En las
        // fichas bloqueadas no se muestra la imagen: sigue "Por descubrir".
        if (!covered && (page.heroImage ?? page.image) != null) ...[
          HeroImage(page),
          const SizedBox(height: 14),
        ] else if (covered)
          Center(
            child: Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: K.bramble,
                shape: BoxShape.circle,
                border: Border.all(color: K.magenta, width: 2),
              ),
              child: coveredImage != null
                  ? ClipOval(
                      child: Image.asset(
                        coveredImage,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (_, __, ___) => const Text(
                          '🌫️',
                          style: TextStyle(fontSize: 38),
                        ),
                      ),
                    )
                  : const Text('🌫️', style: TextStyle(fontSize: 38)),
            ),
          ),
        if (!covered) ...[
          // Placa con el nombre, como en las fichas de la inspiración.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: K.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: K.gold, width: 2),
            ),
            child: Text(page.title,
                textAlign: TextAlign.center, style: K.title(13)),
          ),
          const SizedBox(height: 10),
        ],
        if (covered) ...[
          Cover(
            coverText(page.key),
            title: page.emblem != null || page.category == 'criatura'
                ? page.title
                : null,
          ),
          const SizedBox(height: 12),
          if (locked && page.note != null)
            MayaNote(page.note!, label: 'Adelanto de Maya'),
          if (spoiler)
            FilledButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                await state.setProgress(Progress.rescued);
                nav.pop();
              },
              child: const Text('Ya terminé la demo'),
            ),
        ] else ...[
          if (status != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Center(child: Pill('Estado: $status')),
            ),
          if (page.emblem != null) ...[
            const SizedBox(height: 12),
            Center(
              child: ClipOval(
                child: Image.asset(
                  page.emblem!,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          for (final e in page.meta.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: '${e.key}: ', style: K.body(14, w: FontWeight.w800)),
                TextSpan(text: e.value, style: K.body(14)),
              ])),
            ),
          if (page.body.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(page.body, style: K.body(15)),
            ),
          for (final e in page.lists.entries) ...[
            const SizedBox(height: 6),
            Text(e.key, style: K.title(10, color: K.forest)),
            const SizedBox(height: 8),
            Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [for (final i in e.value) Pill(i)]),
            const SizedBox(height: 14),
          ],
          if (page.note != null) MayaNote(page.note!),
        ],
      ]),
    );
  }
}

class _CharacterDetailScreen extends StatelessWidget {
  const _CharacterDetailScreen({required this.page, required this.status});

  final DiaryPage page;
  final String status;

  @override
  Widget build(BuildContext context) {
    final heroAsset = page.key == 'personaje_maya'
        ? 'assets/images/maya_escena.png'
        : (page.heroImage ?? page.image);
    final containHero = page.key == 'personaje_zarzal';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(page.title, style: K.title(11, color: K.paper)),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF9E8), Color(0xFFF4E3B6)],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(26),
                      ),
                      child: AspectRatio(
                        aspectRatio: 838 / 275,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF082F2C), Color(0xFF0B5148)],
                            ),
                          ),
                          child: heroAsset == null
                              ? Center(
                                  child: Text(
                                    page.emoji,
                                    style: const TextStyle(fontSize: 82),
                                  ),
                                )
                              : Image.asset(
                                  heroAsset,
                                  fit: containHero
                                      ? BoxFit.contain
                                      : BoxFit.cover,
                                  alignment: Alignment.center,
                                  filterQuality: FilterQuality.none,
                                  semanticLabel:
                                      '${page.title} en el Bosque del Eco',
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(
                                      page.emoji,
                                      style: const TextStyle(fontSize: 82),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: K.title(18),
                          ),
                          const SizedBox(height: 8),
                          Center(child: _MayaStatus(status)),
                          const SizedBox(height: 16),
                          _MayaProfilePanel(page: page),
                          if (page.note != null) ...[
                            const SizedBox(height: 16),
                            _MayaQuotePanel(text: page.note!),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MayaStatus extends StatelessWidget {
  const _MayaStatus(this.status);

  final String status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFDCEDE1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFB7D5BE)),
        ),
        child: Text(
          'Estado: $status',
          style: K.body(14, color: K.night, w: FontWeight.w900),
        ),
      );
}

class _MayaProfilePanel extends StatelessWidget {
  const _MayaProfilePanel({required this.page});

  final DiaryPage page;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAEC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFD5BA72), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in page.meta.entries) ...[
              _MayaFact(
                icon: entry.key == 'Especie' ? '🦋' : '📖',
                label: entry.key,
                value: entry.value,
              ),
              const SizedBox(height: 8),
            ],
            const Divider(color: Color(0xFFD5BA72), height: 20),
            Text(page.body, style: K.body(15)),
            const SizedBox(height: 16),
            for (final entry in page.lists.entries) ...[
              _MayaTagGroup(
                title: entry.key,
                icon: '🌿',
                values: entry.value,
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      );
}

class _MayaFact extends StatelessWidget {
  const _MayaFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: K.body(14, color: K.ink, w: FontWeight.w900),
                  ),
                  TextSpan(text: value, style: K.body(14)),
                ],
              ),
            ),
          ),
        ],
      );
}

class _MayaTagGroup extends StatelessWidget {
  const _MayaTagGroup({
    required this.title,
    required this.icon,
    required this.values,
  });

  final String title;
  final String icon;
  final List<String> values;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(title, style: K.title(10, color: K.forest)),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in values)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDECDD),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    value,
                    style: K.body(12, color: K.night, w: FontWeight.w800),
                  ),
                ),
            ],
          ),
        ],
      );
}

class _MayaQuotePanel extends StatelessWidget {
  const _MayaQuotePanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCF1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFBEA15B), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📖', style: TextStyle(fontSize: 25)),
                const SizedBox(width: 9),
                Text(
                  'Nota de Maya',
                  style: K.body(17, color: K.moss, w: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('“$text”', style: K.serif(16)),
            const SizedBox(height: 8),
            Text(
              '— Maya, guardiana del círculo',
              style: K.body(12, color: K.muted),
            ),
          ],
        ),
      );
}

class _BosqueEcoScreen extends StatelessWidget {
  const _BosqueEcoScreen({required this.page});

  final DiaryPage page;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '❧  Bosque del Eco  ❧',
            style: K.title(10, color: K.paper),
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF7DF), Color(0xFFF2DFAF)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _AncestralTreeHero(),
                      const SizedBox(height: 12),
                      Center(
                        child: _ForestStatus(
                          page.meta['Estado'] ?? 'Disponible',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ForestDescription(text: page.body),
                      if (page.note != null) ...[
                        const SizedBox(height: 18),
                        _ForestMayaNote(text: page.note!),
                      ],
                      const SizedBox(height: 18),
                      const Text(
                        '🌿     ✦     💎     ✦     🌿',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, color: K.forest),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _AncestralTreeHero extends StatelessWidget {
  const _AncestralTreeHero();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AspectRatio(
              aspectRatio: 2.05,
              child: Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: K.gold, width: 3),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0A4946), Color(0xFF102E27)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x44000000),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Semantics(
                  image: true,
                  label: 'Árbol ancestral del Bosque del Eco',
                  child: Image.asset(
                    'assets/images/arbol_ancestral.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    filterQuality: FilterQuality.none,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 34,
              right: 34,
              bottom: -25,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFC98616), width: 2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF8E4), Color(0xFFF3D898)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Bosque del Eco',
                  textAlign: TextAlign.center,
                  style: K.title(10),
                ),
              ),
            ),
          ],
        ),
      );
}

class _ForestStatus extends StatelessWidget {
  const _ForestStatus(this.status);

  final String status;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFD9F2B8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFA8CF73)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 7),
            Text(
              'Estado: $status',
              style: K.body(13, color: K.forest, w: FontWeight.w900),
            ),
          ],
        ),
      );
}

class _ForestDescription extends StatelessWidget {
  const _ForestDescription({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD99A22), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📖', style: TextStyle(fontSize: 27)),
                const SizedBox(width: 9),
                Text('Descripción', style: K.title(9, color: K.forest)),
              ],
            ),
            const Divider(color: Color(0xFFD99A22), height: 18),
            Text(text, style: K.body(15)),
          ],
        ),
      );
}

class _ForestMayaNote extends StatelessWidget {
  const _ForestMayaNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final portraitWidth = constraints.maxWidth >= 600 ? 180.0 : 104.0;
          return Container(
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.fromLTRB(16, 13, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB7C77A), width: 2),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBE9), Color(0xFFEAF4DB)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCECB9),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFAFC06B)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪶', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        'Nota de Maya',
                        style: K.body(
                          13,
                          color: K.forest,
                          w: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('“$text”', style: K.serif(14)),
                            const SizedBox(height: 7),
                            Text(
                              '— Maya, guardiana del círculo',
                              style: K.body(11, color: K.muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Semantics(
                      image: true,
                      label: 'Retrato de Maya',
                      child: Image.asset(
                        'assets/images/maya_retrato_sin_fondo.png',
                        width: portraitWidth,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
}

class _IllustratedArchiveScreen extends StatelessWidget {
  const _IllustratedArchiveScreen({required this.page, this.status});

  final DiaryPage page;
  final String? status;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '❧  ${page.title}  ❧',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: K.title(10, color: K.paper),
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF7DF), Color(0xFFF2DFAF)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _IllustratedArchiveHero(page: page),
                      if (status != null) ...[
                        const SizedBox(height: 12),
                        Center(child: _ForestStatus(status!)),
                      ],
                      const SizedBox(height: 16),
                      _ForestDescription(text: page.body),
                      if (page.meta.entries
                          .any((entry) => entry.key != 'Estado')) ...[
                        const SizedBox(height: 16),
                        _ArchiveDetailsPanel(
                          title: 'Detalles',
                          icon: '✦',
                          entries: page.meta.entries
                              .where((entry) => entry.key != 'Estado')
                              .toList(),
                        ),
                      ],
                      for (final entry in page.lists.entries) ...[
                        const SizedBox(height: 16),
                        _ArchiveListPanel(
                          title: entry.key,
                          values: entry.value,
                        ),
                      ],
                      if (page.note != null) ...[
                        const SizedBox(height: 18),
                        _ForestMayaNote(text: page.note!),
                      ],
                      const SizedBox(height: 18),
                      const Text(
                        '🌿     ✦     💎     ✦     🌿',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, color: K.forest),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _IllustratedArchiveHero extends StatelessWidget {
  const _IllustratedArchiveHero({required this.page});

  final DiaryPage page;

  @override
  Widget build(BuildContext context) {
    final asset = page.heroImage ?? page.image;
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AspectRatio(
            aspectRatio: 2.05,
            child: Container(
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: K.gold, width: 3),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A4946), Color(0xFF102E27)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: asset == null
                  ? Center(
                      child: Text(
                        page.emoji,
                        style: const TextStyle(fontSize: 72),
                      ),
                    )
                  : Image.asset(
                      asset,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.none,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          page.emoji,
                          style: const TextStyle(fontSize: 72),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            left: 34,
            right: 34,
            bottom: -25,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFC98616), width: 2),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8E4), Color(0xFFF3D898)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: K.title(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveDetailsPanel extends StatelessWidget {
  const _ArchiveDetailsPanel({
    required this.title,
    required this.icon,
    required this.entries,
  });

  final String title;
  final String icon;
  final List<MapEntry<String, String>> entries;

  @override
  Widget build(BuildContext context) => _ArchivePanel(
        title: title,
        icon: icon,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${entries[i].key}: ',
                      style: K.body(13, color: K.forest, w: FontWeight.w900),
                    ),
                    TextSpan(text: entries[i].value, style: K.body(13)),
                  ],
                ),
              ),
              if (i < entries.length - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      );
}

class _ArchiveListPanel extends StatelessWidget {
  const _ArchiveListPanel({required this.title, required this.values});

  final String title;
  final List<String> values;

  @override
  Widget build(BuildContext context) => _ArchivePanel(
        title: title,
        icon: '🌿',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F0CF),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFB7C77A)),
                ),
                child: Text(
                  value,
                  style: K.body(12, color: K.forest, w: FontWeight.w800),
                ),
              ),
          ],
        ),
      );
}

class _ArchivePanel extends StatelessWidget {
  const _ArchivePanel({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final String icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD99A22), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 25)),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(title, style: K.title(9, color: K.forest)),
                ),
              ],
            ),
            const Divider(color: Color(0xFFD99A22), height: 18),
            child,
          ],
        ),
      );
}
