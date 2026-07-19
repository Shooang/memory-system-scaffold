#!/usr/bin/env bash
# memory-system-scaffold installer (macOS / Linux)
# Compatible with macOS default bash 3.2 (no associative arrays)
#
# Usage:
#   ./install.sh                          # interactive
#   ./install.sh --tool trae              # specify tool directly
#   ./install.sh --tool cursor --global   # global install
#   ./install.sh --help                   # show help

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory (repository root = Skill folder)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Skill files to copy (LICENSE/install scripts are not copied, kept as repo metadata)
SKILL_FILES=("SKILL.md" "README.md")

# Tool name mapping (using case for bash 3.2 compatibility)
get_tool_name() {
  case "$1" in
    trae)         echo "TRAE" ;;
    cursor)       echo "Cursor" ;;
    codex)        echo "Codex" ;;
    claude-code)  echo "Claude Code" ;;
    workbuddy)    echo "WorkBuddy" ;;
    *)            echo "" ;;
  esac
}

# Project-level target path (relative to current working directory)
get_project_path() {
  case "$1" in
    trae)         echo "./.trae/skills/memory-system-scaffold" ;;
    cursor)       echo "./.cursor/skills/memory-system-scaffold" ;;
    codex)        echo "./.codex/skills/memory-system-scaffold" ;;
    claude-code)  echo "." ;;
    workbuddy)    echo "./skills/memory-system-scaffold" ;;
    *)            echo "" ;;
  esac
}

# Global target path (only trae / cursor supported). Empty string means not supported.
get_global_path() {
  case "$1" in
    trae)         echo "$HOME/.trae-cn/builtin/global/skills/memory-system-scaffold" ;;
    cursor)       echo "$HOME/.cursor/skills/memory-system-scaffold" ;;
    *)            echo "" ;;
  esac
}

# Argument parsing
TOOL=""
GLOBAL=false
while [ $# -gt 0 ]; do
  case "$1" in
    --tool)
      TOOL="$2"
      shift 2
      ;;
    --global)
      GLOBAL=true
      shift
      ;;
    --help|-h)
      cat <<'EOF'
Usage: ./install.sh [--tool <tool>] [--global]

Available tools: trae, cursor, codex, claude-code, workbuddy
Default mode: project-level install (--global switches to global install, only trae/cursor supported)

Examples:
  ./install.sh                          # interactive
  ./install.sh --tool trae              # install to current project's TRAE
  ./install.sh --tool cursor --global   # global install to Cursor
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Verify source files exist
for f in "${SKILL_FILES[@]}"; do
  if [ ! -f "$SCRIPT_DIR/$f" ]; then
    echo -e "${RED}Error: required file $f not found (script should run from repo root)${NC}"
    exit 1
  fi
done

# Interactive tool selection
if [ -z "$TOOL" ]; then
  echo -e "${BLUE}memory-system-scaffold install wizard${NC}"
  echo ""
  echo "Select target AI workbench:"
  echo "  1) TRAE        (project: ./.trae/skills/, global: ~/.trae-cn/builtin/global/skills/)"
  echo "  2) Cursor      (project: ./.cursor/skills/, global: ~/.cursor/skills/)"
  echo "  3) Codex       (project: ./.codex/skills/)"
  echo "  4) Claude Code (project root: ./)"
  echo "  5) WorkBuddy   (project: ./skills/)"
  echo ""
  read -rp "Enter number [1-5]: " choice
  case "$choice" in
    1) TOOL="trae" ;;
    2) TOOL="cursor" ;;
    3) TOOL="codex" ;;
    4) TOOL="claude-code" ;;
    5) TOOL="workbuddy" ;;
    *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
  esac

  # Ask mode (only for tools that support global)
  GLOBAL_PATH_CHECK="$(get_global_path "$TOOL")"
  if [ -n "$GLOBAL_PATH_CHECK" ]; then
    echo ""
    echo "Select install mode:"
    echo "  1) Project-level (available only in current project)"
    echo "  2) Global (available in all projects)"
    read -rp "Enter number [1-2, default 1]: " mode
    case "$mode" in
      2) GLOBAL=true ;;
      *) GLOBAL=false ;;
    esac
  fi
fi

# Validate tool
TOOL_NAME="$(get_tool_name "$TOOL")"
if [ -z "$TOOL_NAME" ]; then
  echo -e "${RED}Unknown tool: $TOOL${NC}"
  echo "Supported tools: trae, cursor, codex, claude-code, workbuddy"
  exit 1
fi

# Determine target path
if $GLOBAL; then
  TARGET_DIR="$(get_global_path "$TOOL")"
  if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}${TOOL_NAME} does not support global install${NC}"
    exit 1
  fi
  MODE_DESC="global"
else
  TARGET_DIR="$(get_project_path "$TOOL")"
  MODE_DESC="project-level"
fi

# Claude Code special handling: copy directly to project root
# Expand to absolute path for display
if [ "$TARGET_DIR" = "." ]; then
  TARGET_DIR="$(pwd)"
elif [ "${TARGET_DIR#"$HOME"}" != "$TARGET_DIR" ]; then
  : # Already absolute path (starts with $HOME)
else
  TARGET_DIR="$(pwd)/$TARGET_DIR"
fi

echo ""
echo -e "${BLUE}Install info${NC}"
echo "  Tool: $TOOL_NAME"
echo "  Mode: $MODE_DESC"
echo "  Target: $TARGET_DIR"
echo ""

# Confirm
read -rp "Confirm install? [y/N]: " confirm
if ! echo "$confirm" | grep -qE "^[yY]"; then
  echo "Cancelled"
  exit 0
fi

# Create directory (Claude Code doesn't need creation, target is project root)
if [ "$TOOL" != "claude-code" ]; then
  mkdir -p "$TARGET_DIR"
fi

# Copy files
for f in "${SKILL_FILES[@]}"; do
  cp "$SCRIPT_DIR/$f" "$TARGET_DIR/$f"
  echo -e "  ${GREEN}✓${NC} $f -> $TARGET_DIR/$f"
done

echo ""
echo -e "${GREEN}Install complete!${NC}"
echo ""
echo "Next steps:"
if [ "$TOOL" = "claude-code" ]; then
  echo "  Open current project in Claude Code, say 'set up memory system' to trigger"
else
  echo "  Open ${TOOL_NAME}, load target project, say 'set up memory system' to trigger"
fi
echo ""
echo "See README.md for more usage."
