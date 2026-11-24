# SolidWorks-style sketch tools prototype

This branch adds the first native sketch-workflow milestone to Inkscape 1.5-dev:

- `L` — line, using the native Pen tool
- `C` — center-to-radius snapped circle
- `R` — corner rectangle
- `G` — center-origin rectangle
- `D` — non-document dimension overlay for a selected circle or single straight segment
- `A` — fillet every eligible corner of selected rectangles or straight-edged paths
- `Z` — chamfer every eligible corner of selected rectangles or straight-edged paths
- matching buttons at the start of the Commands Bar

Dimension overlays are canvas UI only: they do not add lines or text to the SVG. A selected circle
shows its diameter and a selected one-segment path shows its length. They are reference measurements,
not associative or driving CAD dimensions.

Fillet and chamfer directly rewrite the selected geometry in one undoable operation; they do not use
Live Path Effects. The current first pass uses an automatic corner size (up to 10 document units and
no more than 25% of either adjacent edge) and applies to all eligible corners. Interactive radius and
per-corner selection are future refinements.

Persistent horizontal, vertical, coincident, parallel, and equal relations still require a constraint
model and solver. Power trim is also a later milestone.

## Verified Windows build

The branch completed a full UCRT64/Ninja build and subsequent incremental builds linked successfully.
A staged copy is kept for disposable interactive testing.

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
