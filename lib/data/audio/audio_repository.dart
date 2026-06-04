import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:bayan/data/audio/audio_clip.dart';

part 'audio_repository.g.dart';

// ── Playback state ────────────────────────────────────────────────────────────

/// Playback state exposed to the UI.
enum AudioPlaybackState {
  /// No clip loaded or player idle after completing.
  idle,

  /// Preparing the clip (buffering / seeking inside the sprite pack).
  loading,

  /// Actively playing.
  playing,
}

// ── Repository ────────────────────────────────────────────────────────────────

/// Manages a single [AudioPlayer] instance shared across the whole app.
///
/// Design choices:
/// - One player singleton → no resource leaks from multiple instances.
/// - [playClip] stops any current playback before starting the new clip;
///   calling it with the same clip while it is playing stops playback (toggle).
/// - Uses `ClippingAudioSource` with `AudioSource.asset(packFile)` so clips
///   are resolved from Flutter's asset bundle (100 % offline).
/// - Exposes [playbackState] as a [Stream] so the UI can react without polling.
///
/// **Audio not yet available**: if [clip] is `null`, do nothing — callers are
/// expected to disable their play button in that case.
///
/// The [AudioPlayer] can be injected via the [audioPlayer] parameter to
/// facilitate testing without a native audio platform.
class AudioRepository {
  AudioRepository({AudioPlayer? audioPlayer})
    : _player = audioPlayer ?? AudioPlayer();

  final AudioPlayer _player;

  // Tracks which clip id is currently loaded (null = none).
  int? _currentClipId;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Streams the current playback state derived from [just_audio]'s
  /// [ProcessingState] and [playing] flag.
  Stream<AudioPlaybackState> get playbackState =>
      _player.playerStateStream.map((s) => _mapState(s));

  /// The id of the clip currently loaded (null if none).
  int? get currentClipId => _currentClipId;

  /// Returns `true` while the player is actively playing.
  bool get isPlaying => _player.playing;

  /// Plays [clip], building a [ClippingAudioSource] from its sprite metadata.
  ///
  /// - If [clip] is null, returns immediately (no audio configured yet).
  /// - If the same clip is already playing, the call **stops** it (toggle).
  /// - Any previously playing clip is stopped and the source is replaced.
  Future<void> playClip(AudioClip? clip) async {
    if (clip == null) return;

    // Toggle: stop if already playing this clip.
    if (_currentClipId == clip.id && _player.playing) {
      await _player.stop();
      return;
    }

    // Stop previous clip cleanly before loading a new source.
    if (_player.playing) {
      await _player.stop();
    }

    _currentClipId = clip.id;

    try {
      final source = ClippingAudioSource(
        child: AudioSource.asset(clip.packFile),
        start: Duration(milliseconds: clip.startMs),
        end: Duration(milliseconds: clip.endMs),
      );

      // setAudioSource positions the player at the start of the clip.
      await _player.setAudioSource(source);
      await _player.play();
    } catch (e) {
      // If the asset is missing (pre-production) or the player errors,
      // reset state cleanly so subsequent calls work.
      _currentClipId = null;
      await _player.stop();
      rethrow;
    }
  }

  /// Stops playback and releases the current source.
  Future<void> stop() async {
    _currentClipId = null;
    await _player.stop();
  }

  /// Must be called when the repository is disposed (app shutdown / test
  /// teardown).  Riverpod calls this via [ref.onDispose].
  Future<void> dispose() async {
    await _player.dispose();
  }

  // ── Mapping just_audio state → AudioPlaybackState ─────────────────────────

  static AudioPlaybackState _mapState(PlayerState state) {
    if (state.playing) return AudioPlaybackState.playing;
    switch (state.processingState) {
      case ProcessingState.loading:
      case ProcessingState.buffering:
        return AudioPlaybackState.loading;
      case ProcessingState.idle:
      case ProcessingState.ready:
      case ProcessingState.completed:
        return AudioPlaybackState.idle;
    }
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────

/// App-lifetime singleton [AudioRepository].
///
/// `keepAlive: true` because the [AudioPlayer] underneath manages native
/// resources that should persist for the whole session.
@Riverpod(keepAlive: true)
AudioRepository audioRepository(Ref ref) {
  final repo = AudioRepository();
  ref.onDispose(repo.dispose);
  return repo;
}
