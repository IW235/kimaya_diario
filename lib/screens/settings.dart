import 'package:flutter/material.dart';

import '../common.dart';
import '../state.dart';
import '../theme.dart';
import 'welcome.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: state,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: Text('Ajustes', style: K.title(12, color: K.paper))),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            const SectionTitle('Progreso narrativo'),
            PaperCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(state.rescued ? 'Ya rescaté a Kiara' : 'Todavía no he jugado la demo',
                    style: K.body(15, w: FontWeight.w800)),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProgressScreen(state: state, fromSettings: true))),
                  child: const Text('Cambiar progreso'),
                ),
              ]),
            ),
            const SectionTitle('Supabase'),
            PaperCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(state.online ? Icons.cloud_done : Icons.cloud_off,
                      color: state.online ? K.forest : K.muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.online
                          ? 'Conectado: leyendo lore_entries'
                          : 'Modo local: usando el contenido integrado',
                      style: K.body(14),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: state.syncing ? null : state.syncRemote,
                  child: Text(state.syncing ? 'Sincronizando…' : 'Sincronizar ahora'),
                ),
              ]),
            ),
            const SectionTitle('Créditos y procedencia'),
            PaperCard(
              child: Text(
                'Proyecto escolar de la Universidad Tecnológica de Chihuahua.\n'
                'Equipo Fairytopia · IDGS102N · Creación de Videojuegos.\n\n'
                'Textos: documento “Aplicación Móvil Kimaya”.\n'
                'Tipografías: Press Start 2P y Nunito (SIL Open Font License), con el paquete google_fonts.\n'
                'Ilustraciones: emojis del sistema como marcador provisional. Sustituir por pixel art propio y registrar autor, fuente y licencia de cada recurso.',
                style: K.body(13, color: K.muted),
              ),
            ),
          ]),
        ),
      );
}
