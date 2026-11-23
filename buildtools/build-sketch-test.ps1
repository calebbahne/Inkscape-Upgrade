$ErrorActionPreference = 'Stop'

$source = Split-Path -Parent $PSScriptRoot
$workspace = Split-Path -Parent $source
$bash = 'C:\msys64\usr\bin\bash.exe'
$runtimeBin = 'C:\msys64\ucrt64\bin'
$stageBin = Join-Path $workspace 'inkscape-test-install\bin'

if (-not (Test-Path -LiteralPath $bash -PathType Leaf)) {
    throw 'MSYS2 was not found at C:\msys64. Install the official Inkscape UCRT64 build dependencies first.'
}

$env:MSYSTEM = 'UCRT64'
$env:CHERE_INVOKING = '1'

Push-Location $source
try {
    & $bash -lc 'cmake -S . -B ../inkscape-build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=../inkscape-test-install -DWITH_INTERNAL_2GEOM=ON'
    if ($LASTEXITCODE -ne 0) { throw "CMake configuration failed with exit code $LASTEXITCODE." }
    & $bash -lc 'cmake --build ../inkscape-build --parallel'
    if ($LASTEXITCODE -ne 0) { throw "Compilation failed with exit code $LASTEXITCODE." }
    & $bash -lc 'cmake --install ../inkscape-build'
    if ($LASTEXITCODE -ne 0) { throw "Staging failed with exit code $LASTEXITCODE." }
}
finally {
    Pop-Location
}

Copy-Item -LiteralPath @(
    (Join-Path $runtimeBin 'libz-1.dll'),
    (Join-Path $runtimeBin 'libcrypto-4-x64.dll'),
    (Join-Path $runtimeBin 'libssl-4-x64.dll')
) -Destination $stageBin -Force

Write-Host "Isolated test build staged at $stageBin"
