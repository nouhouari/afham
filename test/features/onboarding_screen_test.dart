// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/core/theme/theme.dart';
import 'package:bayan/features/onboarding/onboarding_screen.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await LocaleSettings.setLocaleRaw('fr');
  });

  Widget harness() {
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('SEARCH_HOME')),
        ),
      ],
    );
    return TranslationProvider(
      child: ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp.router(theme: buildDaftar(), routerConfig: router),
      ),
    );
  }

  testWidgets('renders the first slide (FR)', (tester) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    expect(find.text('Comprendre le Coran'), findsOneWidget);
    expect(find.text('Passer'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
  });

  testWidgets('Skip marks onboarding seen and navigates to Search', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();
    expect(find.text('SEARCH_HOME'), findsOneWidget);
    expect(prefs.getBool(onboardingSeenKey), isTrue);
  });

  testWidgets('Next advances slides; Get started finishes to Search', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(find.text('Cherchez un mot'), findsOneWidget);

    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    expect(find.text('Découvrez son sens'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget); // last slide CTA

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();
    expect(find.text('SEARCH_HOME'), findsOneWidget);
    expect(prefs.getBool(onboardingSeenKey), isTrue);
  });
}
