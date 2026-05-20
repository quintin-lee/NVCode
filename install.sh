#!/usr/bin/env bash

# ==============================================================================
# NvCode 一键式安装脚本 (Unified Installer)
# 自动检测环境并选择最佳安装方案
# ==============================================================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}NvCode IDE 一键安装程序${NC}"
echo "--------------------------------------------------"

# 检查是否安装了 Nix
if command -v nix &>/dev/null; then
    echo -e "${GREEN}[检测到 Nix]${NC} 将使用 Nix Flake 进行安装（推荐：自动管理依赖，环境隔离）。"
    echo "正在构建/启动环境..."
    
    # 预构建并显示帮助
    nix run . -- --help &>/dev/null || true
    
    # 创建快捷启动器
    mkdir -p "$HOME/.local/bin"
    BIN_PATH="$HOME/.local/bin/nvcode"
    cat <<EOF > "$BIN_PATH"
#!/usr/bin/env bash
nix run "$(pwd)" -- "\$@"
EOF
    chmod +x "$BIN_PATH"
    
    echo -e "\n${GREEN}安装完成！${NC}"
    echo -e "您现在可以直接在终端输入 ${BOLD}nvcode${NC} 启动 IDE。"
else
    echo -e "${BLUE}[未检测到 Nix]${NC} 将使用传统的隔离安装模式。"
    echo "此模式将尝试安装 Neovim 并配置环境。"
    
    if [ -f "scripts/install.sh" ]; then
        bash scripts/install.sh -i
    else
        echo -e "${RED}错误：找不到 scripts/install.sh${NC}"
        echo "提示：您也可以从 GitHub Releases 页面下载预打包的便携版 (ZIP)。"
        echo "地址: https://github.com/quintin-lee/NVCode/releases"
        exit 1
    fi
fi
