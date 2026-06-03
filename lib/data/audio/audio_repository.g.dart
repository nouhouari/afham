// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-lifetime singleton [AudioRepository].
///
/// `keepAlive: true` because the [AudioPlayer] underneath manages native
/// resources that should persist for the whole session.

@ProviderFor(audioRepository)
final audioRepositoryProvider = AudioRepositoryProvider._();

/// App-lifetime singleton [AudioRepository].
///
/// `keepAlive: true` because the [AudioPlayer] underneath manages native
/// resources that should persist for the whole session.

final class AudioRepositoryProvider
    extends
        $FunctionalProvider<AudioRepository, AudioRepository, AudioRepository>
    with $Provider<AudioRepository> {
  /// App-lifetime singleton [AudioRepository].
  ///
  /// `keepAlive: true` because the [AudioPlayer] underneath manages native
  /// resources that should persist for the whole session.
  AudioRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioRepositoryHash();

  @$internal
  @override
  $ProviderElement<AudioRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AudioRepository create(Ref ref) {
    return audioRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioRepository>(value),
    );
  }
}

String _$audioRepositoryHash() => r'77f25ba294b43266f8be49d0f0605d8eb83af35c';
