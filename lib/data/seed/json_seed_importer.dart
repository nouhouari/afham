// ignore_for_file: lines_longer_than_80_chars
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:bayan/core/text/arabic_normalizer.dart';
import 'package:bayan/data/database/app_database.dart';

/// Default seed asset shipped with the app.
///
/// During Phase 3 this points at the 5-lemma sample; the full ~3 400-lemma
/// file is produced by a separate LLM run (see docs/content_generation_prompt.md)
/// and dropped at the same path before release.
const String kSeedAssetPath = 'assets/db/seed/lemmas.sample.json';

/// Imports a JSON content file (conforming to docs/content_schema.json) into
/// [db].
///
/// The whole import runs in a single transaction and is **idempotent**: rows are
/// matched on their natural keys before insertion, so re-running never produces
/// duplicates (roots by `root_ar`, lemmas by `lemma_ar`+root, surface forms by
/// `text_ar`+lemma, verses by `surah:ayah`, word content by `lemma_id`+lang,
/// occurrences by form+verse).
///
/// [searchKeys] (`search_key`, `root_normalized`) are computed here via
/// [normalizeArabic]; the JSON never carries them. FTS5 stays in sync through
/// the surface_forms triggers declared in tables.drift.
Future<void> importLemmasJson(AppDatabase db, String jsonString) async {
  final decoded = json.decode(jsonString);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Seed JSON root must be a JSON object.');
  }
  final rawLemmas = decoded['lemmas'];
  if (rawLemmas is! List) {
    throw const FormatException('Seed JSON must contain a "lemmas" array.');
  }

  await db.transaction(() async {
    for (final raw in rawLemmas) {
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('Each lemma must be a JSON object.');
      }
      await _importOneLemma(db, raw);
    }
  });
}

/// Loads [kSeedAssetPath] from the asset bundle and imports it. Convenience for
/// production first-launch seeding.
Future<void> importLemmasFromAsset(
  AppDatabase db, {
  String assetPath = kSeedAssetPath,
}) async {
  final jsonString = await rootBundle.loadString(assetPath);
  await importLemmasJson(db, jsonString);
}

// ── per-lemma import ──────────────────────────────────────────────────────────

Future<void> _importOneLemma(AppDatabase db, Map<String, dynamic> lemma) async {
  // 1. ROOT (idempotent on root_ar).
  final rootJson = _asMap(lemma['root'], 'root');
  final rootAr = _asString(rootJson['ar'], 'root.ar');
  final rootLatin = _asString(rootJson['latin'], 'root.latin');
  final rootId = await _upsertRoot(db, rootAr: rootAr, latin: rootLatin);

  // 2. LEMMA (idempotent on lemma_ar + root_id).
  final lemmaAr = _asString(lemma['lemma_ar'], 'lemma_ar');
  final lemmaLatin = _asString(lemma['latin'], 'latin');
  final pos = (lemma['pos'] as String?)?.trim();
  final frequency = (lemma['frequency'] as num?)?.toInt() ?? 0;
  final lemmaId = await _upsertLemma(
    db,
    rootId: rootId,
    lemmaAr: lemmaAr,
    latin: lemmaLatin,
    pos: (pos == null || pos.isEmpty) ? 'noun' : pos,
    frequency: frequency,
  );

  // 3. WORD CONTENT (UNIQUE(lemma_id, lang_code) → insertOnConflictUpdate).
  // Imports every language present in the content block (fr, en, id, ur, …) —
  // adding a language is just more rows, no code change here.
  final content = _asMap(lemma['content'], 'content');
  for (final lang in content.keys) {
    final block = content[lang];
    if (block == null) continue;
    final loc = _asMap(block, 'content.$lang');
    final wc = WordContentCompanion.insert(
      lemmaId: lemmaId,
      langCode: lang,
      translation: _asString(loc['translation'], 'content.$lang.translation'),
      tafsir: Value((loc['tafsir'] as String?) ?? ''),
      gem: Value((loc['gem'] as String?) ?? ''),
      mnemonic: Value((loc['mnemonic'] as String?) ?? ''),
    );
    // UNIQUE(lemma_id, lang_code) is the conflict target (not the PK), so the
    // upsert is spelled out explicitly to make re-imports idempotent.
    await db
        .into(db.wordContent)
        .insert(
          wc,
          onConflict: DoUpdate(
            (_) => wc,
            target: [db.wordContent.lemmaId, db.wordContent.langCode],
          ),
        );
  }

  // 4. SURFACE FORMS + VERSES + OCCURRENCES.
  final forms = lemma['surface_forms'];
  if (forms is! List) {
    throw const FormatException('lemma.surface_forms must be an array.');
  }
  for (final rawForm in forms) {
    final form = _asMap(rawForm, 'surface_forms[]');
    final textAr = _asString(form['text_ar'], 'surface_form.text_ar');
    final formLatin = _asString(form['latin'], 'surface_form.latin');
    final surfaceFormId = await _upsertSurfaceForm(
      db,
      lemmaId: lemmaId,
      textAr: textAr,
      latin: formLatin,
    );

    final verses = form['verses'];
    if (verses is! List) {
      throw const FormatException('surface_form.verses must be an array.');
    }
    for (final rawVerse in verses) {
      final verse = _asMap(rawVerse, 'verses[]');
      final surah = _asInt(verse['surah'], 'verse.surah');
      final ayah = _asInt(verse['ayah'], 'verse.ayah');
      final textUthmani = _asString(
        verse['text_uthmani'],
        'verse.text_uthmani',
      );
      final textSimple =
          (verse['text_simple'] as String?) ?? normalizeArabic(textUthmani);
      final position = (verse['position'] as num?)?.toInt() ?? 0;

      final verseId = await _upsertVerse(
        db,
        surah: surah,
        ayah: ayah,
        textUthmani: textUthmani,
        textSimple: textSimple,
      );
      await _upsertOccurrence(
        db,
        surfaceFormId: surfaceFormId,
        verseId: verseId,
        position: position,
      );
    }
  }
}

// ── idempotent upserts ────────────────────────────────────────────────────────

Future<int> _upsertRoot(
  AppDatabase db, {
  required String rootAr,
  required String latin,
}) async {
  final existing =
      await (db.select(db.roots)
            ..where((r) => r.rootAr.equals(rootAr))
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return existing.id;
  return db
      .into(db.roots)
      .insert(
        RootsCompanion.insert(
          rootAr: rootAr,
          rootNormalized: normalizeArabic(rootAr),
          latin: latin,
        ),
      );
}

Future<int> _upsertLemma(
  AppDatabase db, {
  required int rootId,
  required String lemmaAr,
  required String latin,
  required String pos,
  required int frequency,
}) async {
  final existing =
      await (db.select(db.lemmas)
            ..where((l) => l.lemmaAr.equals(lemmaAr) & l.rootId.equals(rootId))
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return existing.id;
  return db
      .into(db.lemmas)
      .insert(
        LemmasCompanion.insert(
          rootId: Value(rootId),
          lemmaAr: lemmaAr,
          searchKey: normalizeArabic(lemmaAr),
          latin: latin,
          pos: Value(pos),
          frequency: Value(frequency),
        ),
      );
}

Future<int> _upsertSurfaceForm(
  AppDatabase db, {
  required int lemmaId,
  required String textAr,
  required String latin,
}) async {
  final existing =
      await (db.select(db.surfaceForms)
            ..where((s) => s.lemmaId.equals(lemmaId) & s.textAr.equals(textAr))
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return existing.id;
  return db
      .into(db.surfaceForms)
      .insert(
        SurfaceFormsCompanion.insert(
          lemmaId: lemmaId,
          textAr: textAr,
          searchKey: normalizeArabic(textAr),
          latin: latin,
        ),
      );
}

Future<int> _upsertVerse(
  AppDatabase db, {
  required int surah,
  required int ayah,
  required String textUthmani,
  required String textSimple,
}) async {
  final existing =
      await (db.select(db.verses)
            ..where((v) => v.surah.equals(surah) & v.ayah.equals(ayah))
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return existing.id;
  return db
      .into(db.verses)
      .insert(
        VersesCompanion.insert(
          surah: surah,
          ayah: ayah,
          textUthmani: textUthmani,
          textSimple: Value(textSimple),
        ),
      );
}

Future<void> _upsertOccurrence(
  AppDatabase db, {
  required int surfaceFormId,
  required int verseId,
  required int position,
}) async {
  final existing =
      await (db.select(db.occurrences)
            ..where(
              (o) =>
                  o.surfaceFormId.equals(surfaceFormId) &
                  o.verseId.equals(verseId),
            )
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return;
  await db
      .into(db.occurrences)
      .insert(
        OccurrencesCompanion.insert(
          surfaceFormId: surfaceFormId,
          verseId: verseId,
          position: position,
        ),
      );
}

// ── tiny JSON coercion helpers (clear errors over silent nulls) ───────────────

Map<String, dynamic> _asMap(Object? v, String field) {
  if (v is Map<String, dynamic>) return v;
  throw FormatException('Expected object for "$field", got ${v.runtimeType}.');
}

String _asString(Object? v, String field) {
  if (v is String && v.isNotEmpty) return v;
  throw FormatException('Expected non-empty string for "$field".');
}

int _asInt(Object? v, String field) {
  if (v is num) return v.toInt();
  throw FormatException('Expected integer for "$field".');
}
