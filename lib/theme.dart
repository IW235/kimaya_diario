import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta y tipografías de la guía visual de Kimaya.
class K {
  static const night = Color(0xFF183B36); // fondos profundos
  static const forest = Color(0xFF2F624C); // acciones
  static const moss = Color(0xFF729B58);
  static const magic = Color(0xFF58C6B4); // magia de Maya
  static const gold = Color(0xFFE6C568); // solo runas y descubrimientos
  static const paper = Color(0xFFF3E6C5); // lectura
  static const ink = Color(0xFF292936);
  static const coral = Color(0xFFD97870);
  static const bramble = Color(0xFF35243F); // Zarzal
  static const violet = Color(0xFF24263F);
  static const magenta = Color(0xFF914C70);
  static const rose = Color(0xFFC15C79);
  static const card = Color(0xFFFFF9E8);
  static const line = Color(0xFFD7C997);
  static const mossLight = Color(0xFFE5EFDC);
  static const muted = Color(0xFF52645A);

  /// Pixel: solo títulos, nombres y botones importantes.
  static TextStyle title(double size, {Color color = night}) =>
      GoogleFonts.pressStart2p(fontSize: size, color: color, height: 1.5);

  /// Redondeada y legible para párrafos.
  static TextStyle body(double size,
          {Color color = ink, FontWeight w = FontWeight.w500}) =>
      GoogleFonts.nunito(fontSize: size, color: color, fontWeight: w, height: 1.45);

  /// Voz manuscrita de Maya.
  static TextStyle serif(double size, {Color color = ink}) => GoogleFonts.lora(
      fontSize: size, color: color, height: 1.5, fontStyle: FontStyle.italic);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: K.forest, primary: K.forest, secondary: K.magic, surface: K.paper),
  );
  return base.copyWith(
    scaffoldBackgroundColor: K.paper,
    textTheme: GoogleFonts.nunitoTextTheme(base.textTheme)
        .apply(bodyColor: K.ink, displayColor: K.ink),
    appBarTheme: const AppBarTheme(
        backgroundColor: K.night, foregroundColor: K.paper, elevation: 0),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: K.card,
      indicatorColor: K.gold.withValues(alpha: .35),
      labelTextStyle: WidgetStateProperty.all(K.body(11, w: FontWeight.w800)),
    ),
  );
}
