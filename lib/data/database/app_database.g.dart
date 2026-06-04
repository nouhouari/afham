// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class AudioClips extends Table with TableInfo<AudioClips, AudioClip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AudioClips(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _packFileMeta = const VerificationMeta(
    'packFile',
  );
  late final GeneratedColumn<String> packFile = GeneratedColumn<String>(
    'pack_file',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _startMsMeta = const VerificationMeta(
    'startMs',
  );
  late final GeneratedColumn<int> startMs = GeneratedColumn<int>(
    'start_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, packFile, startMs, durationMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_clips';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioClip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pack_file')) {
      context.handle(
        _packFileMeta,
        packFile.isAcceptableOrUnknown(data['pack_file']!, _packFileMeta),
      );
    } else if (isInserting) {
      context.missing(_packFileMeta);
    }
    if (data.containsKey('start_ms')) {
      context.handle(
        _startMsMeta,
        startMs.isAcceptableOrUnknown(data['start_ms']!, _startMsMeta),
      );
    } else if (isInserting) {
      context.missing(_startMsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioClip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioClip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_file'],
      )!,
      startMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_ms'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
    );
  }

  @override
  AudioClips createAlias(String alias) {
    return AudioClips(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AudioClip extends DataClass implements Insertable<AudioClip> {
  final int id;
  final String packFile;
  final int startMs;
  final int durationMs;
  const AudioClip({
    required this.id,
    required this.packFile,
    required this.startMs,
    required this.durationMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pack_file'] = Variable<String>(packFile);
    map['start_ms'] = Variable<int>(startMs);
    map['duration_ms'] = Variable<int>(durationMs);
    return map;
  }

  AudioClipsCompanion toCompanion(bool nullToAbsent) {
    return AudioClipsCompanion(
      id: Value(id),
      packFile: Value(packFile),
      startMs: Value(startMs),
      durationMs: Value(durationMs),
    );
  }

  factory AudioClip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioClip(
      id: serializer.fromJson<int>(json['id']),
      packFile: serializer.fromJson<String>(json['pack_file']),
      startMs: serializer.fromJson<int>(json['start_ms']),
      durationMs: serializer.fromJson<int>(json['duration_ms']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pack_file': serializer.toJson<String>(packFile),
      'start_ms': serializer.toJson<int>(startMs),
      'duration_ms': serializer.toJson<int>(durationMs),
    };
  }

  AudioClip copyWith({
    int? id,
    String? packFile,
    int? startMs,
    int? durationMs,
  }) => AudioClip(
    id: id ?? this.id,
    packFile: packFile ?? this.packFile,
    startMs: startMs ?? this.startMs,
    durationMs: durationMs ?? this.durationMs,
  );
  AudioClip copyWithCompanion(AudioClipsCompanion data) {
    return AudioClip(
      id: data.id.present ? data.id.value : this.id,
      packFile: data.packFile.present ? data.packFile.value : this.packFile,
      startMs: data.startMs.present ? data.startMs.value : this.startMs,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioClip(')
          ..write('id: $id, ')
          ..write('packFile: $packFile, ')
          ..write('startMs: $startMs, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packFile, startMs, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioClip &&
          other.id == this.id &&
          other.packFile == this.packFile &&
          other.startMs == this.startMs &&
          other.durationMs == this.durationMs);
}

class AudioClipsCompanion extends UpdateCompanion<AudioClip> {
  final Value<int> id;
  final Value<String> packFile;
  final Value<int> startMs;
  final Value<int> durationMs;
  const AudioClipsCompanion({
    this.id = const Value.absent(),
    this.packFile = const Value.absent(),
    this.startMs = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  AudioClipsCompanion.insert({
    this.id = const Value.absent(),
    required String packFile,
    required int startMs,
    required int durationMs,
  }) : packFile = Value(packFile),
       startMs = Value(startMs),
       durationMs = Value(durationMs);
  static Insertable<AudioClip> custom({
    Expression<int>? id,
    Expression<String>? packFile,
    Expression<int>? startMs,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packFile != null) 'pack_file': packFile,
      if (startMs != null) 'start_ms': startMs,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  AudioClipsCompanion copyWith({
    Value<int>? id,
    Value<String>? packFile,
    Value<int>? startMs,
    Value<int>? durationMs,
  }) {
    return AudioClipsCompanion(
      id: id ?? this.id,
      packFile: packFile ?? this.packFile,
      startMs: startMs ?? this.startMs,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packFile.present) {
      map['pack_file'] = Variable<String>(packFile.value);
    }
    if (startMs.present) {
      map['start_ms'] = Variable<int>(startMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioClipsCompanion(')
          ..write('id: $id, ')
          ..write('packFile: $packFile, ')
          ..write('startMs: $startMs, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class Roots extends Table with TableInfo<Roots, Root> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Roots(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _rootArMeta = const VerificationMeta('rootAr');
  late final GeneratedColumn<String> rootAr = GeneratedColumn<String>(
    'root_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _rootNormalizedMeta = const VerificationMeta(
    'rootNormalized',
  );
  late final GeneratedColumn<String> rootNormalized = GeneratedColumn<String>(
    'root_normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _latinMeta = const VerificationMeta('latin');
  late final GeneratedColumn<String> latin = GeneratedColumn<String>(
    'latin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, rootAr, rootNormalized, latin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Root> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('root_ar')) {
      context.handle(
        _rootArMeta,
        rootAr.isAcceptableOrUnknown(data['root_ar']!, _rootArMeta),
      );
    } else if (isInserting) {
      context.missing(_rootArMeta);
    }
    if (data.containsKey('root_normalized')) {
      context.handle(
        _rootNormalizedMeta,
        rootNormalized.isAcceptableOrUnknown(
          data['root_normalized']!,
          _rootNormalizedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rootNormalizedMeta);
    }
    if (data.containsKey('latin')) {
      context.handle(
        _latinMeta,
        latin.isAcceptableOrUnknown(data['latin']!, _latinMeta),
      );
    } else if (isInserting) {
      context.missing(_latinMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Root map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Root(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      rootAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_ar'],
      )!,
      rootNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_normalized'],
      )!,
      latin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latin'],
      )!,
    );
  }

  @override
  Roots createAlias(String alias) {
    return Roots(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Root extends DataClass implements Insertable<Root> {
  final int id;
  final String rootAr;
  final String rootNormalized;

  /// normalizeArabic(root_ar)
  final String latin;
  const Root({
    required this.id,
    required this.rootAr,
    required this.rootNormalized,
    required this.latin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['root_ar'] = Variable<String>(rootAr);
    map['root_normalized'] = Variable<String>(rootNormalized);
    map['latin'] = Variable<String>(latin);
    return map;
  }

  RootsCompanion toCompanion(bool nullToAbsent) {
    return RootsCompanion(
      id: Value(id),
      rootAr: Value(rootAr),
      rootNormalized: Value(rootNormalized),
      latin: Value(latin),
    );
  }

  factory Root.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Root(
      id: serializer.fromJson<int>(json['id']),
      rootAr: serializer.fromJson<String>(json['root_ar']),
      rootNormalized: serializer.fromJson<String>(json['root_normalized']),
      latin: serializer.fromJson<String>(json['latin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'root_ar': serializer.toJson<String>(rootAr),
      'root_normalized': serializer.toJson<String>(rootNormalized),
      'latin': serializer.toJson<String>(latin),
    };
  }

  Root copyWith({
    int? id,
    String? rootAr,
    String? rootNormalized,
    String? latin,
  }) => Root(
    id: id ?? this.id,
    rootAr: rootAr ?? this.rootAr,
    rootNormalized: rootNormalized ?? this.rootNormalized,
    latin: latin ?? this.latin,
  );
  Root copyWithCompanion(RootsCompanion data) {
    return Root(
      id: data.id.present ? data.id.value : this.id,
      rootAr: data.rootAr.present ? data.rootAr.value : this.rootAr,
      rootNormalized: data.rootNormalized.present
          ? data.rootNormalized.value
          : this.rootNormalized,
      latin: data.latin.present ? data.latin.value : this.latin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Root(')
          ..write('id: $id, ')
          ..write('rootAr: $rootAr, ')
          ..write('rootNormalized: $rootNormalized, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rootAr, rootNormalized, latin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Root &&
          other.id == this.id &&
          other.rootAr == this.rootAr &&
          other.rootNormalized == this.rootNormalized &&
          other.latin == this.latin);
}

class RootsCompanion extends UpdateCompanion<Root> {
  final Value<int> id;
  final Value<String> rootAr;
  final Value<String> rootNormalized;
  final Value<String> latin;
  const RootsCompanion({
    this.id = const Value.absent(),
    this.rootAr = const Value.absent(),
    this.rootNormalized = const Value.absent(),
    this.latin = const Value.absent(),
  });
  RootsCompanion.insert({
    this.id = const Value.absent(),
    required String rootAr,
    required String rootNormalized,
    required String latin,
  }) : rootAr = Value(rootAr),
       rootNormalized = Value(rootNormalized),
       latin = Value(latin);
  static Insertable<Root> custom({
    Expression<int>? id,
    Expression<String>? rootAr,
    Expression<String>? rootNormalized,
    Expression<String>? latin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rootAr != null) 'root_ar': rootAr,
      if (rootNormalized != null) 'root_normalized': rootNormalized,
      if (latin != null) 'latin': latin,
    });
  }

  RootsCompanion copyWith({
    Value<int>? id,
    Value<String>? rootAr,
    Value<String>? rootNormalized,
    Value<String>? latin,
  }) {
    return RootsCompanion(
      id: id ?? this.id,
      rootAr: rootAr ?? this.rootAr,
      rootNormalized: rootNormalized ?? this.rootNormalized,
      latin: latin ?? this.latin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rootAr.present) {
      map['root_ar'] = Variable<String>(rootAr.value);
    }
    if (rootNormalized.present) {
      map['root_normalized'] = Variable<String>(rootNormalized.value);
    }
    if (latin.present) {
      map['latin'] = Variable<String>(latin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RootsCompanion(')
          ..write('id: $id, ')
          ..write('rootAr: $rootAr, ')
          ..write('rootNormalized: $rootNormalized, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }
}

class Lemmas extends Table with TableInfo<Lemmas, Lemma> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Lemmas(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _rootIdMeta = const VerificationMeta('rootId');
  late final GeneratedColumn<int> rootId = GeneratedColumn<int>(
    'root_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES roots(id)',
  );
  static const VerificationMeta _lemmaArMeta = const VerificationMeta(
    'lemmaAr',
  );
  late final GeneratedColumn<String> lemmaAr = GeneratedColumn<String>(
    'lemma_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _searchKeyMeta = const VerificationMeta(
    'searchKey',
  );
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
    'search_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _latinMeta = const VerificationMeta('latin');
  late final GeneratedColumn<String> latin = GeneratedColumn<String>(
    'latin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'noun\'',
    defaultValue: const CustomExpression('\'noun\''),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _audioIdMeta = const VerificationMeta(
    'audioId',
  );
  late final GeneratedColumn<int> audioId = GeneratedColumn<int>(
    'audio_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES audio_clips(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rootId,
    lemmaAr,
    searchKey,
    latin,
    pos,
    frequency,
    audioId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lemmas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lemma> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('root_id')) {
      context.handle(
        _rootIdMeta,
        rootId.isAcceptableOrUnknown(data['root_id']!, _rootIdMeta),
      );
    }
    if (data.containsKey('lemma_ar')) {
      context.handle(
        _lemmaArMeta,
        lemmaAr.isAcceptableOrUnknown(data['lemma_ar']!, _lemmaArMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaArMeta);
    }
    if (data.containsKey('search_key')) {
      context.handle(
        _searchKeyMeta,
        searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    if (data.containsKey('latin')) {
      context.handle(
        _latinMeta,
        latin.isAcceptableOrUnknown(data['latin']!, _latinMeta),
      );
    } else if (isInserting) {
      context.missing(_latinMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('audio_id')) {
      context.handle(
        _audioIdMeta,
        audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lemma map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lemma(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      rootId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}root_id'],
      ),
      lemmaAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma_ar'],
      )!,
      searchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_key'],
      )!,
      latin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latin'],
      )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency'],
      )!,
      audioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_id'],
      ),
    );
  }

  @override
  Lemmas createAlias(String alias) {
    return Lemmas(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Lemma extends DataClass implements Insertable<Lemma> {
  final int id;
  final int? rootId;
  final String lemmaAr;
  final String searchKey;

  /// normalizeArabic(lemma_ar)
  final String latin;
  final String pos;

  /// noun/verb/particle/…
  final int frequency;
  final int? audioId;
  const Lemma({
    required this.id,
    this.rootId,
    required this.lemmaAr,
    required this.searchKey,
    required this.latin,
    required this.pos,
    required this.frequency,
    this.audioId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || rootId != null) {
      map['root_id'] = Variable<int>(rootId);
    }
    map['lemma_ar'] = Variable<String>(lemmaAr);
    map['search_key'] = Variable<String>(searchKey);
    map['latin'] = Variable<String>(latin);
    map['pos'] = Variable<String>(pos);
    map['frequency'] = Variable<int>(frequency);
    if (!nullToAbsent || audioId != null) {
      map['audio_id'] = Variable<int>(audioId);
    }
    return map;
  }

  LemmasCompanion toCompanion(bool nullToAbsent) {
    return LemmasCompanion(
      id: Value(id),
      rootId: rootId == null && nullToAbsent
          ? const Value.absent()
          : Value(rootId),
      lemmaAr: Value(lemmaAr),
      searchKey: Value(searchKey),
      latin: Value(latin),
      pos: Value(pos),
      frequency: Value(frequency),
      audioId: audioId == null && nullToAbsent
          ? const Value.absent()
          : Value(audioId),
    );
  }

  factory Lemma.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lemma(
      id: serializer.fromJson<int>(json['id']),
      rootId: serializer.fromJson<int?>(json['root_id']),
      lemmaAr: serializer.fromJson<String>(json['lemma_ar']),
      searchKey: serializer.fromJson<String>(json['search_key']),
      latin: serializer.fromJson<String>(json['latin']),
      pos: serializer.fromJson<String>(json['pos']),
      frequency: serializer.fromJson<int>(json['frequency']),
      audioId: serializer.fromJson<int?>(json['audio_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'root_id': serializer.toJson<int?>(rootId),
      'lemma_ar': serializer.toJson<String>(lemmaAr),
      'search_key': serializer.toJson<String>(searchKey),
      'latin': serializer.toJson<String>(latin),
      'pos': serializer.toJson<String>(pos),
      'frequency': serializer.toJson<int>(frequency),
      'audio_id': serializer.toJson<int?>(audioId),
    };
  }

  Lemma copyWith({
    int? id,
    Value<int?> rootId = const Value.absent(),
    String? lemmaAr,
    String? searchKey,
    String? latin,
    String? pos,
    int? frequency,
    Value<int?> audioId = const Value.absent(),
  }) => Lemma(
    id: id ?? this.id,
    rootId: rootId.present ? rootId.value : this.rootId,
    lemmaAr: lemmaAr ?? this.lemmaAr,
    searchKey: searchKey ?? this.searchKey,
    latin: latin ?? this.latin,
    pos: pos ?? this.pos,
    frequency: frequency ?? this.frequency,
    audioId: audioId.present ? audioId.value : this.audioId,
  );
  Lemma copyWithCompanion(LemmasCompanion data) {
    return Lemma(
      id: data.id.present ? data.id.value : this.id,
      rootId: data.rootId.present ? data.rootId.value : this.rootId,
      lemmaAr: data.lemmaAr.present ? data.lemmaAr.value : this.lemmaAr,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      latin: data.latin.present ? data.latin.value : this.latin,
      pos: data.pos.present ? data.pos.value : this.pos,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      audioId: data.audioId.present ? data.audioId.value : this.audioId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lemma(')
          ..write('id: $id, ')
          ..write('rootId: $rootId, ')
          ..write('lemmaAr: $lemmaAr, ')
          ..write('searchKey: $searchKey, ')
          ..write('latin: $latin, ')
          ..write('pos: $pos, ')
          ..write('frequency: $frequency, ')
          ..write('audioId: $audioId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rootId,
    lemmaAr,
    searchKey,
    latin,
    pos,
    frequency,
    audioId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lemma &&
          other.id == this.id &&
          other.rootId == this.rootId &&
          other.lemmaAr == this.lemmaAr &&
          other.searchKey == this.searchKey &&
          other.latin == this.latin &&
          other.pos == this.pos &&
          other.frequency == this.frequency &&
          other.audioId == this.audioId);
}

class LemmasCompanion extends UpdateCompanion<Lemma> {
  final Value<int> id;
  final Value<int?> rootId;
  final Value<String> lemmaAr;
  final Value<String> searchKey;
  final Value<String> latin;
  final Value<String> pos;
  final Value<int> frequency;
  final Value<int?> audioId;
  const LemmasCompanion({
    this.id = const Value.absent(),
    this.rootId = const Value.absent(),
    this.lemmaAr = const Value.absent(),
    this.searchKey = const Value.absent(),
    this.latin = const Value.absent(),
    this.pos = const Value.absent(),
    this.frequency = const Value.absent(),
    this.audioId = const Value.absent(),
  });
  LemmasCompanion.insert({
    this.id = const Value.absent(),
    this.rootId = const Value.absent(),
    required String lemmaAr,
    required String searchKey,
    required String latin,
    this.pos = const Value.absent(),
    this.frequency = const Value.absent(),
    this.audioId = const Value.absent(),
  }) : lemmaAr = Value(lemmaAr),
       searchKey = Value(searchKey),
       latin = Value(latin);
  static Insertable<Lemma> custom({
    Expression<int>? id,
    Expression<int>? rootId,
    Expression<String>? lemmaAr,
    Expression<String>? searchKey,
    Expression<String>? latin,
    Expression<String>? pos,
    Expression<int>? frequency,
    Expression<int>? audioId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rootId != null) 'root_id': rootId,
      if (lemmaAr != null) 'lemma_ar': lemmaAr,
      if (searchKey != null) 'search_key': searchKey,
      if (latin != null) 'latin': latin,
      if (pos != null) 'pos': pos,
      if (frequency != null) 'frequency': frequency,
      if (audioId != null) 'audio_id': audioId,
    });
  }

  LemmasCompanion copyWith({
    Value<int>? id,
    Value<int?>? rootId,
    Value<String>? lemmaAr,
    Value<String>? searchKey,
    Value<String>? latin,
    Value<String>? pos,
    Value<int>? frequency,
    Value<int?>? audioId,
  }) {
    return LemmasCompanion(
      id: id ?? this.id,
      rootId: rootId ?? this.rootId,
      lemmaAr: lemmaAr ?? this.lemmaAr,
      searchKey: searchKey ?? this.searchKey,
      latin: latin ?? this.latin,
      pos: pos ?? this.pos,
      frequency: frequency ?? this.frequency,
      audioId: audioId ?? this.audioId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rootId.present) {
      map['root_id'] = Variable<int>(rootId.value);
    }
    if (lemmaAr.present) {
      map['lemma_ar'] = Variable<String>(lemmaAr.value);
    }
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    if (latin.present) {
      map['latin'] = Variable<String>(latin.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (audioId.present) {
      map['audio_id'] = Variable<int>(audioId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LemmasCompanion(')
          ..write('id: $id, ')
          ..write('rootId: $rootId, ')
          ..write('lemmaAr: $lemmaAr, ')
          ..write('searchKey: $searchKey, ')
          ..write('latin: $latin, ')
          ..write('pos: $pos, ')
          ..write('frequency: $frequency, ')
          ..write('audioId: $audioId')
          ..write(')'))
        .toString();
  }
}

class WordContent extends Table with TableInfo<WordContent, WordContentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WordContent(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _lemmaIdMeta = const VerificationMeta(
    'lemmaId',
  );
  late final GeneratedColumn<int> lemmaId = GeneratedColumn<int>(
    'lemma_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES lemmas(id)',
  );
  static const VerificationMeta _langCodeMeta = const VerificationMeta(
    'langCode',
  );
  late final GeneratedColumn<String> langCode = GeneratedColumn<String>(
    'lang_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _tafsirMeta = const VerificationMeta('tafsir');
  late final GeneratedColumn<String> tafsir = GeneratedColumn<String>(
    'tafsir',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _gemMeta = const VerificationMeta('gem');
  late final GeneratedColumn<String> gem = GeneratedColumn<String>(
    'gem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  static const VerificationMeta _mnemonicMeta = const VerificationMeta(
    'mnemonic',
  );
  late final GeneratedColumn<String> mnemonic = GeneratedColumn<String>(
    'mnemonic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lemmaId,
    langCode,
    translation,
    tafsir,
    gem,
    mnemonic,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_content';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordContentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lemma_id')) {
      context.handle(
        _lemmaIdMeta,
        lemmaId.isAcceptableOrUnknown(data['lemma_id']!, _lemmaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaIdMeta);
    }
    if (data.containsKey('lang_code')) {
      context.handle(
        _langCodeMeta,
        langCode.isAcceptableOrUnknown(data['lang_code']!, _langCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_langCodeMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('tafsir')) {
      context.handle(
        _tafsirMeta,
        tafsir.isAcceptableOrUnknown(data['tafsir']!, _tafsirMeta),
      );
    }
    if (data.containsKey('gem')) {
      context.handle(
        _gemMeta,
        gem.isAcceptableOrUnknown(data['gem']!, _gemMeta),
      );
    }
    if (data.containsKey('mnemonic')) {
      context.handle(
        _mnemonicMeta,
        mnemonic.isAcceptableOrUnknown(data['mnemonic']!, _mnemonicMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {lemmaId, langCode},
  ];
  @override
  WordContentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordContentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lemmaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lemma_id'],
      )!,
      langCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang_code'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      tafsir: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tafsir'],
      )!,
      gem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gem'],
      )!,
      mnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mnemonic'],
      )!,
    );
  }

  @override
  WordContent createAlias(String alias) {
    return WordContent(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(lemma_id, lang_code)'];
  @override
  bool get dontWriteConstraints => true;
}

class WordContentData extends DataClass implements Insertable<WordContentData> {
  final int id;
  final int lemmaId;
  final String langCode;

  /// 'fr' | 'en'
  final String translation;
  final String tafsir;
  final String gem;

  /// Pépite linguistique/spirituelle
  final String mnemonic;
  const WordContentData({
    required this.id,
    required this.lemmaId,
    required this.langCode,
    required this.translation,
    required this.tafsir,
    required this.gem,
    required this.mnemonic,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lemma_id'] = Variable<int>(lemmaId);
    map['lang_code'] = Variable<String>(langCode);
    map['translation'] = Variable<String>(translation);
    map['tafsir'] = Variable<String>(tafsir);
    map['gem'] = Variable<String>(gem);
    map['mnemonic'] = Variable<String>(mnemonic);
    return map;
  }

  WordContentCompanion toCompanion(bool nullToAbsent) {
    return WordContentCompanion(
      id: Value(id),
      lemmaId: Value(lemmaId),
      langCode: Value(langCode),
      translation: Value(translation),
      tafsir: Value(tafsir),
      gem: Value(gem),
      mnemonic: Value(mnemonic),
    );
  }

  factory WordContentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordContentData(
      id: serializer.fromJson<int>(json['id']),
      lemmaId: serializer.fromJson<int>(json['lemma_id']),
      langCode: serializer.fromJson<String>(json['lang_code']),
      translation: serializer.fromJson<String>(json['translation']),
      tafsir: serializer.fromJson<String>(json['tafsir']),
      gem: serializer.fromJson<String>(json['gem']),
      mnemonic: serializer.fromJson<String>(json['mnemonic']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lemma_id': serializer.toJson<int>(lemmaId),
      'lang_code': serializer.toJson<String>(langCode),
      'translation': serializer.toJson<String>(translation),
      'tafsir': serializer.toJson<String>(tafsir),
      'gem': serializer.toJson<String>(gem),
      'mnemonic': serializer.toJson<String>(mnemonic),
    };
  }

  WordContentData copyWith({
    int? id,
    int? lemmaId,
    String? langCode,
    String? translation,
    String? tafsir,
    String? gem,
    String? mnemonic,
  }) => WordContentData(
    id: id ?? this.id,
    lemmaId: lemmaId ?? this.lemmaId,
    langCode: langCode ?? this.langCode,
    translation: translation ?? this.translation,
    tafsir: tafsir ?? this.tafsir,
    gem: gem ?? this.gem,
    mnemonic: mnemonic ?? this.mnemonic,
  );
  WordContentData copyWithCompanion(WordContentCompanion data) {
    return WordContentData(
      id: data.id.present ? data.id.value : this.id,
      lemmaId: data.lemmaId.present ? data.lemmaId.value : this.lemmaId,
      langCode: data.langCode.present ? data.langCode.value : this.langCode,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      tafsir: data.tafsir.present ? data.tafsir.value : this.tafsir,
      gem: data.gem.present ? data.gem.value : this.gem,
      mnemonic: data.mnemonic.present ? data.mnemonic.value : this.mnemonic,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordContentData(')
          ..write('id: $id, ')
          ..write('lemmaId: $lemmaId, ')
          ..write('langCode: $langCode, ')
          ..write('translation: $translation, ')
          ..write('tafsir: $tafsir, ')
          ..write('gem: $gem, ')
          ..write('mnemonic: $mnemonic')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lemmaId, langCode, translation, tafsir, gem, mnemonic);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordContentData &&
          other.id == this.id &&
          other.lemmaId == this.lemmaId &&
          other.langCode == this.langCode &&
          other.translation == this.translation &&
          other.tafsir == this.tafsir &&
          other.gem == this.gem &&
          other.mnemonic == this.mnemonic);
}

class WordContentCompanion extends UpdateCompanion<WordContentData> {
  final Value<int> id;
  final Value<int> lemmaId;
  final Value<String> langCode;
  final Value<String> translation;
  final Value<String> tafsir;
  final Value<String> gem;
  final Value<String> mnemonic;
  const WordContentCompanion({
    this.id = const Value.absent(),
    this.lemmaId = const Value.absent(),
    this.langCode = const Value.absent(),
    this.translation = const Value.absent(),
    this.tafsir = const Value.absent(),
    this.gem = const Value.absent(),
    this.mnemonic = const Value.absent(),
  });
  WordContentCompanion.insert({
    this.id = const Value.absent(),
    required int lemmaId,
    required String langCode,
    required String translation,
    this.tafsir = const Value.absent(),
    this.gem = const Value.absent(),
    this.mnemonic = const Value.absent(),
  }) : lemmaId = Value(lemmaId),
       langCode = Value(langCode),
       translation = Value(translation);
  static Insertable<WordContentData> custom({
    Expression<int>? id,
    Expression<int>? lemmaId,
    Expression<String>? langCode,
    Expression<String>? translation,
    Expression<String>? tafsir,
    Expression<String>? gem,
    Expression<String>? mnemonic,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lemmaId != null) 'lemma_id': lemmaId,
      if (langCode != null) 'lang_code': langCode,
      if (translation != null) 'translation': translation,
      if (tafsir != null) 'tafsir': tafsir,
      if (gem != null) 'gem': gem,
      if (mnemonic != null) 'mnemonic': mnemonic,
    });
  }

  WordContentCompanion copyWith({
    Value<int>? id,
    Value<int>? lemmaId,
    Value<String>? langCode,
    Value<String>? translation,
    Value<String>? tafsir,
    Value<String>? gem,
    Value<String>? mnemonic,
  }) {
    return WordContentCompanion(
      id: id ?? this.id,
      lemmaId: lemmaId ?? this.lemmaId,
      langCode: langCode ?? this.langCode,
      translation: translation ?? this.translation,
      tafsir: tafsir ?? this.tafsir,
      gem: gem ?? this.gem,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lemmaId.present) {
      map['lemma_id'] = Variable<int>(lemmaId.value);
    }
    if (langCode.present) {
      map['lang_code'] = Variable<String>(langCode.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (tafsir.present) {
      map['tafsir'] = Variable<String>(tafsir.value);
    }
    if (gem.present) {
      map['gem'] = Variable<String>(gem.value);
    }
    if (mnemonic.present) {
      map['mnemonic'] = Variable<String>(mnemonic.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordContentCompanion(')
          ..write('id: $id, ')
          ..write('lemmaId: $lemmaId, ')
          ..write('langCode: $langCode, ')
          ..write('translation: $translation, ')
          ..write('tafsir: $tafsir, ')
          ..write('gem: $gem, ')
          ..write('mnemonic: $mnemonic')
          ..write(')'))
        .toString();
  }
}

class SurfaceForms extends Table with TableInfo<SurfaceForms, SurfaceForm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SurfaceForms(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _lemmaIdMeta = const VerificationMeta(
    'lemmaId',
  );
  late final GeneratedColumn<int> lemmaId = GeneratedColumn<int>(
    'lemma_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES lemmas(id)',
  );
  static const VerificationMeta _textArMeta = const VerificationMeta('textAr');
  late final GeneratedColumn<String> textAr = GeneratedColumn<String>(
    'text_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _searchKeyMeta = const VerificationMeta(
    'searchKey',
  );
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
    'search_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _latinMeta = const VerificationMeta('latin');
  late final GeneratedColumn<String> latin = GeneratedColumn<String>(
    'latin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, lemmaId, textAr, searchKey, latin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surface_forms';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurfaceForm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lemma_id')) {
      context.handle(
        _lemmaIdMeta,
        lemmaId.isAcceptableOrUnknown(data['lemma_id']!, _lemmaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaIdMeta);
    }
    if (data.containsKey('text_ar')) {
      context.handle(
        _textArMeta,
        textAr.isAcceptableOrUnknown(data['text_ar']!, _textArMeta),
      );
    } else if (isInserting) {
      context.missing(_textArMeta);
    }
    if (data.containsKey('search_key')) {
      context.handle(
        _searchKeyMeta,
        searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    if (data.containsKey('latin')) {
      context.handle(
        _latinMeta,
        latin.isAcceptableOrUnknown(data['latin']!, _latinMeta),
      );
    } else if (isInserting) {
      context.missing(_latinMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurfaceForm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurfaceForm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lemmaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lemma_id'],
      )!,
      textAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_ar'],
      )!,
      searchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_key'],
      )!,
      latin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latin'],
      )!,
    );
  }

  @override
  SurfaceForms createAlias(String alias) {
    return SurfaceForms(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SurfaceForm extends DataClass implements Insertable<SurfaceForm> {
  final int id;
  final int lemmaId;
  final String textAr;

  /// full harakat form, e.g. رَحْمَةً
  final String searchKey;

  /// normalizeArabic(text_ar)
  final String latin;
  const SurfaceForm({
    required this.id,
    required this.lemmaId,
    required this.textAr,
    required this.searchKey,
    required this.latin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lemma_id'] = Variable<int>(lemmaId);
    map['text_ar'] = Variable<String>(textAr);
    map['search_key'] = Variable<String>(searchKey);
    map['latin'] = Variable<String>(latin);
    return map;
  }

  SurfaceFormsCompanion toCompanion(bool nullToAbsent) {
    return SurfaceFormsCompanion(
      id: Value(id),
      lemmaId: Value(lemmaId),
      textAr: Value(textAr),
      searchKey: Value(searchKey),
      latin: Value(latin),
    );
  }

  factory SurfaceForm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurfaceForm(
      id: serializer.fromJson<int>(json['id']),
      lemmaId: serializer.fromJson<int>(json['lemma_id']),
      textAr: serializer.fromJson<String>(json['text_ar']),
      searchKey: serializer.fromJson<String>(json['search_key']),
      latin: serializer.fromJson<String>(json['latin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lemma_id': serializer.toJson<int>(lemmaId),
      'text_ar': serializer.toJson<String>(textAr),
      'search_key': serializer.toJson<String>(searchKey),
      'latin': serializer.toJson<String>(latin),
    };
  }

  SurfaceForm copyWith({
    int? id,
    int? lemmaId,
    String? textAr,
    String? searchKey,
    String? latin,
  }) => SurfaceForm(
    id: id ?? this.id,
    lemmaId: lemmaId ?? this.lemmaId,
    textAr: textAr ?? this.textAr,
    searchKey: searchKey ?? this.searchKey,
    latin: latin ?? this.latin,
  );
  SurfaceForm copyWithCompanion(SurfaceFormsCompanion data) {
    return SurfaceForm(
      id: data.id.present ? data.id.value : this.id,
      lemmaId: data.lemmaId.present ? data.lemmaId.value : this.lemmaId,
      textAr: data.textAr.present ? data.textAr.value : this.textAr,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      latin: data.latin.present ? data.latin.value : this.latin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurfaceForm(')
          ..write('id: $id, ')
          ..write('lemmaId: $lemmaId, ')
          ..write('textAr: $textAr, ')
          ..write('searchKey: $searchKey, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lemmaId, textAr, searchKey, latin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurfaceForm &&
          other.id == this.id &&
          other.lemmaId == this.lemmaId &&
          other.textAr == this.textAr &&
          other.searchKey == this.searchKey &&
          other.latin == this.latin);
}

class SurfaceFormsCompanion extends UpdateCompanion<SurfaceForm> {
  final Value<int> id;
  final Value<int> lemmaId;
  final Value<String> textAr;
  final Value<String> searchKey;
  final Value<String> latin;
  const SurfaceFormsCompanion({
    this.id = const Value.absent(),
    this.lemmaId = const Value.absent(),
    this.textAr = const Value.absent(),
    this.searchKey = const Value.absent(),
    this.latin = const Value.absent(),
  });
  SurfaceFormsCompanion.insert({
    this.id = const Value.absent(),
    required int lemmaId,
    required String textAr,
    required String searchKey,
    required String latin,
  }) : lemmaId = Value(lemmaId),
       textAr = Value(textAr),
       searchKey = Value(searchKey),
       latin = Value(latin);
  static Insertable<SurfaceForm> custom({
    Expression<int>? id,
    Expression<int>? lemmaId,
    Expression<String>? textAr,
    Expression<String>? searchKey,
    Expression<String>? latin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lemmaId != null) 'lemma_id': lemmaId,
      if (textAr != null) 'text_ar': textAr,
      if (searchKey != null) 'search_key': searchKey,
      if (latin != null) 'latin': latin,
    });
  }

  SurfaceFormsCompanion copyWith({
    Value<int>? id,
    Value<int>? lemmaId,
    Value<String>? textAr,
    Value<String>? searchKey,
    Value<String>? latin,
  }) {
    return SurfaceFormsCompanion(
      id: id ?? this.id,
      lemmaId: lemmaId ?? this.lemmaId,
      textAr: textAr ?? this.textAr,
      searchKey: searchKey ?? this.searchKey,
      latin: latin ?? this.latin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lemmaId.present) {
      map['lemma_id'] = Variable<int>(lemmaId.value);
    }
    if (textAr.present) {
      map['text_ar'] = Variable<String>(textAr.value);
    }
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    if (latin.present) {
      map['latin'] = Variable<String>(latin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurfaceFormsCompanion(')
          ..write('id: $id, ')
          ..write('lemmaId: $lemmaId, ')
          ..write('textAr: $textAr, ')
          ..write('searchKey: $searchKey, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }
}

class Verses extends Table with TableInfo<Verses, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Verses(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _surahMeta = const VerificationMeta('surah');
  late final GeneratedColumn<int> surah = GeneratedColumn<int>(
    'surah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _ayahMeta = const VerificationMeta('ayah');
  late final GeneratedColumn<int> ayah = GeneratedColumn<int>(
    'ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _textUthmaniMeta = const VerificationMeta(
    'textUthmani',
  );
  late final GeneratedColumn<String> textUthmani = GeneratedColumn<String>(
    'text_uthmani',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _textSimpleMeta = const VerificationMeta(
    'textSimple',
  );
  late final GeneratedColumn<String> textSimple = GeneratedColumn<String>(
    'text_simple',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'\'',
    defaultValue: const CustomExpression('\'\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surah,
    ayah,
    textUthmani,
    textSimple,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah')) {
      context.handle(
        _surahMeta,
        surah.isAcceptableOrUnknown(data['surah']!, _surahMeta),
      );
    } else if (isInserting) {
      context.missing(_surahMeta);
    }
    if (data.containsKey('ayah')) {
      context.handle(
        _ayahMeta,
        ayah.isAcceptableOrUnknown(data['ayah']!, _ayahMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahMeta);
    }
    if (data.containsKey('text_uthmani')) {
      context.handle(
        _textUthmaniMeta,
        textUthmani.isAcceptableOrUnknown(
          data['text_uthmani']!,
          _textUthmaniMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textUthmaniMeta);
    }
    if (data.containsKey('text_simple')) {
      context.handle(
        _textSimpleMeta,
        textSimple.isAcceptableOrUnknown(data['text_simple']!, _textSimpleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {surah, ayah},
  ];
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah'],
      )!,
      ayah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah'],
      )!,
      textUthmani: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_uthmani'],
      )!,
      textSimple: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_simple'],
      )!,
    );
  }

  @override
  Verses createAlias(String alias) {
    return Verses(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(surah, ayah)'];
  @override
  bool get dontWriteConstraints => true;
}

class Verse extends DataClass implements Insertable<Verse> {
  final int id;
  final int surah;
  final int ayah;
  final String textUthmani;
  final String textSimple;
  const Verse({
    required this.id,
    required this.surah,
    required this.ayah,
    required this.textUthmani,
    required this.textSimple,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah'] = Variable<int>(surah);
    map['ayah'] = Variable<int>(ayah);
    map['text_uthmani'] = Variable<String>(textUthmani);
    map['text_simple'] = Variable<String>(textSimple);
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      id: Value(id),
      surah: Value(surah),
      ayah: Value(ayah),
      textUthmani: Value(textUthmani),
      textSimple: Value(textSimple),
    );
  }

  factory Verse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      id: serializer.fromJson<int>(json['id']),
      surah: serializer.fromJson<int>(json['surah']),
      ayah: serializer.fromJson<int>(json['ayah']),
      textUthmani: serializer.fromJson<String>(json['text_uthmani']),
      textSimple: serializer.fromJson<String>(json['text_simple']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surah': serializer.toJson<int>(surah),
      'ayah': serializer.toJson<int>(ayah),
      'text_uthmani': serializer.toJson<String>(textUthmani),
      'text_simple': serializer.toJson<String>(textSimple),
    };
  }

  Verse copyWith({
    int? id,
    int? surah,
    int? ayah,
    String? textUthmani,
    String? textSimple,
  }) => Verse(
    id: id ?? this.id,
    surah: surah ?? this.surah,
    ayah: ayah ?? this.ayah,
    textUthmani: textUthmani ?? this.textUthmani,
    textSimple: textSimple ?? this.textSimple,
  );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      id: data.id.present ? data.id.value : this.id,
      surah: data.surah.present ? data.surah.value : this.surah,
      ayah: data.ayah.present ? data.ayah.value : this.ayah,
      textUthmani: data.textUthmani.present
          ? data.textUthmani.value
          : this.textUthmani,
      textSimple: data.textSimple.present
          ? data.textSimple.value
          : this.textSimple,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('id: $id, ')
          ..write('surah: $surah, ')
          ..write('ayah: $ayah, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSimple: $textSimple')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surah, ayah, textUthmani, textSimple);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.id == this.id &&
          other.surah == this.surah &&
          other.ayah == this.ayah &&
          other.textUthmani == this.textUthmani &&
          other.textSimple == this.textSimple);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<int> id;
  final Value<int> surah;
  final Value<int> ayah;
  final Value<String> textUthmani;
  final Value<String> textSimple;
  const VersesCompanion({
    this.id = const Value.absent(),
    this.surah = const Value.absent(),
    this.ayah = const Value.absent(),
    this.textUthmani = const Value.absent(),
    this.textSimple = const Value.absent(),
  });
  VersesCompanion.insert({
    this.id = const Value.absent(),
    required int surah,
    required int ayah,
    required String textUthmani,
    this.textSimple = const Value.absent(),
  }) : surah = Value(surah),
       ayah = Value(ayah),
       textUthmani = Value(textUthmani);
  static Insertable<Verse> custom({
    Expression<int>? id,
    Expression<int>? surah,
    Expression<int>? ayah,
    Expression<String>? textUthmani,
    Expression<String>? textSimple,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surah != null) 'surah': surah,
      if (ayah != null) 'ayah': ayah,
      if (textUthmani != null) 'text_uthmani': textUthmani,
      if (textSimple != null) 'text_simple': textSimple,
    });
  }

  VersesCompanion copyWith({
    Value<int>? id,
    Value<int>? surah,
    Value<int>? ayah,
    Value<String>? textUthmani,
    Value<String>? textSimple,
  }) {
    return VersesCompanion(
      id: id ?? this.id,
      surah: surah ?? this.surah,
      ayah: ayah ?? this.ayah,
      textUthmani: textUthmani ?? this.textUthmani,
      textSimple: textSimple ?? this.textSimple,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surah.present) {
      map['surah'] = Variable<int>(surah.value);
    }
    if (ayah.present) {
      map['ayah'] = Variable<int>(ayah.value);
    }
    if (textUthmani.present) {
      map['text_uthmani'] = Variable<String>(textUthmani.value);
    }
    if (textSimple.present) {
      map['text_simple'] = Variable<String>(textSimple.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('id: $id, ')
          ..write('surah: $surah, ')
          ..write('ayah: $ayah, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSimple: $textSimple')
          ..write(')'))
        .toString();
  }
}

class Occurrences extends Table with TableInfo<Occurrences, Occurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Occurrences(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _surfaceFormIdMeta = const VerificationMeta(
    'surfaceFormId',
  );
  late final GeneratedColumn<int> surfaceFormId = GeneratedColumn<int>(
    'surface_form_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES surface_forms(id)',
  );
  static const VerificationMeta _verseIdMeta = const VerificationMeta(
    'verseId',
  );
  late final GeneratedColumn<int> verseId = GeneratedColumn<int>(
    'verse_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES verses(id)',
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, surfaceFormId, verseId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Occurrence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surface_form_id')) {
      context.handle(
        _surfaceFormIdMeta,
        surfaceFormId.isAcceptableOrUnknown(
          data['surface_form_id']!,
          _surfaceFormIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surfaceFormIdMeta);
    }
    if (data.containsKey('verse_id')) {
      context.handle(
        _verseIdMeta,
        verseId.isAcceptableOrUnknown(data['verse_id']!, _verseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_verseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Occurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Occurrence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surfaceFormId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surface_form_id'],
      )!,
      verseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  Occurrences createAlias(String alias) {
    return Occurrences(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Occurrence extends DataClass implements Insertable<Occurrence> {
  final int id;
  final int surfaceFormId;
  final int verseId;
  final int position;
  const Occurrence({
    required this.id,
    required this.surfaceFormId,
    required this.verseId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surface_form_id'] = Variable<int>(surfaceFormId);
    map['verse_id'] = Variable<int>(verseId);
    map['position'] = Variable<int>(position);
    return map;
  }

  OccurrencesCompanion toCompanion(bool nullToAbsent) {
    return OccurrencesCompanion(
      id: Value(id),
      surfaceFormId: Value(surfaceFormId),
      verseId: Value(verseId),
      position: Value(position),
    );
  }

  factory Occurrence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Occurrence(
      id: serializer.fromJson<int>(json['id']),
      surfaceFormId: serializer.fromJson<int>(json['surface_form_id']),
      verseId: serializer.fromJson<int>(json['verse_id']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surface_form_id': serializer.toJson<int>(surfaceFormId),
      'verse_id': serializer.toJson<int>(verseId),
      'position': serializer.toJson<int>(position),
    };
  }

  Occurrence copyWith({
    int? id,
    int? surfaceFormId,
    int? verseId,
    int? position,
  }) => Occurrence(
    id: id ?? this.id,
    surfaceFormId: surfaceFormId ?? this.surfaceFormId,
    verseId: verseId ?? this.verseId,
    position: position ?? this.position,
  );
  Occurrence copyWithCompanion(OccurrencesCompanion data) {
    return Occurrence(
      id: data.id.present ? data.id.value : this.id,
      surfaceFormId: data.surfaceFormId.present
          ? data.surfaceFormId.value
          : this.surfaceFormId,
      verseId: data.verseId.present ? data.verseId.value : this.verseId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Occurrence(')
          ..write('id: $id, ')
          ..write('surfaceFormId: $surfaceFormId, ')
          ..write('verseId: $verseId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surfaceFormId, verseId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Occurrence &&
          other.id == this.id &&
          other.surfaceFormId == this.surfaceFormId &&
          other.verseId == this.verseId &&
          other.position == this.position);
}

class OccurrencesCompanion extends UpdateCompanion<Occurrence> {
  final Value<int> id;
  final Value<int> surfaceFormId;
  final Value<int> verseId;
  final Value<int> position;
  const OccurrencesCompanion({
    this.id = const Value.absent(),
    this.surfaceFormId = const Value.absent(),
    this.verseId = const Value.absent(),
    this.position = const Value.absent(),
  });
  OccurrencesCompanion.insert({
    this.id = const Value.absent(),
    required int surfaceFormId,
    required int verseId,
    required int position,
  }) : surfaceFormId = Value(surfaceFormId),
       verseId = Value(verseId),
       position = Value(position);
  static Insertable<Occurrence> custom({
    Expression<int>? id,
    Expression<int>? surfaceFormId,
    Expression<int>? verseId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surfaceFormId != null) 'surface_form_id': surfaceFormId,
      if (verseId != null) 'verse_id': verseId,
      if (position != null) 'position': position,
    });
  }

  OccurrencesCompanion copyWith({
    Value<int>? id,
    Value<int>? surfaceFormId,
    Value<int>? verseId,
    Value<int>? position,
  }) {
    return OccurrencesCompanion(
      id: id ?? this.id,
      surfaceFormId: surfaceFormId ?? this.surfaceFormId,
      verseId: verseId ?? this.verseId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surfaceFormId.present) {
      map['surface_form_id'] = Variable<int>(surfaceFormId.value);
    }
    if (verseId.present) {
      map['verse_id'] = Variable<int>(verseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('surfaceFormId: $surfaceFormId, ')
          ..write('verseId: $verseId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class FormsFts extends Table
    with TableInfo<FormsFts, FormsFt>, VirtualTableInfo<FormsFts, FormsFt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FormsFts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _searchKeyMeta = const VerificationMeta(
    'searchKey',
  );
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
    'search_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _latinMeta = const VerificationMeta('latin');
  late final GeneratedColumn<String> latin = GeneratedColumn<String>(
    'latin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [searchKey, latin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forms_fts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FormsFt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('search_key')) {
      context.handle(
        _searchKeyMeta,
        searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    if (data.containsKey('latin')) {
      context.handle(
        _latinMeta,
        latin.isAcceptableOrUnknown(data['latin']!, _latinMeta),
      );
    } else if (isInserting) {
      context.missing(_latinMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  FormsFt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FormsFt(
      searchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_key'],
      )!,
      latin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latin'],
      )!,
    );
  }

  @override
  FormsFts createAlias(String alias) {
    return FormsFts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(search_key, latin, content=\'surface_forms\', content_rowid=\'id\')';
}

class FormsFt extends DataClass implements Insertable<FormsFt> {
  final String searchKey;
  final String latin;
  const FormsFt({required this.searchKey, required this.latin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['search_key'] = Variable<String>(searchKey);
    map['latin'] = Variable<String>(latin);
    return map;
  }

  FormsFtsCompanion toCompanion(bool nullToAbsent) {
    return FormsFtsCompanion(searchKey: Value(searchKey), latin: Value(latin));
  }

  factory FormsFt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FormsFt(
      searchKey: serializer.fromJson<String>(json['search_key']),
      latin: serializer.fromJson<String>(json['latin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'search_key': serializer.toJson<String>(searchKey),
      'latin': serializer.toJson<String>(latin),
    };
  }

  FormsFt copyWith({String? searchKey, String? latin}) => FormsFt(
    searchKey: searchKey ?? this.searchKey,
    latin: latin ?? this.latin,
  );
  FormsFt copyWithCompanion(FormsFtsCompanion data) {
    return FormsFt(
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      latin: data.latin.present ? data.latin.value : this.latin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FormsFt(')
          ..write('searchKey: $searchKey, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(searchKey, latin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FormsFt &&
          other.searchKey == this.searchKey &&
          other.latin == this.latin);
}

class FormsFtsCompanion extends UpdateCompanion<FormsFt> {
  final Value<String> searchKey;
  final Value<String> latin;
  final Value<int> rowid;
  const FormsFtsCompanion({
    this.searchKey = const Value.absent(),
    this.latin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FormsFtsCompanion.insert({
    required String searchKey,
    required String latin,
    this.rowid = const Value.absent(),
  }) : searchKey = Value(searchKey),
       latin = Value(latin);
  static Insertable<FormsFt> custom({
    Expression<String>? searchKey,
    Expression<String>? latin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (searchKey != null) 'search_key': searchKey,
      if (latin != null) 'latin': latin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FormsFtsCompanion copyWith({
    Value<String>? searchKey,
    Value<String>? latin,
    Value<int>? rowid,
  }) {
    return FormsFtsCompanion(
      searchKey: searchKey ?? this.searchKey,
      latin: latin ?? this.latin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    if (latin.present) {
      map['latin'] = Variable<String>(latin.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FormsFtsCompanion(')
          ..write('searchKey: $searchKey, ')
          ..write('latin: $latin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final AudioClips audioClips = AudioClips(this);
  late final Roots roots = Roots(this);
  late final Lemmas lemmas = Lemmas(this);
  late final WordContent wordContent = WordContent(this);
  late final SurfaceForms surfaceForms = SurfaceForms(this);
  late final Verses verses = Verses(this);
  late final Occurrences occurrences = Occurrences(this);
  late final FormsFts formsFts = FormsFts(this);
  late final Trigger surfaceFormsAi = Trigger(
    'CREATE TRIGGER surface_forms_ai AFTER INSERT ON surface_forms BEGIN INSERT INTO forms_fts ("rowid", search_key, latin) VALUES (new.id, new.search_key, new.latin);END',
    'surface_forms_ai',
  );
  late final Trigger surfaceFormsAd = Trigger(
    'CREATE TRIGGER surface_forms_ad AFTER DELETE ON surface_forms BEGIN INSERT INTO forms_fts (forms_fts, "rowid", search_key, latin) VALUES (\'delete\', old.id, old.search_key, old.latin);END',
    'surface_forms_ad',
  );
  late final Trigger surfaceFormsAu = Trigger(
    'CREATE TRIGGER surface_forms_au AFTER UPDATE ON surface_forms BEGIN INSERT INTO forms_fts (forms_fts, "rowid", search_key, latin) VALUES (\'delete\', old.id, old.search_key, old.latin);INSERT INTO forms_fts ("rowid", search_key, latin) VALUES (new.id, new.search_key, new.latin);END',
    'surface_forms_au',
  );
  late final SearchDao searchDao = SearchDao(this as AppDatabase);
  late final SeedDao seedDao = SeedDao(this as AppDatabase);
  late final WordDetailDao wordDetailDao = WordDetailDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    audioClips,
    roots,
    lemmas,
    wordContent,
    surfaceForms,
    verses,
    occurrences,
    formsFts,
    surfaceFormsAi,
    surfaceFormsAd,
    surfaceFormsAu,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'surface_forms',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('forms_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'surface_forms',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('forms_fts', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'surface_forms',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('forms_fts', kind: UpdateKind.insert)],
    ),
  ]);
}

typedef $AudioClipsCreateCompanionBuilder =
    AudioClipsCompanion Function({
      Value<int> id,
      required String packFile,
      required int startMs,
      required int durationMs,
    });
typedef $AudioClipsUpdateCompanionBuilder =
    AudioClipsCompanion Function({
      Value<int> id,
      Value<String> packFile,
      Value<int> startMs,
      Value<int> durationMs,
    });

final class $AudioClipsReferences
    extends BaseReferences<_$AppDatabase, AudioClips, AudioClip> {
  $AudioClipsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Lemmas, List<Lemma>> _lemmasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lemmas,
    aliasName: $_aliasNameGenerator(db.audioClips.id, db.lemmas.audioId),
  );

  $LemmasProcessedTableManager get lemmasRefs {
    final manager = $LemmasTableManager(
      $_db,
      $_db.lemmas,
    ).filter((f) => f.audioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lemmasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AudioClipsFilterComposer extends Composer<_$AppDatabase, AudioClips> {
  $AudioClipsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packFile => $composableBuilder(
    column: $table.packFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lemmasRefs(
    Expression<bool> Function($LemmasFilterComposer f) f,
  ) {
    final $LemmasFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.audioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasFilterComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AudioClipsOrderingComposer extends Composer<_$AppDatabase, AudioClips> {
  $AudioClipsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packFile => $composableBuilder(
    column: $table.packFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMs => $composableBuilder(
    column: $table.startMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AudioClipsAnnotationComposer
    extends Composer<_$AppDatabase, AudioClips> {
  $AudioClipsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packFile =>
      $composableBuilder(column: $table.packFile, builder: (column) => column);

  GeneratedColumn<int> get startMs =>
      $composableBuilder(column: $table.startMs, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  Expression<T> lemmasRefs<T extends Object>(
    Expression<T> Function($LemmasAnnotationComposer a) f,
  ) {
    final $LemmasAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.audioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasAnnotationComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AudioClipsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AudioClips,
          AudioClip,
          $AudioClipsFilterComposer,
          $AudioClipsOrderingComposer,
          $AudioClipsAnnotationComposer,
          $AudioClipsCreateCompanionBuilder,
          $AudioClipsUpdateCompanionBuilder,
          (AudioClip, $AudioClipsReferences),
          AudioClip,
          PrefetchHooks Function({bool lemmasRefs})
        > {
  $AudioClipsTableManager(_$AppDatabase db, AudioClips table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AudioClipsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AudioClipsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AudioClipsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packFile = const Value.absent(),
                Value<int> startMs = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
              }) => AudioClipsCompanion(
                id: id,
                packFile: packFile,
                startMs: startMs,
                durationMs: durationMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packFile,
                required int startMs,
                required int durationMs,
              }) => AudioClipsCompanion.insert(
                id: id,
                packFile: packFile,
                startMs: startMs,
                durationMs: durationMs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $AudioClipsReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({lemmasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lemmasRefs) db.lemmas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lemmasRefs)
                    await $_getPrefetchedData<AudioClip, AudioClips, Lemma>(
                      currentTable: table,
                      referencedTable: $AudioClipsReferences._lemmasRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $AudioClipsReferences(db, table, p0).lemmasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.audioId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $AudioClipsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AudioClips,
      AudioClip,
      $AudioClipsFilterComposer,
      $AudioClipsOrderingComposer,
      $AudioClipsAnnotationComposer,
      $AudioClipsCreateCompanionBuilder,
      $AudioClipsUpdateCompanionBuilder,
      (AudioClip, $AudioClipsReferences),
      AudioClip,
      PrefetchHooks Function({bool lemmasRefs})
    >;
typedef $RootsCreateCompanionBuilder =
    RootsCompanion Function({
      Value<int> id,
      required String rootAr,
      required String rootNormalized,
      required String latin,
    });
typedef $RootsUpdateCompanionBuilder =
    RootsCompanion Function({
      Value<int> id,
      Value<String> rootAr,
      Value<String> rootNormalized,
      Value<String> latin,
    });

final class $RootsReferences
    extends BaseReferences<_$AppDatabase, Roots, Root> {
  $RootsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Lemmas, List<Lemma>> _lemmasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lemmas,
    aliasName: $_aliasNameGenerator(db.roots.id, db.lemmas.rootId),
  );

  $LemmasProcessedTableManager get lemmasRefs {
    final manager = $LemmasTableManager(
      $_db,
      $_db.lemmas,
    ).filter((f) => f.rootId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lemmasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $RootsFilterComposer extends Composer<_$AppDatabase, Roots> {
  $RootsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootAr => $composableBuilder(
    column: $table.rootAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootNormalized => $composableBuilder(
    column: $table.rootNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lemmasRefs(
    Expression<bool> Function($LemmasFilterComposer f) f,
  ) {
    final $LemmasFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.rootId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasFilterComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RootsOrderingComposer extends Composer<_$AppDatabase, Roots> {
  $RootsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootAr => $composableBuilder(
    column: $table.rootAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootNormalized => $composableBuilder(
    column: $table.rootNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $RootsAnnotationComposer extends Composer<_$AppDatabase, Roots> {
  $RootsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rootAr =>
      $composableBuilder(column: $table.rootAr, builder: (column) => column);

  GeneratedColumn<String> get rootNormalized => $composableBuilder(
    column: $table.rootNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<String> get latin =>
      $composableBuilder(column: $table.latin, builder: (column) => column);

  Expression<T> lemmasRefs<T extends Object>(
    Expression<T> Function($LemmasAnnotationComposer a) f,
  ) {
    final $LemmasAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.rootId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasAnnotationComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RootsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Roots,
          Root,
          $RootsFilterComposer,
          $RootsOrderingComposer,
          $RootsAnnotationComposer,
          $RootsCreateCompanionBuilder,
          $RootsUpdateCompanionBuilder,
          (Root, $RootsReferences),
          Root,
          PrefetchHooks Function({bool lemmasRefs})
        > {
  $RootsTableManager(_$AppDatabase db, Roots table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RootsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RootsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RootsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> rootAr = const Value.absent(),
                Value<String> rootNormalized = const Value.absent(),
                Value<String> latin = const Value.absent(),
              }) => RootsCompanion(
                id: id,
                rootAr: rootAr,
                rootNormalized: rootNormalized,
                latin: latin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String rootAr,
                required String rootNormalized,
                required String latin,
              }) => RootsCompanion.insert(
                id: id,
                rootAr: rootAr,
                rootNormalized: rootNormalized,
                latin: latin,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $RootsReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({lemmasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lemmasRefs) db.lemmas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lemmasRefs)
                    await $_getPrefetchedData<Root, Roots, Lemma>(
                      currentTable: table,
                      referencedTable: $RootsReferences._lemmasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $RootsReferences(db, table, p0).lemmasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.rootId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $RootsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Roots,
      Root,
      $RootsFilterComposer,
      $RootsOrderingComposer,
      $RootsAnnotationComposer,
      $RootsCreateCompanionBuilder,
      $RootsUpdateCompanionBuilder,
      (Root, $RootsReferences),
      Root,
      PrefetchHooks Function({bool lemmasRefs})
    >;
typedef $LemmasCreateCompanionBuilder =
    LemmasCompanion Function({
      Value<int> id,
      Value<int?> rootId,
      required String lemmaAr,
      required String searchKey,
      required String latin,
      Value<String> pos,
      Value<int> frequency,
      Value<int?> audioId,
    });
typedef $LemmasUpdateCompanionBuilder =
    LemmasCompanion Function({
      Value<int> id,
      Value<int?> rootId,
      Value<String> lemmaAr,
      Value<String> searchKey,
      Value<String> latin,
      Value<String> pos,
      Value<int> frequency,
      Value<int?> audioId,
    });

final class $LemmasReferences
    extends BaseReferences<_$AppDatabase, Lemmas, Lemma> {
  $LemmasReferences(super.$_db, super.$_table, super.$_typedResult);

  static Roots _rootIdTable(_$AppDatabase db) =>
      db.roots.createAlias($_aliasNameGenerator(db.lemmas.rootId, db.roots.id));

  $RootsProcessedTableManager? get rootId {
    final $_column = $_itemColumn<int>('root_id');
    if ($_column == null) return null;
    final manager = $RootsTableManager(
      $_db,
      $_db.roots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static AudioClips _audioIdTable(_$AppDatabase db) => db.audioClips
      .createAlias($_aliasNameGenerator(db.lemmas.audioId, db.audioClips.id));

  $AudioClipsProcessedTableManager? get audioId {
    final $_column = $_itemColumn<int>('audio_id');
    if ($_column == null) return null;
    final manager = $AudioClipsTableManager(
      $_db,
      $_db.audioClips,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_audioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<WordContent, List<WordContentData>>
  _wordContentRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wordContent,
    aliasName: $_aliasNameGenerator(db.lemmas.id, db.wordContent.lemmaId),
  );

  $WordContentProcessedTableManager get wordContentRefs {
    final manager = $WordContentTableManager(
      $_db,
      $_db.wordContent,
    ).filter((f) => f.lemmaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordContentRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<SurfaceForms, List<SurfaceForm>>
  _surfaceFormsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.surfaceForms,
    aliasName: $_aliasNameGenerator(db.lemmas.id, db.surfaceForms.lemmaId),
  );

  $SurfaceFormsProcessedTableManager get surfaceFormsRefs {
    final manager = $SurfaceFormsTableManager(
      $_db,
      $_db.surfaceForms,
    ).filter((f) => f.lemmaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_surfaceFormsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $LemmasFilterComposer extends Composer<_$AppDatabase, Lemmas> {
  $LemmasFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemmaAr => $composableBuilder(
    column: $table.lemmaAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchKey => $composableBuilder(
    column: $table.searchKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  $RootsFilterComposer get rootId {
    final $RootsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootId,
      referencedTable: $db.roots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RootsFilterComposer(
            $db: $db,
            $table: $db.roots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AudioClipsFilterComposer get audioId {
    final $AudioClipsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioId,
      referencedTable: $db.audioClips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AudioClipsFilterComposer(
            $db: $db,
            $table: $db.audioClips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> wordContentRefs(
    Expression<bool> Function($WordContentFilterComposer f) f,
  ) {
    final $WordContentFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordContent,
      getReferencedColumn: (t) => t.lemmaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $WordContentFilterComposer(
            $db: $db,
            $table: $db.wordContent,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> surfaceFormsRefs(
    Expression<bool> Function($SurfaceFormsFilterComposer f) f,
  ) {
    final $SurfaceFormsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surfaceForms,
      getReferencedColumn: (t) => t.lemmaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SurfaceFormsFilterComposer(
            $db: $db,
            $table: $db.surfaceForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $LemmasOrderingComposer extends Composer<_$AppDatabase, Lemmas> {
  $LemmasOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemmaAr => $composableBuilder(
    column: $table.lemmaAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchKey => $composableBuilder(
    column: $table.searchKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  $RootsOrderingComposer get rootId {
    final $RootsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootId,
      referencedTable: $db.roots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RootsOrderingComposer(
            $db: $db,
            $table: $db.roots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AudioClipsOrderingComposer get audioId {
    final $AudioClipsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioId,
      referencedTable: $db.audioClips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AudioClipsOrderingComposer(
            $db: $db,
            $table: $db.audioClips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $LemmasAnnotationComposer extends Composer<_$AppDatabase, Lemmas> {
  $LemmasAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lemmaAr =>
      $composableBuilder(column: $table.lemmaAr, builder: (column) => column);

  GeneratedColumn<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => column);

  GeneratedColumn<String> get latin =>
      $composableBuilder(column: $table.latin, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  $RootsAnnotationComposer get rootId {
    final $RootsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootId,
      referencedTable: $db.roots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RootsAnnotationComposer(
            $db: $db,
            $table: $db.roots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AudioClipsAnnotationComposer get audioId {
    final $AudioClipsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.audioId,
      referencedTable: $db.audioClips,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AudioClipsAnnotationComposer(
            $db: $db,
            $table: $db.audioClips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> wordContentRefs<T extends Object>(
    Expression<T> Function($WordContentAnnotationComposer a) f,
  ) {
    final $WordContentAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordContent,
      getReferencedColumn: (t) => t.lemmaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $WordContentAnnotationComposer(
            $db: $db,
            $table: $db.wordContent,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> surfaceFormsRefs<T extends Object>(
    Expression<T> Function($SurfaceFormsAnnotationComposer a) f,
  ) {
    final $SurfaceFormsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surfaceForms,
      getReferencedColumn: (t) => t.lemmaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SurfaceFormsAnnotationComposer(
            $db: $db,
            $table: $db.surfaceForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $LemmasTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Lemmas,
          Lemma,
          $LemmasFilterComposer,
          $LemmasOrderingComposer,
          $LemmasAnnotationComposer,
          $LemmasCreateCompanionBuilder,
          $LemmasUpdateCompanionBuilder,
          (Lemma, $LemmasReferences),
          Lemma,
          PrefetchHooks Function({
            bool rootId,
            bool audioId,
            bool wordContentRefs,
            bool surfaceFormsRefs,
          })
        > {
  $LemmasTableManager(_$AppDatabase db, Lemmas table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $LemmasFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $LemmasOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $LemmasAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> rootId = const Value.absent(),
                Value<String> lemmaAr = const Value.absent(),
                Value<String> searchKey = const Value.absent(),
                Value<String> latin = const Value.absent(),
                Value<String> pos = const Value.absent(),
                Value<int> frequency = const Value.absent(),
                Value<int?> audioId = const Value.absent(),
              }) => LemmasCompanion(
                id: id,
                rootId: rootId,
                lemmaAr: lemmaAr,
                searchKey: searchKey,
                latin: latin,
                pos: pos,
                frequency: frequency,
                audioId: audioId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> rootId = const Value.absent(),
                required String lemmaAr,
                required String searchKey,
                required String latin,
                Value<String> pos = const Value.absent(),
                Value<int> frequency = const Value.absent(),
                Value<int?> audioId = const Value.absent(),
              }) => LemmasCompanion.insert(
                id: id,
                rootId: rootId,
                lemmaAr: lemmaAr,
                searchKey: searchKey,
                latin: latin,
                pos: pos,
                frequency: frequency,
                audioId: audioId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $LemmasReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback:
              ({
                rootId = false,
                audioId = false,
                wordContentRefs = false,
                surfaceFormsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (wordContentRefs) db.wordContent,
                    if (surfaceFormsRefs) db.surfaceForms,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (rootId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.rootId,
                                    referencedTable: $LemmasReferences
                                        ._rootIdTable(db),
                                    referencedColumn: $LemmasReferences
                                        ._rootIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (audioId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.audioId,
                                    referencedTable: $LemmasReferences
                                        ._audioIdTable(db),
                                    referencedColumn: $LemmasReferences
                                        ._audioIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (wordContentRefs)
                        await $_getPrefetchedData<
                          Lemma,
                          Lemmas,
                          WordContentData
                        >(
                          currentTable: table,
                          referencedTable: $LemmasReferences
                              ._wordContentRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $LemmasReferences(db, table, p0).wordContentRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lemmaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (surfaceFormsRefs)
                        await $_getPrefetchedData<Lemma, Lemmas, SurfaceForm>(
                          currentTable: table,
                          referencedTable: $LemmasReferences
                              ._surfaceFormsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $LemmasReferences(db, table, p0).surfaceFormsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lemmaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $LemmasProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Lemmas,
      Lemma,
      $LemmasFilterComposer,
      $LemmasOrderingComposer,
      $LemmasAnnotationComposer,
      $LemmasCreateCompanionBuilder,
      $LemmasUpdateCompanionBuilder,
      (Lemma, $LemmasReferences),
      Lemma,
      PrefetchHooks Function({
        bool rootId,
        bool audioId,
        bool wordContentRefs,
        bool surfaceFormsRefs,
      })
    >;
typedef $WordContentCreateCompanionBuilder =
    WordContentCompanion Function({
      Value<int> id,
      required int lemmaId,
      required String langCode,
      required String translation,
      Value<String> tafsir,
      Value<String> gem,
      Value<String> mnemonic,
    });
typedef $WordContentUpdateCompanionBuilder =
    WordContentCompanion Function({
      Value<int> id,
      Value<int> lemmaId,
      Value<String> langCode,
      Value<String> translation,
      Value<String> tafsir,
      Value<String> gem,
      Value<String> mnemonic,
    });

final class $WordContentReferences
    extends BaseReferences<_$AppDatabase, WordContent, WordContentData> {
  $WordContentReferences(super.$_db, super.$_table, super.$_typedResult);

  static Lemmas _lemmaIdTable(_$AppDatabase db) => db.lemmas.createAlias(
    $_aliasNameGenerator(db.wordContent.lemmaId, db.lemmas.id),
  );

  $LemmasProcessedTableManager get lemmaId {
    final $_column = $_itemColumn<int>('lemma_id')!;

    final manager = $LemmasTableManager(
      $_db,
      $_db.lemmas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lemmaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $WordContentFilterComposer extends Composer<_$AppDatabase, WordContent> {
  $WordContentFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get langCode => $composableBuilder(
    column: $table.langCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tafsir => $composableBuilder(
    column: $table.tafsir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gem => $composableBuilder(
    column: $table.gem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mnemonic => $composableBuilder(
    column: $table.mnemonic,
    builder: (column) => ColumnFilters(column),
  );

  $LemmasFilterComposer get lemmaId {
    final $LemmasFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lemmaId,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasFilterComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $WordContentOrderingComposer
    extends Composer<_$AppDatabase, WordContent> {
  $WordContentOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get langCode => $composableBuilder(
    column: $table.langCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tafsir => $composableBuilder(
    column: $table.tafsir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gem => $composableBuilder(
    column: $table.gem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mnemonic => $composableBuilder(
    column: $table.mnemonic,
    builder: (column) => ColumnOrderings(column),
  );

  $LemmasOrderingComposer get lemmaId {
    final $LemmasOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lemmaId,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasOrderingComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $WordContentAnnotationComposer
    extends Composer<_$AppDatabase, WordContent> {
  $WordContentAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get langCode =>
      $composableBuilder(column: $table.langCode, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tafsir =>
      $composableBuilder(column: $table.tafsir, builder: (column) => column);

  GeneratedColumn<String> get gem =>
      $composableBuilder(column: $table.gem, builder: (column) => column);

  GeneratedColumn<String> get mnemonic =>
      $composableBuilder(column: $table.mnemonic, builder: (column) => column);

  $LemmasAnnotationComposer get lemmaId {
    final $LemmasAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lemmaId,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasAnnotationComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $WordContentTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          WordContent,
          WordContentData,
          $WordContentFilterComposer,
          $WordContentOrderingComposer,
          $WordContentAnnotationComposer,
          $WordContentCreateCompanionBuilder,
          $WordContentUpdateCompanionBuilder,
          (WordContentData, $WordContentReferences),
          WordContentData,
          PrefetchHooks Function({bool lemmaId})
        > {
  $WordContentTableManager(_$AppDatabase db, WordContent table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $WordContentFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $WordContentOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $WordContentAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lemmaId = const Value.absent(),
                Value<String> langCode = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String> tafsir = const Value.absent(),
                Value<String> gem = const Value.absent(),
                Value<String> mnemonic = const Value.absent(),
              }) => WordContentCompanion(
                id: id,
                lemmaId: lemmaId,
                langCode: langCode,
                translation: translation,
                tafsir: tafsir,
                gem: gem,
                mnemonic: mnemonic,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lemmaId,
                required String langCode,
                required String translation,
                Value<String> tafsir = const Value.absent(),
                Value<String> gem = const Value.absent(),
                Value<String> mnemonic = const Value.absent(),
              }) => WordContentCompanion.insert(
                id: id,
                lemmaId: lemmaId,
                langCode: langCode,
                translation: translation,
                tafsir: tafsir,
                gem: gem,
                mnemonic: mnemonic,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $WordContentReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({lemmaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lemmaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lemmaId,
                                referencedTable: $WordContentReferences
                                    ._lemmaIdTable(db),
                                referencedColumn: $WordContentReferences
                                    ._lemmaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $WordContentProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      WordContent,
      WordContentData,
      $WordContentFilterComposer,
      $WordContentOrderingComposer,
      $WordContentAnnotationComposer,
      $WordContentCreateCompanionBuilder,
      $WordContentUpdateCompanionBuilder,
      (WordContentData, $WordContentReferences),
      WordContentData,
      PrefetchHooks Function({bool lemmaId})
    >;
typedef $SurfaceFormsCreateCompanionBuilder =
    SurfaceFormsCompanion Function({
      Value<int> id,
      required int lemmaId,
      required String textAr,
      required String searchKey,
      required String latin,
    });
typedef $SurfaceFormsUpdateCompanionBuilder =
    SurfaceFormsCompanion Function({
      Value<int> id,
      Value<int> lemmaId,
      Value<String> textAr,
      Value<String> searchKey,
      Value<String> latin,
    });

final class $SurfaceFormsReferences
    extends BaseReferences<_$AppDatabase, SurfaceForms, SurfaceForm> {
  $SurfaceFormsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Lemmas _lemmaIdTable(_$AppDatabase db) => db.lemmas.createAlias(
    $_aliasNameGenerator(db.surfaceForms.lemmaId, db.lemmas.id),
  );

  $LemmasProcessedTableManager get lemmaId {
    final $_column = $_itemColumn<int>('lemma_id')!;

    final manager = $LemmasTableManager(
      $_db,
      $_db.lemmas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lemmaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Occurrences, List<Occurrence>>
  _occurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.occurrences,
    aliasName: $_aliasNameGenerator(
      db.surfaceForms.id,
      db.occurrences.surfaceFormId,
    ),
  );

  $OccurrencesProcessedTableManager get occurrencesRefs {
    final manager = $OccurrencesTableManager(
      $_db,
      $_db.occurrences,
    ).filter((f) => f.surfaceFormId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_occurrencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $SurfaceFormsFilterComposer
    extends Composer<_$AppDatabase, SurfaceForms> {
  $SurfaceFormsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textAr => $composableBuilder(
    column: $table.textAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchKey => $composableBuilder(
    column: $table.searchKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnFilters(column),
  );

  $LemmasFilterComposer get lemmaId {
    final $LemmasFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lemmaId,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasFilterComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> occurrencesRefs(
    Expression<bool> Function($OccurrencesFilterComposer f) f,
  ) {
    final $OccurrencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occurrences,
      getReferencedColumn: (t) => t.surfaceFormId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OccurrencesFilterComposer(
            $db: $db,
            $table: $db.occurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SurfaceFormsOrderingComposer
    extends Composer<_$AppDatabase, SurfaceForms> {
  $SurfaceFormsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textAr => $composableBuilder(
    column: $table.textAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchKey => $composableBuilder(
    column: $table.searchKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnOrderings(column),
  );

  $LemmasOrderingComposer get lemmaId {
    final $LemmasOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lemmaId,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasOrderingComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $SurfaceFormsAnnotationComposer
    extends Composer<_$AppDatabase, SurfaceForms> {
  $SurfaceFormsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textAr =>
      $composableBuilder(column: $table.textAr, builder: (column) => column);

  GeneratedColumn<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => column);

  GeneratedColumn<String> get latin =>
      $composableBuilder(column: $table.latin, builder: (column) => column);

  $LemmasAnnotationComposer get lemmaId {
    final $LemmasAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lemmaId,
      referencedTable: $db.lemmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $LemmasAnnotationComposer(
            $db: $db,
            $table: $db.lemmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> occurrencesRefs<T extends Object>(
    Expression<T> Function($OccurrencesAnnotationComposer a) f,
  ) {
    final $OccurrencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occurrences,
      getReferencedColumn: (t) => t.surfaceFormId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OccurrencesAnnotationComposer(
            $db: $db,
            $table: $db.occurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $SurfaceFormsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SurfaceForms,
          SurfaceForm,
          $SurfaceFormsFilterComposer,
          $SurfaceFormsOrderingComposer,
          $SurfaceFormsAnnotationComposer,
          $SurfaceFormsCreateCompanionBuilder,
          $SurfaceFormsUpdateCompanionBuilder,
          (SurfaceForm, $SurfaceFormsReferences),
          SurfaceForm,
          PrefetchHooks Function({bool lemmaId, bool occurrencesRefs})
        > {
  $SurfaceFormsTableManager(_$AppDatabase db, SurfaceForms table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SurfaceFormsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SurfaceFormsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SurfaceFormsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lemmaId = const Value.absent(),
                Value<String> textAr = const Value.absent(),
                Value<String> searchKey = const Value.absent(),
                Value<String> latin = const Value.absent(),
              }) => SurfaceFormsCompanion(
                id: id,
                lemmaId: lemmaId,
                textAr: textAr,
                searchKey: searchKey,
                latin: latin,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lemmaId,
                required String textAr,
                required String searchKey,
                required String latin,
              }) => SurfaceFormsCompanion.insert(
                id: id,
                lemmaId: lemmaId,
                textAr: textAr,
                searchKey: searchKey,
                latin: latin,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $SurfaceFormsReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({lemmaId = false, occurrencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (occurrencesRefs) db.occurrences],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (lemmaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lemmaId,
                                referencedTable: $SurfaceFormsReferences
                                    ._lemmaIdTable(db),
                                referencedColumn: $SurfaceFormsReferences
                                    ._lemmaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (occurrencesRefs)
                    await $_getPrefetchedData<
                      SurfaceForm,
                      SurfaceForms,
                      Occurrence
                    >(
                      currentTable: table,
                      referencedTable: $SurfaceFormsReferences
                          ._occurrencesRefsTable(db),
                      managerFromTypedResult: (p0) => $SurfaceFormsReferences(
                        db,
                        table,
                        p0,
                      ).occurrencesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.surfaceFormId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $SurfaceFormsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SurfaceForms,
      SurfaceForm,
      $SurfaceFormsFilterComposer,
      $SurfaceFormsOrderingComposer,
      $SurfaceFormsAnnotationComposer,
      $SurfaceFormsCreateCompanionBuilder,
      $SurfaceFormsUpdateCompanionBuilder,
      (SurfaceForm, $SurfaceFormsReferences),
      SurfaceForm,
      PrefetchHooks Function({bool lemmaId, bool occurrencesRefs})
    >;
typedef $VersesCreateCompanionBuilder =
    VersesCompanion Function({
      Value<int> id,
      required int surah,
      required int ayah,
      required String textUthmani,
      Value<String> textSimple,
    });
typedef $VersesUpdateCompanionBuilder =
    VersesCompanion Function({
      Value<int> id,
      Value<int> surah,
      Value<int> ayah,
      Value<String> textUthmani,
      Value<String> textSimple,
    });

final class $VersesReferences
    extends BaseReferences<_$AppDatabase, Verses, Verse> {
  $VersesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Occurrences, List<Occurrence>>
  _occurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.occurrences,
    aliasName: $_aliasNameGenerator(db.verses.id, db.occurrences.verseId),
  );

  $OccurrencesProcessedTableManager get occurrencesRefs {
    final manager = $OccurrencesTableManager(
      $_db,
      $_db.occurrences,
    ).filter((f) => f.verseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_occurrencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $VersesFilterComposer extends Composer<_$AppDatabase, Verses> {
  $VersesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayah => $composableBuilder(
    column: $table.ayah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textSimple => $composableBuilder(
    column: $table.textSimple,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> occurrencesRefs(
    Expression<bool> Function($OccurrencesFilterComposer f) f,
  ) {
    final $OccurrencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occurrences,
      getReferencedColumn: (t) => t.verseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OccurrencesFilterComposer(
            $db: $db,
            $table: $db.occurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $VersesOrderingComposer extends Composer<_$AppDatabase, Verses> {
  $VersesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surah => $composableBuilder(
    column: $table.surah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayah => $composableBuilder(
    column: $table.ayah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textSimple => $composableBuilder(
    column: $table.textSimple,
    builder: (column) => ColumnOrderings(column),
  );
}

class $VersesAnnotationComposer extends Composer<_$AppDatabase, Verses> {
  $VersesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surah =>
      $composableBuilder(column: $table.surah, builder: (column) => column);

  GeneratedColumn<int> get ayah =>
      $composableBuilder(column: $table.ayah, builder: (column) => column);

  GeneratedColumn<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textSimple => $composableBuilder(
    column: $table.textSimple,
    builder: (column) => column,
  );

  Expression<T> occurrencesRefs<T extends Object>(
    Expression<T> Function($OccurrencesAnnotationComposer a) f,
  ) {
    final $OccurrencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.occurrences,
      getReferencedColumn: (t) => t.verseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OccurrencesAnnotationComposer(
            $db: $db,
            $table: $db.occurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $VersesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Verses,
          Verse,
          $VersesFilterComposer,
          $VersesOrderingComposer,
          $VersesAnnotationComposer,
          $VersesCreateCompanionBuilder,
          $VersesUpdateCompanionBuilder,
          (Verse, $VersesReferences),
          Verse,
          PrefetchHooks Function({bool occurrencesRefs})
        > {
  $VersesTableManager(_$AppDatabase db, Verses table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VersesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VersesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VersesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surah = const Value.absent(),
                Value<int> ayah = const Value.absent(),
                Value<String> textUthmani = const Value.absent(),
                Value<String> textSimple = const Value.absent(),
              }) => VersesCompanion(
                id: id,
                surah: surah,
                ayah: ayah,
                textUthmani: textUthmani,
                textSimple: textSimple,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surah,
                required int ayah,
                required String textUthmani,
                Value<String> textSimple = const Value.absent(),
              }) => VersesCompanion.insert(
                id: id,
                surah: surah,
                ayah: ayah,
                textUthmani: textUthmani,
                textSimple: textSimple,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), $VersesReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({occurrencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (occurrencesRefs) db.occurrences],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (occurrencesRefs)
                    await $_getPrefetchedData<Verse, Verses, Occurrence>(
                      currentTable: table,
                      referencedTable: $VersesReferences._occurrencesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $VersesReferences(db, table, p0).occurrencesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.verseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $VersesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Verses,
      Verse,
      $VersesFilterComposer,
      $VersesOrderingComposer,
      $VersesAnnotationComposer,
      $VersesCreateCompanionBuilder,
      $VersesUpdateCompanionBuilder,
      (Verse, $VersesReferences),
      Verse,
      PrefetchHooks Function({bool occurrencesRefs})
    >;
typedef $OccurrencesCreateCompanionBuilder =
    OccurrencesCompanion Function({
      Value<int> id,
      required int surfaceFormId,
      required int verseId,
      required int position,
    });
typedef $OccurrencesUpdateCompanionBuilder =
    OccurrencesCompanion Function({
      Value<int> id,
      Value<int> surfaceFormId,
      Value<int> verseId,
      Value<int> position,
    });

final class $OccurrencesReferences
    extends BaseReferences<_$AppDatabase, Occurrences, Occurrence> {
  $OccurrencesReferences(super.$_db, super.$_table, super.$_typedResult);

  static SurfaceForms _surfaceFormIdTable(_$AppDatabase db) =>
      db.surfaceForms.createAlias(
        $_aliasNameGenerator(db.occurrences.surfaceFormId, db.surfaceForms.id),
      );

  $SurfaceFormsProcessedTableManager get surfaceFormId {
    final $_column = $_itemColumn<int>('surface_form_id')!;

    final manager = $SurfaceFormsTableManager(
      $_db,
      $_db.surfaceForms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surfaceFormIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Verses _verseIdTable(_$AppDatabase db) => db.verses.createAlias(
    $_aliasNameGenerator(db.occurrences.verseId, db.verses.id),
  );

  $VersesProcessedTableManager get verseId {
    final $_column = $_itemColumn<int>('verse_id')!;

    final manager = $VersesTableManager(
      $_db,
      $_db.verses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_verseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $OccurrencesFilterComposer extends Composer<_$AppDatabase, Occurrences> {
  $OccurrencesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $SurfaceFormsFilterComposer get surfaceFormId {
    final $SurfaceFormsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surfaceFormId,
      referencedTable: $db.surfaceForms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SurfaceFormsFilterComposer(
            $db: $db,
            $table: $db.surfaceForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VersesFilterComposer get verseId {
    final $VersesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verseId,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesFilterComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $OccurrencesOrderingComposer
    extends Composer<_$AppDatabase, Occurrences> {
  $OccurrencesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $SurfaceFormsOrderingComposer get surfaceFormId {
    final $SurfaceFormsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surfaceFormId,
      referencedTable: $db.surfaceForms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SurfaceFormsOrderingComposer(
            $db: $db,
            $table: $db.surfaceForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VersesOrderingComposer get verseId {
    final $VersesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verseId,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesOrderingComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $OccurrencesAnnotationComposer
    extends Composer<_$AppDatabase, Occurrences> {
  $OccurrencesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $SurfaceFormsAnnotationComposer get surfaceFormId {
    final $SurfaceFormsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surfaceFormId,
      referencedTable: $db.surfaceForms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $SurfaceFormsAnnotationComposer(
            $db: $db,
            $table: $db.surfaceForms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VersesAnnotationComposer get verseId {
    final $VersesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verseId,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VersesAnnotationComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $OccurrencesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Occurrences,
          Occurrence,
          $OccurrencesFilterComposer,
          $OccurrencesOrderingComposer,
          $OccurrencesAnnotationComposer,
          $OccurrencesCreateCompanionBuilder,
          $OccurrencesUpdateCompanionBuilder,
          (Occurrence, $OccurrencesReferences),
          Occurrence,
          PrefetchHooks Function({bool surfaceFormId, bool verseId})
        > {
  $OccurrencesTableManager(_$AppDatabase db, Occurrences table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $OccurrencesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $OccurrencesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $OccurrencesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surfaceFormId = const Value.absent(),
                Value<int> verseId = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => OccurrencesCompanion(
                id: id,
                surfaceFormId: surfaceFormId,
                verseId: verseId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surfaceFormId,
                required int verseId,
                required int position,
              }) => OccurrencesCompanion.insert(
                id: id,
                surfaceFormId: surfaceFormId,
                verseId: verseId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $OccurrencesReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({surfaceFormId = false, verseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (surfaceFormId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.surfaceFormId,
                                referencedTable: $OccurrencesReferences
                                    ._surfaceFormIdTable(db),
                                referencedColumn: $OccurrencesReferences
                                    ._surfaceFormIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (verseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.verseId,
                                referencedTable: $OccurrencesReferences
                                    ._verseIdTable(db),
                                referencedColumn: $OccurrencesReferences
                                    ._verseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $OccurrencesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Occurrences,
      Occurrence,
      $OccurrencesFilterComposer,
      $OccurrencesOrderingComposer,
      $OccurrencesAnnotationComposer,
      $OccurrencesCreateCompanionBuilder,
      $OccurrencesUpdateCompanionBuilder,
      (Occurrence, $OccurrencesReferences),
      Occurrence,
      PrefetchHooks Function({bool surfaceFormId, bool verseId})
    >;
typedef $FormsFtsCreateCompanionBuilder =
    FormsFtsCompanion Function({
      required String searchKey,
      required String latin,
      Value<int> rowid,
    });
typedef $FormsFtsUpdateCompanionBuilder =
    FormsFtsCompanion Function({
      Value<String> searchKey,
      Value<String> latin,
      Value<int> rowid,
    });

class $FormsFtsFilterComposer extends Composer<_$AppDatabase, FormsFts> {
  $FormsFtsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get searchKey => $composableBuilder(
    column: $table.searchKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnFilters(column),
  );
}

class $FormsFtsOrderingComposer extends Composer<_$AppDatabase, FormsFts> {
  $FormsFtsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get searchKey => $composableBuilder(
    column: $table.searchKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $FormsFtsAnnotationComposer extends Composer<_$AppDatabase, FormsFts> {
  $FormsFtsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => column);

  GeneratedColumn<String> get latin =>
      $composableBuilder(column: $table.latin, builder: (column) => column);
}

class $FormsFtsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          FormsFts,
          FormsFt,
          $FormsFtsFilterComposer,
          $FormsFtsOrderingComposer,
          $FormsFtsAnnotationComposer,
          $FormsFtsCreateCompanionBuilder,
          $FormsFtsUpdateCompanionBuilder,
          (FormsFt, BaseReferences<_$AppDatabase, FormsFts, FormsFt>),
          FormsFt,
          PrefetchHooks Function()
        > {
  $FormsFtsTableManager(_$AppDatabase db, FormsFts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FormsFtsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FormsFtsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FormsFtsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> searchKey = const Value.absent(),
                Value<String> latin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FormsFtsCompanion(
                searchKey: searchKey,
                latin: latin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String searchKey,
                required String latin,
                Value<int> rowid = const Value.absent(),
              }) => FormsFtsCompanion.insert(
                searchKey: searchKey,
                latin: latin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $FormsFtsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      FormsFts,
      FormsFt,
      $FormsFtsFilterComposer,
      $FormsFtsOrderingComposer,
      $FormsFtsAnnotationComposer,
      $FormsFtsCreateCompanionBuilder,
      $FormsFtsUpdateCompanionBuilder,
      (FormsFt, BaseReferences<_$AppDatabase, FormsFts, FormsFt>),
      FormsFt,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $AudioClipsTableManager get audioClips =>
      $AudioClipsTableManager(_db, _db.audioClips);
  $RootsTableManager get roots => $RootsTableManager(_db, _db.roots);
  $LemmasTableManager get lemmas => $LemmasTableManager(_db, _db.lemmas);
  $WordContentTableManager get wordContent =>
      $WordContentTableManager(_db, _db.wordContent);
  $SurfaceFormsTableManager get surfaceForms =>
      $SurfaceFormsTableManager(_db, _db.surfaceForms);
  $VersesTableManager get verses => $VersesTableManager(_db, _db.verses);
  $OccurrencesTableManager get occurrences =>
      $OccurrencesTableManager(_db, _db.occurrences);
  $FormsFtsTableManager get formsFts =>
      $FormsFtsTableManager(_db, _db.formsFts);
}
