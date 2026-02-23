import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Permet de changer le thème depuis n'importe quel écran
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  bool get isDark =>
      _themeMode == ThemeMode.dark ||
          (_themeMode == ThemeMode.system &&
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Météo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F80ED),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F80ED),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: const HomeScreen(),
    );
  }
}