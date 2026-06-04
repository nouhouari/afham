# Audio pipeline

Word-pronunciation audio in Af'ham is **real Qur'anic recitation** (not TTS — Kokoro and most
TTS engines don't speak Arabic, and a Qur'an app needs correct *tajwīd*).

## How it's generated

1. **`tool/fetch_quran_word_audio.py`** (`uv` / stdlib) — for each lemma, finds its surface form
   in the cited verse via the quran.com API and downloads the **isolated word clip**
   `https://audio.qurancdn.com/wbw/SSS_AAA_WWW.mp3` (the files quran.com plays on word-click),
   keyed by `lemma.latin`. Falls back to clipping the word from a full-ayah recitation (verse
   segment timings, reciter 7 = Alafasy) if the WBW file is missing.
2. **`tool/build_audio_sprites.dart`** — packs the clips into `assets/audio/pack_001.m4a`
   (AAC-LC 32 k mono) + `manifest.json` (`key` / `pack_file` / `start_ms` / `duration_ms`). The
   app imports the manifest and plays clips via `ClippingAudioSource`.

Regenerate:
```sh
uv run tool/fetch_quran_word_audio.py
dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/
```

## Gotchas (hard-won)

- **WBW file numbering is off-by-one after a waqf mark.** The API's per-word `audio_url` file
  number inserts a phantom slot for pause marks (ۚ) that the CDN doesn't have, so it points at
  the *next* word (e.g. iman 49:7 `_018` is actually وَزَيَّنَهُۥ). `۞` (rub-el-hizb) marks *do*
  have a real file, so they're fine. Correction used:
  `real_file = audio_url − (gaps between consecutive words)`. Verified: iman → `_017`, nur → `_003`.
- **just_audio leaves `playing == true` at clip end** (`processingState` → `completed`). So
  `_mapState` treats `completed` as idle *before* the playing flag, and a completion listener
  resets the player — otherwise the play button sticks on "stop" and the next tap toggles stop
  instead of replaying. See `lib/data/audio/audio_repository.dart`.

## ⚠️ Licensing — NOT cleared for release

The bundled clips come from **quran.com** (`audio.qurancdn.com`). Per quran.com's
[Terms & Conditions](https://quran.com/en/terms-and-conditions):

- §5.1 — the audio Content is "the sole property of Quran.com."
- §1.4 — use/copy/distribute is granted for "**individual, noncommercial, informational
  purposes only**."
- §2.3 — "you will **not** copy, reproduce… distribute… any of the Content… without the **prior
  written consent of Quran.com**."

(The MIT licence on `quran/audio.quran.com` covers the *website software*, not the recordings.)

**So the current audio is fine for development/personal use but must NOT ship in a public or
commercial release as-is.** Before release, do ONE of:
1. Obtain **written permission** from Quran Foundation / quran.com (worth asking — common for
   da'wah apps).
2. Switch to a **properly-licensed recitation** — a reciter who has explicitly released word/verse
   audio for free redistribution, or commissioned/self-recorded word audio.
3. Drop bundled audio for V1 and add it once rights are secured.

Tracked in [`PLAN.md`](PLAN.md) as a release blocker.
