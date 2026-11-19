import 'package:flutter/material.dart';

import '../common.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets/kimaya_art.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.state});
  final AppState state;

  Future<void> _pick(BuildContext context, Progress progress) async {
    final navigator = Navigator.of(context);
    await state.setProgress(progress);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: K.night,
        body: ArtworkBackdrop(
          asset: 'assets/images/menu_aventura.png',
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton.filled(
                          tooltip: 'Volver',
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: K.night.withValues(alpha: .88),
                            foregroundColor: K.paper,
                            side: const BorderSide(color: K.gold, width: 2),
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FantasyPanel(
                        padding: const EdgeInsets.fromLTRB(18, 26, 18, 24),
                        child: Column(
                          children: [
                            const Icon(Icons.auto_awesome,
                                color: K.gold, size: 30),
                            const SizedBox(height: 8),
                            Text(
                              '¿En qué parte de la aventura\nte encuentras?',
                              textAlign: TextAlign.center,
                              style:
                                  K.title(15, color: const Color(0xFF461B10)),
                            ),
                            const SizedBox(height: 18),
                            const _OrnamentDivider(),
                            const SizedBox(height: 20),
                            _ProgressChoiceCard(
                              label: 'Aún no he jugado la demo',
                              description:
                                  'Quiero comenzar la aventura desde el inicio.',
                              assetRegion:
                                  const Rect.fromLTWH(.135, .405, .19, .12),
                              selected: !state.rescued,
                              onTap: () => _pick(context, Progress.notPlayed),
                            ),
                            const SizedBox(height: 14),
                            _ProgressChoiceCard(
                              label: '¡Rescaté a Kiara!',
                              description:
                                  'Ya jugué la demo y quiero continuar desde donde me quedé.',
                              assetRegion:
                                  const Rect.fromLTWH(.14, .608, .19, .13),
                              selected: state.rescued,
                              onTap: () => _pick(context, Progress.rescued),
                            ),
                            const SizedBox(height: 18),
                            const _OrnamentDivider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _OrnamentDivider extends StatelessWidget {
  const _OrnamentDivider();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
              child: Divider(color: Color(0xFFD49B24), thickness: 2)),
          const SizedBox(width: 12),
          Transform.rotate(
            angle: .78,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: K.magic,
                border: Border.all(color: const Color(0xFFC97808), width: 2),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
              child: Divider(color: Color(0xFFD49B24), thickness: 2)),
        ],
      );
}

class _ProgressChoiceCard extends StatelessWidget {
  const _ProgressChoiceCard({
    required this.label,
    required this.description,
    required this.assetRegion,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description;
  final Rect assetRegion;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        label: label,
        child: Material(
          color: const Color(0xFFFFF7E5),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: selected ? K.magic : const Color(0xFFD69420),
              width: selected ? 3 : 2,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 88,
                    child: AssetCrop(
                      asset: 'assets/images/menu_aventura.png',
                      region: assetRegion,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 76,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    color: const Color(0xFFE4A22C),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: K.body(18,
                              color: const Color(0xFF40170E),
                              w: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: K.serif(14, color: const Color(0xFF40170E)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFFC06A00), size: 38),
                ],
              ),
            ),
          ),
        ),
      );
}
