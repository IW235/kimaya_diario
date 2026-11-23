import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'screens/home.dart';
import 'screens/welcome.dart';
import 'state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['Nunito'],
      await rootBundle.loadString('assets/fonts/Nunito-OFL.txt'),
    );
    yield LicenseEntryWithLineBreaks(
      ['Lora'],
      await rootBundle.loadString('assets/fonts/Lora-OFL.txt'),
    );
    yield LicenseEntryWithLineBreaks(
      ['Press Start 2P'],
      await rootBundle.loadString('assets/fonts/PressStart2P-OFL.txt'),
    );
  });
  await Supabase.initialize(
      url: kSupabaseUrl, anonKey: kSupabasePublishableKey);
  final state = AppState();
  await state.load();
  runApp(KimayaApp(state: state));
}

class KimayaApp extends StatelessWidget {
  const KimayaApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kimaya',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: ListenableBuilder(
          listenable: state,
          builder: (_, __) => state.progress == null
              ? WelcomeScreen(state: state)
              : HomeShell(state: state),
        ),
      );
}
