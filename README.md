# Af'ham (أَفْهَم)

A **100% offline** Flutter app that helps people who read the Qur'an in Arabic but
don't understand it — bridging the vocabulary gap so reading becomes *Tadabbur*
(reading with the heart) rather than mechanical recitation.

Type or select a Qur'anic word in its exact form and get a concise **fiche**:

- **Translation** (FR / EN)
- **Root** — to learn to recognize word families
- **Tafsir** — short contextual explanation
- **Pépite** — a linguistic / spiritual gem
- **Astuce mémo** — a memory trick (priority to Darija/dialectal links for
  francophones, else universal mnemonics)

…plus **audio** pronunciation of the word, all embedded locally.

## Highlights

- **Offline-first** — text and micro-audio shipped in the app; works in airplane mode.
- **Tolerant search** — harakat/phonetic-insensitive (`رحمه` or `rahma` → `رَحْمَة`)
  via SQLite FTS5 + an Arabic normalizer.
- **Light + Dark** — sober, premium, spiritual design (Daftar / Sakīna themes).
- **Bilingual FR / EN** from V1 (slang i18n).

## Tech stack

Flutter · Drift (SQLite) + FTS5 · Riverpod · go_router · just_audio
(`ClippingAudioSource` sprite playback) · slang.

## Project docs

- [`docs/PLAN.md`](docs/PLAN.md) — phased plan, status, and architecture (source of truth)
- [`docs/content_generation_prompt.md`](docs/content_generation_prompt.md) /
  [`docs/content_schema.json`](docs/content_schema.json) — content pipeline
- [`docs/reviews/`](docs/reviews/) — phase review compte-rendus

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift / Riverpod / slang codegen
flutter run -d <device>
flutter test
```
