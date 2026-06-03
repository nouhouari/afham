// ignore_for_file: lines_longer_than_80_chars
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:bayan/data/database/app_database.dart';

/// Default asset path for the audio manifest produced by
/// `tool/build_audio_sprites.dart`.
const String kAudioManifestAssetPath = 'assets/audio/manifest.json';

/// Imports an audio sprite manifest JSON file into the database, populating
/// `audio_clips` rows and updating `lemmas.audio_id` FKs.
///
/// ## Manifest format
/// ```json
/// [
///   {
///     "key":         "rahma",      // matches lemmas.latin (case-insensitive)
///     "pack_file":   "assets/audio/pack_001.m4a",
///     "start_ms":    0,
///     "duration_ms": 620
///   },
///   ...
/// ]
/// ```
///
/// The import is idempotent: if an `audio_clips` row with the same
/// (pack_file, start_ms, duration_ms) already exists, its id is reused.
/// `lemmas.audio_id` is always refreshed to point at the resolved clip id.
///
/// Clips whose [key] does not match any lemma are silently skipped — they
/// will be imported once the corresponding lemma content is loaded.
Future<void> importAudioManifest(AppDatabase db, String jsonString) async {
  final decoded = json.decode(jsonString);
  if (decoded is! List) {
    throw const FormatException(
      'Audio manifest root must be a JSON array.',
    );
  }

  await db.transaction(() async {
    for (final raw in decoded) {
      if (raw is! Map<String, dynamic>) {
        throw const FormatException(
          'Each manifest entry must be a JSON object.',
        );
      }
      await _importOneClip(db, raw);
    }
  });
}

/// Loads [kAudioManifestAssetPath] from the asset bundle and imports it.
///
/// Silently returns if the asset is absent (pre-production, no audio yet).
Future<void> importAudioManifestFromAsset(
  AppDatabase db, {
  String assetPath = kAudioManifestAssetPath,
}) async {
  String jsonString;
  try {
    jsonString = await rootBundle.loadString(assetPath);
  } catch (_) {
    // Asset not yet present — not an error during development.
    return;
  }
  await importAudioManifest(db, jsonString);
}

// ── per-clip import ───────────────────────────────────────────────────────────

Future<void> _importOneClip(AppDatabase db, Map<String, dynamic> entry) async {
  final key = _asString(entry['key'], 'key').toLowerCase().trim();
  final packFile = _asString(entry['pack_file'], 'pack_file');
  final startMs = _asInt(entry['start_ms'], 'start_ms');
  final durationMs = _asInt(entry['duration_ms'], 'duration_ms');

  // 1. Upsert audio_clips row (idempotent on pack_file + start_ms + duration_ms).
  final clipId = await _upsertAudioClip(
    db,
    packFile: packFile,
    startMs: startMs,
    durationMs: durationMs,
  );

  // 2. Find the matching lemma by latin key (case-insensitive LIKE).
  //    Using customUpdate / customStatement is not available in a DAO-less
  //    context, so we use a SELECT + UPDATE pair inside the transaction.
  final lemmaRows = await (db.select(db.lemmas)
        ..where((l) => l.latin.lower().equals(key)))
      .get();

  for (final lemma in lemmaRows) {
    if (lemma.audioId == clipId) continue; // already up-to-date
    await (db.update(db.lemmas)..where((l) => l.id.equals(lemma.id))).write(
      LemmasCompanion(audioId: Value(clipId)),
    );
  }
}

// ── idempotent upsert ─────────────────────────────────────────────────────────

Future<int> _upsertAudioClip(
  AppDatabase db, {
  required String packFile,
  required int startMs,
  required int durationMs,
}) async {
  // Check for existing row.
  final existing = await (db.select(db.audioClips)
        ..where(
          (a) =>
              a.packFile.equals(packFile) &
              a.startMs.equals(startMs) &
              a.durationMs.equals(durationMs),
        )
        ..limit(1))
      .getSingleOrNull();

  if (existing != null) return existing.id;

  return db.into(db.audioClips).insert(
    AudioClipsCompanion.insert(
      packFile: packFile,
      startMs: startMs,
      durationMs: durationMs,
    ),
  );
}

// ── helpers ───────────────────────────────────────────────────────────────────

String _asString(Object? v, String field) {
  if (v is String && v.isNotEmpty) return v;
  throw FormatException('Expected non-empty string for "$field".');
}

int _asInt(Object? v, String field) {
  if (v is num) return v.toInt();
  throw FormatException('Expected integer for "$field".');
}
