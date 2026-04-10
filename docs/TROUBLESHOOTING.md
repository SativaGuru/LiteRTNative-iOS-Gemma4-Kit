# Troubleshooting

## Build fails with missing LiteRT-LM or runtime symbols

Cause:

- downstream app linked an incomplete archive set
- downstream app did not use the packaged monolithic library

Fix:

- use `LiteRTNativeGemma4Kit.xcframework` or `libLiteRTNativeGemma4Kit.a`
- do not substitute a reduced archive subset

## Build fails with Apple audio or Metal symbols

Cause:

- missing required Apple system frameworks

Fix:

- link `AVFAudio.framework`
- link `AudioToolbox.framework`
- link `Metal.framework`
- link `libz.tbd`

## Engine creation fails immediately

Check:

- model path is not empty
- model path points to a real file
- model is a `.litertlm` bundle, not a `.task` bundle

## Runtime fails around logits or metadata

Check:

- the bundle metadata includes a correct output logits mapping
- the model bundle was converted correctly for LiteRT-LM

## Runtime crashes or is terminated on device

Check:

- model size and quantization
- context length and cache growth
- real device memory pressure

## Swift cannot see the wrapper

Check:

- bridging header exists
- bridging header imports `LiteRTNativeGemma4/LiteRTNativeGemma4.h`
- `HEADER_SEARCH_PATHS` includes the package `include/` directory

