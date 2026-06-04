// ignore_for_file: lines_longer_than_80_chars
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bayan/core/text/arabic_normalizer.dart';
import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/seed/json_seed_importer.dart';

/// Reads the sample seed JSON straight from disk (the asset bundle is not
/// available in plain unit tests).
String _sampleJson() =>
    File('assets/db/seed/lemmas.sample.json').readAsStringSync();

/// Row counts derived from the seed JSON itself, so the suite stays correct as
/// the corpus grows (was hard-coded to 5; the corpus is now 20 and counting).
typedef _Counts = ({
  int lemmas,
  int roots,
  int content,
  int forms,
  int verses,
  int occ,
});

_Counts _deriveCounts(String jsonStr) {
  final lemmas = ((jsonDecode(jsonStr) as Map)['lemmas'] as List)
      .cast<Map<String, dynamic>>();
  final roots = <String>{};
  final verses = <String>{};
  var forms = 0;
  var occ = 0;
  var content = 0;
  for (final l in lemmas) {
    roots.add((l['root'] as Map)['ar'] as String);
    content += (l['content'] as Map).length; // one row per language present
    for (final sf
        in (l['surface_forms'] as List).cast<Map<String, dynamic>>()) {
      forms++;
      final vs = sf['verses'] as List;
      occ += vs.length;
      for (final v in vs) {
        verses.add('${(v as Map)['surah']}:${v['ayah']}');
      }
    }
  }
  return (
    lemmas: lemmas.length,
    roots: roots.length,
    content: content, // langs × lemmas (fr/en/id/ur)
    forms: forms,
    verses: verses.length,
    occ: occ,
  );
}

final _expected = _deriveCounts(_sampleJson());

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

    test('imports all sample lemmas (count derived from JSON)', () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS c FROM lemmas')
          .getSingle();
      expect(row.read<int>('c'), _expected.lemmas);
    });

    test('computes word_content rows for both fr and en', () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS c FROM word_content')
          .getSingle();
      expect(row.read<int>('c'), _expected.content); // lemmas × 2 langs
    });

    test('links surface forms to verses via occurrences', () async {
      final row = await db
          .customSelect('SELECT COUNT(*) AS c FROM occurrences')
          .getSingle();
      expect(row.read<int>('c'), _expected.occ);
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

    test(
      'EVERY lemma is findable by its bare Arabic dictionary form',
      () async {
        // Regression guard: Quranic surface forms often carry the article
        // (صَبْر → ٱلصَّبْرِ), so the search must also match each lemma's own
        // normalized form — otherwise typing «صبر» finds nothing.
        final rows = await db
            .customSelect('SELECT id, lemma_ar FROM lemmas')
            .get();
        expect(rows, isNotEmpty);
        for (final row in rows) {
          final id = row.read<int>('id');
          final lemmaAr = row.read<String>('lemma_ar');
          final bare = normalizeArabic(lemmaAr);
          final results = await db.searchDao.searchLemmas(bare);
          expect(
            results.any((r) => r.lemmaId == id),
            isTrue,
            reason: 'bare form «$bare» ($lemmaAr) must find its own lemma',
          );
        }
      },
    );

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

      expect(lemmas.read<int>('c'), _expected.lemmas);
      expect(roots.read<int>('c'), _expected.roots);
      expect(content.read<int>('c'), _expected.content);
      expect(forms.read<int>('c'), _expected.forms);
      expect(verses.read<int>('c'), _expected.verses);
      expect(occ.read<int>('c'), _expected.occ);
    });
  });
}
