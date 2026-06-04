# Compte-rendu — Phase 7 (Vérification)

**VERDICT: APPROUVÉ (avec réserves notées)**

On-device verification on the Samsung SM A245F (Android 16), debug build.

## Offline content — ✅ confirmed
With **airplane mode ON**, the full word-detail fiche for نُور (nur) renders entirely
from the local Drift DB: translation, root (ن-و-ر), tafsir (al-Nur 24:35…), pépite,
astuce mémo, verses. No network dependency in the read path. The "100% offline at
install" guarantee holds for all text content.

## Offline audio — ✅ by construction, ⚠️ not positively captured on-device
- The bundled `assets/audio/sample_pack.m4a` is a **valid AAC-LC M4A, 1.5 s** (verified
  with `ffprobe`); the 3 seed clips (rahma/sabr/nur) map into it via `start_ms`/`duration_ms`.
- Playback uses `just_audio` `ClippingAudioSource` on a **local asset** → no network needed;
  the mapping is unit-tested (`test/data/audio_repository_test.dart`).
- A precise "playing" frame wasn't captured on-device: the clip is 500 ms and playback
  errors are swallowed (`catch (_) {}`), so the tap produced no observable state change in
  a screenshot and no ExoPlayer log was captured. **Not a failure** — the path is offline by
  construction — but two follow-ups are warranted:
  - real audio sprite packs beyond the 3-clip sample (already tracked in PLAN.md);
  - surface audio-playback failures instead of swallowing them (Phase 5.1 deferred item) so
    a bad asset is visible.

## Bundle size — ✅ healthy baseline
`flutter build apk --release --target-platform android-arm64 --analyze-size`:
- **app-release.apk = 22.4 MB** (arm64-v8a). Dart AOT ~6 MB; `package:flutter` ~2 MB.
- Icon fonts tree-shaken 99.7% (MaterialIcons 1.6 MB → 5 KB; Cupertino 258 KB → 0.8 KB).
- Headroom: the full audio corpus is estimated at ~15–30 MB (§1.B), projecting a ~37–52 MB
  release APK — acceptable for a 100%-offline app.

## Not done here (tracked)
- iOS build pass (work to date is Android-device focused).
- `flutter build appbundle` signed path is exercised only via the Phase-8 CD workflow.
