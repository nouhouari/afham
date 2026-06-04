import 'package:flutter/foundation.dart';

/// Domain model for a single audio clip inside a sprite pack.
///
/// Stored in `audio_clips(id, pack_file, start_ms, duration_ms)` in the DB.
/// [packFile] is a Flutter asset path relative to the project root, e.g.
/// `assets/audio/pack_001.m4a`. It is passed directly to
/// `AudioSource.asset(packFile)` — no path manipulation needed.
@immutable
class AudioClip {
  const AudioClip({
    required this.id,
    required this.packFile,
    required this.startMs,
    required this.durationMs,
  });

  /// Row id in `audio_clips`.
  final int id;

  /// Asset path, e.g. `assets/audio/pack_001.m4a`.
  final String packFile;

  /// Start offset inside the pack (milliseconds, inclusive).
  final int startMs;

  /// Duration of this clip (milliseconds).
  final int durationMs;

  /// Convenience: end offset = start + duration.
  int get endMs => startMs + durationMs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioClip && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AudioClip(id=$id, pack=$packFile, start=${startMs}ms, dur=${durationMs}ms)';
}
