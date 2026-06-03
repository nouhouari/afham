// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The [SharedPreferences] instance. Overridden with the real, async-loaded
/// instance in `main()` via `ProviderScope(overrides: …)`.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// The [SharedPreferences] instance. Overridden with the real, async-loaded
/// instance in `main()` via `ProviderScope(overrides: …)`.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// The [SharedPreferences] instance. Overridden with the real, async-loaded
  /// instance in `main()` via `ProviderScope(overrides: …)`.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'bdf49748bece142c907bc28d050b90b97094eaa9';

/// The user's preferred [ThemeMode], persisted across launches.
/// Defaults to [ThemeMode.system].

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// The user's preferred [ThemeMode], persisted across launches.
/// Defaults to [ThemeMode.system].
final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, ThemeMode> {
  /// The user's preferred [ThemeMode], persisted across launches.
  /// Defaults to [ThemeMode.system].
  ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeNotifierHash() => r'21214dda34d785f16b32a28a2199191b94358fc7';

/// The user's preferred [ThemeMode], persisted across launches.
/// Defaults to [ThemeMode.system].

abstract class _$ThemeModeNotifier extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The user's preferred [Locale] (fr or en), persisted across launches.
/// Defaults to French.
///
/// Setting it also updates slang's [LocaleSettings] so Material widgets and
/// app strings switch together.

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// The user's preferred [Locale] (fr or en), persisted across launches.
/// Defaults to French.
///
/// Setting it also updates slang's [LocaleSettings] so Material widgets and
/// app strings switch together.
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale> {
  /// The user's preferred [Locale] (fr or en), persisted across launches.
  /// Defaults to French.
  ///
  /// Setting it also updates slang's [LocaleSettings] so Material widgets and
  /// app strings switch together.
  LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localeNotifierHash() => r'58d2df53451f04b2674824222612b9d648c897aa';

/// The user's preferred [Locale] (fr or en), persisted across launches.
/// Defaults to French.
///
/// Setting it also updates slang's [LocaleSettings] so Material widgets and
/// app strings switch together.

abstract class _$LocaleNotifier extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
