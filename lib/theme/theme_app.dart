import 'package:flutter/material.dart';

class AppTheme {
  // ── Colores base ──────────────────────────────────────────────────────────
  static const _gold = Color(0xFFD4A853);
  static const _goldLight = Color(0xFFF0C97A);
  static const _goldDark = Color(0xFFB8893A);

  static const _darkBg = Color(0xFF0D0D0D);
  static const _darkSurface = Color(0xFF161616);
  static const _darkCard = Color(0xFF1D1D1D);
  static const _darkNav = Color(0xFF111111);

  static const _lightBg = Color(0xFFF5F0E8);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightCard = Color(0xFFFAF6EF);
  static const _lightNav = Color(0xFFFFFFFF);

  // ── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBg,

      colorScheme: const ColorScheme.dark(
        primary: _gold,
        onPrimary: Colors.black,
        secondary: _goldLight,
        onSecondary: Colors.black,
        tertiary: Color(0xFF7EA1FF),
        surface: _darkSurface,
        onSurface: Colors.white,
        surfaceContainerHighest: _darkCard,
        outline: Colors.white10,
        error: Color(0xFFEAA86C),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkNav,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(color: _gold),
      ),

      // BottomNav
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkNav,
        selectedItemColor: _gold,
        unselectedItemColor: Colors.white30,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Card
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Colors.white10),
        ),
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _gold,
          side: const BorderSide(color: _gold, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _gold,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkCard,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 14),
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEAA86C)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEAA86C), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Colors.white10,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(color: Colors.white70, size: 22),

      // Text
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        headlineLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        headlineSmall: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.5),
        bodySmall: TextStyle(color: Colors.white38, fontSize: 12, height: 1.4),
        labelLarge: TextStyle(color: _gold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.8),
        labelSmall: TextStyle(color: Colors.white38, fontSize: 10.5, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkCard,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        tileColor: _darkSurface,
        textColor: Colors.white,
        iconColor: _gold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // CircularProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _gold,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? _gold : Colors.white30,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? _gold.withOpacity(0.3)
              : Colors.white10,
        ),
      ),
    );
  }

  // ── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBg,

      colorScheme: ColorScheme.light(
        primary: _goldDark,
        onPrimary: Colors.white,
        secondary: _gold,
        onSecondary: Colors.white,
        tertiary: const Color(0xFF4A6FD4),
        surface: _lightSurface,
        onSurface: const Color(0xFF1A1A1A), // Color del texto principal
        surfaceContainerHighest: _lightCard,
        outline: Colors.black.withOpacity(0.08),
        error: const Color(0xFFD4732A),
        onError: Colors.white,
        background: _lightBg,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _lightNav,
        foregroundColor: Color(0xFF1A1A1A), // Color de flecha y botones
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightNav,
        selectedItemColor: _goldDark,
        unselectedItemColor: Colors.black54,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: Colors.black.withOpacity(0.07)),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _goldDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _goldDark,
          side: const BorderSide(color: _goldDark, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _goldDark,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightCard,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 14),
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _goldDark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4732A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4732A), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),

      dividerTheme: DividerThemeData(
        color: Colors.black.withOpacity(0.07),
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(color: Color(0xFF3A3A3A), size: 22),

      textTheme: TextTheme(
        displayLarge: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800),
        displayMedium: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800),
        headlineLarge: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 24, fontWeight: FontWeight.w800),
        headlineMedium: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 20, fontWeight: FontWeight.w700),
        headlineSmall: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 17, fontWeight: FontWeight.w700),
        titleLarge: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w700),
        titleMedium: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 15, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 15, height: 1.5),
        bodyMedium: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 13.5, height: 1.5),
        bodySmall: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12, height: 1.4),
        labelLarge: const TextStyle(color: _goldDark, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.8),
        labelSmall: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 10.5, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFFF5F0E8),
        contentTextStyle: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      listTileTheme: ListTileThemeData(
        tileColor: _lightSurface,
        textColor: const Color(0xFF1A1A1A),
        iconColor: _goldDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _goldDark,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? _goldDark : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? _goldDark.withOpacity(0.4)
              : Colors.black12,
        ),
      ),
    );
  }
}