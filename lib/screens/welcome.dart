import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../common.dart';
import '../state.dart';
import '../theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.state});
  final AppState state;
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 24))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [K.violet, K.night, K.forest]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              const Spacer(),
              SizedBox(
                width: 230,
                height: 230,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (_, __) {
                    final t = reduce ? 0.0 : _c.value * 2 * math.pi;
                    return Stack(alignment: Alignment.center, children: [
                      for (var i = 0; i < 8; i++)
                        Transform.translate(
                          offset: Offset(math.cos(t + i * math.pi / 4) * 90,
                              math.sin(t + i * math.pi / 4) * 90),
                          child: const Text('🍄', style: TextStyle(fontSize: 28)),
                        ),
                      Transform.scale(
                        scale: 1 + 0.12 * math.sin(t * 12),
                        child: const Text('✨', style: TextStyle(fontSize: 44)),
                      ),
                    ]);
                  },
                ),
              ),
              const SizedBox(height: 18),
              Text('KIMAYA', style: K.title(26, color: K.gold)),
              const SizedBox(height: 10),
              Text('Diario del Bosque del Eco', style: K.body(16, color: K.paper, w: FontWeight.w700)),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: K.card.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: K.magic.withValues(alpha: .6)),
                ),
                child: Text(
                  '🧚 “¡Lo encontraste! Este diario contiene todo lo que he logrado registrar sobre el Bosque del Eco. Algunas páginas están completas. Otras… bueno, será mejor que las descubramos juntos.”',
                  style: K.serif(14, color: K.paper),
                ),
              ),
              const Spacer(),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: K.gold,
                    foregroundColor: K.ink,
                    minimumSize: const Size.fromHeight(54)),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProgressScreen(state: widget.state)),
                ),
                child: Text('Abrir el diario', style: K.title(12, color: K.ink)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// "¿En qué parte de la aventura te encuentras?" — evita spoilers.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.state, this.fromSettings = false});
  final AppState state;
  final bool fromSettings;

  Future<void> _pick(BuildContext context, Progress p) async {
    final nav = Navigator.of(context);
    await state.setProgress(p);
    if (fromSettings) {
      nav.pop();
    } else {
      nav.popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Tu progreso', style: K.title(12, color: K.paper))),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('¿En qué parte de la aventura te encuentras?', style: K.title(13)),
            const SizedBox(height: 10),
            Text('Así evito contarte cosas antes de tiempo. Puedes cambiarlo cuando quieras.',
                style: K.body(14, color: K.muted)),
            const SizedBox(height: 22),
            PaperCard(
              onTap: () => _pick(context, Progress.notPlayed),
              child: const _Option('🌱', 'Todavía no he jugado la demo',
                  'Te presento la premisa. El rescate queda oculto y Kiara aparece como desaparecida.'),
            ),
            PaperCard(
              onTap: () => _pick(context, Progress.rescued),
              child: const _Option('✦', 'Ya rescaté a Kiara',
                  'Se abren todas las páginas, se enciende la primera runa y se desbloquean notas de Maya.'),
            ),
          ]),
        ),
      );
}

class _Option extends StatelessWidget {
  const _Option(this.emoji, this.title, this.sub);
  final String emoji, title, sub;
  @override
  Widget build(BuildContext context) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: K.body(16, color: K.night, w: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(sub, style: K.body(12, color: K.muted)),
          ]),
        ),
      ]);
}
