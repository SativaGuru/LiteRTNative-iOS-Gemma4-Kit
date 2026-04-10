# Build Provenance

## Package intent

This package is a curated redistribution of an iOS device build closure produced from upstream LiteRT-LM and LiteRT source snapshots.

## Target

- Platform: `iphoneos`
- Architecture: `arm64`
- Minimum iOS: `26.1`
- SDK used during build: `26.4`
- Xcode used during build: `26.4 (17E192)`

## Upstream source snapshots

- LiteRT-LM declared version: `0.10.0`
- LiteRT-LM source snapshot SHA-256: `e665b446950958b84c5b18a77f60f2d44de7f3f904a6da77b5c1164d509e5274`

## Build style

- Built externally, not from an app target
- iOS-only archive production
- Forwarded static-link closure curated from the external deliverables
- Public package intentionally excludes raw build directories and raw source trees

## Public package derivation

The packaged binary content in this folder was repackaged into:

- one monolithic static library
- one one-slice `.xcframework`
- a generic Objective-C++ wrapper source file
- a reduced public header surface

## Packaging policy

The package intentionally contains only the public deliverable surface:

- packaged binary artifacts
- public headers
- generic wrapper source
- migration and setup documentation
- high-level provenance
