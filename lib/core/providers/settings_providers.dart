import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Holds the user's preferred [ThemeMode] (in memory only for now).
/// Defaults to [ThemeMode.system].
/// TODO(phase5): persist via shared_preferences and restore on startup.
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) => state = mode;
}

/// Holds the user's preferred [Locale] (fr or en), in memory only for now.
/// Defaults to French.
///
/// NOTE: when this changes, slang's LocaleSettings must be updated too
/// (LocaleSettings.setLocaleRaw) so Material widgets and app strings stay in
/// sync — wired in the settings screen.
/// TODO(phase5): persist + perform the slang sync on change.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale('fr');

  void setLocale(Locale locale) => state = locale;
}
