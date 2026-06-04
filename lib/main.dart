import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/core/router/app_router.dart';
import 'package:bayan/core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // Restore the saved locale (default French) and load it into slang before
  // the first frame. Async (not *Sync) because slang lazily loads per-locale
  // translations as deferred libraries.
  await LocaleSettings.setLocaleRaw(prefs.getString(localePrefKey) ?? 'fr');

  // First launch → onboarding; otherwise straight to search.
  final seenOnboarding = prefs.getBool(onboardingSeenKey) ?? false;
  final router = buildAppRouter(
    initialLocation: seenOnboarding ? Routes.search : Routes.onboarding,
  );

  runApp(
    // TranslationProvider must wrap the tree so `Translations.of(context)`
    // (used by every screen) can resolve the active locale.
    TranslationProvider(
      child: ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: BayanApp(router: router),
      ),
    ),
  );
}

/// Root widget — reads theme / locale providers and wires them into
/// [MaterialApp.router].
class BayanApp extends ConsumerWidget {
  const BayanApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: "Af'ham",
      debugShowCheckedModeBanner: false,

      // Theme
      theme: buildDaftar(),
      darkTheme: buildSakina(),
      themeMode: themeMode,

      // Locale — slang-generated AppLocale drives the supported list.
      locale: locale,
      supportedLocales: AppLocale.values.map((l) => l.flutterLocale),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Router
      routerConfig: router,
    );
  }
}
