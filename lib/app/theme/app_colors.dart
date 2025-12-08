import 'package:flutter/material.dart';

class AppColors {
  // Background colors - более насыщенный градиент
  static const Color backgroundStart = Color(0xFFF8F0FF);
  static const Color backgroundEnd = Color(0xFFE0F4FF);
  static const Color backgroundAccent = Color(0xFFFFF0F5);

  // Primary accent colors - яркие неоновые оттенки
  static const Color accentPrimary = Color(0xFF7C4DFF);
  static const Color accentSecondary = Color(0xFF00E5FF);
  static const Color accentTertiary = Color(0xFFFF6090);
  static const Color accentGold = Color(0xFFFFD740);

  // Surface colors - полупрозрачные для стеклянного эффекта
  static const Color surface = Color(0xF2FFFFFF);
  static const Color surfaceMuted = Color(0xCCFFFFFF);
  static const Color surfaceGlass = Color(0x99FFFFFF);
  static const Color surfaceDark = Color(0x1A000000);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF5C5C7A);

  // Glow colors для свечения
  static const Color glowPurple = Color(0xFF7C4DFF);
  static const Color glowCyan = Color(0xFF00E5FF);
  static const Color glowPink = Color(0xFFFF6090);

  // Основной градиент фона с тремя цветами
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundStart, backgroundEnd, backgroundAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Градиент для AppBar с большей прозрачностью
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0x80FFFFFF), Color(0x33FFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Яркий неоновый градиент для кнопок
  static const LinearGradient vibrantGradient = LinearGradient(
    colors: [accentPrimary, Color(0xFF536DFE), accentSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Розово-фиолетовый градиент
  static const LinearGradient pinkPurpleGradient = LinearGradient(
    colors: [accentTertiary, accentPrimary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Голографический градиент
  static const LinearGradient holographicGradient = LinearGradient(
    colors: [
      Color(0xFFFF6B9D),
      Color(0xFFC44FFF),
      Color(0xFF6B5BFF),
      Color(0xFF00D9FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  // Градиент для карточек
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F0FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Мягкое свечение фиолетовое
  static const List<BoxShadow> softGlow = [
    BoxShadow(
      color: Color(0x407C4DFF),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x207C4DFF),
      blurRadius: 40,
      spreadRadius: 4,
      offset: Offset(0, 20),
    ),
  ];

  // Неоновое свечение для активных элементов
  static const List<BoxShadow> neonGlow = [
    BoxShadow(
      color: Color(0x6000E5FF),
      blurRadius: 20,
      spreadRadius: 2,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x407C4DFF),
      blurRadius: 30,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  // Розовое свечение
  static const List<BoxShadow> pinkGlow = [
    BoxShadow(
      color: Color(0x50FF6090),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
  ];

  // Мягкая тень для карточек
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x207C4DFF),
      blurRadius: 30,
      spreadRadius: -5,
      offset: Offset(0, 15),
    ),
  ];

  // Свечение для иконок
  static List<BoxShadow> iconGlow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.5),
      blurRadius: 12,
      spreadRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];

  // Градиент для tile элементов с динамическим цветом
  static LinearGradient tileGradient(Color baseColor) => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      baseColor.withOpacity(0.4),
      baseColor.withOpacity(0.15),
      Colors.transparent,
    ],
    stops: const [0.0, 0.5, 1.0],
  );
}
