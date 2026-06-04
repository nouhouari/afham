#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""Fetch authentic word-by-word Qur'anic recitation audio for each lemma.

For every lemma in the content corpus, this matches its Qur'anic *surface form*
to the exact word of its cited verse (via the quran.com API), and downloads that
word's recitation clip — keyed by `lemma.latin` so it feeds straight into
`tool/build_audio_sprites.dart`.

Why real recitation (not TTS): Kokoro/most TTS engines don't speak Arabic, and a
Qur'an app needs correct tajwīd — so we use the quran.com word-by-word reciter.

Usage:
    uv run tool/fetch_quran_word_audio.py            # download all
    uv run tool/fetch_quran_word_audio.py --out recordings
    python3 tool/fetch_quran_word_audio.py           # works without uv too

Then pack into sprites:
    dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/

Source: quran.com API (api.quran.com/api/v4) + audio.qurancdn.com.
The word-by-word reciter is Shaykh Wisam Sharieff (quran.com). Verify the
licence/attribution for your distribution before shipping.
"""

from __future__ import annotations

import argparse
import json
import sys
import time
import unicodedata
import urllib.parse
import urllib.request
from pathlib import Path

API = "https://api.quran.com/api/v4/verses/by_key/{key}?words=true&word_fields=text_uthmani,audio_url"
CDN = "https://audio.qurancdn.com/"

ROOT = Path(__file__).resolve().parent.parent
CORPUS = ROOT / "assets" / "db" / "seed" / "lemmas.sample.json"

# Some words have no word-by-word clip on the CDN at their corpus verse (the
# quran.com WBW audio set has gaps / number offsets). These fallback verses host
# the same lemma's word with working audio. (surah, ayah, expected_form)
FALLBACK_VERSES: dict[str, list[tuple[int, int, str]]] = {
    "qalb": [(50, 37, "قَلْبٌ")],
    "ilm": [(2, 32, "عِلْمَ")],
    "huda": [(31, 5, "هُدًى")],
}

# Combining marks / pause & honorific symbols / tatweel to drop for matching.
_STRIP = set(
    list(range(0x0610, 0x061B))      # honorific signs
    + list(range(0x064B, 0x0660))    # harakat
    + [0x0640]                       # tatweel
    + [0x0670]                       # dagger alef
    + list(range(0x06D6, 0x06EE))    # small high/low marks, pause marks, ۞ etc.
)
# Letter-form unification matching lib/core/text/arabic_normalizer.dart.
_UNIFY = {
    "أ": "ا", "إ": "ا", "آ": "ا", "ٱ": "ا",
    "ى": "ي", "ة": "ه", "ؤ": "و", "ئ": "ي",
}


def normalize(s: str) -> str:
    s = unicodedata.normalize("NFC", s)
    out = []
    for ch in s:
        if ord(ch) in _STRIP:
            continue
        out.append(_UNIFY.get(ch, ch))
    # keep only Arabic letters (drop spaces, punctuation, the ۞ that survived, etc.)
    return "".join(c for c in out if "ء" <= c <= "ي")


def http_json(url: str) -> dict:
    req = urllib.request.Request(url, headers={"User-Agent": "afham-audio/1.0"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def download(url: str, dest: Path) -> int:
    req = urllib.request.Request(url, headers={"User-Agent": "afham-audio/1.0"})
    with urllib.request.urlopen(req, timeout=30) as r:
        data = r.read()
    dest.write_bytes(data)
    return len(data)


def match_word(words: list[dict], target_norm: str) -> dict | None:
    """Find the verse word whose normalized text equals/contains the form."""
    # 1) exact normalized equality
    for w in words:
        if normalize(w.get("text_uthmani", "")) == target_norm:
            return w
    # 2) the form is the bare word minus a 1-char proclitic (وَ / فَ / بِ / لِ / ٱل…)
    for w in words:
        wn = normalize(w.get("text_uthmani", ""))
        if wn.endswith(target_norm) and len(wn) - len(target_norm) <= 3:
            return w
        if target_norm.endswith(wn) and len(target_norm) - len(wn) <= 3:
            return w
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--corpus", default=str(CORPUS), help="path to lemmas JSON")
    ap.add_argument("--out", default=str(ROOT / "recordings"), help="output dir")
    ap.add_argument("--sleep", type=float, default=0.3, help="delay between requests (s)")
    args = ap.parse_args()

    corpus = json.loads(Path(args.corpus).read_text(encoding="utf-8"))
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    lemmas = corpus["lemmas"]
    print(f"Fetching word audio for {len(lemmas)} lemmas → {out}\n")

    ok, missing = [], []
    verse_cache: dict[str, list[dict]] = {}

    def words_for(key: str) -> list[dict]:
        if key not in verse_cache:
            try:
                verse_cache[key] = http_json(API.format(key=key))["verse"]["words"]
                time.sleep(args.sleep)
            except Exception as e:  # noqa: BLE001
                print(f"  ! API error for {key}: {e}")
                verse_cache[key] = []
        return verse_cache[key]

    for lemma in lemmas:
        latin = lemma["latin"]
        # Candidate (form, surah, ayah): corpus surface forms first, then fallbacks.
        candidates = [
            (sf["text_ar"], v["surah"], v["ayah"])
            for sf in lemma["surface_forms"]
            for v in sf["verses"]
        ]
        candidates += [(f, s, a) for (s, a, f) in FALLBACK_VERSES.get(latin, [])]

        dest = out / f"{latin}.mp3"
        done = False
        for form, surah, ayah in candidates:
            key = f"{surah}:{ayah}"
            w = match_word(words_for(key), normalize(form))
            if not (w and w.get("audio_url")):
                continue
            try:
                size = download(CDN + w["audio_url"], dest)
            except Exception:  # noqa: BLE001 — CDN gap; try next candidate
                continue
            ok.append(latin)
            print(f"  ✓ {latin:8} {form:12} {key:>8} → {w['audio_url']} ({size // 1024} KB)")
            time.sleep(args.sleep)
            done = True
            break

        if not done:
            missing.append(latin)
            print(f"  ✗ {latin:8} — no working word audio found")

    print(f"\nDone: {len(ok)}/{len(lemmas)} downloaded.")
    if missing:
        print("Missing:", ", ".join(missing))
        return 1
    print("\nNext: dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
