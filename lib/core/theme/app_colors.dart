// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Primary Palette
  static const Color primary = Color(0xFF6C63FF); // violet
  static const Color secondary = Color(0xFFFF6584); // pink
  static const Color accent = Color(0xFF00BFA6); // teal

  // 🟢 Success / 🔴 Error
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);

  // 🔳 Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF424242);

  // 🌞 Light Theme
  static const Color lightBackground = Color(0xFFFDFDFD);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF212121);

  // 🌙 Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);

  // 🃏 Game Specific
  static const Color cardBack = Color(0xFF6C63FF); // back of card
  static const Color cardFront = Color(0xFFFFFFFF); // front face
  static const Color matchHighlight = Color(0xFF4CAF50); // green border when matched
  static const Color mismatchHighlight = Color(0xFFE53935); // red border when wrong
}
