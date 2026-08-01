param(
  [Parameter(Mandatory = $true)]
  [string]$ProjectName,

  [Parameter(Mandatory = $true)]
  [string]$ProjectRoot,

  [string]$PackRoot = 'F:\正式项目与模块化内容\项目资料包'
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectName)) { throw '项目名称不能为空。' }
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) { throw '项目根目录不能为空。' }
if ([string]::IsNullOrWhiteSpace($PackRoot)) { throw '资料包根目录不能为空。' }
if ($PackRoot.StartsWith('C:', [System.StringComparison]::OrdinalIgnoreCase)) {
  throw '项目资料包不得创建在 C 盘。'
}

$resolvedProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
if (-not (Test-Path -LiteralPath $resolvedProjectRoot -PathType Container)) {
  throw "项目根目录不存在：$ProjectRoot"
}

$projectId = ($ProjectName -replace '[\\/:*?"<>| ]', '-').Trim('-')
if ([string]::IsNullOrWhiteSpace($projectId)) {
  throw '项目名称不能生成有效资料包标识。'
}

$packPath = Join-Path $PackRoot $projectId
if (Test-Path -LiteralPath $packPath) {
  throw "资料包已存在，拒绝覆盖：$packPath"
}

$gitHead = $null
$gitState = 'not-a-git-repository'
if (Test-Path -LiteralPath (Join-Path $resolvedProjectRoot '.git')) {
  $candidateHead = (& git -C $resolvedProjectRoot rev-parse HEAD 2>$null).Trim()
  if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($candidateHead)) {
    $gitHead = $candidateHead
    $gitState = 'recorded'
  } else {
    $gitState = 'git-head-unavailable'
  }
}

New-Item -ItemType Directory -Path $packPath -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $packPath 'changes') -Force | Out-Null

$now = [DateTimeOffset]::Now.ToString('o')
$manifest = [ordered]@{
  schemaVersion = 1
  project = [ordered]@{
    name = $ProjectName
    id = $projectId
    root = $resolvedProjectRoot
    initializedAt = $now
  }
  sources = @(
    [ordered]@{
      id = 'project-root'
      kind = 'project-root'
      location = $resolvedProjectRoot
      owner = 'technical'
      required = $true
      recordedGitHead = $gitHead
      gitState = $gitState
      lastVerifiedAt = $now
    }
  )
  sections = [ordered]@{
    humanResources = [ordered]@{ owner = 'hr'; lastUpdatedAt = $null; lastThreadId = $null; receiptStatus = 'not-yet-received'; status = 'not-yet-received' }
    requirementsAudit = [ordered]@{ owner = 'requirements-audit'; lastUpdatedAt = $null; lastThreadId = $null; receiptStatus = 'not-yet-received'; status = 'not-yet-received' }
    development = [ordered]@{ owner = 'development'; lastUpdatedAt = $null; lastThreadId = $null; receiptStatus = 'not-yet-received'; status = 'not-yet-received' }
  }
  aiStudy = [ordered]@{
    sources = @()
    ragStatus = 'unknown'
    lastCheckedAt = $null
  }
  sync = [ordered]@{
    status = 'initialization-pending'
    staleItems = @()
    openConflicts = @()
  }
}

$manifestPath = Join-Path $packPath 'manifest.json'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($manifestPath, ($manifest | ConvertTo-Json -Depth 8), $utf8NoBom)

[pscustomobject]@{
  success = $true
  packPath = $packPath
  manifestPath = $manifestPath
  projectRoot = $resolvedProjectRoot
  recordedGitHead = $gitHead
  nextAction = '由三线程分别登记已读资料、项目事实与首条资料变更单。'
}
