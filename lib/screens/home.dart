import 'package:flutter/material.dart';

import '../state.dart';
import '../widgets/kimaya_art.dart';
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
    if (_i == 0) {
      return Scaffold(
        body: InicioTab(
          state: s,
          goto: (index) => setState(() => _i = index),
          onSettings: () => _openSettings(context, s),
        ),
        bottomNavigationBar: _navigationBar(),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          JournalHeader(onSettings: () => _openSettings(context, s)),
          Expanded(
            child: IndexedStack(index: _i, children: [
              const SizedBox.shrink(),
              DiarioTab(state: s),
              MundoTab(state: s),
              ArchivoTab(state: s),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }

  void _openSettings(BuildContext context, AppState state) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsScreen(state: state)),
    );
  }

  NavigationBar _navigationBar() => NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (i) => setState(() => _i = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Diario'),
          NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Mundo'),
          NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Archivo'),
        ],
      );
}
