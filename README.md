# LiteRTNative-iOS-Gemma4-Kit
Prebuilt iOS arm64 LiteRT-LM C API libraries + headers for Gemma 4 integration in Swift apps (no source build required).

LiteRTNative iOS Gemma 4 Kit is a prebuilt native artifact bundle intended to accelerate Swift adoption of LiteRT-LM while Swift-native APIs are still in development.

It provides a validated iOS-native static-link closure for LiteRT-LM engine initialization, so teams can focus on product integration and Gemma migration work instead of toolchain-heavy source builds.

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

- ## Platform

- iOS (`iphoneos`)
- `arm64`
- Minimum iOS: `26.1`
- SDK: `26.4`

## Why this exists

As of this package build date, LiteRT-LM Swift language APIs are still marked **In Dev**, so this package provides the C API route for immediate Swift integration.

## License

This package redistributes third-party artifacts. See upstream licenses in LiteRT-LM and dependency repositories before release/use.
