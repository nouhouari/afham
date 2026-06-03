import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bayan/core/i18n/strings.g.dart';

part 'settings_providers.g.dart';

const _kThemeModeKey = 'settings.themeMode';

/// Storage key for the persisted locale language code. Also read in `main()`.
const localePrefKey = 'settings.locale';

/// The [SharedPreferences] instance. Overridden with the real, async-loaded
/// instance in `main()` via `ProviderScope(overrides: …)`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden in main()',
);

/// The user's preferred [ThemeMode], persisted across launches.
/// Defaults to [ThemeMode.system].
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(_kThemeModeKey);
    return ThemeMode.values.asNameMap()[raw] ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_kThemeModeKey, mode.name);
  }
}

/// The user's preferred [Locale] (fr or en), persisted across launches.
/// Defaults to French.
///
/// Setting it also updates slang's [LocaleSettings] so Material widgets and
/// app strings switch together.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(localePrefKey);
    return Locale(raw ?? 'fr');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await LocaleSettings.setLocaleRaw(locale.languageCode);
    await ref
        .read(sharedPreferencesProvider)
        .setString(localePrefKey, locale.languageCode);
  }
}
