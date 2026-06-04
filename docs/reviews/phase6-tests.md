# Compte-rendu — Phase 6 (QA / tests)

**VERDICT: APPROUVÉ**

Phase 6 adds automated coverage for the Phase-5 surfaces. Design review is N/A
(no UI change); this is the **code-review gate** for the new tests.

## Added (42 new tests → suite now 136 passing)

- **`test/data/word_detail_dao_test.dart`** (11) — DAO contract:
  - `getLemmaDetail`: full fiche for رَحْمَة, null for unknown id, FR≠EN localization,
    verses capped at 2 with valid surah:ayah refs.
  - `lemmasByRoot`: **root-family blocker regression guard** — every item exposes the
    shared `rootAr` (`ر-ح-م`); frequency-descending order; empty list for unknown root.
  - `wordOfDay`: non-null for a normal index; **rotates across the corpus** (>1 distinct
    lemma over a 25-day window — locks the coverage fix); wraps on large index; null on
    empty DB.
- **`test/features/audio_play_button_test.dart`** (9) — null-clip renders `volume_off`
  and no `IconButton`; non-null renders an `IconButton`; **D2 a11y guard**: asserts
  `IconButton.constraints.minWidth/minHeight ≥ 44` (compact tiles) and `≥ 48` (hero
  header); idle play glyph; tap no-throw via a fake `AudioRepository`.
- **`test/features/search_screen_test.dart`** (11) — empty-query word-of-day card;
  `rahma`/`رحمة` → result card with `رَحْمَة` + "Miséricorde"; unknown query → no-results;
  tap card → sheet opens with hero/translation/root.
- **`test/features/word_detail_sheet_test.dart`** (11) — hero word, translation +
  "TRADUCTION", root row (`ر-ح-م` + "RACINE" + latin), **localized error for unknown id**
  (not the old raw "Lemma #.. not found"), cross-lemma spot checks (صَبْر, نُور).

## Test-infra notes (no `lib/` changes were needed)
- Widget tests wrap `TranslationProvider` → `ProviderScope(overrides: appDatabaseProvider /
  audioRepositoryProvider)` → `MaterialApp(theme: buildDaftar())`, with a stub `GoRouter`
  (screens call `context.goNamed`). slang locale set via `LocaleSettings.setLocaleRaw('fr')`.
- Drift codegen emits an `AudioClip` row class colliding with the domain `AudioClip`;
  resolved with `hide AudioClip, ...` on the DB import.
- just_audio platform channel mocked so no native audio is touched.

## Findings
- **minor** — `audio_play_button_test.dart` has two near-identical "≥44 constraints"
  tests; harmless redundancy, left as-is.
- No correctness issues. `flutter analyze`: 0 issues. `flutter test`: **136 passing**.

## Reste (Phase 7+)
Airplane-mode audio playback + `flutter build apk --analyze-size` (Phase 7); optional
MCP-conductor Gherkin e2e; the non-blocking minors from Phase 5.1 (debounce, list keys).
