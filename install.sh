#!/usr/bin/env bash
# memory-system-scaffold 一键安装脚本（macOS / Linux）
# 兼容 macOS 自带 bash 3.2，不使用关联数组
#
# 用法：
#   ./install.sh                          # 交互式
#   ./install.sh --tool trae              # 直接指定工具
#   ./install.sh --tool cursor --global   # 全局安装
#   ./install.sh --help                   # 查看帮助

set -e

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# 脚本所在目录（即仓库根目录 = Skill 文件夹）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 需要复制的 Skill 文件（LICENSE/install 脚本不复制，留作仓库元数据）
SKILL_FILES=("SKILL.md" "README.md")

# 工具名映射（用 case 实现，兼容 bash 3.2）
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

# 项目级目标路径（相对当前工作目录）
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

# 全局目标路径（仅 trae / cursor 支持）。空字符串表示不支持
get_global_path() {
  case "$1" in
    trae)         echo "$HOME/.trae-cn/builtin/global/skills/memory-system-scaffold" ;;
    cursor)       echo "$HOME/.cursor/skills/memory-system-scaffold" ;;
    *)            echo "" ;;
  esac
}

# 参数解析
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
用法: ./install.sh [--tool <tool>] [--global]

可选工具: trae, cursor, codex, claude-code, workbuddy
默认模式: 项目级安装（--global 切换为全局安装，仅 trae/cursor 支持）

示例:
  ./install.sh                          # 交互式
  ./install.sh --tool trae              # 安装到当前项目 TRAE
  ./install.sh --tool cursor --global   # 全局安装到 Cursor
EOF
      exit 0
      ;;
    *)
      echo "未知参数: $1"
      exit 1
      ;;
  esac
done

# 校验源文件存在
for f in "${SKILL_FILES[@]}"; do
  if [ ! -f "$SCRIPT_DIR/$f" ]; then
    echo -e "${RED}错误：找不到必需文件 $f（脚本应在仓库根目录运行）${NC}"
    exit 1
  fi
done

# 交互式选择工具
if [ -z "$TOOL" ]; then
  echo -e "${BLUE}memory-system-scaffold 安装向导${NC}"
  echo ""
  echo "选择目标 AI 工作台："
  echo "  1) TRAE        （项目级 ./.trae/skills/，全局 ~/.trae-cn/builtin/global/skills/）"
  echo "  2) Cursor      （项目级 ./.cursor/skills/，全局 ~/.cursor/skills/）"
  echo "  3) Codex       （项目级 ./.codex/skills/）"
  echo "  4) Claude Code （项目根目录 ./）"
  echo "  5) WorkBuddy   （项目级 ./skills/）"
  echo ""
  read -rp "输入编号 [1-5]: " choice
  case "$choice" in
    1) TOOL="trae" ;;
    2) TOOL="cursor" ;;
    3) TOOL="codex" ;;
    4) TOOL="claude-code" ;;
    5) TOOL="workbuddy" ;;
    *) echo -e "${RED}无效选择${NC}"; exit 1 ;;
  esac

  # 询问模式（仅支持全局的工具）
  GLOBAL_PATH_CHECK="$(get_global_path "$TOOL")"
  if [ -n "$GLOBAL_PATH_CHECK" ]; then
    echo ""
    echo "选择安装模式："
    echo "  1) 项目级（仅当前项目可用）"
    echo "  2) 全局（所有项目可用）"
    read -rp "输入编号 [1-2，默认 1]: " mode
    case "$mode" in
      2) GLOBAL=true ;;
      *) GLOBAL=false ;;
    esac
  fi
fi

# 校验工具
TOOL_NAME="$(get_tool_name "$TOOL")"
if [ -z "$TOOL_NAME" ]; then
  echo -e "${RED}未知工具: $TOOL${NC}"
  echo "支持的工具: trae, cursor, codex, claude-code, workbuddy"
  exit 1
fi

# 确定目标路径
if $GLOBAL; then
  TARGET_DIR="$(get_global_path "$TOOL")"
  if [ -z "$TARGET_DIR" ]; then
    echo -e "${RED}${TOOL_NAME} 不支持全局安装${NC}"
    exit 1
  fi
  MODE_DESC="全局"
else
  TARGET_DIR="$(get_project_path "$TOOL")"
  MODE_DESC="项目级"
fi

# Claude Code 特殊处理：直接复制到项目根目录
# 展开为绝对路径便于显示
if [ "$TARGET_DIR" = "." ]; then
  TARGET_DIR="$(pwd)"
elif [ "${TARGET_DIR#"$HOME"}" != "$TARGET_DIR" ]; then
  : # 已经是绝对路径（以 $HOME 开头）
else
  TARGET_DIR="$(pwd)/$TARGET_DIR"
fi

echo ""
echo -e "${BLUE}安装信息${NC}"
echo "  工具：$TOOL_NAME"
echo "  模式：$MODE_DESC"
echo "  目标：$TARGET_DIR"
echo ""

# 确认
read -rp "确认安装？[y/N]: " confirm
if ! echo "$confirm" | grep -qE "^[yY]"; then
  echo "已取消"
  exit 0
fi

# 创建目录（Claude Code 不需要创建，目标是项目根目录）
if [ "$TOOL" != "claude-code" ]; then
  mkdir -p "$TARGET_DIR"
fi

# 复制文件
for f in "${SKILL_FILES[@]}"; do
  cp "$SCRIPT_DIR/$f" "$TARGET_DIR/$f"
  echo -e "  ${GREEN}✓${NC} $f → $TARGET_DIR/$f"
done

echo ""
echo -e "${GREEN}安装完成！${NC}"
echo ""
echo "下一步："
if [ "$TOOL" = "claude-code" ]; then
  echo "  在 Claude Code 中打开当前项目，说「搭建记忆系统」即可触发"
else
  echo "  打开 ${TOOL_NAME}，加载目标项目，说「搭建记忆系统」即可触发"
fi
echo ""
echo "更多用法详见 README.md"
