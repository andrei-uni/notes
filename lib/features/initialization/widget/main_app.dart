import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes/theme/app_theme.dart';
import 'package:notes/features/home/widget/home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // --- THEME ---
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // --- LOCALE ---
      supportedLocales: const [
        Locale('ru'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      // --- ---
      home: const HomeScreen(),
    );
  }
}
