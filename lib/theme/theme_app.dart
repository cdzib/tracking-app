import 'package:flutter/material.dart';
import 'package:vagonetas_app/app.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDimensions {
  // Spacing (8px system)
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;

  // Radius
  static const rSm = 12.0;
  static const rMd = 16.0;
  static const rLg = 20.0;
}

class AppTypography {
  static TextTheme get textTheme {
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      // Headings (jerarquía fuerte)
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

      // Titles
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      // Body
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 15,
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 13.5,
        height: 1.5,
      ),

      // Labels (botones)
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),

      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
      ),
    );
  }
}

class AppTheme {
  // ── Color base ─────────────────────────────────────────────
  static const _primary = Color(0xFF3F51B5);

  // ── Neutrales Dark ─────────────────────────────────────────
  static const _darkBg = Color(0xFF0D0D0D);
  static const _darkSurface = Color(0xFF161616);
  static const _darkCard = Color(0xFF1D1D1D);
  static const _darkNav = Color(0xFF111111);

  // ── Neutrales Light ────────────────────────────────────────
  static const _lightBg = Color(0xFFF5F0E8);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightCard = Color(0xFFFAF6EF);
  static const _lightNav = Color(0xFFFFFFFF);

  // ── DARK THEME ─────────────────────────────────────────────
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme.copyWith(
        surface: _darkSurface,
        surfaceContainerHighest: _darkCard,
        outline: Colors.white10,
      ),
      scaffoldBackgroundColor: _darkBg,
      textTheme: AppTypography.textTheme,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _darkNav,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(color: scheme.primary),
      ),

      // BottomNav (M3 usa NavigationBar)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkNav,
        indicatorColor: scheme.primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.rLg),
          side: const BorderSide(color: Colors.white10),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.rMd),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.rMd),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkCard,
        hintStyle: const TextStyle(color: Colors.white30),
        labelStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.rMd),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.rMd),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Colors.white10,
        thickness: 1,
      ),

      // Icons
      iconTheme: const IconThemeData(color: Colors.white70),

      // ListTile
      listTileTheme: ListTileThemeData(
        tileColor: _darkSurface,
        iconColor: scheme.primary,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.rMd),
        ),
      ),

      // Progress
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? scheme.primary
              : Colors.white30,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? scheme.primary.withOpacity(0.3)
              : Colors.white10,
        ),
      ),
    );
  }

  // ── LIGHT THEME ────────────────────────────────────────────
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme.copyWith(
        surface: _lightSurface,
        surfaceContainerHighest: _lightCard,
        outline: Colors.black12,
      ),
      scaffoldBackgroundColor: _lightBg,
      textTheme: AppTypography.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightNav,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _lightNav,
        indicatorColor: scheme.primary.withOpacity(0.15),
      ),
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.rLg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.rMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.rMd),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      listTileTheme: ListTileThemeData(
        tileColor: _lightSurface,
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
    );
  }
}
extension TextThemeExtension on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;
}