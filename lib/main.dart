import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/core/router/app_router.dart';
import 'package:bayan/core/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Slang: set initial locale synchronously before first frame.
  LocaleSettings.setLocaleRawSync('fr');
  runApp(const ProviderScope(child: BayanApp()));
}

/// Root widget — reads theme / locale providers and wires them into
/// [MaterialApp.router].
class BayanApp extends ConsumerWidget {
  const BayanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Bayan',
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
      routerConfig: appRouter,
    );
  }
}
