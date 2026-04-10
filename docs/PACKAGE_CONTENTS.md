# Package Contents

## Public artifacts

- `artifacts/lib/libLiteRTNativeGemma4Kit.a`
- `artifacts/xcframework/LiteRTNativeGemma4Kit.xcframework`

## Intentional duplicate headers

The public header set exists in both:

- `include/`
- `artifacts/xcframework/.../Headers/`

This is intentional. The first copy is for compiling `src/LiteRTNativeGemma4.mm` in downstream apps. The second copy is embedded by xcframework packaging.

## Public headers

- `include/LiteRTNativeGemma4/LiteRTNativeGemma4.h`
- `include/litert_lm/engine.h`
- `include/litert_lm/litert_lm_logging.h`
- `include/module.modulemap`

## Source wrapper

- `src/LiteRTNativeGemma4.mm`

## Docs

- `README.md`
- `docs/PREREQUISITES.md`
- `docs/XCODE_SETUP.md`
- `docs/BUILD_SETTINGS_REFERENCE.md`
- `docs/INTEGRATION.md`
- `docs/MEDIAPIPE_TO_LITERTLM_MIGRATION.md`
- `docs/TROUBLESHOOTING.md`
- `docs/BUILD_PROVENANCE.md`
- `docs/PATCH_NOTES.md`
- `docs/PACKAGE_CONTENTS.md`
- `docs/VERIFY.md`

## Notices

- `licenses/THIRD_PARTY_NOTICES.md`
- copied upstream license texts in `licenses/`
