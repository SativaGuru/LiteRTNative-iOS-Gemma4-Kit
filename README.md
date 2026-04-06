# LiteRTNative iOS Gemma 4 Kit

Prebuilt iOS-native LiteRT-LM C API artifacts for integrating Gemma 4 in Swift projects **without rebuilding LiteRT-LM from source**.

## Included

- `lib/libc_engine.a`
- `lib/libruntime_core_engine_impl.a`
- `lib/liblitert_c_api.a`
- `lib/liblitert_runtime.a`
- `lib/libtensorflow-lite.a`
- `lib/libxnnpack-delegate.a`
- `include/engine.h`
- `include/litert_lm_logging.h`
- `docs/INTEGRATION.md`
- `docs/VERSION.txt`
- `docs/CHECKSUMS.txt`
- `docs/ABOUT.md`
- `docs/GITHUB_METADATA.md`

## Platform

- iOS (`iphoneos`)
- `arm64`
- Minimum iOS: `26.1`
- SDK: `26.4`

## Why this exists

As of this package build date, LiteRT-LM Swift language APIs are still marked **In Dev**, so this package provides the C API route for immediate Swift integration.

## License

This package redistributes third-party artifacts. See upstream licenses in LiteRT-LM and dependency repositories before release/use.
