# Third-Party Notices

This package redistributes build output derived from upstream projects and their dependency graph. Review the original upstream repositories before release in production.

## Primary upstreams

- LiteRT-LM
  - Source family: Google ODML / LiteRT-LM
  - License: Apache-2.0
- LiteRT
  - Source family: Google LiteRT
  - License: Apache-2.0

## Dependency families present in the packaged static-link closure

- Abseil
  - License family: Apache-2.0
- Protocol Buffers
  - License family: BSD-3-Clause
- SentencePiece
  - License family: Apache-2.0
- XNNPACK
  - License family: BSD-3-Clause
- cpuinfo
  - License family: BSD-2-Clause
- pthreadpool
  - License family: BSD-2-Clause
- farmhash
  - License family: MIT
- re2
  - License family: BSD-3-Clause
- upb
  - License family: BSD-3-Clause
- utf8_range
  - License family: Apache-2.0
- minizip
  - License family: zlib
- kissfft
  - License family: BSD-style

## System link expectations

- `AVFAudio.framework`
- `AudioToolbox.framework`
- `Metal.framework`
- zlib via `libz.tbd`

## Distribution note

This public package is intentionally curated and does not include raw vendor source trees. If you need complete per-dependency license texts beyond the copied upstream files in this folder, fetch them from the original upstream repositories and pin them to the exact revisions you rebuild from.
