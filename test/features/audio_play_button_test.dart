// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/theme/theme.dart';
import 'package:bayan/core/widgets/audio_play_button.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';

// ── Fake AudioRepository ──────────────────────────────────────────────────────

/// Minimal fake that never touches native audio and stays idle forever.
class _FakeAudioRepository implements AudioRepository {
  @override
  Stream<AudioPlaybackState> get playbackState =>
      Stream<AudioPlaybackState>.value(AudioPlaybackState.idle);

  @override
  int? get currentClipId => null;

  @override
  bool get isPlaying => false;

  @override
  Future<void> playClip(AudioClip? clip) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

// ── Test helper ───────────────────────────────────────────────────────────────

/// Wraps [child] with the Riverpod + i18n + theme scaffolding required by
/// [AudioPlayButton] without a real router or database.
Widget _wrap(Widget child) {
  final fakeRepo = _FakeAudioRepository();
  return TranslationProvider(
    child: ProviderScope(
      overrides: [audioRepositoryProvider.overrideWithValue(fakeRepo)],
      child: MaterialApp(
        theme: buildDaftar(),
        home: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

const _testClip = AudioClip(
  id: 1,
  packFile: 'assets/audio/sample_pack.m4a',
  startMs: 0,
  durationMs: 500,
);

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Silence the just_audio platform channel — construction of a real
    // AudioRepository in ProviderScope would touch it otherwise.
    const channel = MethodChannel('com.ryanheise.just_audio.methods');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
    await LocaleSettings.setLocaleRaw('fr');
  });

  group('AudioPlayButton — clip == null', () {
    testWidgets('renders Icons.volume_off_outlined icon', (tester) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: null)));
      await tester.pump();
      expect(find.byIcon(Icons.volume_off_outlined), findsOneWidget);
    });

    testWidgets('does NOT render an IconButton when clip is null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: null)));
      await tester.pump();
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('non-interactive: tapping the icon does nothing', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: null)));
      await tester.pump();
      // Should not throw — there is no tap handler.
      await tester.tap(find.byIcon(Icons.volume_off_outlined));
      await tester.pump();
    });
  });

  group('AudioPlayButton — clip != null', () {
    testWidgets('renders an IconButton', (tester) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: _testClip)));
      await tester.pump();
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets(
      'tap target constraints are >= 44x44 logical px (D2 accessibility fix)',
      (tester) async {
        await tester.pumpWidget(_wrap(const AudioPlayButton(clip: _testClip)));
        await tester.pump();

        // We verify the BoxConstraints (minWidth / minHeight) rather than the
        // rendered size, because VisualDensity.compact shrinks the painted area
        // while the *touch* area is governed by the constraints passed to the
        // framework gesture detector — that is the correct accessibility metric.
        final iconBtn = tester.widget<IconButton>(find.byType(IconButton));
        final constraints = iconBtn.constraints!;
        expect(
          constraints.minWidth,
          greaterThanOrEqualTo(44),
          reason:
              'minWidth >= 44 ensures the touch target meets a11y guidelines',
        );
        expect(
          constraints.minHeight,
          greaterThanOrEqualTo(44),
          reason:
              'minHeight >= 44 ensures the touch target meets a11y guidelines',
        );
      },
    );

    testWidgets('constraints enforce minWidth >= 44 on IconButton', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: _testClip)));
      await tester.pump();

      final iconBtn = tester.widget<IconButton>(find.byType(IconButton));
      final constraints = iconBtn.constraints;
      expect(constraints, isNotNull);
      expect(
        constraints!.minWidth,
        greaterThanOrEqualTo(44),
        reason: 'minWidth constraint must be >= 44 px',
      );
      expect(
        constraints.minHeight,
        greaterThanOrEqualTo(44),
        reason: 'minHeight constraint must be >= 44 px',
      );
    });

    testWidgets(
      'larger iconSize (28) uses a 48 pt box constraint (hero header variant)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            const AudioPlayButton(clip: _testClip, iconSize: 28, filled: true),
          ),
        );
        await tester.pump();

        // iconSize >= 26 → box = 48 per the widget implementation, which means
        // the hero-header variant has an even larger touch area than the compact
        // tile variant (44 pt).
        final iconBtn = tester.widget<IconButton>(find.byType(IconButton));
        final constraints = iconBtn.constraints!;
        expect(constraints.minWidth, greaterThanOrEqualTo(48));
        expect(constraints.minHeight, greaterThanOrEqualTo(48));
      },
    );

    testWidgets('play icon is visible in idle state', (tester) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: _testClip)));
      await tester.pump();

      // In idle state and not-filled mode, expect the outlined play circle.
      expect(find.byIcon(Icons.play_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('tapping the button does not throw', (tester) async {
      await tester.pumpWidget(_wrap(const AudioPlayButton(clip: _testClip)));
      await tester.pump();

      // The fake repo.playClip is a no-op, so the tap should complete cleanly.
      await tester.tap(find.byType(IconButton));
      await tester.pump();
    });
  });
}
