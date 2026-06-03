// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';

import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Builds an [AudioClip] for tests (no real file needed for mapping tests).
AudioClip _clip({
  int id = 1,
  String packFile = 'assets/audio/sample_pack.m4a',
  int startMs = 0,
  int durationMs = 500,
}) => AudioClip(
      id: id,
      packFile: packFile,
      startMs: startMs,
      durationMs: durationMs,
    );

// ── AudioClip domain model tests ──────────────────────────────────────────────

void main() {
  group('AudioClip', () {
    test('endMs equals startMs + durationMs', () {
      final clip = _clip(startMs: 1200, durationMs: 750);
      expect(clip.endMs, equals(1950));
    });

    test('endMs is correct for clip at offset zero', () {
      final clip = _clip(startMs: 0, durationMs: 620);
      expect(clip.endMs, equals(620));
    });

    test('endMs is correct for mid-pack clip', () {
      final clip = _clip(startMs: 500, durationMs: 500);
      expect(clip.endMs, equals(1000));
    });

    test('equality is based on id', () {
      final a = _clip(id: 42, startMs: 0, durationMs: 500);
      final b = _clip(id: 42, startMs: 999, durationMs: 1);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('clips with different ids are not equal', () {
      final a = _clip(id: 1);
      final b = _clip(id: 2);
      expect(a, isNot(equals(b)));
    });

    test('toString includes key fields', () {
      final clip = _clip(
        id: 7,
        packFile: 'assets/audio/pack_001.m4a',
        startMs: 1500,
        durationMs: 640,
      );
      final s = clip.toString();
      expect(s, contains('7'));
      expect(s, contains('pack_001.m4a'));
      expect(s, contains('1500'));
      expect(s, contains('640'));
    });
  });

  // ── ClippingAudioSource parameter mapping ────────────────────────────────────

  group('ClippingAudioSource parameter mapping', () {
    /// Verifies the Duration values that [AudioRepository.playClip] would pass
    /// to [ClippingAudioSource] are computed correctly from (startMs, durationMs).
    ///
    /// We test the *logic* only — no real audio device or asset bundle needed.

    test('start Duration matches startMs', () {
      final clip = _clip(startMs: 2300, durationMs: 480);
      final start = Duration(milliseconds: clip.startMs);
      expect(start.inMilliseconds, equals(2300));
    });

    test('end Duration matches startMs + durationMs', () {
      final clip = _clip(startMs: 2300, durationMs: 480);
      final end = Duration(milliseconds: clip.endMs);
      expect(end.inMilliseconds, equals(2780));
    });

    test('clip at position zero: start=0ms end=500ms', () {
      final clip = _clip(startMs: 0, durationMs: 500);
      expect(Duration(milliseconds: clip.startMs).inMilliseconds, equals(0));
      expect(Duration(milliseconds: clip.endMs).inMilliseconds, equals(500));
    });

    test('second clip in pack: start=500ms end=1000ms', () {
      final clip = _clip(startMs: 500, durationMs: 500);
      expect(Duration(milliseconds: clip.startMs).inMilliseconds, equals(500));
      expect(Duration(milliseconds: clip.endMs).inMilliseconds, equals(1000));
    });

    test('third clip in pack: start=1000ms end=1500ms', () {
      final clip = _clip(startMs: 1000, durationMs: 500);
      expect(Duration(milliseconds: clip.startMs).inMilliseconds, equals(1000));
      expect(Duration(milliseconds: clip.endMs).inMilliseconds, equals(1500));
    });

    test('large offset clip is correct', () {
      final clip = _clip(startMs: 128750, durationMs: 1200);
      expect(
        Duration(milliseconds: clip.startMs).inMilliseconds,
        equals(128750),
      );
      expect(
        Duration(milliseconds: clip.endMs).inMilliseconds,
        equals(129950),
      );
    });

    test('end is always start + duration regardless of values', () {
      for (final start in [0, 100, 5000, 99999]) {
        for (final dur in [200, 500, 1000, 1500]) {
          final clip = _clip(startMs: start, durationMs: dur);
          expect(
            Duration(milliseconds: clip.endMs).inMilliseconds,
            equals(start + dur),
            reason: 'start=$start dur=$dur',
          );
        }
      }
    });
  });

  // ── PlaybackState mapping ────────────────────────────────────────────────────

  group('AudioPlaybackState mapping', () {
    /// Tests the mapping from just_audio [PlayerState] to [AudioPlaybackState].
    /// We mirror the private _mapState logic to exercise all branches.

    AudioPlaybackState mapState(PlayerState state) {
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

    test('playing=true → AudioPlaybackState.playing', () {
      expect(
        mapState(PlayerState(true, ProcessingState.ready)),
        AudioPlaybackState.playing,
      );
    });

    test('playing=false + processing=loading → loading', () {
      expect(
        mapState(PlayerState(false, ProcessingState.loading)),
        AudioPlaybackState.loading,
      );
    });

    test('playing=false + processing=buffering → loading', () {
      expect(
        mapState(PlayerState(false, ProcessingState.buffering)),
        AudioPlaybackState.loading,
      );
    });

    test('playing=false + processing=idle → idle', () {
      expect(
        mapState(PlayerState(false, ProcessingState.idle)),
        AudioPlaybackState.idle,
      );
    });

    test('playing=false + processing=ready → idle', () {
      expect(
        mapState(PlayerState(false, ProcessingState.ready)),
        AudioPlaybackState.idle,
      );
    });

    test('playing=false + processing=completed → idle', () {
      expect(
        mapState(PlayerState(false, ProcessingState.completed)),
        AudioPlaybackState.idle,
      );
    });

    test('playing=true overrides any processing state', () {
      for (final ps in ProcessingState.values) {
        expect(
          mapState(PlayerState(true, ps)),
          AudioPlaybackState.playing,
          reason: 'processing=$ps should still yield playing',
        );
      }
    });
  });

  // ── AudioRepository.playClip null-safety ─────────────────────────────────────

  group('AudioRepository null clip guard', () {
    /// playClip(null) must return immediately without touching the player.
    /// We set up the just_audio method channel mock so AudioPlayer() can be
    /// constructed in a test environment.

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Silence the just_audio platform channel in tests.
      const channel = MethodChannel('com.ryanheise.just_audio.methods');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (_) async => null);
    });

    test('playClip(null) returns without throwing', () async {
      final repo = AudioRepository();
      await expectLater(repo.playClip(null), completes);
      await repo.dispose();
    });

    test('currentClipId is null before any clip is played', () async {
      final repo = AudioRepository();
      expect(repo.currentClipId, isNull);
      await repo.dispose();
    });

    test('playClip(null) leaves currentClipId null', () async {
      final repo = AudioRepository();
      await repo.playClip(null);
      expect(repo.currentClipId, isNull);
      await repo.dispose();
    });

    test('stop() resets currentClipId to null', () async {
      final repo = AudioRepository();
      await repo.stop();
      expect(repo.currentClipId, isNull);
      await repo.dispose();
    });
  });
}
