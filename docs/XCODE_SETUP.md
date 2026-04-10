# Xcode Setup

Read `PREREQUISITES.md` first. This package requires:

- a valid Gemma 4 `.litertlm` model bundle
- a real iOS device
- correct app-side build settings

## Recommended setup

1. Drag `artifacts/xcframework/LiteRTNativeGemma4Kit.xcframework` into your Xcode project.
2. Add it to your app target under Frameworks, Libraries, and Embedded Content.
3. Add `src/LiteRTNativeGemma4.mm` to your app target.
4. Add this header search path:

```text
$(PROJECT_DIR)/path/to/LiteRTNative_iOS_Gemma4_PublicKit/include
```

5. Link these Apple dependencies:

```text
AVFAudio.framework
AudioToolbox.framework
Metal.framework
libz.tbd
```

6. If you use Swift, create a bridging header and import:

```objective-c
#import "LiteRTNativeGemma4/LiteRTNativeGemma4.h"
```

7. Set the bridging header build setting to the actual file you created. See `BUILD_SETTINGS_REFERENCE.md`.

## Do not do these things

- Do not link only a few top-level LiteRT-LM archives and assume the rest are optional.
- Do not pass model bytes through Swift or Objective-C if you can pass a file path.
- Do not use a MediaPipe `.task` bundle with this package.
- Do not mix this integration path with MediaPipe LLM runtime wiring for the same migrated model path.
- Do not add separate TensorFlowLiteSwift or TensorFlowLiteObjC packaging for the same LiteRT-LM integration path unless you know exactly why you need both layers.
- Do not expect simulator support from this package. It is iOS device only.

## If your build strips static registration objects

If your toolchain aggressively strips archive members and inference creation fails very early, add a force-load rule for `libLiteRTNativeGemma4Kit.a`.
