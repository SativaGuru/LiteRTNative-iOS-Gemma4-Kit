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

# Integration Guide (Swift / Xcode)

## 1) Add files

Add all `lib/*.a` and `include/*.h` to your project.

## 2) Header search paths

Add:

- `$(PROJECT_DIR)/path/to/LiteRTNative_iOS_Gemma4_Kit/include`

## 3) Library search paths

Add:

- `$(PROJECT_DIR)/path/to/LiteRTNative_iOS_Gemma4_Kit/lib`

## 4) Link static libraries

Link these exactly:

- `libc_engine.a`
- `libruntime_core_engine_impl.a`
- `liblitert_c_api.a`
- `liblitert_runtime.a`
- `libtensorflow-lite.a`
- `libxnnpack-delegate.a`

## 5) Swift bridge

Expose `engine.h` in Objective-C bridging header.

## 6) Minimal init path

Use C API entry points from `engine.h`, starting with:

- `litert_lm_engine_settings_create(...)`
- `litert_lm_engine_create(...)`
- `litert_lm_engine_delete(...)`
- `litert_lm_engine_settings_delete(...)`

## Notes

- This kit solves native engine linkage/runtime closure.
- Model packaging, tokenizer/config files, and app-level migration logic remain app-specific.


## License

This package redistributes third-party artifacts. See upstream licenses in LiteRT-LM and dependency repositories before release/use.


