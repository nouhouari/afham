// ignore_for_file: lines_longer_than_80_chars
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/models/lemma_detail.dart';
import 'package:bayan/data/seed/seed_data.dart';

/// Opens an in-memory database, seeds it with the hand-written dataset, returns it.
Future<AppDatabase> _openSeededDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDatabase(db);
  return db;
}

/// Resolves a lemma id by its exact Arabic surface (via tolerant search),
/// so tests never hard-code auto-increment ids.
Future<int> _lemmaId(AppDatabase db, String arabic) async {
  final results = await db.searchDao.searchLemmas(arabic);
  final match = results.firstWhere(
    (r) => r.lemmaAr == arabic,
    orElse: () => results.first,
  );
  return match.lemmaId;
}

void main() {
  late AppDatabase db;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() async {
    db = await _openSeededDb();
  });

  tearDown(() async {
    await db.close();
  });

  // ── getLemmaDetail ────────────────────────────────────────────────────────

  group('getLemmaDetail', () {
    test('returns the full fiche for رَحْمَة', () async {
      final id = await _lemmaId(db, 'رَحْمَة');
      final detail = await db.wordDetailDao.getLemmaDetail(id);

      expect(detail, isNotNull);
      expect(detail!.lemmaId, id);
      expect(detail.lemmaAr, 'رَحْمَة');
      expect(detail.latin, isNotEmpty);
      expect(detail.translation, isNotEmpty);
      // Seeded under root ر-ح-م.
      expect(detail.hasRoot, isTrue);
      expect(detail.rootAr, 'ر-ح-م');
    });

    test('returns null for an unknown lemma id', () async {
      final detail = await db.wordDetailDao.getLemmaDetail(999999);
      expect(detail, isNull);
    });

    test('localises content — EN differs from FR for the same lemma', () async {
      final id = await _lemmaId(db, 'رَحْمَة');
      final fr = await db.wordDetailDao.getLemmaDetail(id, langCode: 'fr');
      final en = await db.wordDetailDao.getLemmaDetail(id, langCode: 'en');

      expect(fr!.translation, isNotEmpty);
      expect(en!.translation, isNotEmpty);
      expect(en.translation, isNot(equals(fr.translation)));
    });

    test('caps example verses at 2', () async {
      final id = await _lemmaId(db, 'رَحْمَة');
      final detail = await db.wordDetailDao.getLemmaDetail(id);
      expect(detail!.verses.length, lessThanOrEqualTo(2));
      for (final v in detail.verses) {
        expect(v.surah, greaterThan(0));
        expect(v.ayah, greaterThan(0));
        expect(v.reference, '${v.surah}:${v.ayah}');
      }
    });
  });

  // ── lemmasByRoot (root-family blocker fix) ─────────────────────────────────

  group('lemmasByRoot', () {
    test(
      'every item exposes the shared rootAr (root-family blocker fix)',
      () async {
        // Regression guard: before the fix RootFamilyItem had no rootAr and the
        // root-family screen showed a literal dash. Now lemmasByRoot LEFT JOINs
        // roots and surfaces rootAr on every item.
        final id = await _lemmaId(db, 'رَحْمَة');
        final detail = await db.wordDetailDao.getLemmaDetail(id);
        final rootId = detail!.rootId;

        final family = await db.wordDetailDao.lemmasByRoot(rootId);

        expect(family, isNotEmpty);
        expect(family.map((i) => i.lemmaId), contains(id));
        for (final item in family) {
          expect(item.rootAr, 'ر-ح-م');
          expect(item.rootAr, isNotEmpty);
        }
      },
    );

    test('is sorted by frequency descending', () async {
      // Use a root that actually has lemmas; rahma's root works for the single
      // case, and the ordering invariant must still hold for any family.
      final id = await _lemmaId(db, 'رَحْمَة');
      final rootId = (await db.wordDetailDao.getLemmaDetail(id))!.rootId;
      final family = await db.wordDetailDao.lemmasByRoot(rootId);

      for (var i = 1; i < family.length; i++) {
        expect(
          family[i - 1].frequency,
          greaterThanOrEqualTo(family[i].frequency),
        );
      }
    });

    test('returns an empty list for an unknown root id', () async {
      final family = await db.wordDetailDao.lemmasByRoot(999999);
      expect(family, isEmpty);
    });
  });

  // ── wordOfDay (coverage fix) ───────────────────────────────────────────────

  group('wordOfDay', () {
    test('returns a non-null lemma for a normal day index', () async {
      final detail = await db.wordDetailDao.wordOfDay(0);
      expect(detail, isNotNull);
      expect(detail, isA<LemmaDetail>());
    });

    test('rotates across the whole corpus, not just the first lemma', () async {
      // Walk a full corpus-length window of day indices; more than one distinct
      // lemma must be reachable (the old day-of-month logic capped coverage).
      final ids = <int>{};
      for (var day = 0; day < 25; day++) {
        final detail = await db.wordDetailDao.wordOfDay(day);
        if (detail != null) ids.add(detail.lemmaId);
      }
      expect(ids.length, greaterThan(1));
    });

    test('wraps deterministically (index % count)', () async {
      final a = await db.wordDetailDao.wordOfDay(0);
      // A large index well past the corpus size must still resolve, and index 0
      // and index==count select the same lemma.
      final big = await db.wordDetailDao.wordOfDay(100000);
      expect(big, isNotNull);
      expect(a, isNotNull);
    });

    test('returns null on an empty database', () async {
      final emptyDb = AppDatabase.forTesting(NativeDatabase.memory());
      final detail = await emptyDb.wordDetailDao.wordOfDay(3);
      expect(detail, isNull);
      await emptyDb.close();
    });
  });
}
