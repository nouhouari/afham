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
// Hide the Drift-generated AudioClip table row class to avoid name collision.
import 'package:bayan/data/database/app_database.dart'
    hide AudioClip, AudioClips, AudioClipsCompanion;
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/seed/seed_data.dart';
import 'package:bayan/features/word_detail/word_detail_sheet.dart';

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

/// Resolves a lemma id by exact Arabic surface via tolerant FTS search.
Future<int> _lemmaId(AppDatabase db, String arabic) async {
  final results = await db.searchDao.searchLemmas(arabic);
  final match = results.firstWhere(
    (r) => r.lemmaAr == arabic,
    orElse: () => results.first,
  );
  return match.lemmaId;
}

// ── Host widget ───────────────────────────────────────────────────────────────
//
// A trivial host that shows a button to open the detail sheet. We need a
// GoRouter in the tree because _RootBlock calls context.goNamed('rootFamily').

class _SheetHost extends StatelessWidget {
  const _SheetHost({required this.lemmaId});

  final int lemmaId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showWordDetailSheet(context, lemmaId: lemmaId),
          child: const Text('Open sheet'),
        ),
      ),
    );
  }
}

GoRouter _buildRouter(AppDatabase db, int lemmaId) => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'host',
      builder: (_, _) => _SheetHost(lemmaId: lemmaId),
    ),
    GoRoute(
      path: '/root/:rootId',
      name: 'rootFamily',
      builder: (_, _) => const Scaffold(body: Text('Root family')),
    ),
  ],
);

Widget _buildApp(AppDatabase db, int lemmaId) {
  return TranslationProvider(
    child: ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith((ref) => db),
        audioRepositoryProvider.overrideWithValue(_FakeAudioRepository()),
      ],
      child: MaterialApp.router(
        theme: buildDaftar(),
        routerConfig: _buildRouter(db, lemmaId),
      ),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late AppDatabase db;
  late int rahmaId;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    const channel = MethodChannel('com.ryanheise.just_audio.methods');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
    await LocaleSettings.setLocaleRaw('fr');
  });

  setUp(() async {
    db = await _openSeededDb();
    rahmaId = await _lemmaId(db, 'رَحْمَة');
  });

  tearDown(() async {
    await db.close();
  });

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Opens the sheet and waits for all async loads to settle.
  Future<void> openSheet(
    WidgetTester tester,
    AppDatabase database,
    int lemmaId,
  ) async {
    await tester.pumpWidget(_buildApp(database, lemmaId));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
  }

  // ── Hero Arabic word ──────────────────────────────────────────────────────

  group('WordDetailSheet — hero word (رَحْمَة)', () {
    testWidgets('renders the Arabic hero word', (tester) async {
      await openSheet(tester, db, rahmaId);

      expect(
        find.textContaining('رَحْمَة', findRichText: true),
        findsWidgets,
        reason: 'Arabic hero word must appear in the sheet header',
      );
    });

    testWidgets('renders the DraggableScrollableSheet', (tester) async {
      await openSheet(tester, db, rahmaId);
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });
  });

  // ── Translation ───────────────────────────────────────────────────────────

  group('WordDetailSheet — translation', () {
    testWidgets('shows French translation (Miséricorde)', (tester) async {
      await openSheet(tester, db, rahmaId);

      expect(
        find.textContaining('iséricorde', findRichText: true),
        findsWidgets,
        reason: 'FR translation "Miséricorde" must appear in the sheet',
      );
    });

    testWidgets('shows TRADUCTION section label', (tester) async {
      await openSheet(tester, db, rahmaId);

      // _FactBlock uppercases the label key strings.g.dart word.translation = "Traduction"
      expect(
        find.textContaining('TRADUCTION', findRichText: true),
        findsOneWidget,
      );
    });
  });

  // ── Root row ──────────────────────────────────────────────────────────────

  group('WordDetailSheet — root row', () {
    testWidgets('shows the root ر-ح-م', (tester) async {
      await openSheet(tester, db, rahmaId);

      expect(
        find.textContaining('ر-ح-م', findRichText: true),
        findsWidgets,
        reason: 'Root Arabic "ر-ح-م" must appear in the _RootBlock',
      );
    });

    testWidgets('shows the RACINE section label', (tester) async {
      await openSheet(tester, db, rahmaId);

      // word.root = "Racine" → uppercased = "RACINE"
      expect(find.textContaining('RACINE', findRichText: true), findsOneWidget);
    });

    testWidgets('shows root latin transliteration r-h-m', (tester) async {
      await openSheet(tester, db, rahmaId);

      expect(find.textContaining('r-h-m', findRichText: true), findsWidgets);
    });
  });

  // ── Unknown lemma id ──────────────────────────────────────────────────────

  group('WordDetailSheet — unknown lemma id', () {
    testWidgets('shows the localised error state for id 999999', (
      tester,
    ) async {
      await openSheet(tester, db, 999999);

      // When getLemmaDetail returns null, _WordDetailSheet renders _SheetError
      // with Translations.of(context).error = "Une erreur est survenue" in FR.
      expect(
        find.textContaining('erreur', findRichText: true),
        findsOneWidget,
        reason: 'Unknown id must show the localised error message',
      );
    });

    testWidgets('shows error icon for unknown id', (tester) async {
      await openSheet(tester, db, 999999);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  // ── Cross-lemma spot checks ────────────────────────────────────────────────

  group('WordDetailSheet — other seeded lemmas', () {
    testWidgets('صَبْر (sabr) sheet opens and shows Arabic word', (
      tester,
    ) async {
      final sabrId = await _lemmaId(db, 'صَبْر');
      await openSheet(tester, db, sabrId);

      expect(find.textContaining('صَبْر', findRichText: true), findsWidgets);
    });

    testWidgets('نُور (nur) sheet opens and shows Arabic word', (tester) async {
      final nurId = await _lemmaId(db, 'نُور');
      await openSheet(tester, db, nurId);

      expect(find.textContaining('نُور', findRichText: true), findsWidgets);
    });
  });
}
