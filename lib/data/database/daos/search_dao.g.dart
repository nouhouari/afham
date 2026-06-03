// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_dao.dart';

// ignore_for_file: type=lint
mixin _$SearchDaoMixin on DatabaseAccessor<AppDatabase> {
  AudioClips get audioClips => attachedDatabase.audioClips;
  Roots get roots => attachedDatabase.roots;
  Lemmas get lemmas => attachedDatabase.lemmas;
  WordContent get wordContent => attachedDatabase.wordContent;
  SurfaceForms get surfaceForms => attachedDatabase.surfaceForms;
  Verses get verses => attachedDatabase.verses;
  Occurrences get occurrences => attachedDatabase.occurrences;
  FormsFts get formsFts => attachedDatabase.formsFts;
  SearchDaoManager get managers => SearchDaoManager(this);
}

class SearchDaoManager {
  final _$SearchDaoMixin _db;
  SearchDaoManager(this._db);
  $AudioClipsTableManager get audioClips =>
      $AudioClipsTableManager(_db.attachedDatabase, _db.audioClips);
  $RootsTableManager get roots =>
      $RootsTableManager(_db.attachedDatabase, _db.roots);
  $LemmasTableManager get lemmas =>
      $LemmasTableManager(_db.attachedDatabase, _db.lemmas);
  $WordContentTableManager get wordContent =>
      $WordContentTableManager(_db.attachedDatabase, _db.wordContent);
  $SurfaceFormsTableManager get surfaceForms =>
      $SurfaceFormsTableManager(_db.attachedDatabase, _db.surfaceForms);
  $VersesTableManager get verses =>
      $VersesTableManager(_db.attachedDatabase, _db.verses);
  $OccurrencesTableManager get occurrences =>
      $OccurrencesTableManager(_db.attachedDatabase, _db.occurrences);
  $FormsFtsTableManager get formsFts =>
      $FormsFtsTableManager(_db.attachedDatabase, _db.formsFts);
}
