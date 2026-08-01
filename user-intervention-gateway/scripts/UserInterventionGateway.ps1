param(
    [ValidateSet('Authorize', 'Input')]
    [string]$Mode = 'Authorize',

    [string]$Title = 'User intervention required',
    [string]$Message = '',
    [string]$Prompt = '',
    [string]$DefaultValue = '',
    [string]$OutputPath = '',

    [ValidateSet('Generic', 'ResourceIsolationAuthorization', 'FormalLoginInput', 'BusinessInput', 'FileOrPathSelection')]
    [string]$Scenario = 'Generic',

    [ValidateSet('Allow', 'Deny', 'Cancel')]
    [string]$DefaultDecision = 'Allow',

    [switch]$Sensitive,
    [switch]$NonInteractive
)

$ErrorActionPreference = 'Stop'

if ($Scenario -eq 'ResourceIsolationAuthorization') {
    $Mode = 'Authorize'
    if (-not $Title -or $Title -eq 'User intervention required') {
        $Title = '授权隔离资源'
    }
    if (-not $Message) {
        $Message = '允许本次流程使用隔离数据库或隔离 Profile 继续执行。'
    }
}
if ($Scenario -eq 'FormalLoginInput') {
    $Mode = 'Input'
    $Sensitive = $true
    if (-not $Title -or $Title -eq 'User intervention required') {
        $Title = '正式登录输入'
    }
    if (-not $Prompt -and -not $Message) {
        $Prompt = '请在正式登录流程中输入账号、密码、验证码或完成外部风控后确认。'
    }
}
if ($Scenario -eq 'BusinessInput') {
    $Mode = 'Input'
    if (-not $Title -or $Title -eq 'User intervention required') {
        $Title = '业务信息输入'
    }
    if (-not $Prompt -and -not $Message) {
        $Prompt = '请输入本次流程需要的真实业务信息。'
    }
}
if ($Scenario -eq 'FileOrPathSelection') {
    $Mode = 'Input'
    if (-not $Title -or $Title -eq 'User intervention required') {
        $Title = '路径或文件选择'
    }
    if (-not $Prompt -and -not $Message) {
        $Prompt = '请输入或粘贴本次流程需要使用的文件或路径。'
    }
}

function Write-Result {
    param([hashtable]$Result)

    $json = $Result | ConvertTo-Json -Compress
    if ($OutputPath) {
        $dir = Split-Path -Parent $OutputPath
        if ($dir -and -not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        [System.IO.File]::WriteAllText($OutputPath, $json, [System.Text.UTF8Encoding]::new($false))
    }
    Write-Output $json
}

function New-BaseResult {
    return @{
        mode = $Mode
        title = $Title
        timestamp = (Get-Date).ToString('o')
        scenario = $Scenario
        approved = $false
        cancelled = $false
        value = $null
        hasValue = $false
        sensitive = [bool]$Sensitive
    }
}

if ($NonInteractive) {
    $result = New-BaseResult
    if ($Mode -eq 'Authorize') {
        $result.approved = ($DefaultDecision -eq 'Allow')
        $result.cancelled = ($DefaultDecision -eq 'Cancel')
    } else {
        $result.approved = $true
        $result.cancelled = $false
        $result.hasValue = ($DefaultValue.Length -gt 0)
        if (-not $Sensitive) {
            $result.value = $DefaultValue
        }
    }
    Write-Result $result
    exit 0
}

$result = New-BaseResult

try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    if ($Mode -eq 'Authorize') {
        $buttons = [System.Windows.Forms.MessageBoxButtons]::OKCancel
        $icon = [System.Windows.Forms.MessageBoxIcon]::Question
        $dialogResult = [System.Windows.Forms.MessageBox]::Show($Message, $Title, $buttons, $icon)
        $result.approved = ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK)
        $result.cancelled = ($dialogResult -eq [System.Windows.Forms.DialogResult]::Cancel)
        Write-Result $result
        exit 0
    }

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.StartPosition = 'CenterScreen'
    $form.Width = 520
    $form.Height = 190
    $form.TopMost = $true

    $label = New-Object System.Windows.Forms.Label
    $label.Left = 16
    $label.Top = 16
    $label.Width = 470
    $label.Height = 42
    $label.Text = $(if ($Prompt) { $Prompt } else { $Message })
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Left = 16
    $textBox.Top = 64
    $textBox.Width = 470
    $textBox.Text = $DefaultValue
    $textBox.UseSystemPasswordChar = [bool]$Sensitive
    $form.Controls.Add($textBox)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = '确认'
    $okButton.Left = 310
    $okButton.Top = 104
    $okButton.Width = 80
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = '取消'
    $cancelButton.Left = 406
    $cancelButton.Top = 104
    $cancelButton.Width = 80
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $dialogResult = $form.ShowDialog()
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
        $result.approved = $true
        $result.hasValue = ($textBox.Text.Length -gt 0)
        if (-not $Sensitive) {
            $result.value = $textBox.Text
        }
    } else {
        $result.cancelled = $true
    }

    Write-Result $result
    exit 0
} catch {
    if ($Mode -eq 'Authorize') {
        Write-Host $Title
        Write-Host $Message
        $answer = Read-Host '输入 Y 允许，其他任意键取消'
        $result.approved = ($answer -match '^(y|yes)$')
        $result.cancelled = -not $result.approved
        Write-Result $result
        exit 0
    }

    $displayPrompt = if ($Prompt) { $Prompt } else { $Message }
    if ($Sensitive) {
        $secure = Read-Host $displayPrompt -AsSecureString
        $result.approved = $true
        $result.hasValue = ($null -ne $secure)
    } else {
        $value = Read-Host $displayPrompt
        if (-not $value -and $DefaultValue) {
            $value = $DefaultValue
        }
        $result.approved = $true
        $result.hasValue = ($value.Length -gt 0)
        $result.value = $value
    }
    Write-Result $result
    exit 0
}
