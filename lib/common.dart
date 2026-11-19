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

/// Bloque tipo papel con la voz de Maya.
class MayaNote extends StatelessWidget {
  const MayaNote(this.text, {super.key, this.label = 'Nota de Maya'});
  final String text, label;

  @override
  Widget build(BuildContext context) => PaperCard(
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [K.bramble, K.violet]),
        ),
        child: Column(children: [
          const Text('🕸️', style: TextStyle(fontSize: 34)),
          const SizedBox(height: 10),
          Text('Por descubrir', style: K.title(11, color: K.rose)),
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
        : (page.meta['Papel'] ?? page.meta['Estado'] ?? page.body);
    return PaperCard(
      color: covered ? K.bramble : K.mossLight,
      onTap: () => openPage(context, state, page),
      child: Row(children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: covered ? K.violet : const Color(0xFFC5D8B7),
              borderRadius: BorderRadius.circular(10)),
          child: Text(covered ? '🌫️' : page.emoji,
              style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: K.body(15,
                    color: covered ? K.paper : K.night, w: FontWeight.w800)),
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
    final status = state.statusFor(page);
    final heading = covered && page.category == 'capitulo'
        ? 'Capítulo ${page.order}'
        : page.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(heading,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: K.title(11, color: K.paper)),
      ),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        Center(
          child: Container(
            width: 84,
            height: 84,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: covered ? K.bramble : K.mossLight,
              shape: BoxShape.circle,
              border: Border.all(color: covered ? K.magenta : K.moss, width: 2),
            ),
            child: Text(covered ? '🌫️' : page.emoji,
                style: const TextStyle(fontSize: 38)),
          ),
        ),
        const SizedBox(height: 16),
        if (covered) ...[
          Cover(coverText(page.key)),
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
          Text(page.title, textAlign: TextAlign.center, style: K.title(13)),
          if (status != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(child: Pill('Estado: $status')),
            ),
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
