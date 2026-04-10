# Prerequisites

Do not start integration until all three are true.

## 1. Valid model bundle

You need:

- a valid Gemma 4 `.litertlm` model bundle

You do not need:

- a MediaPipe `.task` bundle

Recommended checks:

- the model opens as a real file on disk
- the model is intended for LiteRT-LM
- the bundle metadata includes an output logits mapping

## 2. Real iOS device

You need:

- a physical iPhone or iPad that can run your app target

This package is not for:

- iOS Simulator
- macOS
- Catalyst

Reason:

- the packaged artifact is `iphoneos arm64`
- final inference validation should happen on-device

## 3. Correct app-side build settings

You need to apply:

- header search paths
- Swift bridging header path if using Swift
- Apple framework links
- `libz.tbd`
- force-load linker rule only if your project strips static registration too aggressively

Use `BUILD_SETTINGS_REFERENCE.md` for the exact keys and example values.

