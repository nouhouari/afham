// ignore_for_file: lines_longer_than_80_chars
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/seed/seed_data.dart';

/// Integration test for locale-aware content: the word definition (and the
/// meaning search) must follow the active language, switching live.
void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase db;
  late SharedPreferences prefs;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedDatabase(db);

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    // Keep locale state alive across reads so setLocale persists in-container.
    container.listen(localeProvider, (_, _) {});
    addTearDown(() async {
      container.dispose();
      await db.close();
    });
  });

  Future<int> rahmaId() async {
    final results = await db.searchDao.searchLemmas('رحمه', langCode: 'fr');
    return results.firstWhere((r) => r.lemmaAr == 'رَحْمَة').lemmaId;
  }

  Future<void> setLocale(String code) =>
      container.read(localeProvider.notifier).setLocale(Locale(code));

  test('word definition follows the active language (fr → en → fr)', () async {
    final id = await rahmaId();

    // Default locale is French.
    final fr = await container.read(lemmaDetailProvider(id).future);
    expect(fr!.translation.toLowerCase(), contains('miséricorde'));

    // Switch to English → English definition.
    await setLocale('en');
    final en = await container.read(lemmaDetailProvider(id).future);
    expect(en!.translation.toLowerCase(), contains('mercy'));
    expect(en.translation.toLowerCase(), isNot(contains('miséricorde')));

    // Switch back to French → French again.
    await setLocale('fr');
    final fr2 = await container.read(lemmaDetailProvider(id).future);
    expect(fr2!.translation.toLowerCase(), contains('miséricorde'));
  });

  test('meaning search follows the active language', () async {
    container.read(searchQueryProvider.notifier).update('mercy');

    // English: «mercy» matches the English translation → finds رَحْمَة.
    await setLocale('en');
    final en = await container.read(searchResultsProvider.future);
    expect(en.any((r) => r.lemmaAr == 'رَحْمَة'), isTrue);

    // French: «mercy» is not a French meaning (nor an Arabic/Latin form) → none.
    await setLocale('fr');
    final fr = await container.read(searchResultsProvider.future);
    expect(fr.any((r) => r.lemmaAr == 'رَحْمَة'), isFalse);
  });
}
