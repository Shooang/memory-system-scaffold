# memory-system-scaffold installer (Windows PowerShell)
#
# Usage:
#   .\install.ps1                      # interactive
#   .\install.ps1 -Tool trae           # specify tool directly
#   .\install.ps1 -Tool cursor -Global # global install
#   .\install.ps1 -Help                # show help

param(
  [string]$Tool,
  [switch]$Global,
  [switch]$Help
)

if ($Help) {
  Write-Host "Usage: .\install.ps1 [-Tool <tool>] [-Global]"
  Write-Host ""
  Write-Host "Available tools: trae, cursor, codex, claude-code, workbuddy"
  Write-Host "Default mode: project-level install (-Global switches to global install, only trae/cursor supported)"
  Write-Host ""
  Write-Host "Examples:"
  Write-Host "  .\install.ps1                       # interactive"
  Write-Host "  .\install.ps1 -Tool trae            # install to current project's TRAE"
  Write-Host "  .\install.ps1 -Tool cursor -Global  # global install to Cursor"
  exit 0
}

$ErrorActionPreference = "Stop"

# Script directory (repository root = Skill folder)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Skill files to copy
$SkillFiles = @("SKILL.md", "README.md")

# Tool configuration
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

# Verify source files exist
foreach ($f in $SkillFiles) {
  $srcFile = Join-Path $ScriptDir $f
  if (-not (Test-Path $srcFile)) {
    Write-Host "Error: required file $f not found (script should run from repo root)" -ForegroundColor Red
    exit 1
  }
}

# Interactive tool selection
if (-not $Tool) {
  Write-Host "memory-system-scaffold install wizard" -ForegroundColor Blue
  Write-Host ""
  Write-Host "Select target AI workbench:"
  Write-Host "  1) TRAE        (project: .\.trae\skills\, global: ~/.trae-cn\builtin\global\skills\)"
  Write-Host "  2) Cursor      (project: .\.cursor\skills\, global: ~/.cursor\skills\)"
  Write-Host "  3) Codex       (project: .\.codex\skills\)"
  Write-Host "  4) Claude Code (project root: .\)"
  Write-Host "  5) WorkBuddy   (project: .\skills\)"
  Write-Host ""
  $choice = Read-Host "Enter number [1-5]"
  switch ($choice) {
    "1" { $Tool = "trae" }
    "2" { $Tool = "cursor" }
    "3" { $Tool = "codex" }
    "4" { $Tool = "claude-code" }
    "5" { $Tool = "workbuddy" }
    default { Write-Host "Invalid choice" -ForegroundColor Red; exit 1 }
  }

  # Ask mode (only for tools that support global)
  if ($ToolConfig[$Tool].GlobalPath) {
    Write-Host ""
    Write-Host "Select install mode:"
    Write-Host "  1) Project-level (available only in current project)"
    Write-Host "  2) Global (available in all projects)"
    $mode = Read-Host "Enter number [1-2, default 1]"
    if ($mode -eq "2") {
      $Global = $true
    }
  }
}

# Validate tool
if (-not $ToolConfig.ContainsKey($Tool)) {
  Write-Host "Unknown tool: $Tool" -ForegroundColor Red
  Write-Host "Supported tools: trae, cursor, codex, claude-code, workbuddy"
  exit 1
}

# Determine target path
if ($Global) {
  if (-not $ToolConfig[$Tool].GlobalPath) {
    Write-Host "$($ToolConfig[$Tool].Name) does not support global install" -ForegroundColor Red
    exit 1
  }
  $TargetDir = $ToolConfig[$Tool].GlobalPath
  $ModeDesc = "global"
} else {
  $TargetDir = $ToolConfig[$Tool].ProjectPath
  $ModeDesc = "project-level"
}

# Expand to absolute path
if ($TargetDir -eq ".") {
  $TargetDir = (Get-Location).Path
} else {
  $TargetDir = [System.IO.Path]::GetFullPath($TargetDir)
}

Write-Host ""
Write-Host "Install info" -ForegroundColor Blue
Write-Host "  Tool: $($ToolConfig[$Tool].Name)"
Write-Host "  Mode: $ModeDesc"
Write-Host "  Target: $TargetDir"
Write-Host ""

# Confirm
$confirm = Read-Host "Confirm install? [y/N]"
if ($confirm -notmatch "^[yY]") {
  Write-Host "Cancelled"
  exit 0
}

# Create directory (Claude Code doesn't need creation)
if ($Tool -ne "claude-code") {
  New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
}

# Copy files
foreach ($f in $SkillFiles) {
  $src = Join-Path $ScriptDir $f
  $dst = Join-Path $TargetDir $f
  Copy-Item -Path $src -Destination $dst -Force
  Write-Host "  ✓ $f -> $dst" -ForegroundColor Green
}

Write-Host ""
Write-Host "Install complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
if ($Tool -eq "claude-code") {
  Write-Host "  Open current project in Claude Code, say 'set up memory system' to trigger"
} else {
  Write-Host "  Open $($ToolConfig[$Tool].Name), load target project, say 'set up memory system' to trigger"
}
Write-Host ""
Write-Host "See README.md for more usage."
