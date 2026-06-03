import 'package:bayan/core/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProviderContainer _container(SharedPreferences prefs) {
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeModeNotifier', () {
    test('defaults to system when nothing is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(_container(prefs).read(themeModeProvider), ThemeMode.system);
    });

    test('restores a persisted theme mode', () async {
      SharedPreferences.setMockInitialValues({'settings.themeMode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      expect(_container(prefs).read(themeModeProvider), ThemeMode.dark);
    });

    test('setThemeMode updates state and persists it', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = _container(prefs);

      await container
          .read(themeModeProvider.notifier)
          .setThemeMode(ThemeMode.light);

      expect(container.read(themeModeProvider), ThemeMode.light);
      expect(prefs.getString('settings.themeMode'), 'light');
    });
  });

  group('LocaleNotifier', () {
    test('defaults to French when nothing is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(_container(prefs).read(localeProvider), const Locale('fr'));
    });

    test('restores a persisted locale', () async {
      SharedPreferences.setMockInitialValues({'settings.locale': 'en'});
      final prefs = await SharedPreferences.getInstance();
      expect(_container(prefs).read(localeProvider), const Locale('en'));
    });
  });
}
