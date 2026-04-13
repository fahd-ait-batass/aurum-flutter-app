import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    const Color backgroundColor = Color(0xFF0B0D12);
    const Color surfaceColor = Color(0xFF151821);
    const Color elevatedSurfaceColor = Color(0xFF1C212B);
    const Color primaryColor = Color(0xFFF6B756);
    const Color secondaryColor = Color(0xFFE58F4B);
    const Color textColor = Color(0xFFF8F1E7);
    const Color mutedTextColor = Color(0xFFA8A095);
    const Color outlineColor = Color(0xFF2A303A);

    final ThemeData baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: primaryColor,
            brightness: Brightness.dark,
          ).copyWith(
            primary: primaryColor,
            onPrimary: const Color(0xFF221507),
            secondary: secondaryColor,
            onSecondary: Colors.white,
            primaryContainer: const Color(0xFF3D2B15),
            onPrimaryContainer: const Color(0xFFFFE4BA),
            secondaryContainer: const Color(0xFF41281B),
            onSecondaryContainer: const Color(0xFFFFD7B9),
            surface: surfaceColor,
            onSurface: textColor,
            outline: outlineColor,
            shadow: const Color(0xD9000000),
          ),
    );

    final TextTheme textTheme = baseTheme.textTheme.copyWith(
      headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        color: textColor,
      ),
      titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: textColor,
      ),
      titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: textColor,
      ),
      bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
        color: mutedTextColor,
        height: 1.45,
      ),
      bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF908A82),
        height: 1.45,
      ),
      labelLarge: baseTheme.textTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
      labelMedium: baseTheme.textTheme.labelMedium?.copyWith(
        color: mutedTextColor,
        fontWeight: FontWeight.w700,
      ),
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: elevatedSurfaceColor.withValues(alpha: 0.94),
        indicatorColor: const Color(0x2AF6B756),
        elevation: 0,
        height: 76,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: const WidgetStatePropertyAll<TextStyle>(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: const Color(0xFF221507),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: const BorderSide(color: outlineColor),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevatedSurfaceColor,
        hintStyle: const TextStyle(color: mutedTextColor),
        prefixIconColor: primaryColor,
        suffixIconColor: mutedTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: outlineColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: outlineColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
      dividerColor: outlineColor,
    );
  }
}
