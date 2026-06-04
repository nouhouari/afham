// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The singleton [AppDatabase] instance, kept alive for the app lifecycle.
///
/// Seeding is triggered here on first access: if the database is empty we
/// insert the seed dataset before returning, so the first search already
/// works.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The singleton [AppDatabase] instance, kept alive for the app lifecycle.
///
/// Seeding is triggered here on first access: if the database is empty we
/// insert the seed dataset before returning, so the first search already
/// works.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The singleton [AppDatabase] instance, kept alive for the app lifecycle.
  ///
  /// Seeding is triggered here on first access: if the database is empty we
  /// insert the seed dataset before returning, so the first search already
  /// works.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'0ce56580e204a54fba13ef0efea3dd8a3bd5cd38';

/// State holder for the live search query string.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// State holder for the live search query string.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// State holder for the live search query string.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'790bd96a8a13bb944767c7bf06a5378cfc78a54d';

/// State holder for the live search query string.

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that executes the FTS5 search whenever [searchQueryProvider]
/// changes. Returns an empty list for blank queries.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Provider that executes the FTS5 search whenever [searchQueryProvider]
/// changes. Returns an empty list for blank queries.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SearchResult>>,
          List<SearchResult>,
          FutureOr<List<SearchResult>>
        >
    with
        $FutureModifier<List<SearchResult>>,
        $FutureProvider<List<SearchResult>> {
  /// Provider that executes the FTS5 search whenever [searchQueryProvider]
  /// changes. Returns an empty list for blank queries.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<SearchResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SearchResult>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'f59b056215f27b59fc0af59b62034e725cb70ab9';

/// Loads the full [LemmaDetail] for a given lemma id.
///
/// Used by the word-detail sheet and (indirectly) the word-of-day card.

@ProviderFor(lemmaDetail)
final lemmaDetailProvider = LemmaDetailFamily._();

/// Loads the full [LemmaDetail] for a given lemma id.
///
/// Used by the word-detail sheet and (indirectly) the word-of-day card.

final class LemmaDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<LemmaDetail?>,
          LemmaDetail?,
          FutureOr<LemmaDetail?>
        >
    with $FutureModifier<LemmaDetail?>, $FutureProvider<LemmaDetail?> {
  /// Loads the full [LemmaDetail] for a given lemma id.
  ///
  /// Used by the word-detail sheet and (indirectly) the word-of-day card.
  LemmaDetailProvider._({
    required LemmaDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'lemmaDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lemmaDetailHash();

  @override
  String toString() {
    return r'lemmaDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LemmaDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LemmaDetail?> create(Ref ref) {
    final argument = this.argument as int;
    return lemmaDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LemmaDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lemmaDetailHash() => r'b41b2af00ceeaf6f0554722332ea396a54178e30';

/// Loads the full [LemmaDetail] for a given lemma id.
///
/// Used by the word-detail sheet and (indirectly) the word-of-day card.

final class LemmaDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LemmaDetail?>, int> {
  LemmaDetailFamily._()
    : super(
        retry: null,
        name: r'lemmaDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads the full [LemmaDetail] for a given lemma id.
  ///
  /// Used by the word-detail sheet and (indirectly) the word-of-day card.

  LemmaDetailProvider call(int lemmaId) =>
      LemmaDetailProvider._(argument: lemmaId, from: this);

  @override
  String toString() => r'lemmaDetailProvider';
}

/// Returns all lemmas sharing [rootId] for the root-family screen.

@ProviderFor(rootFamilyItems)
final rootFamilyItemsProvider = RootFamilyItemsFamily._();

/// Returns all lemmas sharing [rootId] for the root-family screen.

final class RootFamilyItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RootFamilyItem>>,
          List<RootFamilyItem>,
          FutureOr<List<RootFamilyItem>>
        >
    with
        $FutureModifier<List<RootFamilyItem>>,
        $FutureProvider<List<RootFamilyItem>> {
  /// Returns all lemmas sharing [rootId] for the root-family screen.
  RootFamilyItemsProvider._({
    required RootFamilyItemsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rootFamilyItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rootFamilyItemsHash();

  @override
  String toString() {
    return r'rootFamilyItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RootFamilyItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RootFamilyItem>> create(Ref ref) {
    final argument = this.argument as int;
    return rootFamilyItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RootFamilyItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rootFamilyItemsHash() => r'643127229d2bf9bcbc68648928ca24fd4bcf5967';

/// Returns all lemmas sharing [rootId] for the root-family screen.

final class RootFamilyItemsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RootFamilyItem>>, int> {
  RootFamilyItemsFamily._()
    : super(
        retry: null,
        name: r'rootFamilyItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns all lemmas sharing [rootId] for the root-family screen.

  RootFamilyItemsProvider call(int rootId) =>
      RootFamilyItemsProvider._(argument: rootId, from: this);

  @override
  String toString() => r'rootFamilyItemsProvider';
}

/// Returns the deterministic word-of-the-day lemma detail.
///
/// [dayOfMonth] should be [DateTime.now().day] from the UI layer, so this
/// provider itself stays pure and testable.

@ProviderFor(wordOfDay)
final wordOfDayProvider = WordOfDayFamily._();

/// Returns the deterministic word-of-the-day lemma detail.
///
/// [dayOfMonth] should be [DateTime.now().day] from the UI layer, so this
/// provider itself stays pure and testable.

final class WordOfDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<LemmaDetail?>,
          LemmaDetail?,
          FutureOr<LemmaDetail?>
        >
    with $FutureModifier<LemmaDetail?>, $FutureProvider<LemmaDetail?> {
  /// Returns the deterministic word-of-the-day lemma detail.
  ///
  /// [dayOfMonth] should be [DateTime.now().day] from the UI layer, so this
  /// provider itself stays pure and testable.
  WordOfDayProvider._({
    required WordOfDayFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'wordOfDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$wordOfDayHash();

  @override
  String toString() {
    return r'wordOfDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LemmaDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LemmaDetail?> create(Ref ref) {
    final argument = this.argument as int;
    return wordOfDay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WordOfDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wordOfDayHash() => r'3eb6fa27372ec7244060592bd84ad43541d9b5f6';

/// Returns the deterministic word-of-the-day lemma detail.
///
/// [dayOfMonth] should be [DateTime.now().day] from the UI layer, so this
/// provider itself stays pure and testable.

final class WordOfDayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LemmaDetail?>, int> {
  WordOfDayFamily._()
    : super(
        retry: null,
        name: r'wordOfDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns the deterministic word-of-the-day lemma detail.
  ///
  /// [dayOfMonth] should be [DateTime.now().day] from the UI layer, so this
  /// provider itself stays pure and testable.

  WordOfDayProvider call(int dayOfMonth) =>
      WordOfDayProvider._(argument: dayOfMonth, from: this);

  @override
  String toString() => r'wordOfDayProvider';
}
