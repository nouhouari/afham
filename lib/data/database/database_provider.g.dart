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

String _$appDatabaseHash() => r'7320124220b0b16882c02716d4457993e6c58079';

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
