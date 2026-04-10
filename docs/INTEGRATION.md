# Integration Guide

## Supported packaging mode

This package is curated for:

- Xcode iOS app targets
- `iphoneos`
- `arm64`
- minimum iOS `26.1`
- real iOS devices, not simulator

## Recommended integration

1. Add `artifacts/xcframework/LiteRTNativeGemma4Kit.xcframework` to your app target.
2. Add `src/LiteRTNativeGemma4.mm` to your app target.
3. Add the package `include/` directory to `HEADER_SEARCH_PATHS`.
4. If you use Swift, expose `LiteRTNativeGemma4/LiteRTNativeGemma4.h` from your bridging header.
5. Add `-ObjC` only if your project already requires it for unrelated reasons. This package does not require it by default.
6. Link the following Apple system dependencies because the packaged closure references them:

```text
AVFAudio.framework
AudioToolbox.framework
Metal.framework
libz.tbd
```

7. Apply the app-side build settings in `BUILD_SETTINGS_REFERENCE.md`.

## Header Search Paths

Add:

```text
$(PROJECT_DIR)/path/to/LiteRTNative_iOS_Gemma4_PublicKit/include
```

## Wrapper usage from Swift

```swift
import Foundation

final class DemoRunner {
    func run(modelPath: String) throws -> String {
        var createError: NSError?
        guard let engine = LiteRTNativeGemma4Engine(
            modelPath: modelPath,
            backend: .cpu,
            error: &createError
        ) else {
            throw createError ?? NSError(domain: "Demo", code: 1)
        }

        var warmupError: NSError?
        guard engine.warmUp(&warmupError) else {
            throw warmupError ?? NSError(domain: "Demo", code: 2)
        }

        var generationError: NSError?
        guard let text = engine.generateTextFromPrompt("Say hello from LiteRT-LM.", error: &generationError) else {
            throw generationError ?? NSError(domain: "Demo", code: 3)
        }

        return text
    }
}
```

## Wrapper usage from Objective-C

```objective-c
#import <LiteRTNativeGemma4/LiteRTNativeGemma4.h>

NSError *error = nil;
LiteRTNativeGemma4Engine *engine =
    [[LiteRTNativeGemma4Engine alloc] initWithModelPath:modelPath
                                                backend:LiteRTNativeGemma4BackendCPU
                                                  error:&error];
if (engine == nil) {
    NSLog(@"Create failed: %@", error);
    return;
}

NSString *text = [engine generateTextFromPrompt:@"Say hello from LiteRT-LM."
                                          error:&error];
NSLog(@"%@", text ?: error);
```

## Model requirements

- Pass a file path to a valid `.litertlm` model bundle.
- Use a Gemma 4 `.litertlm` bundle, not a `.task` bundle.
- Do not pass raw model bytes.
- Keep the model file accessible on-device for memory mapping.

## Device requirement

- Test and run on a physical iOS device.
- This package is not a simulator integration package.

## Notes

- The included wrapper is intentionally minimal.
- The wrapper uses the public LiteRT-LM C API only.
- If you want direct control of conversations, sessions, or benchmark APIs, you can also include `litert_lm/engine.h` directly.
- If a downstream build strips static registration objects too aggressively, add a force-load rule for `libLiteRTNativeGemma4Kit.a`.
