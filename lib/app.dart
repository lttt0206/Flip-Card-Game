// lib/app.dart
import 'package:flip_card_game/features/menu/home_page.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class FlipCardApp extends StatelessWidget {
  const FlipCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flip-Card Game',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomePage(), // TODO: HomePage()
    );
  }
}
