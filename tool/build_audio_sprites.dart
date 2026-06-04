#!/usr/bin/env dart

// ignore_for_file: avoid_print, dangling_library_doc_comments
library;

///
/// Concatenates individual clip files (WAV or M4A/AAC) into AAC-LC sprite
/// packs and emits a manifest JSON ready to import into `audio_clips`.
///
/// ## Dependencies
/// - **ffmpeg** — must be on PATH (`which ffmpeg`).
///   Install: `brew install ffmpeg` (macOS) or `apt install ffmpeg` (Linux).
///   Minimum version: 4.x (6+ recommended for stable AAC-LC muxing).
///
/// ## Usage
/// ```sh
/// dart tool/build_audio_sprites.dart \
///   --input  recordings/        \  # dir of *.wav / *.m4a individual clips
///   --output assets/audio/      \  # where packs + manifest.json are written
///   --pack-size 500              # max clips per pack (default 500)
/// ```
///
/// Input naming convention: `<latin_key>.<wav|m4a>` where `latin_key` matches
/// `lemmas.latin`, e.g. `rahma.wav`, `rabb.m4a`.
///
/// ## Output
/// - `assets/audio/pack_001.m4a`, `pack_002.m4a`, …
/// - `assets/audio/manifest.json` — array of:
///   ```json
///   { "key": "rahma", "pack_file": "assets/audio/pack_001.m4a",
///     "start_ms": 0, "duration_ms": 620 }
///   ```
///
/// ## Idempotency
/// If the output pack file already exists, it is overwritten.  Re-running with
/// the same inputs produces the same manifest (clips are processed in filename
/// sorted order → offsets are deterministic).
///
/// ## What changes when you get real recordings
/// 1. Drop your *.wav / *.m4a files into the `--input` dir.
/// 2. Re-run this script.
/// 3. Run `importAudioManifest(db, manifest)` (or just re-install the app).
/// Nothing else in the Flutter codebase needs to change.

import 'dart:convert';
import 'dart:io';

// ── Entry point ───────────────────────────────────────────────────────────────

void main(List<String> rawArgs) async {
  // ── 1. Guard: ffmpeg required ───────────────────────────────────────────────
  final ffmpegPath = _findFfmpeg();
  if (ffmpegPath == null) {
    stderr.writeln(
      '✗ ffmpeg not found on PATH.\n'
      '  Install: brew install ffmpeg  (macOS)\n'
      '           apt install ffmpeg   (Ubuntu/Debian)\n'
      '  Then re-run this script.',
    );
    exit(1);
  }
  print('ffmpeg: $ffmpegPath');

  // ── 2. Parse args ───────────────────────────────────────────────────────────
  final args = _parseArgs(rawArgs);
  final inputDir = Directory(args['input']!);
  final outputDir = Directory(args['output']!);
  final packSize = int.parse(args['pack-size']!);

  if (!inputDir.existsSync()) {
    stderr.writeln('✗ Input directory not found: ${inputDir.path}');
    exit(1);
  }
  outputDir.createSync(recursive: true);

  // ── 3. Collect input clips (sorted for determinism) ─────────────────────────
  final clips = inputDir.listSync().whereType<File>().where((f) {
    final ext = f.path.toLowerCase();
    return ext.endsWith('.wav') || ext.endsWith('.m4a');
  }).toList()..sort((a, b) => a.path.compareTo(b.path));

  if (clips.isEmpty) {
    print('No *.wav / *.m4a files found in ${inputDir.path}. Nothing to do.');
    exit(0);
  }

  print('Found ${clips.length} clip(s). Pack size: $packSize.');

  // ── 4. Measure durations ─────────────────────────────────────────────────────
  final durations = <File, int>{};
  for (final clip in clips) {
    final ms = await _probeDurationMs(ffmpegPath, clip.path);
    if (ms == null) {
      stderr.writeln('  ⚠ Could not probe duration: ${clip.path} — skipping.');
      continue;
    }
    durations[clip] = ms;
  }

  final measuredClips = clips.where(durations.containsKey).toList();
  print('Measured ${measuredClips.length} clip(s).');

  // ── 5. Partition into packs and concatenate ──────────────────────────────────
  final manifest = <Map<String, dynamic>>[];
  final packs = _partition(measuredClips, packSize);

  for (var i = 0; i < packs.length; i++) {
    final packIndex = (i + 1).toString().padLeft(3, '0');
    final packName = 'pack_$packIndex.m4a';
    final packPath = '${outputDir.path}/$packName';
    // Normalise: ensure it starts with assets/audio/
    final normalised = _normalisePath(args['output']!, packName);

    final packClips = packs[i];
    await _buildPack(ffmpegPath, packClips, durations, packPath);

    // Accumulate manifest entries.
    var offset = 0;
    for (final clip in packClips) {
      final dur = durations[clip]!;
      final key = _latinKey(clip);
      manifest.add({
        'key': key,
        'pack_file': normalised,
        'start_ms': offset,
        'duration_ms': dur,
      });
      offset += dur;
    }
    print('  Pack $packName written (${packClips.length} clips).');
  }

  // ── 6. Write manifest ────────────────────────────────────────────────────────
  final manifestPath = '${outputDir.path}/manifest.json';
  File(
    manifestPath,
  ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));
  print('Manifest written: $manifestPath (${manifest.length} entries).');
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Probes a file's duration via `ffprobe`, returns ms or null on failure.
Future<int?> _probeDurationMs(String ffmpegPath, String filePath) async {
  // ffprobe lives alongside ffmpeg.
  final ffprobePath = ffmpegPath.replaceAll('ffmpeg', 'ffprobe');
  final result = await Process.run(ffprobePath, [
    '-v',
    'error',
    '-show_entries',
    'format=duration',
    '-of',
    'default=noprint_wrappers=1:nokey=1',
    filePath,
  ]);
  if (result.exitCode != 0) return null;
  final s = (result.stdout as String).trim();
  final seconds = double.tryParse(s);
  if (seconds == null) return null;
  return (seconds * 1000).round();
}

/// Concatenates [clips] into a single AAC-LC M4A file at [outputPath].
Future<void> _buildPack(
  String ffmpegPath,
  List<File> clips,
  Map<File, int> durations,
  String outputPath,
) async {
  if (clips.isEmpty) return;

  // Build a concat filter graph.
  // Input files: -i clip1 -i clip2 ...
  // Filter: [0:a][1:a]...concat=n=N:v=0:a=1[aout]
  // Output: -map [aout] -c:a aac -b:a 32k -ac 1
  final inputArgs = clips.expand((f) => ['-i', f.path]).toList();
  final filterInputs = List.generate(clips.length, (i) => '[$i:a]').join();
  final filterComplex = '${filterInputs}concat=n=${clips.length}:v=0:a=1[aout]';

  final args = [
    '-y', // overwrite
    ...inputArgs,
    '-filter_complex', filterComplex,
    '-map', '[aout]',
    '-c:a', 'aac',
    '-b:a', '32k',
    '-ac', '1',
    '-movflags', '+faststart',
    outputPath,
  ];

  final result = await Process.run(ffmpegPath, args);
  if (result.exitCode != 0) {
    throw ProcessException(
      ffmpegPath,
      args,
      'ffmpeg concat failed:\n${result.stderr}',
      result.exitCode,
    );
  }
}

/// Locate `ffmpeg` on PATH.
String? _findFfmpeg() {
  try {
    final result = Process.runSync('which', ['ffmpeg']);
    if (result.exitCode == 0) {
      return (result.stdout as String).trim();
    }
  } catch (_) {}
  return null;
}

/// Splits [items] into sub-lists of at most [size] elements.
List<List<T>> _partition<T>(List<T> items, int size) {
  final result = <List<T>>[];
  for (var i = 0; i < items.length; i += size) {
    result.add(items.sublist(i, (i + size).clamp(0, items.length)));
  }
  return result;
}

/// Extracts the latin key from the filename (stem before extension).
String _latinKey(File file) {
  final name = file.uri.pathSegments.last;
  final dot = name.lastIndexOf('.');
  return (dot == -1 ? name : name.substring(0, dot)).toLowerCase();
}

/// Normalises the output dir + pack name to `assets/audio/<packName>`.
/// Handles paths like `assets/audio/`, `./assets/audio`, etc.
String _normalisePath(String outputDir, String packName) {
  // Strip leading ./ and trailing /
  var d = outputDir.replaceAll(RegExp(r'^[./]+'), '').replaceAll('//', '/');
  if (d.endsWith('/')) d = d.substring(0, d.length - 1);
  return '$d/$packName';
}

/// Minimal CLI argument parser for --key value pairs.
Map<String, String> _parseArgs(List<String> args) {
  final defaults = <String, String>{
    'input': 'recordings/',
    'output': 'assets/audio/',
    'pack-size': '500',
  };
  final result = Map<String, String>.from(defaults);
  for (var i = 0; i < args.length - 1; i++) {
    final key = args[i];
    if (key.startsWith('--')) {
      result[key.substring(2)] = args[i + 1];
      i++; // skip value
    }
  }
  return result;
}
