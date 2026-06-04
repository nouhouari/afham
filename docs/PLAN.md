# Af'ham (أَفْهَم) — Project Plan & Status

> Source of truth for scope and progress. Realigned 2026-06-04 to the **canonical
> 9-phase plan** (recovered from the user's device) after the original planning
> session was lost. Keep this file updated as phases land and gates run.

## Product vision

Mobile app helping people who **read** the Qur'an in Arabic but don't **understand**
it (vocabulary gap) move from mechanical recitation to reading with the heart
(*Tadabbur*). The user types/selects a Qur'anic word in its exact textual form → gets
a concise **fiche**: Translation · Root (to learn word families) · short contextual
Tafsir · a linguistic/spiritual gem (*pépite*) · a memory trick (*astuce mémo* —
priority to Darija/dialectal links for francophones, else universal mnemonics).

**Name:** Af'ham (أَفْهَم — "I understand"). Scaffolded as "Bayan", rebranded in
`a16d981`. Residual "bayan" remains in the **Dart package name** (`pubspec.yaml`
`name:`, drives every `package:bayan/...` import), the Android `applicationId
com.houari.bayan`, the iOS bundle id, and `bayan.iml` — these are **deliberately not
renamed** (invasive, risks signing/build breakage); a focused rename is a separate
decision. README is rebranded to Af'ham.

## Hard constraints

- **Flutter** (iOS + Android). · **100% offline** — all text + micro-audio embedded
  locally; app stays lightweight. · **Relational local DB** linking Words / Roots /
  Verses / Languages. · **Sober/premium Islamic** design (Tarteel/Pillars), native
  Light + Dark, never breaks reading flow. · **i18n FR + EN from V1.**

## Locked technical decisions

- **DB: Drift (SQLite)** — chosen over Hive/Isar for the relational model + FTS5.
- **Tolerant search: FTS5** + `arabic_normalizer` (strips harakat/tatweel; unifies
  أ/إ/آ/ٱ→ا, ى→ي, ة→ه, ؤ→و, ئ→ي) producing `search_key`; query normalizes the same
  way → FTS5 prefix on `surface_forms` + LIKE fallback on `latin` → resolve to lemma
  → fiche, sorted by `frequency ↓`. (`رحمه` or `rahma` → lemma `رَحْمَة`.)
- **Audio: AAC-LC sprite packs** (~3,400 clips of 0.5–1.5 s ≈ 15–30 MB total),
  concatenated into a few packs; store `pack_file` + `start_ms` + `duration_ms`; play
  the segment via `just_audio` `ClippingAudioSource`. Embedded in `assets/audio/`.
  (Play Asset Delivery / on-demand rejected — would break "100% offline at install".)
- **Content pipeline:** LLM prompt (`docs/content_generation_prompt.md`) → JSON
  validated against `docs/content_schema.json` → idempotent Drift seed importer.
- **i18n:** `slang` codegen (`strings_*.g.dart`). The app **must** be wrapped in
  `TranslationProvider` (every screen uses `Translations.of(context)`).
- **Codegen:** Drift + Riverpod (`riverpod_generator`) + slang via `build_runner`.

## Data model (Drift / SQLite — §1.A, confirmed matching `lib/data/database/tables.drift`)

- `roots(id, root_ar, root_normalized, latin)`
- `lemmas(id, root_id→roots, lemma_ar, search_key, latin, pos, frequency, audio_id→audio_clips)`
  — the fiche entry (1 audio per lemma ≈ 3,400 clips).
- `word_content(id, lemma_id→lemmas, lang_code, translation, tafsir, gem, mnemonic,
  UNIQUE(lemma_id, lang_code))` — multilingual; adding a language = inserting rows.
- `surface_forms(id, lemma_id→lemmas, text_ar, search_key, latin)` — each exact Qur'anic
  form, points to its lemma; this is what we index.
- `verses(id, surah, ayah, text_uthmani, text_simple, UNIQUE(surah, ayah))`
- `occurrences(id, surface_form_id→surface_forms, verse_id→verses, position)` — N–N.
- `audio_clips(id, pack_file, start_ms, duration_ms)` — sprite pointer + offset.
- `forms_fts` — FTS5 virtual over `surface_forms(search_key, latin)` with sync triggers.

## Design system (§3, locked)

`BayanTokens` ThemeExtension (`lib/core/theme/app_tokens.dart`); `buildDaftar()` (Light)
/ `buildSakina()` (Dark). Fonts: Amiri (Arabic), Inter (Latin).
- **Daftar (Light):** bg `#F5F0E8`, ink `#7A5C3E`, gold `#9A7B3F` (decorative only —
  not text-safe on light), green `#3D6B52`, highlight `#EDE3CE`, memo `#D9EBE1`,
  arabic `#3B2E1E`.
- **Sakīna (Dark):** bg `#16241D`, gold `#C9A24B`, green `#3D7A58`, highlight `#1F3329`,
  memo `#1A3028`, arabic `#ECE6D6`.

## Phase ledger (canonical 0–8)

| Phase | Scope | Status | Ref |
|------|------|--------|-----|
| 0 · Cadrage | Design direction + palettes (Daftar/Sakīna), screen options | ✅ | tokens/theme |
| 1 · Scaffold & socle | App skeleton, themes, router, Riverpod DI, `arabic_normalizer`; Android build/startup; rebrand → Af'ham | ✅ | `18177ce`,`a16d981`,`910479b` |
| — Settings | Persist theme + locale (SharedPreferences) | ✅ | `f21d154` |
| 2 · BDD + recherche | Drift schema + DAOs + FTS5 tolerant search + 20-lemma seed; tolerant-search DAO tests | ✅ | `5d2b615` |
| 3 · Contenu | Content-gen prompt + JSON schema + idempotent seed importer | ✅ | `bde53c3` |
| 4 · Audio | AAC sprites + `ClippingAudioSource` (`audio_repository.dart`) | ✅ | `236a243` |
| 5 · UI/UX | Word-detail fiche, root-family, search; models + `WordDetailDao` | ✅ gates APPROUVÉ (5.1 debt cleared) | `20c57bf` + fixes |
| 6 · QA | Widget/integration tests, edge cases (option: MCP conductor e2e) | ⏳ next | — |
| 7 · Vérification | `flutter run` device; **airplane-mode audio**; `flutter build apk --analyze-size` | 🟡 partial (device boot ✓) | — |
| 8 · CI/CD | GitHub Actions + Fastlane (see locked decisions below) | ⏳ | — |

**Parallelizable:** Phases 3 (content) and 5 (design) run in parallel after Phase 2.

## Review-gate rule (mandatory, transversal)

No phase starts until the previous one passes **two green reviews**, each logged as a
short compte-rendu in `docs/reviews/`:
1. **Design review** — `ux-design-advisor` (UX/visual coherence + the data/API contract
   supports the target UX).
2. **Code review** — `/code-review` (correctness + reuse/simplicity); fixes applied
   before continuing. `qa-test-engineer` complements on coverage.
Outcome per gate: **APPROUVÉ** (advance) or **À CORRIGER** (loop on the phase).

### Gate log

- **Phase 5** (2026-06-04): design + code reviews run retroactively →
  `docs/reviews/phase5-design.md`, `docs/reviews/phase5-code.md`. Both **À CORRIGER**;
  **blocker fixed** (root-family now displays the root via `LEFT JOIN roots` + `rootAr`),
  lints cleared. Earlier phases (0–4) shipped without recorded gates — historical debt.
- **Phase 5.1** (2026-06-04): gate debt cleared → both gates now **APPROUVÉ**. Deleted dead
  `WordDetailScreen` + route (~490 lines); extracted shared `AudioPlayButton` (≥44pt, fixes
  D2 + dup); added `accentText` token (fixes D3 gold-as-text); `wordOfDay` full-corpus
  rotation; localized not-found; POS i18n in search; `const _SearchPrompt`. Verified on
  device (analyze 0, 94 tests, home + fiche render). Only minor nice-to-haves remain.

## Agent orchestration (per phase)

0 Explore + Plan + `ux-design-advisor` (2–3 design options, pick direction first) ·
1 `flutter-dev-expert` (scaffold, core/) · 2 `flutter-dev-expert` (schema+DAOs+FTS5) →
`qa-test-engineer` · 3 `general-purpose` (gen prompt, schema, seed) · 4 `general-purpose`
(AAC concat → sprites) + `flutter-dev-expert` (audio repo) · 5 `ux-design-advisor` →
`flutter-dev-expert` (Material 3 screens) · 6 `qa-test-engineer` (+ MCP conductor e2e) ·
7 `flutter-dev-expert` (+ MCP playwright web build) · 8 `cicd-pipeline-engineer`.

## Phase 8 — CI/CD (locked decisions)

`match` (iOS signing), trigger on tag `v*`, initial targets **TestFlight + Play
Internal**, accounts not ready → **secrets as placeholders, prod lanes inactive** until
credentials provided.
- **CI** (ubuntu, on PR/push): `pub get` → `build_runner` → `flutter analyze` →
  `dart format --set-exit-if-changed` → `flutter test --coverage` → validation build.
  Pin Flutter 3.44.1 (`subosito/flutter-action@v2`); cache pub + gradle.
- **CD Android** (on `v*`): `flutter build appbundle --release` signed → `fastlane
  supply` → Play Internal (prod off).
- **CD iOS** (macos, on `v*`): `fastlane match` → `gym` → `pilot` → TestFlight (App
  Store deliver lane present but off).
- Tree: `.github/workflows/{ci,release-android,release-ios}.yml`,
  `android/fastlane/{Fastfile,Appfile}`, `ios/fastlane/{Fastfile,Appfile,Matchfile}`.
- User provides (agent wires, doesn't create): Apple Developer + App Store Connect API
  key (.p8/Key ID/Issuer ID), Google Play service-account JSON, Android upload-keystore,
  `match` certs repo → stored as base64 GitHub Secrets. Until present: prod lanes skip.

## Open threads

**Phase 5.1 (UI debt, from the gates) — ✅ DONE 2026-06-04:**
- [x] Deleted dead `WordDetailScreen` + route; extracted shared `AudioPlayButton`
      (`lib/core/widgets/audio_play_button.dart`).
- [x] Accessibility: audio targets ≥ 44pt; `accentText` token removes gold-as-text on light.
- [x] `wordOfDay` full-corpus daily rotation; localized sheet "not found";
      `const _SearchPrompt`; POS i18n in search results.
- [ ] Remaining minor (non-blocking): search debounce; `ValueKey` on list items;
      surface audio-playback failures in prod.

**Roadmap:**
- [ ] Phase 6 — widget/integration tests for the fiche + search flow; a `word_detail_dao`
      test (incl. the root-family fix).
- [ ] Phase 7 — airplane-mode audio playback; `flutter build apk --analyze-size`; iOS pass.
- [ ] Phase 8 — CI/CD per the locked decisions above.
- [ ] Scale content past the 20-lemma seed; real audio sprite packs (currently 3-clip sample).
- [ ] (Separate decision) Dart package / app-id rename `bayan` → `afham`.

## Verification (current)

`flutter analyze` → **0 issues** · `flutter test` → **94 passing** · app boots
**crash-free** on the Samsung SM A245F (the `TranslationProvider` crash, found by running
on-device, is fixed). Airplane-mode audio + bundle-size are Phase-7 items, not yet done.
