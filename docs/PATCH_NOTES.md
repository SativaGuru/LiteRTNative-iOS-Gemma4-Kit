# Patch Notes

## Why this matters

This package is not presented as a pure untouched upstream snapshot. The working iOS closure used here included local build-time fixes and debug instrumentation during migration. Consumers should understand that this package reflects a validated packaging result, not a claim that vanilla upstream source alone is enough to reproduce the same outcome in Xcode.

## Known local deltas reflected in the validated build flow

- Added temporary trace logging markers during bring-up and crash-boundary tracing.
- Included a custom archive `liblitertlm_gemma4_fix.a`.
- That custom archive contains at least:
  - `channel_util.o`
  - `gemma4_data_processor.o`
- The working app link also relied on a curated static-link closure that included generated protobuf, sentencepiece, absl provider archives, and many `runtime_*` archives beyond a minimal top-level archive subset.

## What this public package does with those deltas

- Keeps the validated binary closure
- Documents that the package is not a raw upstream drop
- Does not ship the original build workspace
- Does not ship project-specific bridge code

## Rebuild expectation

If another team wants to rebuild this package from source, they should expect to reproduce:

- the same iOS archive closure
- the same dependency family alignment
- any Gemma 4 specific fixes that landed in the validated build

They should not assume that only the public `engine.h` plus a few top-level archives is enough.
