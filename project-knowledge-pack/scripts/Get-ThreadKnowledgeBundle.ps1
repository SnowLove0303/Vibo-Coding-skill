[CmdletBinding()]
param(
  [Parameter(Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string]$ManifestPath,

  [Parameter(Mandatory)]
  [ValidateSet('hr', 'requirements-audit', 'development')]
  [string]$Role
)

$ErrorActionPreference = 'Stop'
$resolvedManifest = (Resolve-Path -LiteralPath $ManifestPath).Path
$manifest = Get-Content -Raw -Encoding utf8 -LiteralPath $resolvedManifest | ConvertFrom-Json

$course = '49863edd-0522-4619-97b4-56695cd25ef9'
$map = 'mindmap_12be3b7f78da4a2f8cbf88227d747f22'
$refs = [ordered]@{
  total = "aistudy://node/49863edd/e7c762b2?map=$map"
  threadManagement = "aistudy://node/49863edd/545d1ccc?map=$map"
  memory = "aistudy://node/49863edd/ac05d072?map=$map"
  requirementsTasks = "aistudy://node/49863edd/e8c19add?map=$map"
  requirementHierarchy = "aistudy://node/49863edd/f42f2332?map=$map"
  execution = "aistudy://node/49863edd/b1914b92?map=$map"
  taskDispatch = "aistudy://node/49863edd/7316aa62?map=$map"
  auditTest = "aistudy://node/49863edd/99c4f32d?map=$map"
  level1 = "aistudy://node/49863edd/52bacf84?map=$map"
  level2 = "aistudy://node/49863edd/38d7c6fc?map=$map"
  level3 = "aistudy://node/49863edd/a61ad9cc?map=$map"
  level4 = "aistudy://node/49863edd/b5cdf8c8?map=$map"
  taskState = "aistudy://node/49863edd/2678b787?map=$map"
}

$common = @($refs.total, $refs.threadManagement, $refs.memory, $refs.taskState)
$roleRefs = switch ($Role) {
  'hr' { @($refs.requirementsTasks, $refs.taskDispatch, $refs.auditTest) }
  'requirements-audit' { @($refs.requirementsTasks, $refs.requirementHierarchy, $refs.execution, $refs.taskDispatch, $refs.auditTest, $refs.level1, $refs.level2, $refs.level3, $refs.level4) }
  'development' { @($refs.requirementsTasks, $refs.execution, $refs.taskDispatch, $refs.auditTest, $refs.level1, $refs.level2, $refs.level3, $refs.level4) }
}

[pscustomobject]@{
  project = $manifest.project.name
  role = $Role
  completionGate = '必须完成全部资料读取与项目深度遍历并提交接收报告，才可接正式任务。'
  globalMemory = 'C:\Users\52882\.codex\AGENTS.md'
  manifestPath = $resolvedManifest
  changeDirectory = Join-Path (Split-Path -Parent $resolvedManifest) 'changes'
  projectSources = @($manifest.sources | ForEach-Object { $_.location })
  aiStudy = [pscustomobject]@{
    courseId = $course
    mindMapId = $map
    commonRefs = $common
    roleRefs = $roleRefs
    requiredMethod = '先读取当前导图和节点上下文；需要时读取完整正文；记录 Ref、快照、正文与 RAG 状态。'
  }
  requiredTraversal = @(
    '使用 rg --files 或等效方式完整枚举所有项目资料源，并记录排除规则。',
    '读取适用 AGENTS.md、README、入口、核心模块、配置、数据存储、测试、Git 和当前运行入口。',
    '交叉核验资料、源码、Git、数据库和运行事实；标记冲突、过期与未验证项。'
  )
  receiptFields = @('已读资料 Ref/路径', '项目遍历范围', '核心模块/入口/数据/运行理解', 'Git/数据库/构建/回滚基线', '已完成/未完成/未验证能力', '冲突与阻断', '下一步')
} | ConvertTo-Json -Depth 8

