import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'content.dart';

enum Progress { notPlayed, rescued }

class AppState extends ChangeNotifier {
  Progress? progress; // null = primera vez (pantalla de bienvenida)
  String? lastKey;
  bool online = false;
  bool syncing = false;
  Map<String, Map<String, dynamic>> _remote = {};
  late SharedPreferences _prefs;

  bool get rescued => progress == Progress.rescued;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final v = _prefs.getString('progress');
    progress = v == null ? null : (v == 'rescued' ? Progress.rescued : Progress.notPlayed);
    lastKey = _prefs.getString('last');
    syncRemote(); // sin await: la app abre aunque no haya red
  }

  Future<void> setProgress(Progress p) async {
    progress = p;
    await _prefs.setString('progress', p == Progress.rescued ? 'rescued' : 'not_played');
    notifyListeners();
  }

  void visit(String key) {
    lastKey = key;
    _prefs.setString('last', key);
    notifyListeners();
  }

  /// Lee `lore_entries` de Supabase (solo lectura, con la clave pública).
  /// Si la tabla no existe o no hay red, se queda con el contenido integrado.
  Future<void> syncRemote() async {
    syncing = true;
    notifyListeners();
    try {
      final rows = await Supabase.instance.client
          .from('lore_entries')
          .select()
          .timeout(const Duration(seconds: 8));
      _remote = {
        for (final r in rows) r['key'] as String: Map<String, dynamic>.from(r),
      };
      online = true;
    } catch (_) {
      online = false;
    }
    syncing = false;
    notifyListeners();
  }

  DiaryPage resolve(DiaryPage p) {
    final r = _remote[p.key];
    if (r == null) return p;
    return p.copyWith(
      title: r['title'] as String?,
      body: r['body'] as String?,
      note: r['note'] as String?,
    );
  }

  List<DiaryPage> all(String category) =>
      kPages.where((p) => p.category == category).map(resolve).toList();

  DiaryPage byKey(String key) => resolve(kPages.firstWhere((p) => p.key == key));

  DiaryPage? get lastPage {
    final k = lastKey;
    if (k == null) return null;
    for (final p in kPages) {
      if (p.key == k) return resolve(p);
    }
    return null;
  }

  /// Contenido que cuenta el desenlace: oculto hasta terminar la demo.
  bool hidden(DiaryPage p) => p.spoiler && !rescued;

  String? statusFor(DiaryPage p) {
    switch (p.key) {
      case 'personaje_kiara':
        return rescued ? 'Rescatada' : 'Desaparecida';
      case 'personaje_falin':
      case 'personaje_mia':
      case 'personaje_maya':
        return 'En el Bosque del Eco';
      case 'personaje_zarzal':
        return 'Activo';
      case 'magia_runas':
        return rescued ? '1 de 4 despierta' : 'Las cuatro están apagadas';
      default:
        return null;
    }
  }
}
