import 'package:flutter/material.dart';

class AppColors {
  // Deep navy/slate palette — modern & premium without being black
  static const Color background   = Color(0xFF0F172A);
  static const Color surface      = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF283548);
  static const Color border       = Color(0xFF334155);
  static const Color primary      = Color(0xFF38BDF8);
  static const Color primaryDark  = Color(0xFF0EA5E9);
  static const Color accent       = Color(0xFFA78BFA);
  static const Color accentLight  = Color(0xFFC4B5FD);
  static const Color warning      = Color(0xFFFBBF24);
  static const Color error        = Color(0xFFF87171);
  static const Color success      = Color(0xFF34D399);
  static const Color textPrimary  = Color(0xFFF1F5F9);
  static const Color textSecondary= Color(0xFF94A3B8);
  static const Color textMuted    = Color(0xFF64748B);
  static const Color gold         = Color(0xFFFCD34D);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color scoreColor(int score) {
    if (score >= 80) return success;
    if (score >= 60) return primary;
    if (score >= 40) return warning;
    return error;
  }
}
