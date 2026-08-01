[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string]$ManifestPath,

  [Parameter(Mandatory)]
  [ValidateSet('hr', 'requirements-audit', 'development')]
  [string]$Role,

  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string]$ThreadId
)

$ErrorActionPreference = 'Stop'
$resolvedManifest = (Resolve-Path -LiteralPath $ManifestPath).Path
$manifest = Get-Content -Raw -Encoding utf8 -LiteralPath $resolvedManifest | ConvertFrom-Json
$sectionName = switch ($Role) {
  'hr' { 'humanResources' }
  'requirements-audit' { 'requirementsAudit' }
  'development' { 'development' }
}
$now = [DateTimeOffset]::Now.ToString('o')
$section = $manifest.sections.$sectionName
$section.lastUpdatedAt = $now
$section.lastThreadId = $ThreadId
$section.receiptStatus = 'awaiting-deep-intake'
$section.status = 'materials-dispatched'

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($resolvedManifest, ($manifest | ConvertTo-Json -Depth 10), $utf8NoBom)

$changesPath = Join-Path (Split-Path -Parent $resolvedManifest) 'changes'
if (-not (Test-Path -LiteralPath $changesPath -PathType Container)) {
  throw '缺少 changes 目录，拒绝登记派发。'
}
$recordPath = Join-Path $changesPath (('dispatch-{0}-{1}.md' -f $Role, ([DateTimeOffset]::Now.ToString('yyyyMMdd-HHmmss'))))
$record = @(
  '# 资料变更单'
  ''
  "变更编号：资料派发-$Role-$([DateTimeOffset]::Now.ToString('yyyyMMdd-HHmmss'))"
  ''
  "项目与模块：$($manifest.project.name)"
  ''
  "责任线程与日期：人事部 / $now"
  ''
  "事实变化：已向 $Role 线程派发资料包，ThreadId 为 $ThreadId；等待完整遍历接收报告。"
  ''
  "证据位置：$resolvedManifest"
  ''
  '影响分区：协作与资料索引'
  ''
  '当前核验状态：未验证'
  ''
  '下一线程启动时必须读取：manifest、changes、职责资料清单与完整项目资料源。'
) -join [Environment]::NewLine
[System.IO.File]::WriteAllText($recordPath, $record, $utf8NoBom)

[pscustomobject]@{
  success = $true
  manifestPath = $resolvedManifest
  role = $Role
  threadId = $ThreadId
  receiptStatus = 'awaiting-deep-intake'
  changeRecord = $recordPath
}

