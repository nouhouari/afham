import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:bayan/data/database/daos/search_dao.dart';
import 'package:bayan/data/database/daos/seed_dao.dart';
import 'package:bayan/data/database/daos/word_detail_dao.dart';

part 'app_database.g.dart';

/// The single Drift database instance for Bayan.
///
/// Opened with [driftDatabase] (drift_flutter) which picks the correct
/// SQLite backend per platform and enables WAL mode automatically.
@DriftDatabase(
  include: {'package:bayan/data/database/tables.drift'},
  daos: [SearchDao, SeedDao, WordDetailDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'bayan'));

  /// In-memory constructor for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
  );
}
