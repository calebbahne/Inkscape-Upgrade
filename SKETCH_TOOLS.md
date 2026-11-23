# SolidWorks-style sketch tools prototype

This branch adds the first native sketch-workflow milestone to Inkscape 1.5-dev:

- `L` — line, using the native Pen tool
- `C` — center-to-radius snapped circle
- `R` — corner rectangle
- `G` — center-origin rectangle
- `D` — persistent reference dimension graphics
- matching buttons at the start of the Commands Bar

The dimensions are SVG annotations, not associative or driving CAD constraints. Persistent
horizontal, vertical, coincident, parallel, and equal relations require a constraint model and
solver and are a later milestone. Native non-LPE fillet/chamfer and power trim follow that work.

## Verified Windows build

The branch completed a full 1,280-step UCRT64/Ninja build and linked successfully. A staged copy
reported `Inkscape 1.5-dev (2818974, 2026-11-19, custom)` and exported the disposable SVG test to
PNG with exit code 0.

The machine's installed Inkscape was not modified. Build output, staged runtime, test profile, and
smoke-test output were kept in sibling folders outside this repository.

## Safe testing

After installing the official Inkscape MSYS2/UCRT64 dependencies and initializing submodules, run
`buildtools/build-sketch-test.ps1`. It builds and stages into sibling directories without writing
to `C:\Program Files\Inkscape`.

Run `buildtools/launch-sketch-test.ps1` to open the staged copy with a separate profile and the
disposable `testfiles/sketch-tools-test.svg` document. Do not use valuable originals during the
first interactive canvas pass.

The current upstream Windows install script omits three transitive runtime DLLs; the build helper
copies `libz-1.dll`, `libcrypto-4-x64.dll`, and `libssl-4-x64.dll` from UCRT64 into the isolated
stage.
