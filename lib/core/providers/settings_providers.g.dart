// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the user's preferred [ThemeMode] (in memory only for now).
/// Defaults to [ThemeMode.system].
/// TODO(phase5): persist via shared_preferences and restore on startup.

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// Holds the user's preferred [ThemeMode] (in memory only for now).
/// Defaults to [ThemeMode.system].
/// TODO(phase5): persist via shared_preferences and restore on startup.
final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, ThemeMode> {
  /// Holds the user's preferred [ThemeMode] (in memory only for now).
  /// Defaults to [ThemeMode.system].
  /// TODO(phase5): persist via shared_preferences and restore on startup.
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

String _$themeModeNotifierHash() => r'21098a6ac98ee372e04ca080813cee7a17a665e6';

/// Holds the user's preferred [ThemeMode] (in memory only for now).
/// Defaults to [ThemeMode.system].
/// TODO(phase5): persist via shared_preferences and restore on startup.

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

/// Holds the user's preferred [Locale] (fr or en), in memory only for now.
/// Defaults to French.
///
/// NOTE: when this changes, slang's LocaleSettings must be updated too
/// (LocaleSettings.setLocaleRaw) so Material widgets and app strings stay in
/// sync — wired in the settings screen.
/// TODO(phase5): persist + perform the slang sync on change.

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Holds the user's preferred [Locale] (fr or en), in memory only for now.
/// Defaults to French.
///
/// NOTE: when this changes, slang's LocaleSettings must be updated too
/// (LocaleSettings.setLocaleRaw) so Material widgets and app strings stay in
/// sync — wired in the settings screen.
/// TODO(phase5): persist + perform the slang sync on change.
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale> {
  /// Holds the user's preferred [Locale] (fr or en), in memory only for now.
  /// Defaults to French.
  ///
  /// NOTE: when this changes, slang's LocaleSettings must be updated too
  /// (LocaleSettings.setLocaleRaw) so Material widgets and app strings stay in
  /// sync — wired in the settings screen.
  /// TODO(phase5): persist + perform the slang sync on change.
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

String _$localeNotifierHash() => r'd9c977286893cd86887d512980e687bed689e3fa';

/// Holds the user's preferred [Locale] (fr or en), in memory only for now.
/// Defaults to French.
///
/// NOTE: when this changes, slang's LocaleSettings must be updated too
/// (LocaleSettings.setLocaleRaw) so Material widgets and app strings stay in
/// sync — wired in the settings screen.
/// TODO(phase5): persist + perform the slang sync on change.

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
