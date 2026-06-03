import 'package:drift/drift.dart';

import 'package:bayan/data/database/app_database.dart';

part 'seed_dao.g.dart';

/// Low-level DAO used exclusively by the seed loader.
///
/// Provides typed insert helpers so the seed file does not have to reference
/// generated companion classes directly.
@DriftAccessor(include: {'package:bayan/data/database/tables.drift'})
class SeedDao extends DatabaseAccessor<AppDatabase> with _$SeedDaoMixin {
  SeedDao(super.db);

  Future<int> insertRoot(RootsCompanion root) =>
      into(roots).insertOnConflictUpdate(root);

  Future<int> insertLemma(LemmasCompanion lemma) =>
      into(lemmas).insertOnConflictUpdate(lemma);

  Future<void> insertWordContent(WordContentCompanion wc) =>
      into(wordContent).insertOnConflictUpdate(wc);

  Future<int> insertSurfaceForm(SurfaceFormsCompanion sf) =>
      into(surfaceForms).insertOnConflictUpdate(sf);

  Future<int> insertVerse(VersesCompanion verse) =>
      into(verses).insertOnConflictUpdate(verse);

  Future<void> insertOccurrence(OccurrencesCompanion occ) =>
      into(occurrences).insertOnConflictUpdate(occ);
}
