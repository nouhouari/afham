import 'package:drift/drift.dart';

import 'package:bayan/core/text/arabic_normalizer.dart';
import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/models/search_result.dart';

part 'search_dao.g.dart';

/// DAO for tolerant search over the Quranic vocabulary.
///
/// Query pipeline (Arabic and Latin run **together** and are unioned — the
/// query is never routed to a single script):
///  1. Arabic   : normaliseArabic(query) → FTS5 prefix on forms_fts.search_key
///     **and** lemmas.search_key (the bare dictionary form) → lemma ids.
///  2. Latin    : query.toLowerCase() → FTS5 prefix on forms_fts.latin, plus a
///     LIKE fallback on lemmas.latin → lemma ids.
///  3. Union the two id sets.
///  4. Load word_content for the requested lang_code.
///  5. Sort by lemma.frequency DESC.
@DriftAccessor(include: {'package:bayan/data/database/tables.drift'})
class SearchDao extends DatabaseAccessor<AppDatabase> with _$SearchDaoMixin {
  SearchDao(super.db);

  // ── public API ─────────────────────────────────────────────────────────────

  /// Returns up to [limit] [SearchResult]s matching [query], localised in
  /// [langCode] (default 'fr').
  ///
  /// Empty / whitespace-only query returns an empty list immediately.
  Future<List<SearchResult>> searchLemmas(
    String query, {
    String langCode = 'fr',
    int limit = 30,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    // Search the Arabic and the Latin/transliteration indexes *together* in one
    // pass and union the matches — the query is no longer gated to a single
    // script by detection, so a word is found whether typed in Arabic letters
    // or in transliteration (the irrelevant index simply returns nothing).
    final lemmaIds = <int>{
      ...await _ftsArabic(trimmed, limit: limit),
      ...await _ftsLatin(trimmed, limit: limit),
    };
    if (lemmaIds.isEmpty) return const [];

    return _buildResults(lemmaIds, langCode: langCode, limit: limit);
  }

  // ── FTS helpers ────────────────────────────────────────────────────────────

  /// Prefix search on the Arabic side: the surface-form FTS index **and** each
  /// lemma's own dictionary form.
  Future<Set<int>> _ftsArabic(String query, {required int limit}) async {
    final key = normalizeArabic(query);
    if (key.isEmpty) return const {};

    // (a) FTS5 prefix query over the surface forms (as they appear in verses).
    final rows = await customSelect(
      'SELECT sf.lemma_id AS lemma_id '
      'FROM forms_fts ff '
      'JOIN surface_forms sf ON sf.id = ff.rowid '
      "WHERE ff.search_key MATCH ? || '*' "
      'LIMIT ?',
      variables: [Variable.withString(key), Variable.withInt(limit)],
      readsFrom: {surfaceForms, formsFts},
    ).get();

    // (b) Also match each lemma's own normalized dictionary form
    // (lemmas.search_key). Quranic surface forms often carry the article or a
    // case ending (صَبْر → ٱلصَّبْرِ), so without this a user typing the bare
    // word «صبر» would find nothing. The lemma key is the bare form, so a prefix
    // LIKE makes every lemma findable by what a learner would naturally type.
    final lemmaRows = await customSelect(
      "SELECT id AS lemma_id FROM lemmas WHERE search_key LIKE ? || '%' LIMIT ?",
      variables: [Variable.withString(key), Variable.withInt(limit)],
      readsFrom: {lemmas},
    ).get();

    return {
      for (final r in rows) r.read<int>('lemma_id'),
      for (final r in lemmaRows) r.read<int>('lemma_id'),
    };
  }

  /// Prefix FTS5 search on the Latin column.
  Future<Set<int>> _ftsLatin(String query, {required int limit}) async {
    final key = query.trim().toLowerCase();
    if (key.isEmpty) return const {};

    final rows = await customSelect(
      'SELECT sf.lemma_id AS lemma_id '
      'FROM forms_fts ff '
      'JOIN surface_forms sf ON sf.id = ff.rowid '
      "WHERE ff.latin MATCH ? || '*' "
      'LIMIT ?',
      variables: [Variable.withString(key), Variable.withInt(limit)],
      readsFrom: {surfaceForms, formsFts},
    ).get();

    // Also fallback: direct LIKE on lemmas.latin (handles cases where a lemma
    // has no surface forms yet, or the FTS didn't index the lemma latin field).
    final likeRows = await customSelect(
      'SELECT id AS lemma_id FROM lemmas WHERE latin LIKE ? LIMIT ?',
      variables: [Variable.withString('%$key%'), Variable.withInt(limit)],
      readsFrom: {lemmas},
    ).get();

    return {
      for (final r in rows) r.read<int>('lemma_id'),
      for (final r in likeRows) r.read<int>('lemma_id'),
    };
  }

  // ── result builder ─────────────────────────────────────────────────────────

  Future<List<SearchResult>> _buildResults(
    Set<int> lemmaIds, {
    required String langCode,
    required int limit,
  }) async {
    if (lemmaIds.isEmpty) return const [];

    // Build an IN clause. Drift's customSelect handles the variable binding.
    final idList = lemmaIds.toList();
    final placeholders = List.filled(idList.length, '?').join(', ');

    final rows = await customSelect(
      '''
      SELECT
        l.id        AS lemma_id,
        l.lemma_ar  AS lemma_ar,
        l.latin     AS latin,
        l.pos       AS pos,
        l.frequency AS frequency,
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
      WHERE l.id IN ($placeholders)
      ORDER BY l.frequency DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withString(langCode),
        ...idList.map(Variable.withInt),
        Variable.withInt(limit),
      ],
      readsFrom: {lemmas, roots, wordContent, audioClips},
    ).get();

    return rows
        .map(
          (r) => SearchResult(
            lemmaId: r.read<int>('lemma_id'),
            lemmaAr: r.read<String>('lemma_ar'),
            latin: r.read<String>('latin'),
            pos: r.read<String>('pos'),
            frequency: r.read<int>('frequency'),
            rootAr: r.read<String>('root_ar'),
            rootLatin: r.read<String>('root_latin'),
            translation: r.read<String>('translation'),
            tafsir: r.read<String>('tafsir'),
            gem: r.read<String>('gem'),
            mnemonic: r.read<String>('mnemonic'),
            audioId: r.readNullable<int>('audio_id'),
            audioPackFile: r.readNullable<String>('audio_pack_file'),
            audioStartMs: r.readNullable<int>('audio_start_ms'),
            audioDurationMs: r.readNullable<int>('audio_duration_ms'),
          ),
        )
        .toList();
  }

  /// Checks whether the database has been seeded (i.e. lemmas table is
  /// non-empty). Used by the seed loader to avoid double-seeding.
  Future<bool> isSeeded() async {
    final row = await customSelect(
      'SELECT COUNT(*) AS c FROM lemmas',
      readsFrom: {lemmas},
    ).getSingle();
    return row.read<int>('c') > 0;
  }
}
