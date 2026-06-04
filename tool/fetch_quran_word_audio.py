#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = []
# ///
"""Fetch authentic word-by-word Qur'anic recitation audio for each lemma.

Primary: download quran.com's clean *isolated-word* clip (`wbw/SSS_AAA_WWW.mp3`)
for each lemma's surface form — the same files quran.com plays when you click a
word. Fallback: if that file is missing, clip the word out of the full-ayah
recitation using the word segment timings.

The catch the obvious approach misses: the API's per-word `audio_url` *file
number* drifts off-by-one after a **waqf/pause mark** (the API counts a phantom
file slot the CDN doesn't have), so it can point at the *next* word. We correct
it: real_file = audio_url − (gaps between consecutive words before this one).
Verified: iman 49:7 → 018−1 = 017 ✓ ; nur 24:35 → 003−0 = 003 ✓.

Why real recitation (not TTS): Kokoro/most TTS engines don't speak Arabic.

Usage:
    uv run tool/fetch_quran_word_audio.py
    uv run tool/fetch_quran_word_audio.py --reciter 7

Then: dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/

WBW reciter is quran.com's word-by-word reciter; --reciter sets the ayah-segment
fallback reciter (7=Alafasy). Verify licence/attribution before shipping.
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
    "?words=true&word_fields=text_uthmani,audio_url&audio={reciter}"
)
WBW_BASE = "https://audio.qurancdn.com/"
AUDIO_BASE = "https://verses.quran.com/"

ROOT = Path(__file__).resolve().parent.parent
CORPUS = ROOT / "assets" / "db" / "seed" / "lemmas.sample.json"

# Prefer a clearer verse for words the corpus verse recites too briefly.
AUDIO_VERSE_OVERRIDE: dict[str, tuple[int, int, str]] = {
    "huda": (2, 185, "هُدًى"),
}

_STRIP = set(
    list(range(0x0610, 0x061B))
    + list(range(0x064B, 0x0660))
    + [0x0640, 0x0670]
    + list(range(0x06D6, 0x06EE))
)
_UNIFY = {"أ": "ا", "إ": "ا", "آ": "ا", "ٱ": "ا", "ى": "ي", "ة": "ه", "ؤ": "و", "ئ": "ي"}


def normalize(s: str) -> str:
    out = [_UNIFY.get(c, c) for c in unicodedata.normalize("NFC", s) if ord(c) not in _STRIP]
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


def _au_num(url: str) -> int:
    return int(url.rsplit("_", 1)[-1].split(".")[0])


def find_word(words: list[dict], target_norm: str) -> dict | None:
    cands = [w for w in words if w.get("char_type_name") == "word"]
    for w in cands:
        if normalize(w.get("text_uthmani", "")) == target_norm:
            return w
    for w in cands:
        wn = normalize(w.get("text_uthmani", ""))
        if (wn.endswith(target_norm) or target_norm.endswith(wn)) and abs(len(wn) - len(target_norm)) <= 3:
            return w
    return None


def wbw_file_number(words: list[dict], position: int) -> int | None:
    """Corrected WBW file number: audio_url minus phantom waqf gaps before it."""
    ws = sorted(
        [w for w in words if w.get("char_type_name") == "word" and w.get("audio_url")],
        key=lambda w: w["position"],
    )
    phantom, prev = 0, None
    for w in ws:
        au = _au_num(w["audio_url"])
        if prev is not None:
            phantom += au - prev - 1  # gaps between consecutive words = phantom slots
        if w["position"] == position:
            return au - phantom
        prev = au
    return None


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--corpus", default=str(CORPUS))
    ap.add_argument("--out", default=str(ROOT / "recordings"))
    ap.add_argument("--reciter", type=int, default=7, help="segment-fallback reciter id")
    ap.add_argument("--pad-ms", type=int, default=60)
    ap.add_argument("--sleep", type=float, default=0.2)
    args = ap.parse_args()

    ffmpeg = shutil.which("ffmpeg")
    corpus = json.loads(Path(args.corpus).read_text(encoding="utf-8"))
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    cache = Path(tempfile.mkdtemp(prefix="afham-ayah-"))
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

    def segment_clip(audio: dict, position: int, dest: Path) -> bool:
        segs = {s[1]: s for s in audio.get("segments", [])}
        if position not in segs or not audio.get("url") or not ffmpeg:
            return False
        _, _, start, end = segs[position]
        url = audio["url"]
        if url not in ayah_cache:
            p = cache / url.replace("/", "_")
            try:
                http_get(AUDIO_BASE + url, p)
            except Exception:  # noqa: BLE001
                return False
            ayah_cache[url] = p
        r = subprocess.run(
            [ffmpeg, "-v", "error", "-y", "-ss", f"{start/1000}", "-t", f"{(end-start+args.pad_ms)/1000}",
             "-i", str(ayah_cache[url]), "-c:a", "libmp3lame", "-q:a", "4", str(dest)],
            capture_output=True, text=True,
        )
        return r.returncode == 0

    print(f"Fetching word audio for {len(corpus['lemmas'])} lemmas → {out}\n")
    for lemma in corpus["lemmas"]:
        latin = lemma["latin"]
        candidates: list[tuple[str, int, int]] = []
        if latin in AUDIO_VERSE_OVERRIDE:
            s, a, f = AUDIO_VERSE_OVERRIDE[latin]
            candidates.append((f, s, a))
        candidates += [(sf["text_ar"], v["surah"], v["ayah"])
                       for sf in lemma["surface_forms"] for v in sf["verses"]]

        dest = out / f"{latin}.mp3"
        done = ""
        for form_ar, surah, ayah in candidates:
            vd = verse(f"{surah}:{ayah}")
            if not vd:
                continue
            w = find_word(vd.get("words", []), normalize(form_ar))
            if not w:
                continue
            pos = w["position"]
            # Primary: corrected isolated WBW file.
            fn = wbw_file_number(vd["words"], pos)
            if fn is not None:
                url = f"{WBW_BASE}wbw/{surah:03d}_{ayah:03d}_{fn:03d}.mp3"
                try:
                    http_get(url, dest)
                    done = f"wbw _{fn:03d}"
                except Exception:  # noqa: BLE001 — CDN gap → fall back to segment
                    pass
            # Fallback: clip from full-ayah recitation.
            if not done and segment_clip(vd.get("audio") or {}, pos, dest):
                done = "segment-clip"
            if done:
                ok.append(latin)
                print(f"  ✓ {latin:8} {form_ar:12} {surah}:{ayah} word#{pos:<3} [{done}]")
                time.sleep(args.sleep)
                break
        if not done:
            missing.append(latin)
            print(f"  ✗ {latin:8} — no audio found")

    shutil.rmtree(cache, ignore_errors=True)
    print(f"\nDone: {len(ok)}/{len(corpus['lemmas'])}.")
    if missing:
        print("Missing:", ", ".join(missing))
        return 1
    print("\nNext: dart tool/build_audio_sprites.dart --input recordings/ --output assets/audio/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
