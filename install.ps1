# memory-system-scaffold 一键安装脚本（Windows PowerShell）
#
# 用法：
#   .\install.ps1                      # 交互式
#   .\install.ps1 -Tool trae           # 直接指定工具
#   .\install.ps1 -Tool cursor -Global # 全局安装
#   .\install.ps1 -Help                # 查看帮助

param(
  [string]$Tool,
  [switch]$Global,
  [switch]$Help
)

if ($Help) {
  Write-Host "用法: .\install.ps1 [-Tool <tool>] [-Global]"
  Write-Host ""
  Write-Host "可选工具: trae, cursor, codex, claude-code, workbuddy"
  Write-Host "默认模式: 项目级安装（-Global 切换为全局安装，仅 trae/cursor 支持）"
  Write-Host ""
  Write-Host "示例:"
  Write-Host "  .\install.ps1                       # 交互式"
  Write-Host "  .\install.ps1 -Tool trae            # 安装到当前项目 TRAE"
  Write-Host "  .\install.ps1 -Tool cursor -Global  # 全局安装到 Cursor"
  exit 0
}

$ErrorActionPreference = "Stop"

# 脚本所在目录（即仓库根目录 = Skill 文件夹）
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 需要复制的 Skill 文件
$SkillFiles = @("SKILL.md", "README.md")

# 工具配置
$ToolConfig = @{
  "trae" = @{
    Name = "TRAE"
    ProjectPath = ".\.trae\skills\memory-system-scaffold"
    GlobalPath = Join-Path $env:USERPROFILE ".trae-cn\builtin\global\skills\memory-system-scaffold"
  }
  "cursor" = @{
    Name = "Cursor"
    ProjectPath = ".\.cursor\skills\memory-system-scaffold"
    GlobalPath = Join-Path $env:USERPROFILE ".cursor\skills\memory-system-scaffold"
  }
  "codex" = @{
    Name = "Codex"
    ProjectPath = ".\.codex\skills\memory-system-scaffold"
    GlobalPath = $null
  }
  "claude-code" = @{
    Name = "Claude Code"
    ProjectPath = "."
    GlobalPath = $null
  }
  "workbuddy" = @{
    Name = "WorkBuddy"
    ProjectPath = ".\skills\memory-system-scaffold"
    GlobalPath = $null
  }
}

# 校验源文件存在
foreach ($f in $SkillFiles) {
  $srcFile = Join-Path $ScriptDir $f
  if (-not (Test-Path $srcFile)) {
    Write-Host "错误：找不到必需文件 $f（脚本应在仓库根目录运行）" -ForegroundColor Red
    exit 1
  }
}

# 交互式选择工具
if (-not $Tool) {
  Write-Host "memory-system-scaffold 安装向导" -ForegroundColor Blue
  Write-Host ""
  Write-Host "选择目标 AI 工作台："
  Write-Host "  1) TRAE        （项目级 .\.trae\skills\，全局 ~/.trae-cn\builtin\global\skills\）"
  Write-Host "  2) Cursor      （项目级 .\.cursor\skills\，全局 ~/.cursor\skills\）"
  Write-Host "  3) Codex       （项目级 .\.codex\skills\）"
  Write-Host "  4) Claude Code （项目根目录 .\）"
  Write-Host "  5) WorkBuddy   （项目级 .\skills\）"
  Write-Host ""
  $choice = Read-Host "输入编号 [1-5]"
  switch ($choice) {
    "1" { $Tool = "trae" }
    "2" { $Tool = "cursor" }
    "3" { $Tool = "codex" }
    "4" { $Tool = "claude-code" }
    "5" { $Tool = "workbuddy" }
    default { Write-Host "无效选择" -ForegroundColor Red; exit 1 }
  }

  # 询问模式（仅支持全局的工具）
  if ($ToolConfig[$Tool].GlobalPath) {
    Write-Host ""
    Write-Host "选择安装模式："
    Write-Host "  1) 项目级（仅当前项目可用）"
    Write-Host "  2) 全局（所有项目可用）"
    $mode = Read-Host "输入编号 [1-2，默认 1]"
    if ($mode -eq "2") {
      $Global = $true
    }
  }
}

# 校验工具
if (-not $ToolConfig.ContainsKey($Tool)) {
  Write-Host "未知工具: $Tool" -ForegroundColor Red
  Write-Host "支持的工具: trae, cursor, codex, claude-code, workbuddy"
  exit 1
}

# 确定目标路径
if ($Global) {
  if (-not $ToolConfig[$Tool].GlobalPath) {
    Write-Host "$($ToolConfig[$Tool].Name) 不支持全局安装" -ForegroundColor Red
    exit 1
  }
  $TargetDir = $ToolConfig[$Tool].GlobalPath
  $ModeDesc = "全局"
} else {
  $TargetDir = $ToolConfig[$Tool].ProjectPath
  $ModeDesc = "项目级"
}

# 展开为绝对路径
if ($TargetDir -eq ".") {
  $TargetDir = (Get-Location).Path
} else {
  $TargetDir = [System.IO.Path]::GetFullPath($TargetDir)
}

Write-Host ""
Write-Host "安装信息" -ForegroundColor Blue
Write-Host "  工具：$($ToolConfig[$Tool].Name)"
Write-Host "  模式：$ModeDesc"
Write-Host "  目标：$TargetDir"
Write-Host ""

# 确认
$confirm = Read-Host "确认安装？[y/N]"
if ($confirm -notmatch "^[yY]") {
  Write-Host "已取消"
  exit 0
}

# 创建目录（Claude Code 不需要创建）
if ($Tool -ne "claude-code") {
  New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
}

# 复制文件
foreach ($f in $SkillFiles) {
  $src = Join-Path $ScriptDir $f
  $dst = Join-Path $TargetDir $f
  Copy-Item -Path $src -Destination $dst -Force
  Write-Host "  ✓ $f -> $dst" -ForegroundColor Green
}

Write-Host ""
Write-Host "安装完成！" -ForegroundColor Green
Write-Host ""
Write-Host "下一步："
if ($Tool -eq "claude-code") {
  Write-Host "  在 Claude Code 中打开当前项目，说「搭建记忆系统」即可触发"
} else {
  Write-Host "  打开 $($ToolConfig[$Tool].Name)，加载目标项目，说「搭建记忆系统」即可触发"
}
Write-Host ""
Write-Host "更多用法详见 README.md"
