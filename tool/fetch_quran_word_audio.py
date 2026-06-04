#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""Fetch authentic word-by-word Qur'anic recitation audio for each lemma.

For every lemma, this finds its Qur'anic *surface form* in the cited verse and
clips that exact word out of a real full-ayah recitation, using quran.com's
word-segment timings — keyed by `lemma.latin` so it feeds straight into
`tool/build_audio_sprites.dart`.

Why segment-clipping (not the per-word WBW files): quran.com's `audio_url`
word-file numbering is inconsistent on verses with waqf/pause marks (the file
number drifts off-by-one), so it can return a neighbouring word. The word
*segments* `[idx, word_number, start_ms, end_ms]` are derived from the actual
audio and are reliable on every verse.

Why real recitation (not TTS): Kokoro/most TTS engines don't speak Arabic, and a
Qur'an app needs correct tajwīd.

Usage:
    uv run tool/fetch_quran_word_audio.py                 # all lemmas, reciter 7
    uv run tool/fetch_quran_word_audio.py --reciter 6     # Husary
    uv run tool/fetch_quran_word_audio.py --pad-ms 60

Then pack into sprites:
    dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/

Reciters (quran.com ids): 7=Alafasy (default, clear murattal), 6=Husary,
2=AbdulBaset Murattal, 4=Shaatree. Verify the reciter's licence/attribution for
your distribution before shipping.
"""

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
import tempfile
import time
import unicodedata
import urllib.request
from pathlib import Path

VERSES = (
    "https://api.quran.com/api/v4/verses/by_key/{key}"
    "?words=true&word_fields=text_uthmani&audio={reciter}"
)
AUDIO_BASE = "https://verses.quran.com/"

ROOT = Path(__file__).resolve().parent.parent
CORPUS = ROOT / "assets" / "db" / "seed" / "lemmas.sample.json"

# Prefer a clearer verse for words the corpus verse recites too briefly.
# (latin -> (surah, ayah, expected_form)) tried before the corpus verses.
AUDIO_VERSE_OVERRIDE: dict[str, tuple[int, int, str]] = {
    "huda": (2, 185, "هُدًى"),  # 2:2 clips to ~0.2s; 2:185 "هُدًى للناس" is fuller
}

_STRIP = set(
    list(range(0x0610, 0x061B))
    + list(range(0x064B, 0x0660))
    + [0x0640, 0x0670]
    + list(range(0x06D6, 0x06EE))
)
_UNIFY = {
    "أ": "ا", "إ": "ا", "آ": "ا", "ٱ": "ا",
    "ى": "ي", "ة": "ه", "ؤ": "و", "ئ": "ي",
}


def normalize(s: str) -> str:
    s = unicodedata.normalize("NFC", s)
    out = [_UNIFY.get(c, c) for c in s if ord(c) not in _STRIP]
    return "".join(c for c in out if "ء" <= c <= "ي")


def http_json(url: str) -> dict:
    req = urllib.request.Request(url, headers={"User-Agent": "afham-audio/1.0"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def http_get(url: str, dest: Path) -> int:
    req = urllib.request.Request(url, headers={"User-Agent": "afham-audio/1.0"})
    with urllib.request.urlopen(req, timeout=60) as r:
        dest.write_bytes(r.read())
    return dest.stat().st_size


def find_word_position(words: list[dict], target_norm: str) -> int | None:
    """Return the 1-based position of the word matching the surface form."""
    cands = [w for w in words if w.get("char_type_name") == "word"]
    for w in cands:  # exact
        if normalize(w.get("text_uthmani", "")) == target_norm:
            return w["position"]
    for w in cands:  # tolerate a short proclitic (وَ / بِ / لِ …)
        wn = normalize(w.get("text_uthmani", ""))
        if (wn.endswith(target_norm) or target_norm.endswith(wn)) and abs(len(wn) - len(target_norm)) <= 3:
            return w["position"]
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--corpus", default=str(CORPUS))
    ap.add_argument("--out", default=str(ROOT / "recordings"))
    ap.add_argument("--reciter", type=int, default=7, help="quran.com reciter id")
    ap.add_argument("--pad-ms", type=int, default=60, help="padding added to each clip end")
    ap.add_argument("--sleep", type=float, default=0.2)
    args = ap.parse_args()

    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        print("✗ ffmpeg not found on PATH (brew install ffmpeg).", file=sys.stderr)
        return 2

    corpus = json.loads(Path(args.corpus).read_text(encoding="utf-8"))
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    cache = Path(tempfile.mkdtemp(prefix="afham-ayah-"))

    lemmas = corpus["lemmas"]
    print(f"Fetching word audio for {len(lemmas)} lemmas (reciter {args.reciter}) → {out}\n")

    verse_cache: dict[str, dict] = {}
    ayah_cache: dict[str, Path] = {}
    ok, missing = [], []

    def verse(key: str) -> dict:
        if key not in verse_cache:
            try:
                verse_cache[key] = http_json(VERSES.format(key=key, reciter=args.reciter))["verse"]
                time.sleep(args.sleep)
            except Exception as e:  # noqa: BLE001
                print(f"  ! API error {key}: {e}")
                verse_cache[key] = {}
        return verse_cache[key]

    for lemma in lemmas:
        latin = lemma["latin"]
        done = False
        # Candidate (form, surah, ayah): override first, then corpus verses.
        candidates: list[tuple[str, int, int]] = []
        if latin in AUDIO_VERSE_OVERRIDE:
            s, a, f = AUDIO_VERSE_OVERRIDE[latin]
            candidates.append((f, s, a))
        candidates += [
            (sf["text_ar"], v["surah"], v["ayah"])
            for sf in lemma["surface_forms"]
            for v in sf["verses"]
        ]
        for form_ar, surah, ayah in candidates:
            target = normalize(form_ar)
            key = f"{surah}:{ayah}"
            vd = verse(key)
            if not vd:
                continue
            pos = find_word_position(vd.get("words", []), target)
            audio = vd.get("audio") or {}
            segs = {s[1]: s for s in audio.get("segments", [])}
            if pos is None or pos not in segs or not audio.get("url"):
                continue
            _, _, start, end = segs[pos]

            # Download the ayah recitation once, then clip the word.
            ayah_url = audio["url"]
            if ayah_url not in ayah_cache:
                p = cache / ayah_url.replace("/", "_")
                try:
                    http_get(AUDIO_BASE + ayah_url, p)
                except Exception as e:  # noqa: BLE001
                    print(f"  ! ayah download failed {ayah_url}: {e}")
                    continue
                ayah_cache[ayah_url] = p
            ss = start / 1000.0
            dur = (end - start + args.pad_ms) / 1000.0
            dest = out / f"{latin}.mp3"
            r = subprocess.run(
                [ffmpeg, "-v", "error", "-y", "-ss", f"{ss}", "-t", f"{dur}",
                 "-i", str(ayah_cache[ayah_url]), "-c:a", "libmp3lame", "-q:a", "4", str(dest)],
                capture_output=True, text=True,
            )
            if r.returncode != 0:
                print(f"  ! ffmpeg clip failed {latin}: {r.stderr.strip()[:120]}")
                continue
            ok.append(latin)
            print(f"  ✓ {latin:8} {form_ar:12} {key:>8} word#{pos:<3} {start}-{end}ms ({dur:.2f}s)")
            done = True
            break
        if not done:
            missing.append(latin)
            print(f"  ✗ {latin:8} — no segment match found")

    shutil.rmtree(cache, ignore_errors=True)
    print(f"\nDone: {len(ok)}/{len(lemmas)} clipped.")
    if missing:
        print("Missing:", ", ".join(missing))
        return 1
    print("\nNext: dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
