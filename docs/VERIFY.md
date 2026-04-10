# Verification Notes

This package should be re-verified after any update.

## Verification performed for this package

- Confirmed that a minimal top-level archive subset was incomplete for standalone reuse.
- Confirmed that the packaged closure requires a broader static-link dependency set.
- Confirmed that the public wrapper in this package uses the public LiteRT-LM C API only.
- Confirmed that the packaged monolithic binary can be built from the forwarded iOS deliverables.
- Confirmed that the wrapper source compiles against the curated public header surface for `iphoneos arm64`.
- Confirmed that a full linker pass succeeds when linking the package with the required Apple system frameworks and `libz`.

## Recommended verification for downstream users

1. Add the xcframework and wrapper to a clean iOS test app.
2. Build for `Any iOS Device (arm64)`.
3. Instantiate `LiteRTNativeGemma4Engine`.
4. Load a known-good `.litertlm` Gemma 4 model bundle.
5. Run a one-prompt generation test on device.
