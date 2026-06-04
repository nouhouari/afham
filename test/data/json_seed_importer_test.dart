// ignore_for_file: lines_longer_than_80_chars
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/seed/json_seed_importer.dart';

/// Reads the sample seed JSON straight from disk (the asset bundle is not
/// available in plain unit tests).
String _sampleJson() =>
    File('assets/db/seed/lemmas.sample.json').readAsStringSync();

Future<AppDatabase> _openImportedDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await importLemmasJson(db, _sampleJson());
  return db;
}

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase db;

  setUp(() async {
    db = await _openImportedDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('JSON seed import', () {
    test('marks the database as seeded', () async {
      expect(await db.searchDao.isSeeded(), isTrue);
    });

    test('imports all 5 sample lemmas', () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS c FROM lemmas')
          .getSingle();
      expect(row.read<int>('c'), 5);
    });

    test('computes word_content rows for both fr and en', () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS c FROM word_content')
          .getSingle();
      expect(row.read<int>('c'), 10); // 5 lemmas × 2 langs
    });

    test('links surface forms to verses via occurrences', () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS c FROM occurrences')
          .getSingle();
      expect(row.read<int>('c'), greaterThanOrEqualTo(5));
    });
  });

  group('tolerant search over imported data (SearchDao)', () {
    test('bare Arabic «رحمه» finds the imported rahma lemma', () async {
      final results = await db.searchDao.searchLemmas('رحمه');
      expect(results.any((r) => r.lemmaAr == 'رَحْمَة'), isTrue);
    });

    test('Latin «sabr» finds the imported sabr lemma', () async {
      final results = await db.searchDao.searchLemmas('sabr');
      expect(results.any((r) => r.lemmaAr == 'صَبْر'), isTrue);
    });

    test('FR content (with accents) is imported', () async {
      final results = await db.searchDao.searchLemmas(
        'رَحْمَة',
        langCode: 'fr',
      );
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.translation.toLowerCase(), contains('miséricorde'));
      expect(r.tafsir, isNotEmpty);
      expect(r.gem, isNotEmpty);
      expect(r.mnemonic, isNotEmpty);
    });

    test('EN content is imported', () async {
      final results = await db.searchDao.searchLemmas('rahma', langCode: 'en');
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.translation.toLowerCase(), contains('mercy'));
    });
  });

  group('idempotency', () {
    test('re-importing the same JSON does not duplicate rows', () async {
      await importLemmasJson(db, _sampleJson());

      final lemmas = await db
          .customSelect('SELECT COUNT(*) AS c FROM lemmas')
          .getSingle();
      final roots = await db
          .customSelect('SELECT COUNT(*) AS c FROM roots')
          .getSingle();
      final content = await db
          .customSelect('SELECT COUNT(*) AS c FROM word_content')
          .getSingle();
      final forms = await db
          .customSelect('SELECT COUNT(*) AS c FROM surface_forms')
          .getSingle();
      final verses = await db
          .customSelect('SELECT COUNT(*) AS c FROM verses')
          .getSingle();
      final occ = await db
          .customSelect('SELECT COUNT(*) AS c FROM occurrences')
          .getSingle();

      expect(lemmas.read<int>('c'), 5);
      expect(roots.read<int>('c'), 5);
      expect(content.read<int>('c'), 10);
      expect(forms.read<int>('c'), 6); // rahma has 2 forms, others 1 each
      expect(verses.read<int>('c'), 6);
      expect(occ.read<int>('c'), 6);
    });
  });
}
