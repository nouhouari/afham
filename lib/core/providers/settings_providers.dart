import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Persists the user's preferred [ThemeMode].
/// Defaults to [ThemeMode.system].
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) => state = mode;
}

/// Persists the user's preferred [Locale] (fr or en).
/// Defaults to the system locale resolved against supported locales;
/// falls back to English.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale('fr');

  void setLocale(Locale locale) => state = locale;
}
