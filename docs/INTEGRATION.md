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
