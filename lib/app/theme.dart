import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const rose = Color(0xFFC75C7E);
  const peach = Color(0xFFF7E1D7);
  const wine = Color(0xFF6D214F);
  const cream = Color(0xFFFFFBF8);
  const cocoa = Color(0xFF4A3B3B);

  final scheme = ColorScheme.fromSeed(
    seedColor: rose,
    brightness: Brightness.light,
    primary: rose,
    secondary: const Color(0xFFD98F89),
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: cream,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: cocoa,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: cocoa,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: cocoa,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: cocoa,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        height: 1.4,
        color: cocoa,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.4,
        color: Color(0xFF6C5C5C),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: wine,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: peach,
      selectedColor: rose,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: rose, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: peach,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected) ? wine : Colors.grey.shade600,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected) ? wine : Colors.grey.shade600,
        );
      }),
    ),
  );
}
