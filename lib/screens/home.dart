import 'package:flutter/material.dart';

import '../state.dart';
import '../theme.dart';
import 'settings.dart';
import 'tabs.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.state});
  final AppState state;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Diario del Bosque', style: K.title(12, color: K.paper)),
          const SizedBox(height: 4),
          Text('Archivo de Maya · Vol. I', style: K.body(11, color: const Color(0xFFBBD7BE))),
        ]),
        actions: [
          IconButton(
            tooltip: 'Ajustes y créditos',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SettingsScreen(state: s))),
          ),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF38705A),
              border: Border.all(color: K.gold, width: 2),
            ),
            child: const Text('🧚', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
      body: IndexedStack(index: _i, children: [
        InicioTab(state: s, goto: (i) => setState(() => _i = i)),
        DiarioTab(state: s),
        MundoTab(state: s),
        ArchivoTab(state: s),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (i) => setState(() => _i = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Diario'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Mundo'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Archivo'),
        ],
      ),
    );
  }
}
