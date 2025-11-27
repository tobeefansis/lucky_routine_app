import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundStart = Color(0xFFFDFBFF);
  static const Color backgroundEnd = Color(0xFFDCEBFF);

  static const Color accentPrimary = Color(0xFF6F63FF);
  static const Color accentSecondary = Color(0xFF46C2FF);

  static const Color surface = Color(0xE6FFFFFF);
  static const Color surfaceMuted = Color(0xCCFFFFFF);

  static const Color textPrimary = Color(0xFF1C1C33);
  static const Color textSecondary = Color(0xFF4F4F6B);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundStart, backgroundEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [
      Color(0x66FFFFFF),
      Color(0x11FFFFFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient vibrantGradient = LinearGradient(
    colors: [accentPrimary, accentSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<BoxShadow> softGlow = [
    BoxShadow(
      color: Color(0x336F63FF),
      blurRadius: 30,
      spreadRadius: 2,
      offset: Offset(0, 18),
    ),
  ];
}
