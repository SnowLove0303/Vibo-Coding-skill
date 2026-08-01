[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string]$ManifestPath,

  [switch]$FailOnStale
)

$ErrorActionPreference = 'Stop'
$resolvedManifest = (Resolve-Path -LiteralPath $ManifestPath).Path
$manifest = Get-Content -Raw -Encoding utf8 -LiteralPath $resolvedManifest | ConvertFrom-Json
$errors = [System.Collections.Generic.List[string]]::new()
$stale = [System.Collections.Generic.List[string]]::new()

if ($manifest.schemaVersion -ne 1) {
  $errors.Add('不支持的 manifest schemaVersion。')
}
if ([string]::IsNullOrWhiteSpace($manifest.project.root) -or -not (Test-Path -LiteralPath $manifest.project.root -PathType Container)) {
  $errors.Add('项目根目录不存在或未记录。')
}

foreach ($source in @($manifest.sources)) {
  if ([string]::IsNullOrWhiteSpace($source.location) -or -not (Test-Path -LiteralPath $source.location)) {
    $errors.Add("资料源不存在：$($source.id)")
    continue
  }
  if ($source.recordedGitHead) {
    $currentHead = (& git -C $source.location rev-parse HEAD 2>$null).Trim()
    if ($LASTEXITCODE -ne 0) {
      $stale.Add("无法读取 Git HEAD：$($source.id)")
    } elseif ($currentHead -ne $source.recordedGitHead) {
      $stale.Add("Git 基线已变化：$($source.id)")
    }
  }
}

$changesPath = Join-Path (Split-Path -Parent $resolvedManifest) 'changes'
if (-not (Test-Path -LiteralPath $changesPath -PathType Container)) {
  $errors.Add('缺少 changes 目录。')
}

$result = [pscustomobject]@{
  success = ($errors.Count -eq 0 -and (-not $FailOnStale -or $stale.Count -eq 0))
  manifestPath = $resolvedManifest
  project = $manifest.project.name
  errors = @($errors)
  staleItems = @($stale)
  nextAction = if ($errors.Count -gt 0) { '先修复资料包结构或路径。' } elseif ($stale.Count -gt 0) { '登记资料变更单并由对应线程复核受影响分区。' } else { '资料包结构与已记录基线一致；仍须按任务读取实时事实。' }
}

$result
if (-not $result.success) { exit 2 }

