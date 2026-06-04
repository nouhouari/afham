# CI / CD (Phase 8)

GitHub Actions + Fastlane, per the locked decisions in [`PLAN.md`](PLAN.md). Flutter is
pinned to **3.44.1**; pub + gradle are cached.

## Workflows

| File | Trigger | What it does |
|------|---------|--------------|
| `.github/workflows/ci.yml` | push/PR → `main` | `pub get` → `build_runner` → `flutter analyze` → format check (non-generated) → `flutter test --coverage` → debug-APK validation build. Coverage uploaded as an artifact. |
| `.github/workflows/release-android.yml` | tag `v*` | Build signed release **App Bundle** → `fastlane supply` to Play **Internal** (draft). Uploads the AAB as an artifact regardless. |
| `.github/workflows/release-ios.yml` | tag `v*` (macOS) | `fastlane match` → `gym` → `pilot` (TestFlight). |

Fastlane lanes: `android/fastlane/` (`internal`, `production`-disabled),
`ios/fastlane/` (`beta`, `release`-disabled). Build number = `github.run_number`.

## Status: deploy lanes are INACTIVE until credentials are provided

CI runs today (analyze/format/test/validation build). The **release** workflows build their
artifacts but **skip the store upload** until the secrets below exist — each prints a
`::notice::` explaining what's missing. Production / App Store `deliver` lanes are
intentionally disabled.

## Secrets to add (GitHub → Settings → Secrets → Actions)

**Android**
- `ANDROID_KEYSTORE_BASE64` — `base64 -i upload-keystore.jks`
- `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`
- `PLAY_SERVICE_ACCOUNT_JSON` — Google Play service-account JSON (raw)

**iOS**
- `APP_STORE_CONNECT_API_KEY_ID`, `APP_STORE_CONNECT_API_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY_P8`
- `MATCH_GIT_URL`, `MATCH_PASSWORD`, `MATCH_GIT_BASIC_AUTHORIZATION` (if the match repo is private)

Prerequisites you provide (the workflows wire them, they don't create them): Apple Developer
Program + App Store Connect API key (.p8/Key ID/Issuer ID), Google Play service account,
Android upload-keystore, and a `match` certificates repo.

> Note: Android `applicationId` and iOS bundle id are both `com.houari.bayan` (legacy "bayan"
> name). A rename to `afham` is a separate, deliberate decision (see PLAN.md) and would
> require re-provisioning signing — do it before the first store submission if at all.
