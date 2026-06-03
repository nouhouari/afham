import 'package:flutter/material.dart';
import 'package:bayan/core/theme/app_tokens.dart';

// ---------------------------------------------------------------------------
// Daftar — Light theme (ivoire/papier, encre brun-chaud)
// ---------------------------------------------------------------------------

const ColorScheme _daftarScheme = ColorScheme(
  brightness: Brightness.light,
  // Primary: encre brun-chaud
  primary: Color(0xFF7A5C3E),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEDE3CE),
  onPrimaryContainer: Color(0xFF3B2E1E),
  // Secondary: vert sage (Astuce Mémo)
  secondary: Color(0xFF3D6B52),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD9EBE1),
  onSecondaryContainer: Color(0xFF0E2E1E),
  // Tertiary: or mat (accent — only for decorative use, not text)
  tertiary: Color(0xFF9A7B3F),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFF5EDD0),
  onTertiaryContainer: Color(0xFF3A2D0E),
  // Error
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  // Surfaces — use surfaceContainerHighest (surfaceVariant is deprecated M3)
  surface: Color(0xFFF5F0E8),
  onSurface: Color(0xFF1E1A16),
  surfaceContainerHighest: Color(0xFFEDE3CE),
  onSurfaceVariant: Color(0xFF5C4A36),
  outline: Color(0xFF9A7B3F),
  outlineVariant: Color(0xFFD4C4B0),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFF342F2B),
  onInverseSurface: Color(0xFFF8EFE7),
  inversePrimary: Color(0xFFD4B896),
);

// ---------------------------------------------------------------------------
// Sakīna — Dark theme (vert-nuit, or discret, ivoire)
// ---------------------------------------------------------------------------

const ColorScheme _sakinaScheme = ColorScheme(
  brightness: Brightness.dark,
  // Primary: or discret (text-safe 6.7:1 on dark surface)
  primary: Color(0xFFC9A24B),
  onPrimary: Color(0xFF16241D),
  primaryContainer: Color(0xFF2A3D30),
  onPrimaryContainer: Color(0xFFECDDB8),
  // Secondary: vert Astuce Mémo
  secondary: Color(0xFF3D7A58),
  onSecondary: Color(0xFF003823),
  secondaryContainer: Color(0xFF1A3028),
  onSecondaryContainer: Color(0xFFAFDBC3),
  // Tertiary: gold accent (same family as primary in dark)
  tertiary: Color(0xFFC9A24B),
  onTertiary: Color(0xFF3A2D0E),
  tertiaryContainer: Color(0xFF2A3D30),
  onTertiaryContainer: Color(0xFFEDE3CE),
  // Error
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  // Surfaces
  surface: Color(0xFF16241D),
  onSurface: Color(0xFFECE6D6),
  surfaceContainerHighest: Color(0xFF1F3329),
  onSurfaceVariant: Color(0xFFBFB09A),
  outline: Color(0xFFC9A24B),
  outlineVariant: Color(0xFF3D5445),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
  inverseSurface: Color(0xFFECE6D6),
  onInverseSurface: Color(0xFF342F2B),
  inversePrimary: Color(0xFF7A5C3E),
);

// ---------------------------------------------------------------------------
// TextTheme (Inter for Latin UI; Amiri styles live in BayanTokens)
// ---------------------------------------------------------------------------

const _interTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Inter',
    fontSize: 57,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Inter',
    fontSize: 45,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    fontWeight: FontWeight.w400,
  ),
  headlineLarge: TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w600,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w600,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  bodyLarge: TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
  ),
);

// ---------------------------------------------------------------------------
// Public builders
// ---------------------------------------------------------------------------

ThemeData buildDaftar() => ThemeData(
  useMaterial3: true,
  colorScheme: _daftarScheme,
  textTheme: _interTextTheme,
  extensions: const [BayanTokens.daftar],
  scaffoldBackgroundColor: const Color(0xFFF5F0E8),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF5F0E8),
    foregroundColor: Color(0xFF7A5C3E),
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: false,
  ),
  searchBarTheme: const SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
  ),
);

ThemeData buildSakina() => ThemeData(
  useMaterial3: true,
  colorScheme: _sakinaScheme,
  textTheme: _interTextTheme,
  extensions: const [BayanTokens.sakina],
  scaffoldBackgroundColor: const Color(0xFF16241D),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF16241D),
    foregroundColor: Color(0xFFC9A24B),
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: false,
  ),
  searchBarTheme: const SearchBarThemeData(
    elevation: WidgetStatePropertyAll(0),
  ),
);
