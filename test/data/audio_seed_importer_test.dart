// ignore_for_file: lines_longer_than_80_chars
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/seed/audio_seed_importer.dart';
import 'package:bayan/data/seed/seed_data.dart';

/// Minimal manifest with 2 entries matching lemmas already in the seed.
const _validManifest = '''
[
  {
    "key": "rahma",
    "pack_file": "assets/audio/sample_pack.m4a",
    "start_ms": 0,
    "duration_ms": 500
  },
  {
    "key": "sabr",
    "pack_file": "assets/audio/sample_pack.m4a",
    "start_ms": 500,
    "duration_ms": 500
  }
]
''';

/// Manifest with a key that doesn't match any seeded lemma.
const _unknownKeyManifest = '''
[
  {
    "key": "unknown_word_xyz",
    "pack_file": "assets/audio/sample_pack.m4a",
    "start_ms": 0,
    "duration_ms": 400
  }
]
''';

/// Manifest whose root is an object, not an array.
const _malformedManifest = '{"key": "rahma"}';

Future<AppDatabase> _openSeededDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDatabase(db);
  return db;
}

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase db;

  setUp(() async {
    db = await _openSeededDb();
  });

  tearDown(() async {
    await db.close();
  });

  // ── importAudioManifest ────────────────────────────────────────────────────

  group('importAudioManifest', () {
    test('inserts audio_clips rows for valid manifest', () async {
      await importAudioManifest(db, _validManifest);

      final clips = await db.select(db.audioClips).get();
      expect(clips.length, equals(2));
    });

    test('clip offsets are stored correctly', () async {
      await importAudioManifest(db, _validManifest);

      final clips = await db.select(db.audioClips).get();
      final byStart = {for (final c in clips) c.startMs: c};

      expect(byStart[0]?.durationMs, equals(500));
      expect(byStart[500]?.durationMs, equals(500));
    });

    test('updates lemma audio_id for matching key', () async {
      await importAudioManifest(db, _validManifest);

      final rahmaRows = await (db.select(
        db.lemmas,
      )..where((l) => l.latin.equals('rahma'))).get();
      expect(rahmaRows, isNotEmpty);
      expect(rahmaRows.first.audioId, isNotNull);
    });

    test('lemma audio_id points to correct clip', () async {
      await importAudioManifest(db, _validManifest);

      final rahma = await (db.select(
        db.lemmas,
      )..where((l) => l.latin.equals('rahma'))).getSingleOrNull();
      expect(rahma?.audioId, isNotNull);

      final clip = await (db.select(
        db.audioClips,
      )..where((a) => a.id.equals(rahma!.audioId!))).getSingleOrNull();
      expect(clip?.startMs, equals(0));
      expect(clip?.durationMs, equals(500));
    });

    test('sabr lemma gets audio_id set', () async {
      await importAudioManifest(db, _validManifest);

      final sabr = await (db.select(
        db.lemmas,
      )..where((l) => l.latin.equals('sabr'))).getSingleOrNull();
      expect(sabr?.audioId, isNotNull);
    });

    test(
      'idempotent: re-importing same manifest does not duplicate clips',
      () async {
        await importAudioManifest(db, _validManifest);
        await importAudioManifest(db, _validManifest);

        final clips = await db.select(db.audioClips).get();
        expect(clips.length, equals(2));
      },
    );

    test('unknown key is silently skipped without error', () async {
      await expectLater(
        importAudioManifest(db, _unknownKeyManifest),
        completes,
      );
      // No lemma should have audio_id set.
      final withAudio = await (db.select(
        db.lemmas,
      )..where((l) => l.audioId.isNotNull())).get();
      expect(withAudio, isEmpty);
      // But the clip row itself is still inserted (pack-level data).
      final clips = await db.select(db.audioClips).get();
      expect(clips.length, equals(1));
    });

    test('malformed manifest throws FormatException', () async {
      await expectLater(
        importAudioManifest(db, _malformedManifest),
        throwsA(isA<FormatException>()),
      );
    });

    test('lemmas without matching clip keep audio_id null', () async {
      await importAudioManifest(db, _validManifest);

      // 'allah' has no entry in _validManifest.
      final allah = await (db.select(
        db.lemmas,
      )..where((l) => l.latin.equals('allah'))).getSingleOrNull();
      expect(allah?.audioId, isNull);
    });
  });
}
