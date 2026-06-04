import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/models/lemma_detail.dart';
import 'package:bayan/data/database/models/search_result.dart';
import 'package:bayan/data/seed/audio_seed_importer.dart';
import 'package:bayan/data/seed/json_seed_importer.dart';
import 'package:bayan/data/seed/seed_data.dart';

part 'database_provider.g.dart';

/// The singleton [AppDatabase] instance, kept alive for the app lifecycle.
///
/// Seeding is triggered here on first access: if the database is empty we
/// insert the seed dataset before returning, so the first search already
/// works.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  // Dispose the database when the provider is destroyed (app shutdown or
  // test teardown).
  ref.onDispose(db.close);
  // Fire-and-forget seed: the database is ready immediately for reads; the
  // seed inserts happen asynchronously and complete within a few frames on
  // first launch. Using Future.microtask keeps the provider constructor
  // synchronous.
  Future.microtask(() async {
    final seeded = await db.searchDao.isSeeded();
    if (!seeded) {
      // Primary path: import the generated JSON content bundled as an asset.
      // Fallback: the hand-written Dart seed, so the app is never empty even
      // if the asset is missing or malformed during development.
      try {
        await importLemmasFromAsset(db);
      } catch (_) {
        await seedDatabase(db);
      }
    }
    // Audio manifest is imported (or re-imported) every launch so that adding
    // new packs during development is reflected without clearing app data.
    // importAudioManifestFromAsset is a no-op if the asset is absent.
    await importAudioManifestFromAsset(db);
  });
  return db;
}

/// State holder for the live search query string.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;

  void clear() => state = '';
}

/// Provider that executes the FTS5 search whenever [searchQueryProvider]
/// changes. Returns an empty list for blank queries.
@riverpod
Future<List<SearchResult>> searchResults(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final query = ref.watch(searchQueryProvider);
  final lang = ref.watch(localeProvider).languageCode;
  // Expose a stable empty list for blank queries without hitting the DB.
  if (query.trim().isEmpty) return const [];
  return db.searchDao.searchLemmas(query, langCode: lang);
}

/// Loads the full [LemmaDetail] for a given lemma id.
///
/// Used by the word-detail sheet and (indirectly) the word-of-day card.
@riverpod
Future<LemmaDetail?> lemmaDetail(Ref ref, int lemmaId) async {
  final db = ref.watch(appDatabaseProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return db.wordDetailDao.getLemmaDetail(lemmaId, langCode: lang);
}

/// Returns all lemmas sharing [rootId] for the root-family screen.
@riverpod
Future<List<RootFamilyItem>> rootFamilyItems(Ref ref, int rootId) async {
  final db = ref.watch(appDatabaseProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return db.wordDetailDao.lemmasByRoot(rootId, langCode: lang);
}

/// Returns the deterministic word-of-the-day lemma detail.
///
/// [dayOfMonth] should be [DateTime.now().day] from the UI layer, so this
/// provider itself stays pure and testable.
@riverpod
Future<LemmaDetail?> wordOfDay(Ref ref, int dayOfMonth) async {
  final db = ref.watch(appDatabaseProvider);
  final lang = ref.watch(localeProvider).languageCode;
  return db.wordDetailDao.wordOfDay(dayOfMonth, langCode: lang);
}
