$ErrorActionPreference = 'Stop'

$source = Split-Path -Parent $PSScriptRoot
$workspace = Split-Path -Parent $source
$inkscape = Join-Path $workspace 'inkscape-test-install\bin\inkscape.exe'
$profile = Join-Path $workspace 'inkscape-test-profile'
$testDocument = Join-Path $source 'testfiles\sketch-tools-test.svg'

if (-not (Test-Path -LiteralPath $inkscape -PathType Leaf)) {
    throw "The isolated test build has not been staged yet: $inkscape"
}

New-Item -ItemType Directory -Path $profile -Force | Out-Null
$env:INKSCAPE_PROFILE_DIR = $profile
$quotedTestDocument = '"' + $testDocument + '"'
Start-Process -FilePath $inkscape -ArgumentList @($quotedTestDocument)
