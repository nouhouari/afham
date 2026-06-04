// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/theme/theme.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';
// Hide the Drift-generated AudioClip table row class to avoid name collision
// with the domain AudioClip from the audio package.
import 'package:bayan/data/database/app_database.dart'
    hide AudioClip, AudioClips, AudioClipsCompanion;
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/seed/seed_data.dart';
import 'package:bayan/features/search/search_screen.dart';

// ── Fake AudioRepository ──────────────────────────────────────────────────────

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

// ── DB helper ─────────────────────────────────────────────────────────────────

Future<AppDatabase> _openSeededDb() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDatabase(db);
  return db;
}

// ── Router helper ─────────────────────────────────────────────────────────────
//
// SearchScreen calls context.goNamed('settings') from the AppBar settings icon,
// and _WordDetailSheet's root block calls context.goNamed('rootFamily', …).
// Providing a GoRouter with stubs prevents "no GoRouter found" exceptions.

GoRouter _buildRouter() => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'search', builder: (_, _) => const SearchScreen()),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (_, _) => const Scaffold(body: Text('Settings')),
    ),
    GoRoute(
      path: '/root/:rootId',
      name: 'rootFamily',
      builder: (_, _) => const Scaffold(body: Text('Root family')),
    ),
  ],
);

// ── Widget builder ─────────────────────────────────────────────────────────────

Widget _buildApp(AppDatabase db) {
  return TranslationProvider(
    child: ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith((ref) => db),
        audioRepositoryProvider.overrideWithValue(_FakeAudioRepository()),
      ],
      child: MaterialApp.router(
        theme: buildDaftar(),
        routerConfig: _buildRouter(),
      ),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late AppDatabase db;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    // Silence just_audio platform channel.
    const channel = MethodChannel('com.ryanheise.just_audio.methods');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
    await LocaleSettings.setLocaleRaw('fr');
  });

  setUp(() async {
    db = await _openSeededDb();
  });

  tearDown(() async {
    await db.close();
  });

  // ── Empty query → Mot du jour ─────────────────────────────────────────────

  group('SearchScreen — empty query (Mot du jour)', () {
    testWidgets('shows "MOT DU JOUR" label on the home card', (tester) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      // The label is "Mot du jour".toUpperCase() from the FR translation.
      expect(
        find.textContaining('MOT DU JOUR', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('home card contains a seeded Arabic word', (tester) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      // At least one of the seeded Arabic lemmas must appear.
      // The word-of-day rotates through the corpus; we look for any Arabic
      // character range text being present.
      final arabicFinder = find.byWidgetPredicate((widget) {
        if (widget is Text) {
          return widget.data != null &&
              widget.data!.runes.any((r) => r >= 0x0600 && r <= 0x06FF);
        }
        return false;
      });
      expect(arabicFinder, findsWidgets);
    });

    testWidgets('search field is visible and initially empty', (tester) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      final tf = find.byType(TextField);
      expect(tf, findsOneWidget);
      expect(tester.widget<TextField>(tf).controller?.text ?? '', isEmpty);
    });
  });

  // ── Active query → result cards ───────────────────────────────────────────

  group('SearchScreen — active query', () {
    testWidgets('entering «rahma» shows رَحْمَة result card', (tester) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      // Type into the search field (SearchQuery notifier is updated via onChanged).
      await tester.enterText(find.byType(TextField), 'rahma');
      await tester.pumpAndSettle();

      expect(find.textContaining('رَحْمَة', findRichText: true), findsWidgets);
    });

    testWidgets('entering Arabic «رحمة» shows رَحْمَة result card', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'رحمة');
      await tester.pumpAndSettle();

      expect(find.textContaining('رَحْمَة', findRichText: true), findsWidgets);
    });

    testWidgets('result card shows French translation (Miséricorde)', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'rahma');
      await tester.pumpAndSettle();

      expect(
        find.textContaining('iséricorde', findRichText: true),
        findsWidgets,
        reason: 'FR translation "Miséricorde" should appear in the card',
      );
    });

    testWidgets('unknown query shows no-results state', (tester) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzzzunknown');
      await tester.pumpAndSettle();

      // The _NoResults widget shows a search_off icon.
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });
  });

  // ── Tap card → opens word-detail sheet ───────────────────────────────────

  group('SearchScreen — tap result card → word-detail sheet', () {
    testWidgets(
      'tapping rahma result opens a bottom sheet with the Arabic hero word',
      (tester) async {
        await tester.pumpWidget(_buildApp(db));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'rahma');
        await tester.pumpAndSettle();

        // Find and tap the first result card InkWell containing رَحْمَة.
        // The card's InkWell wraps the whole card content; tap a unique text in it.
        final cardText = find
            .textContaining('رَحْمَة', findRichText: true)
            .first;
        await tester.tap(cardText);
        await tester.pumpAndSettle();

        // The sheet should now show the Arabic hero word prominently.
        expect(
          find.textContaining('رَحْمَة', findRichText: true),
          findsWidgets,
        );
      },
    );

    testWidgets('word-detail sheet contains the French translation after tap', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'rahma');
      await tester.pumpAndSettle();

      final cardText = find.textContaining('رَحْمَة', findRichText: true).first;
      await tester.tap(cardText);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('iséricorde', findRichText: true),
        findsWidgets,
      );
    });

    testWidgets('word-detail sheet shows root ر-ح-م', (tester) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'rahma');
      await tester.pumpAndSettle();

      final cardText = find.textContaining('رَحْمَة', findRichText: true).first;
      await tester.tap(cardText);
      await tester.pumpAndSettle();

      // _RootBlock renders detail.rootAr which equals 'ر-ح-م'.
      expect(find.textContaining('ر-ح-م', findRichText: true), findsWidgets);
    });
  });

  // ── Mot du jour card tap → opens word-detail sheet ───────────────────────

  group('SearchScreen — Mot du jour card tap', () {
    testWidgets('tapping the Mot du jour card opens the word-detail sheet', (
      tester,
    ) async {
      await tester.pumpWidget(_buildApp(db));
      await tester.pumpAndSettle();

      // The card's InkWell is in _WordOfDayCard. Tap the card by targeting
      // the MOT DU JOUR label area (which is inside the InkWell).
      final label = find.textContaining('MOT DU JOUR', findRichText: true);
      expect(label, findsOneWidget);

      await tester.tap(label);
      await tester.pumpAndSettle();

      // A DraggableScrollableSheet indicates the bottom sheet opened.
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });
  });
}
