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
          BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 3))
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
        child: Text(text,
            style: K.body(11, color: K.paper, w: FontWeight.w800)),
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
            if (trailing != null) Text(trailing!, style: K.body(12, color: K.muted)),
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
            color: const Color(0xFFDCE9D4), borderRadius: BorderRadius.circular(999)),
        child: Text(text, style: K.body(12, color: const Color(0xFF365C47), w: FontWeight.w800)),
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
                  Text(label, style: K.body(12, color: K.moss, w: FontWeight.w800)),
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
  const Cover(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [K.bramble, K.violet]),
        ),
        child: Column(children: [
          const Text('🕸️', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 10),
          Text('Por descubrir', style: K.title(11, color: K.rose)),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: K.body(14, color: K.paper)),
        ]),
      );
}

/// Cuatro runas. El estado se marca con color Y forma (dorado + check / apagada + candado).
class RuneRow extends StatelessWidget {
  const RuneRow({super.key, required this.firstActive});
  final bool firstActive;
  static const _runes = [('✦', 'Raíces'), ('◇', 'Laguna'), ('⌁', 'Copas'), ('❋', 'Bruma')];

  @override
  Widget build(BuildContext context) => Row(children: [
        for (var i = 0; i < 4; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
              child: Semantics(
                label: 'Runa ${_runes[i].$2}, ${i == 0 && firstActive ? "despierta" : "apagada"}',
                child: _Rune(glyph: _runes[i].$1, name: _runes[i].$2, on: i == 0 && firstActive),
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
            boxShadow: on ? [BoxShadow(color: K.gold.withValues(alpha: .45), blurRadius: 14)] : null,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(glyph,
                style: TextStyle(
                    fontSize: 24,
                    color: on ? const Color(0xFFA47C22) : const Color(0xFF819087))),
            Text(name, style: K.body(10, color: K.muted, w: FontWeight.w700)),
            Icon(on ? Icons.check_circle : Icons.lock_outline,
                size: 13, color: on ? const Color(0xFFA47C22) : const Color(0xFF819087)),
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
        : (page.body.isNotEmpty ? page.body : (page.meta['Papel'] ?? page.meta['Estado'] ?? ''));
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
            child: const Text('🌫️', style: TextStyle(fontSize: 24)),
          )
        else
          PageImage(page, width: 64, height: 64, borderRadius: 10),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(
                child: Text(title,
                    style: K.body(15,
                        color: covered ? K.paper : K.night, w: FontWeight.w800)),
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
                  style: K.body(12, color: covered ? const Color(0xFFD9C6E0) : K.muted)),
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
    MaterialPageRoute(builder: (_) => DetailScreen(state: state, page: state.resolve(page))),
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
    final status = state.statusFor(page);
    final heading =
        covered && page.category == 'capitulo' ? 'Capítulo ${page.order}' : page.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(heading,
            maxLines: 2, overflow: TextOverflow.ellipsis, style: K.title(11, color: K.paper)),
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
              child: const Text('🌫️', style: TextStyle(fontSize: 38)),
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
          Cover(coverText(page.key)),
          const SizedBox(height: 12),
          // El Jardín de la Bruma lleva su emblema aunque esté por descubrir.
          if (page.emblem != null) ...[
            Center(
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(page.emblem!,
                      width: 180,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                ),
                const SizedBox(height: 6),
                Text('Emblema de niebla encantada',
                    style: K.body(12, color: K.muted, w: FontWeight.w800)),
              ]),
            ),
            const SizedBox(height: 12),
          ],
          if (locked && page.note != null) MayaNote(page.note!, label: 'Adelanto de Maya'),
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
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(page.emblem!,
                      width: 180,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                ),
                const SizedBox(height: 6),
                Text('Emblema de niebla encantada',
                    style: K.body(12, color: K.muted, w: FontWeight.w800)),
              ]),
            ),
          ],
          const SizedBox(height: 14),
          for (final e in page.meta.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: '${e.key}: ', style: K.body(14, w: FontWeight.w800)),
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
            Wrap(spacing: 6, runSpacing: 6, children: [for (final i in e.value) Pill(i)]),
            const SizedBox(height: 14),
          ],
          if (page.note != null) MayaNote(page.note!),
        ],
      ]),
    );
  }
}
