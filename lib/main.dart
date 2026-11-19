import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'screens/home.dart';
import 'screens/welcome.dart';
import 'state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: kSupabaseUrl, anonKey: kSupabasePublishableKey);
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
