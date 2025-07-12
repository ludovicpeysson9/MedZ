import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/medication_screen.dart';
import 'screens/settings_screen.dart';
import 'services/notification_service.dart';
import 'utils/checks_persistence.dart';
import 'utils/last_reset_date.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const MedzApp());
}

class MedzApp extends StatefulWidget {
  const MedzApp({super.key});

  @override
  State<MedzApp> createState() => _MedzAppState();
}

class _MedzAppState extends State<MedzApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _maybeResetChecks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeResetChecks();
    }
  }

  Future<void> _maybeResetChecks() async {
    final last = await LastResetDate.load();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (last == null || last.isBefore(today)) {
      await ChecksPersistence.clearAll();
      await LastResetDate.saveToday();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedZ',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [ Locale('fr'), Locale('en') ],
      routes: {
        '/settings': (c) => const SettingsScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const MedicationScreen(),
    );
  }
}
