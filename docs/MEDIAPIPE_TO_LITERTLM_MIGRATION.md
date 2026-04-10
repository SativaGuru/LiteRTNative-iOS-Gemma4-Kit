# MediaPipe to LiteRT-LM Migration

## What changes conceptually

MediaPipe LLM integration and LiteRT-LM are not just filename swaps.

You are changing:

- model bundle format
- runtime packaging
- engine/session/conversation lifecycle
- iOS integration shape

## Migration checklist

Before you start, make sure you have all three:

- a valid Gemma 4 `.litertlm` model bundle
- a real iOS device
- the app-side build settings from `BUILD_SETTINGS_REFERENCE.md`

### 1. Replace the model format

- Use a `.litertlm` Gemma 4 bundle.
- Do not use a MediaPipe `.task` bundle.
- Verify the model metadata includes an output logits mapping.

### 2. Replace the app integration boundary

- Remove MediaPipe-specific model/session wrappers for the migrated path.
- Create one long-lived LiteRT engine object instead of creating inference objects repeatedly.
- Create a conversation from the engine and send prompts through that conversation path.

### 3. Replace byte-loading with file-path loading

- Pass the model file path to the runtime.
- Prefer file-backed access so the runtime can memory-map the bundle.

### 4. Replace ad hoc native linkage

- Use the packaged xcframework and wrapper in this kit.
- Link the documented Apple frameworks and `libz`.
- Do not cherry-pick a handful of archives from an internal build and assume the closure is complete.

### 5. Re-test memory behavior on real hardware

- Large Gemma models can hit iOS memory limits quickly.
- Keep context lengths conservative during first integration.
- Test on physical devices, not only compile surface.

## Good first smoke test

1. Add the package.
2. Instantiate `LiteRTNativeGemma4Engine`.
3. Point it at a known-good `.litertlm` bundle.
4. Run on a real iOS device.
5. Send one short text prompt.
6. Confirm you receive non-empty text back.

## Common wrong assumptions

- “If `engine.h` compiles, the package is complete.”
- “A `.task` bundle is close enough.”
- “If I can load the model into memory myself, that is better.”
- “If six archives link, the rest of the dependency graph is optional.”
