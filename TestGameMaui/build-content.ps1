<# 
Builds MonoGame content for multiple platforms using MGCB.
- Uses relative paths.
- Works whether you have the mgcb **global tool** or only the NuGet’d mgcb.dll.
- Builds Windows, Android, iOS, and MacCatalyst (MacCatalyst reuses iOS content).
USAGE:
  pwsh ./tools/build-content.ps1
OPTIONS:
  -ContentDir <path>   Relative path to the folder that holds Content.mgcb (default: .\TestGameMaui\TestGameMaui\Content)
  -Targets <list>      Any of: Windows, DesktopGL, Android, iOS, MacCatalyst (default: Windows,Android,iOS,MacCatalyst)
  -Clean               Deletes bin/ and obj/ under Content before building
  -Quiet               Suppress /verbose
#>

[CmdletBinding()]
param(
  [string]$ContentDir = ".\TestGameMaui\Content",
  [ValidateSet('Windows','DesktopGL','Android','iOS','MacCatalyst')]
  [string[]]$Targets = @('Windows','Android','iOS','MacCatalyst'),
  [switch]$Clean,
  [switch]$Quiet
)

$ErrorActionPreference = "Stop"

function Resolve-Mgcb {
  $tool = Get-Command mgcb -ErrorAction SilentlyContinue
  if ($tool) {
    return @{ Exec = $tool.Source; PrefixArgs = @(); Describe = "mgcb (global tool)" }
  }

  $dll = Get-ChildItem -Path "$HOME/.nuget/packages/monogame.content.builder.task" -Recurse `
         -Filter "mgcb.dll" -ErrorAction SilentlyContinue |
         Where-Object { $_.FullName -match "tools[\\/ ]net8\.0[\\/ ]any[\\/ ]mgcb\.dll$" } |
         Sort-Object FullName -Descending |
         Select-Object -First 1

  if (-not $dll) {
    throw "MGCB not found. Install with: dotnet tool install --global dotnet-mgcb"
  }
  return @{ Exec = "dotnet"; PrefixArgs = @("exec", $dll.FullName); Describe = "mgcb.dll from NuGet ($($dll.VersionInfo.FileName))" }
}

$mgcb = Resolve-Mgcb
Write-Host "Using $($mgcb.Describe)"

$ContentDir = Resolve-Path $ContentDir
$ContentFile = Join-Path $ContentDir "Content.mgcb"
if (-not (Test-Path $ContentFile)) {
  throw "Could not find Content.mgcb at: $ContentFile"
}

# Map “what you want to build” -> MGCB’s platform value
$platforms = @(
  @{ Label='Windows';      Mgcb='Windows'     },
  @{ Label='DesktopGL';    Mgcb='DesktopGL'   },
  @{ Label='Android';      Mgcb='Android'     },
  @{ Label='iOS';          Mgcb='iOS'         },
  @{ Label='MacCatalyst';  Mgcb='iOS'         } # MacCatalyst reuses iOS content
) | Where-Object { $Targets -contains $_.Label }

foreach ($p in $platforms) {
  $outDir = Join-Path $ContentDir ("bin/{0}/Content" -f $p.Mgcb)
  $intDir = Join-Path $ContentDir ("obj/{0}/Content" -f $p.Mgcb)

  if ($Clean) { Remove-Item $outDir,$intDir -Recurse -Force -ErrorAction SilentlyContinue }
  New-Item $outDir -ItemType Directory -Force | Out-Null
  New-Item $intDir -ItemType Directory -Force | Out-Null

  $args = @()
  $args += $mgcb.PrefixArgs
  if (-not $Quiet) { $args += "/verbose" }
  $args += "/@:`"$ContentFile`""
  $args += "/platform:$($p.Mgcb)"
  $args += "/outputDir:`"$outDir`""
  $args += "/intermediateDir:`"$intDir`""
  $args += "/workingDir:`"$ContentDir`""

  Write-Host ""
  Write-Host "==> Building $($p.Label)  (MGCB platform: $($p.Mgcb))"
  Write-Host "    Output: $outDir"
  & $mgcb.Exec $args
  if ($LASTEXITCODE -ne 0) {
    throw "MGCB failed for $($p.Label) with exit code $LASTEXITCODE"
  }
}

Write-Host ""
Write-Host "All content built successfully."
Write-Host "Outputs under: $ContentDir\bin\{Windows|DesktopGL|Android|iOS}\Content"
