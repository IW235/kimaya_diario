import 'package:flutter/material.dart';

import '../theme.dart';

/// Muestra solamente una región normalizada de un asset sin modificarlo.
/// Permite reutilizar las ilustraciones grandes como piezas visuales.
class AssetCrop extends StatelessWidget {
  const AssetCrop({
    super.key,
    required this.asset,
    required this.region,
    this.fit = BoxFit.fill,
  });

  final String asset;
  final Rect region;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final fullWidth = constraints.maxWidth / region.width;
          final fullHeight = constraints.maxHeight / region.height;
          return ClipRect(
            child: SizedBox.expand(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: -region.left * fullWidth,
                    top: -region.top * fullHeight,
                    width: fullWidth,
                    height: fullHeight,
                    child: Image.asset(
                      asset,
                      fit: fit,
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class KimayaHeader extends StatelessWidget {
  const KimayaHeader({super.key, required this.onSettings});
  final VoidCallback onSettings;

  static const _asset = 'assets/images/bosque_nocturno_chispas.png';

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1672 / 483,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AssetCrop(
              asset: _asset,
              // El archivo conserva franjas blancas fuera de la ilustración.
              region: Rect.fromLTWH(0, .178, 1, .513),
            ),
            Positioned(
              top: 10,
              right: 58,
              child: _RoundHeaderButton(
                tooltip: 'Ajustes',
                icon: Icons.settings_rounded,
                onPressed: onSettings,
              ),
            ),
            const Positioned(
              top: 10,
              right: 10,
              child: _RoundHeaderButton(
                tooltip: 'Maya',
                label: '🧚',
              ),
            ),
          ],
        ),
      );
}

class JournalHeader extends StatelessWidget {
  const JournalHeader({super.key, required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = width / (890 / 200);
    return ColoredBox(
      color: K.night,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/encabezado_diario_del_bosque.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                filterQuality: FilterQuality.none,
                semanticLabel:
                    'Diario del Bosque. Archivo de Maya, volumen uno',
              ),
              Positioned(
                top: (height - 42) / 2,
                right: 10,
                child: Row(
                  children: [
                    _JournalHeaderButton(
                      label: 'Ajustes y créditos',
                      icon: Icons.settings_rounded,
                      onTap: onSettings,
                    ),
                    const SizedBox(width: 7),
                    const _JournalHeaderButton(
                        label: 'Maya',
                        image: 'assets/images/maya_retrato_sin_fondo.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalHeaderButton extends StatelessWidget {
  const _JournalHeaderButton({
    required this.label,
    this.icon,
    this.image,
    this.onTap,
  }) : emoji = null;

  final String label;
  final IconData? icon;
  final String? emoji;
  final String? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: onTap != null,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0E332F),
              border: Border.all(color: K.gold, width: 2),
            ),
            child: image != null
                ? ClipOval(
                    child: Image.asset(
                      image!,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Text('🧚', style: TextStyle(fontSize: 22)),
                    ),
                  )
                : icon != null
                    ? Icon(icon, color: K.paper, size: 23)
                    : Text(emoji!, style: const TextStyle(fontSize: 22)),
          ),
        ),
      );
}

class _RoundHeaderButton extends StatelessWidget {
  const _RoundHeaderButton({
    required this.tooltip,
    this.icon,
    this.label,
    this.onPressed,
  });

  final String tooltip;
  final IconData? icon;
  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: Material(
          color: K.night.withValues(alpha: .92),
          shape: const CircleBorder(side: BorderSide(color: K.gold, width: 2)),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 42,
              child: Center(
                child: icon != null
                    ? Icon(icon, color: K.paper, size: 23)
                    : Text(label!, style: const TextStyle(fontSize: 22)),
              ),
            ),
          ),
        ),
      );
}

class ForestHero extends StatelessWidget {
  const ForestHero({super.key});

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 5.5,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: K.gold, width: 2),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const AssetCrop(
                asset: 'assets/images/pantalla_bosque.png',
                region: Rect.fromLTWH(.07, .270, .86, .104),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC092F2B)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: Text(
                  'Un bosque que escucha lo que sentimos',
                  style: K.serif(15, color: K.paper),
                ),
              ),
            ],
          ),
        ),
      );
}

class FantasyPanel extends StatelessWidget {
  const FantasyPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFFFFF4D8),
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD69A2D), width: 2),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF9E9), Color(0xFFF7E5B8)],
            ),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 7,
                  offset: Offset(0, 3)),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
}

class FantasySectionTitle extends StatelessWidget {
  const FantasySectionTitle(this.title, {super.key, this.trailing});
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 22, 2, 10),
        child: Row(
          children: [
            const Text('❧', style: TextStyle(color: K.moss, fontSize: 22)),
            const SizedBox(width: 7),
            Expanded(child: Text(title, style: K.title(11))),
            if (trailing != null)
              Text(trailing!, style: K.body(12, color: K.muted)),
          ],
        ),
      );
}

class MayaNoteCard extends StatelessWidget {
  const MayaNoteCard(this.text, {super.key, this.label = 'Nota de Maya · hoy'});
  final String text;
  final String label;

  @override
  Widget build(BuildContext context) => FantasyPanel(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: K.gold, width: 2),
              ),
              child: const AssetCrop(
                asset: 'assets/images/pantalla_bosque.png',
                region: Rect.fromLTWH(.076, .414, .158, .105),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: K.moss,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(label,
                        style: K.body(12,
                            color: Colors.white, w: FontWeight.w800)),
                  ),
                  const SizedBox(height: 7),
                  Text('“$text”', style: K.serif(14)),
                  const SizedBox(height: 4),
                  Text('— Maya, guardiana del círculo',
                      style: K.body(11, color: K.muted)),
                ],
              ),
            ),
          ],
        ),
      );
}

class FantasyRuneGrid extends StatelessWidget {
  const FantasyRuneGrid({super.key, required this.firstActive, this.onTap});
  final bool firstActive;
  final VoidCallback? onTap;

  static const _runes = [
    ('✦', 'Raíces'),
    ('◇', 'Laguna'),
    ('⌁', 'Copas'),
    ('❋', 'Bruma'),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 560 ? 4 : 2;
          const spacing = 10.0;
          final cardWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (var i = 0; i < _runes.length; i++)
                SizedBox(
                  width: cardWidth,
                  child: _FantasyRune(
                    glyph: _runes[i].$1,
                    name: _runes[i].$2,
                    active: i == 0 && firstActive,
                    onTap: onTap,
                  ),
                ),
            ],
          );
        },
      );
}

class _FantasyRune extends StatelessWidget {
  const _FantasyRune({
    required this.glyph,
    required this.name,
    required this.active,
    this.onTap,
  });

  final String glyph;
  final String name;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: onTap != null,
        label: 'Runa $name, ${active ? "despierta" : "bloqueada"}',
        child: Material(
          color: const Color(0xFF394D52),
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(minHeight: 132),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: active ? K.gold : const Color(0xFF708077), width: 2),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF516268), Color(0xFF2D3E43)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    glyph,
                    style: TextStyle(
                      fontSize: 34,
                      color: active ? K.gold : const Color(0xFFE9D691),
                      shadows: const [
                        Shadow(color: Color(0xAAE6C568), blurRadius: 8)
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(name,
                      style: K.body(13, color: K.paper, w: FontWeight.w800)),
                  Icon(
                    active ? Icons.check_circle : Icons.lock_rounded,
                    color: active ? K.gold : K.paper,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class ExploreCard extends StatelessWidget {
  const ExploreCard({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => FantasyPanel(
        onTap: onTap,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                iconAsset,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: K.body(16, color: K.night, w: FontWeight.w900)),
                  Text(subtitle, style: K.body(12, color: K.ink)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFB26B0E), size: 34),
          ],
        ),
      );
}

class ResponsiveExploreGrid extends StatelessWidget {
  const ResponsiveExploreGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 620) {
            return Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1) const SizedBox(height: 10),
                ],
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                Expanded(child: children[i]),
                if (i < children.length - 1) const SizedBox(width: 12),
              ],
            ],
          );
        },
      );
}
