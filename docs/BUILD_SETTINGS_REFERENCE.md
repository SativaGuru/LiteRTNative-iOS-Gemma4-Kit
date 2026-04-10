# Build Settings Reference

This is the exact Xcode-facing checklist for downstream app integration.

## Required target settings

### `HEADER_SEARCH_PATHS`

Add:

```text
$(inherited)
$(PROJECT_DIR)/path/to/LiteRTNative_iOS_Gemma4_PublicKit/include
```

### `SWIFT_OBJC_BRIDGING_HEADER`

Only if you use Swift.

Set it to your app bridging header path, for example:

```text
$(PROJECT_DIR)/YourApp/YourApp-Bridging-Header.h
```

That bridging header should contain:

```objective-c
#import "LiteRTNativeGemma4/LiteRTNativeGemma4.h"
```

### Frameworks and libraries to link

Link these:

```text
AVFAudio.framework
AudioToolbox.framework
Metal.framework
libz.tbd
```

If you use the xcframework route, also add:

```text
LiteRTNativeGemma4Kit.xcframework
```

## Optional linker settings

### `OTHER_LDFLAGS`

Usually no extra flags are required beyond normal Xcode linking.

If your project aggressively strips static registration objects and engine creation fails very early, add:

```text
$(inherited)
-Wl,-force_load,$(PROJECT_DIR)/path/to/LiteRTNative_iOS_Gemma4_PublicKit/artifacts/lib/libLiteRTNativeGemma4Kit.a
```

Only use this when needed.

### `-ObjC`

This package does not require `-ObjC` by default.

Do not add it only because this package exists. Keep it only if your app already needs it for unrelated Objective-C category loading behavior.

## Build destination

Use:

```text
Any iOS Device (arm64)
```

Do not use:

```text
iOS Simulator
```

## App-side integration files

Add these to your app target:

- `artifacts/xcframework/LiteRTNativeGemma4Kit.xcframework`
- `src/LiteRTNativeGemma4.mm`

Use these from the package as references or imports:

- `include/LiteRTNativeGemma4/LiteRTNativeGemma4.h`
- `samples/SwiftSample/Example-Bridging-Header.h`
- `samples/SwiftSample/LiteRTNativeGemma4Service.swift`

## Common mistakes

- forgetting `HEADER_SEARCH_PATHS`
- forgetting to set `SWIFT_OBJC_BRIDGING_HEADER`
- trying to run on Simulator
- pointing the wrapper at a `.task` file instead of a `.litertlm` file
- forgetting Apple frameworks or `libz.tbd`
