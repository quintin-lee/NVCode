#!/usr/bin/env bash
set -euo pipefail

# 默认隔离路径
DEFAULT_INSTALL_ROOT="$HOME/.local/nvcode"
INSTALL_ROOT=$DEFAULT_INSTALL_ROOT
NVIM_APPNAME="nvcode"
IS_INSTALL=0
IS_UNINSTALL=0

usage() {
    echo "用法: $(basename "$0") [选项]"
    echo "选项:"
    echo "  -i, --install      安装 Neovim 隔离环境及依赖"
    echo "  -u, --uninstall    卸载指定路径下的环境"
    echo "  -p, --path PATH    指定安装路径 (默认: $DEFAULT_INSTALL_ROOT)"
    echo "  -h, --help         显示帮助"
    exit 1
}

# 参数解析
while [[ $# -gt 0 ]]; do
    case "$1" in
    -i | --install)
        IS_INSTALL=1
        shift
        ;;
    -u | --uninstall)
        IS_UNINSTALL=1
        shift
        ;;
    -p | --path)
        INSTALL_ROOT=$(readlink -f "$2")
        shift 2
        ;;
    -h | --help) usage ;;
    *)
        echo "错误: 未知参数 $1"
        usage
        ;;
    esac
done

# 路径定义
NVIM_BIN_DIR="${INSTALL_ROOT}/bin"
NVIM_CONFIG_DIR="${INSTALL_ROOT}/config"

log() { echo -e "\033[32m[$(date '+%Y-%m-%d %H:%M:%S')] $*\033[0m"; }
warn() { echo -e "\033[33m[WARN] $*\033[0m"; }

# --- 1. 系统依赖安装 (Manjaro 专用优化) ---
install_deps() {
    log "正在安装系统依赖 (Manjaro/Arch)..."
    # 直接通过 pacman 安装绝大部分格式化工具，效率最高且稳定
    sudo pacman -Syu --needed --noconfirm \
        base-devel git curl wget unzip tar gzip \
        ripgrep fd fzf lazygit \
        sqlite lua51 luarocks \
        nodejs npm python-pip python-pynvim \
        imagemagick clang \
        prettier \
        sqlfluff \
        shfmt \
        stylua || warn "部分系统包安装失败，尝试继续..."

    log "安装 Node.js 核心 LSP 工具..."
    # 仅安装必选的、确实在 npm 上的包，并忽略次要错误
    sudo npm install -g markdownlint-cli2 @tailwindcss/language-server bash-language-server || true

    log "安装 Python 语言包..."
    pip install --user pynvim --break-system-packages || true
}

# --- 2. 下载 Neovim AppImage ---
install_nvim_binary() {
    log "下载 Neovim AppImage 到 $NVIM_BIN_DIR..."
    mkdir -p "$NVIM_BIN_DIR"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    mv nvim-linux-x86_64.appimage "${NVIM_BIN_DIR}/nvim-linux-x86_64.appimage"
}

# --- 3. 创建隔离包装脚本 (nvcode) ---
create_wrapper() {
    local wrapper="${NVIM_BIN_DIR}/nvcode"
    log "生成隔离启动脚本: $wrapper"
    cat <<EOF >"$wrapper"
#!/usr/bin/env bash
NVIM_BIN_PATH=\$(dirname \$(readlink -f "\$0"))
NVIM_DIR=\${NVIM_BIN_PATH}/../

export NVIM_APPNAME=$NVIM_APPNAME
export XDG_CONFIG_HOME=\${NVIM_DIR}/config
export XDG_DATA_HOME=\${NVIM_DIR}/share
export XDG_STATE_HOME=\${NVIM_DIR}/state
export XDG_RUNTIME_DIR=\${XDG_RUNTIME_DIR:-/tmp/nvcode-\$USER}
mkdir -p "\$XDG_RUNTIME_DIR"

exec "\${NVIM_BIN_PATH}/nvim-linux-x86_64.appimage" "\$@"
EOF
    chmod +x "$wrapper"
}

# --- 4. 配置同步与插件初始化 ---
setup_config() {
    log "同步配置与初始化插件..."
    local dest_conf_dir="${NVIM_CONFIG_DIR}/${NVIM_APPNAME}"
    mkdir -p "$dest_conf_dir"

    if [ -f "init.lua" ]; then
        cp -rv ./* "$dest_conf_dir/"
    else
        warn "未发现本地配置，克隆 NVCode ..."
        git clone https://github.com/quintin-lee/NVCode.git "$dest_conf_dir"
    fi

    log "正在隔离环境下安装插件 (Headless 模式)..."
    "$NVIM_BIN_DIR/nvcode" --headless "+Lazy! sync" +qa || true

    log "预装关键 Treesitter 解析器..."
    "$NVIM_BIN_DIR/nvcode" --headless "+TSUpdate" +qa || true
}

# --- 5. 卸载流程 ---
uninstall() {
    if [ -d "$INSTALL_ROOT" ]; then
        echo -e "\033[31m警告：将删除 $INSTALL_ROOT 及其下所有配置和插件\033[0m"
        read -p "确定要卸载吗? (y/N): " confirm
        if [[ "$confirm" == [yY] ]]; then
            rm -rf "$INSTALL_ROOT"
            log "已成功卸载隔离环境。"
        else
            log "卸载取消。"
        fi
    else
        warn "未发现安装目录 $INSTALL_ROOT"
    fi
}

# --- 主入口 ---
if [ "$IS_INSTALL" -eq 1 ]; then
    mkdir -p "$INSTALL_ROOT"
    install_deps
    install_nvim_binary
    create_wrapper
    setup_config
    log "=================================================="
    log "安装成功！"
    log "路径: $INSTALL_ROOT"
    log "执行: $NVIM_BIN_DIR/nvcode"
    log "别名建议: alias nv='$NVIM_BIN_DIR/nvcode'"
    log "=================================================="
elif [ "$IS_UNINSTALL" -eq 1 ]; then
    uninstall
else
    usage
fi
