import 'package:drift/drift.dart';

import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/models/lemma_detail.dart';

part 'word_detail_dao.g.dart';

/// DAO for the word-detail sheet and root-family screen.
///
/// [getLemmaDetail] loads the full fiche content for a single lemma.
/// [lemmasByRoot] loads all lemmas sharing a given root (sorted by frequency).
@DriftAccessor(include: {'package:bayan/data/database/tables.drift'})
class WordDetailDao extends DatabaseAccessor<AppDatabase>
    with _$WordDetailDaoMixin {
  WordDetailDao(super.db);

  // ── getLemmaDetail ──────────────────────────────────────────────────────────

  /// Returns the full [LemmaDetail] for [lemmaId] in [langCode].
  ///
  /// Returns `null` if the lemma does not exist (invalid id).
  /// Audio and verse snippets are loaded in the same query where possible.
  Future<LemmaDetail?> getLemmaDetail(
    int lemmaId, {
    String langCode = 'fr',
  }) async {
    // Primary row: lemma + root + content + audio.
    final rows = await customSelect(
      '''
      SELECT
        l.id        AS lemma_id,
        l.lemma_ar  AS lemma_ar,
        l.latin     AS latin,
        l.pos       AS pos,
        l.frequency AS frequency,
        COALESCE(r.id,         0)  AS root_id,
        COALESCE(r.root_ar,   '') AS root_ar,
        COALESCE(r.latin,     '') AS root_latin,
        COALESCE(wc.translation, '') AS translation,
        COALESCE(wc.tafsir,      '') AS tafsir,
        COALESCE(wc.gem,         '') AS gem,
        COALESCE(wc.mnemonic,    '') AS mnemonic,
        ac.id          AS audio_id,
        ac.pack_file   AS audio_pack_file,
        ac.start_ms    AS audio_start_ms,
        ac.duration_ms AS audio_duration_ms
      FROM lemmas l
      LEFT JOIN roots r         ON r.id        = l.root_id
      LEFT JOIN word_content wc  ON wc.lemma_id = l.id
                                 AND wc.lang_code = ?
      LEFT JOIN audio_clips ac   ON ac.id        = l.audio_id
      WHERE l.id = ?
      LIMIT 1
      ''',
      variables: [Variable.withString(langCode), Variable.withInt(lemmaId)],
      readsFrom: {lemmas, roots, wordContent, audioClips},
    ).get();

    if (rows.isEmpty) return null;
    final row = rows.first;

    // Load up to 2 verse snippets for this lemma.
    final verseRows = await customSelect(
      '''
      SELECT DISTINCT
        v.surah          AS surah,
        v.ayah           AS ayah,
        v.text_uthmani   AS text_uthmani
      FROM occurrences occ
      JOIN surface_forms sf ON sf.id     = occ.surface_form_id
      JOIN verses v          ON v.id      = occ.verse_id
      WHERE sf.lemma_id = ?
      ORDER BY v.surah, v.ayah
      LIMIT 2
      ''',
      variables: [Variable.withInt(lemmaId)],
      readsFrom: {occurrences, surfaceForms, verses},
    ).get();

    final verseSnippets = verseRows
        .map(
          (r) => VerseSnippet(
            surah: r.read<int>('surah'),
            ayah: r.read<int>('ayah'),
            textUthmani: r.read<String>('text_uthmani'),
          ),
        )
        .toList();

    return LemmaDetail(
      lemmaId: row.read<int>('lemma_id'),
      lemmaAr: row.read<String>('lemma_ar'),
      latin: row.read<String>('latin'),
      pos: row.read<String>('pos'),
      frequency: row.read<int>('frequency'),
      rootId: row.read<int>('root_id'),
      rootAr: row.read<String>('root_ar'),
      rootLatin: row.read<String>('root_latin'),
      translation: row.read<String>('translation'),
      tafsir: row.read<String>('tafsir'),
      gem: row.read<String>('gem'),
      mnemonic: row.read<String>('mnemonic'),
      verses: verseSnippets,
      audioId: row.readNullable<int>('audio_id'),
      audioPackFile: row.readNullable<String>('audio_pack_file'),
      audioStartMs: row.readNullable<int>('audio_start_ms'),
      audioDurationMs: row.readNullable<int>('audio_duration_ms'),
    );
  }

  // ── lemmasByRoot ────────────────────────────────────────────────────────────

  /// Returns all [RootFamilyItem]s sharing [rootId], sorted by frequency DESC.
  Future<List<RootFamilyItem>> lemmasByRoot(
    int rootId, {
    String langCode = 'fr',
  }) async {
    final rows = await customSelect(
      '''
      SELECT
        l.id        AS lemma_id,
        l.lemma_ar  AS lemma_ar,
        l.latin     AS latin,
        l.pos       AS pos,
        l.frequency AS frequency,
        COALESCE(wc.translation, '') AS translation,
        ac.id          AS audio_id,
        ac.pack_file   AS audio_pack_file,
        ac.start_ms    AS audio_start_ms,
        ac.duration_ms AS audio_duration_ms
      FROM lemmas l
      LEFT JOIN word_content wc ON wc.lemma_id = l.id
                                AND wc.lang_code = ?
      LEFT JOIN audio_clips ac  ON ac.id = l.audio_id
      WHERE l.root_id = ?
      ORDER BY l.frequency DESC
      ''',
      variables: [Variable.withString(langCode), Variable.withInt(rootId)],
      readsFrom: {lemmas, wordContent, audioClips},
    ).get();

    return rows
        .map(
          (r) => RootFamilyItem(
            lemmaId: r.read<int>('lemma_id'),
            lemmaAr: r.read<String>('lemma_ar'),
            latin: r.read<String>('latin'),
            pos: r.read<String>('pos'),
            frequency: r.read<int>('frequency'),
            translation: r.read<String>('translation'),
            audioId: r.readNullable<int>('audio_id'),
            audioPackFile: r.readNullable<String>('audio_pack_file'),
            audioStartMs: r.readNullable<int>('audio_start_ms'),
            audioDurationMs: r.readNullable<int>('audio_duration_ms'),
          ),
        )
        .toList();
  }

  // ── wordOfDay ───────────────────────────────────────────────────────────────

  /// Returns a lemma chosen deterministically by [dayIndex] (typically
  /// `DateTime.now().day` from the calling layer). Returns `null` if the
  /// database is empty.
  Future<LemmaDetail?> wordOfDay(int dayIndex, {String langCode = 'fr'}) async {
    // Count lemmas to derive a stable index.
    final countRow = await customSelect(
      'SELECT COUNT(*) AS c FROM lemmas',
      readsFrom: {lemmas},
    ).getSingle();
    final count = countRow.read<int>('c');
    if (count == 0) return null;

    final index = dayIndex % count;

    final idRow = await customSelect(
      'SELECT id FROM lemmas ORDER BY id LIMIT 1 OFFSET ?',
      variables: [Variable.withInt(index)],
      readsFrom: {lemmas},
    ).getSingle();

    return getLemmaDetail(idRow.read<int>('id'), langCode: langCode);
  }
}
