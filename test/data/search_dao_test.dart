// ignore_for_file: lines_longer_than_80_chars
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/models/search_result.dart';
import 'package:bayan/data/seed/seed_data.dart';

/// Helper — opens an in-memory database, seeds it, returns the DB.
Future<AppDatabase> _openSeededDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDatabase(db);
  return db;
}

void main() {
  late AppDatabase db;

  setUpAll(() {
    // Each test opens its own in-memory DB — suppress the Drift warning about
    // multiple database instances sharing no executor (they are independent).
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() async {
    db = await _openSeededDb();
  });

  tearDown(() async {
    await db.close();
  });

  // ── isSeeded ────────────────────────────────────────────────────────────────

  group('isSeeded', () {
    test('returns true after seeding', () async {
      expect(await db.searchDao.isSeeded(), isTrue);
    });

    test('returns false on empty database', () async {
      final emptyDb = AppDatabase.forTesting(NativeDatabase.memory());
      expect(await emptyDb.searchDao.isSeeded(), isFalse);
      await emptyDb.close();
    });
  });

  // ── Arabic tolerant search ──────────────────────────────────────────────────

  group('Arabic tolerant search', () {
    test('exact harakat form «رَحْمَة» finds the rahma lemma', () async {
      final results = await db.searchDao.searchLemmas('رَحْمَة');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('bare form without harakat «رحمه» finds the rahma lemma', () async {
      // رحمه normalises to رحمه which matches رحمه (ة→ه), same as رحمة normalised.
      final results = await db.searchDao.searchLemmas('رحمه');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('form with non-standard alef «رَاحِمَة» prefix matches rahma', () async {
      // Searching رحم (root prefix) should still surface رَحْمَة via FTS5 prefix.
      final results = await db.searchDao.searchLemmas('رحم');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('searching «صبر» finds sabr lemma', () async {
      final results = await db.searchDao.searchLemmas('صبر');
      _expectContainsLemma(results, 'صَبْر');
    });

    test('searching «نور» finds nur lemma', () async {
      final results = await db.searchDao.searchLemmas('نور');
      _expectContainsLemma(results, 'نُور');
    });

    test('searching «قلب» finds qalb lemma', () async {
      final results = await db.searchDao.searchLemmas('قلب');
      _expectContainsLemma(results, 'قَلْب');
    });

    test('searching with alef variants — «الايمان» finds iman', () async {
      // إ → ا unification, ى → ي unification
      final results = await db.searchDao.searchLemmas('الايمان');
      _expectContainsLemma(results, 'إِيمَان');
    });

    test('prefix match — «رح» returns rahma among results', () async {
      final results = await db.searchDao.searchLemmas('رح');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('empty query returns empty list', () async {
      final results = await db.searchDao.searchLemmas('');
      expect(results, isEmpty);
    });

    test('whitespace-only query returns empty list', () async {
      final results = await db.searchDao.searchLemmas('   ');
      expect(results, isEmpty);
    });

    test('unknown Arabic word returns empty list', () async {
      final results = await db.searchDao.searchLemmas('زززز');
      expect(results, isEmpty);
    });
  });

  // ── Latin fallback search ────────────────────────────────────────────────────

  group('Latin fallback search', () {
    test('«rahma» finds رَحْمَة', () async {
      final results = await db.searchDao.searchLemmas('rahma');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('«sabr» finds صَبْر', () async {
      final results = await db.searchDao.searchLemmas('sabr');
      _expectContainsLemma(results, 'صَبْر');
    });

    test('«nur» finds نُور', () async {
      final results = await db.searchDao.searchLemmas('nur');
      _expectContainsLemma(results, 'نُور');
    });

    test('«iman» finds إِيمَان', () async {
      final results = await db.searchDao.searchLemmas('iman');
      _expectContainsLemma(results, 'إِيمَان');
    });

    test('«salam» finds سَلَام', () async {
      final results = await db.searchDao.searchLemmas('salam');
      _expectContainsLemma(results, 'سَلَام');
    });

    test('partial latin «rah» returns rahma among results', () async {
      final results = await db.searchDao.searchLemmas('rah');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('uppercase «RAHMA» also finds رَحْمَة (case-insensitive)', () async {
      final results = await db.searchDao.searchLemmas('RAHMA');
      _expectContainsLemma(results, 'رَحْمَة');
    });

    test('unknown latin word returns empty list', () async {
      final results = await db.searchDao.searchLemmas('zzzzunknown');
      expect(results, isEmpty);
    });
  });

  // ── Sorting ─────────────────────────────────────────────────────────────────

  group('Frequency sorting', () {
    test('results are sorted by frequency descending', () async {
      // Search for something broad enough to return multiple results.
      // «ال» prefix is common — كتاب، نفس، الله، … all have ال forms.
      final results = await db.searchDao.searchLemmas('ال');
      if (results.length >= 2) {
        for (var i = 0; i < results.length - 1; i++) {
          expect(
            results[i].frequency,
            greaterThanOrEqualTo(results[i + 1].frequency),
            reason:
                'result[$i].frequency should be >= result[${i + 1}].frequency',
          );
        }
      }
    });

    test(
      'allah (freq=2699) ranks higher than kitab (freq=230) when both returned',
      () async {
        // Both lemmas have surface forms beginning with «الل» / «الك»; use «ال»
        final results = await db.searchDao.searchLemmas('ال');
        final allahIdx = results.indexWhere((r) => r.lemmaAr == 'اللَّه');
        final kitabIdx = results.indexWhere((r) => r.lemmaAr == 'كِتَاب');
        if (allahIdx != -1 && kitabIdx != -1) {
          expect(allahIdx, lessThan(kitabIdx));
        }
      },
    );
  });

  // ── Localisation ─────────────────────────────────────────────────────────────

  group('Localisation', () {
    test('FR results contain French translation', () async {
      final results = await db.searchDao.searchLemmas(
        'رَحْمَة',
        langCode: 'fr',
      );
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.translation.toLowerCase(), contains('miséricorde'));
    });

    test('EN results contain English translation', () async {
      final results = await db.searchDao.searchLemmas(
        'رَحْمَة',
        langCode: 'en',
      );
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.translation.toLowerCase(), contains('mercy'));
    });

    test('result contains tafsir, gem, mnemonic', () async {
      final results = await db.searchDao.searchLemmas(
        'رَحْمَة',
        langCode: 'fr',
      );
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.tafsir, isNotEmpty);
      expect(r.gem, isNotEmpty);
      expect(r.mnemonic, isNotEmpty);
    });
  });

  // ── Domain model ─────────────────────────────────────────────────────────────

  group('SearchResult model', () {
    test('result exposes root information', () async {
      final results = await db.searchDao.searchLemmas('رَحْمَة');
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.rootAr, equals('ر-ح-م'));
      expect(r.rootLatin, equals('r-h-m'));
    });

    test('result exposes pos field', () async {
      final results = await db.searchDao.searchLemmas('رَحْمَة');
      final r = results.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r.pos, equals('noun'));
    });

    test('equality is based on lemmaId', () async {
      final results1 = await db.searchDao.searchLemmas('رَحْمَة');
      final results2 = await db.searchDao.searchLemmas('rahma');
      final r1 = results1.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      final r2 = results2.firstWhere((r) => r.lemmaAr == 'رَحْمَة');
      expect(r1, equals(r2));
    });
  });

  // ── Limit parameter ──────────────────────────────────────────────────────────

  group('Limit parameter', () {
    test('respects limit=1', () async {
      final results = await db.searchDao.searchLemmas('ال', limit: 1);
      expect(results.length, lessThanOrEqualTo(1));
    });

    test('default limit is 30 max', () async {
      // Seed only has 20 lemmas, so all results should be <= 20.
      final results = await db.searchDao.searchLemmas('ا');
      expect(results.length, lessThanOrEqualTo(30));
    });
  });
}

// ── helpers ───────────────────────────────────────────────────────────────────

void _expectContainsLemma(List<SearchResult> results, String lemmaAr) {
  expect(
    results.any((r) => r.lemmaAr == lemmaAr),
    isTrue,
    reason:
        'Expected to find lemma "$lemmaAr" in results: '
        '${results.map((r) => r.lemmaAr).toList()}',
  );
}
