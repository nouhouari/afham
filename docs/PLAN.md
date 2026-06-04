# Af'ham (أَفْهَم) — Project Plan & Status

> Reconstructed 2026-06-04 from the original product brief + git history, after the
> planning session's transcript was lost. This file is the source of truth for scope
> and progress — keep it updated as phases land.

## Product vision

Mobile app helping people who **read** the Qur'an in Arabic but don't **understand** it
(vocabulary gap) move from mechanical recitation to reading with the heart (*Tadabbur*).

A user types/selects a Qur'anic word in its exact textual form and gets a concise
**fiche**: Translation · Root (to learn word families) · short contextual Tafsir ·
a linguistic/spiritual gem (*pépite*) · a memory trick (priority to Darija/dialectal
connections for the francophone audience, else universal mnemonics).

**Name:** Af'ham (أَفْهَم — "I understand"). Originally scaffolded as "Bayan"; rebranded
in commit `a16d981`. Residual "bayan" still in `README.md`, `pubspec.yaml` (`name:`),
and `bayan.iml` — pending cleanup.

## Hard constraints

- **Framework:** Flutter (iOS + Android).
- **100% offline** — all text + micro-audio embedded locally; app stays lightweight.
- **Local DB:** relational model linking Words / Roots / Verses / Languages.
- **Design:** sober, clean, premium; modern Islamic-app codes (Tarteel/Pillars vibe);
  native Light + Dark themes; ultra-intuitive, never breaks the reading flow.
- **i18n:** French + English from V1.

## Key technical decisions

- **Database: Drift (SQLite)** — chosen over Hive/Isar for the relational
  Words↔Roots↔Verses model and FTS5 search.
- **Tolerant search: FTS5** with an Arabic normalizer (harakat-insensitive / phonetic).
- **Audio: AAC sprite packs** played via `just_audio` `ClippingAudioSource`
  (each clip = `pack_file` + `start_ms` + `duration_ms` in `audio_clips`).
  Avoids shipping ~4–5k individual files; keeps APK/IPA small.
- **Content pipeline:** an LLM prompt (`docs/content_generation_prompt.md`) emits JSON
  validated against `docs/content_schema.json`, loaded by an idempotent importer.
- **i18n:** `slang` codegen (`strings_*.g.dart`) from `en.i18n.json` / `fr.i18n.json`.

## Data model (Drift / SQLite)

`lemmas` (lemma_ar, latin, pos, frequency, root_id, audio_id) ·
`roots` (root_ar, latin) ·
`word_content` (lemma_id, **lang_code**, translation, tafsir, gem, mnemonic) — multilingual ·
`verses` (surah, ayah, text_uthmani) ·
`surface_forms` + `occurrences` (link lemmas ↔ verses) ·
`audio_clips` (pack_file, start_ms, duration_ms).

## Phase ledger

| Phase | Scope | Status | Commit |
|-------|-------|--------|--------|
| Scaffold | Flutter app skeleton | ✅ | `18177ce` |
| Phase 1 | Android build/startup on device; Arabic normalizer; token alignment; rebrand → Af'ham | ✅ | `a16d981`, `910470b` |
| Settings | Persist theme + locale (SharedPreferences) | ✅ | `f21d154` |
| Phase 2 | Drift schema + FTS5 tolerant search + 20-lemma seed | ✅ | `5d2b615` |
| Phase 3 | Content-generation prompt + JSON schema + idempotent importer | ✅ | `bde53c3` |
| Phase 4 | Offline audio (AAC sprites + ClippingAudioSource) | ✅ | `236a243` |
| Phase 5 | Word-detail fiche: `LemmaDetail`/`RootFamilyItem`/`VerseSnippet` models, `WordDetailDao` (getLemmaDetail / lemmasByRoot / wordOfDay), detail sheet UI, search/root-family expansion | ✅ committed | `20c57bf` |

## User flow (Étape 3)

`search` (tolerant) → `word_detail` fiche (sheet) → `root_family` (siblings sharing a root,
freq-sorted) · `settings` (theme + language). A **word-of-day** entry point exists in the
DAO (`wordOfDay`) — a scope addition beyond the original brief.

## Open threads / next up

- [ ] Verify Phase-5 fiche on a real device against the "fiche concise" vision.
- [ ] Finish Bayan → Af'ham rename (README, `pubspec.yaml` `name:`, `bayan.iml`).
- [ ] Remove unused imports: `search_screen.dart:6`, `word_detail_sheet.dart:6`
      (`core/router/app_router.dart`), tidy `unnecessary_underscores` lints.
- [ ] Decide whether "word of the day" is a kept feature; if so, give it a UI surface.
- [ ] Scale content beyond the 20-lemma seed via the Phase-3 pipeline.
- [ ] Real audio sprite packs (currently seed-level).
- [ ] iOS build pass (work so far has been Android-device focused).
- [ ] Design-system polish: lock Light/Dark palettes (hex), typography for Arabic.
