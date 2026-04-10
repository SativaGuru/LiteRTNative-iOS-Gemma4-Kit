# LiteRTNative iOS Gemma 4 Public Kit

Prebuilt iOS device packaging for running Gemma 4 with LiteRT-LM in Xcode projects.

This repo exists to save other iOS developers from rebuilding the full LiteRT-LM dependency closure by hand just to get Gemma 4 running on-device.

## Who this is for

- iOS developers migrating Gemma 4 from MediaPipe LLM inference paths to LiteRT-LM
- teams that need a working native iOS packaging baseline for LiteRT-LM
- developers who want a generic Objective-C++ wrapper instead of wiring LiteRT-LM C APIs from scratch

## What this repo includes

- a packaged iOS `arm64` static library
- a packaged iOS `arm64` `.xcframework`
- a generic Objective-C++ wrapper source/header
- the public LiteRT-LM C API headers needed by the wrapper
- Swift and Objective-C integration examples
- setup, migration, troubleshooting, and build-settings documentation

## What this repo does not include

- Gemma model files
- simulator support
- a full source checkout of LiteRT or LiteRT-LM
- app-specific project wiring

## Requirements

You need all three:

1. A valid Gemma 4 `.litertlm` model bundle
2. A real iOS device
3. Correct app-side Xcode build settings

Start here:

- [Prerequisites](./docs/PREREQUISITES.md)
- [Xcode Setup](./docs/XCODE_SETUP.md)
- [Build Settings Reference](./docs/BUILD_SETTINGS_REFERENCE.md)

## Quick start

1. Add [`artifacts/xcframework/LiteRTNativeGemma4Kit.xcframework`](./artifacts/xcframework/LiteRTNativeGemma4Kit.xcframework) to your app target.
2. Add [`src/LiteRTNativeGemma4.mm`](./src/LiteRTNativeGemma4.mm) to your app target.
3. Add the package `include/` directory to `HEADER_SEARCH_PATHS`.
4. If you use Swift, import [`LiteRTNativeGemma4.h`](./include/LiteRTNativeGemma4/LiteRTNativeGemma4.h) through your bridging header.
5. Link:
   - `AVFAudio.framework`
   - `AudioToolbox.framework`
   - `Metal.framework`
   - `libz.tbd`
6. Run on `Any iOS Device (arm64)`.

## Docs map

- [Prerequisites](./docs/PREREQUISITES.md)
- [Xcode Setup](./docs/XCODE_SETUP.md)
- [Build Settings Reference](./docs/BUILD_SETTINGS_REFERENCE.md)
- [Integration Guide](./docs/INTEGRATION.md)
- [MediaPipe to LiteRT-LM Migration](./docs/MEDIAPIPE_TO_LITERTLM_MIGRATION.md)
- [Troubleshooting](./docs/TROUBLESHOOTING.md)
- [Package Contents](./docs/PACKAGE_CONTENTS.md)
- [Verification Notes](./docs/VERIFY.md)
- [Patch Notes](./docs/PATCH_NOTES.md)
- [Build Provenance](./docs/BUILD_PROVENANCE.md)

## Included examples

- Swift example service: [`LiteRTNativeGemma4Service.swift`](./samples/SwiftSample/LiteRTNativeGemma4Service.swift)
- Swift example usage: [`LiteRTNativeGemma4Example.swift`](./samples/SwiftSample/LiteRTNativeGemma4Example.swift)
- bridging header example: [`Example-Bridging-Header.h`](./samples/SwiftSample/Example-Bridging-Header.h)
- Objective-C example: [`LiteRTNativeGemma4Example.m`](./samples/ObjCSample/LiteRTNativeGemma4Example.m)

## Important notes

- This package is built for `iphoneos arm64`.
- This package is not for iOS Simulator.
- This package expects a real `.litertlm` Gemma 4 bundle, not a MediaPipe `.task` file.
- The repeated headers in `include/` and inside the `.xcframework` are intentional. The top-level copies are for compiling the wrapper source; the `.xcframework` copies are embedded by Apple packaging.

## License and notices

See:

- [Third Party Notices](./licenses/THIRD_PARTY_NOTICES.md)
- [LiteRT-LM License](./licenses/LICENSE-LiteRT-LM.txt)
- [LiteRT License](./licenses/LICENSE-LiteRT.txt)
