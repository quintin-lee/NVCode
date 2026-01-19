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
    echo "  -i, --install      安装隔离环境及依赖"
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
error() {
    echo -e "\033[31m[ERROR] $*\033[0m"
    exit 1
}

# --- 1. 通用系统检测与依赖安装 ---
install_deps() {
    local OS_TYPE
    OS_TYPE=$(uname -s)

    if [ "$OS_TYPE" = "Darwin" ]; then
        log "检测到 macOS..."
        if ! command -v brew &>/dev/null; then
            error "未找到 Homebrew，请先安装: https://brew.sh/"
        fi
        brew install git curl wget unzip ripgrep fd fzf lazygit \
            sqlite lua@5.1 luarocks node npm python imagemagick gcc stylua shfmt

    elif [ "$OS_TYPE" = "Linux" ]; then
        log "检测到 Linux，正在识别发行版..."

        # 使用 /etc/os-release 获取 ID
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
            arch | manjaro)
                log "发行版: Arch/Manjaro"
                sudo pacman -Syu --needed --noconfirm \
                    base-devel git curl wget unzip ripgrep fd fzf lazygit \
                    sqlite lua51 luarocks nodejs npm python-pip imagemagick clang \
                    prettier sqlfluff shfmt stylua
                ;;
            debian | ubuntu | pop | linuxmint)
                log "发行版: Debian/Ubuntu 系列"
                sudo apt-get update
                sudo apt-get install -y build-essential git curl wget unzip ripgrep \
                    fd-find fzf sqlite3 libsqlite3-dev lua5.1 liblua5.1-0-dev luarocks \
                    nodejs npm python3-pip imagemagick clang stylua shfmt
                ;;
            fedora | rhel | centos)
                log "发行版: RedHat/Fedora 系列"
                sudo dnf groupinstall -y "Development Tools"
                sudo dnf install -y git curl wget unzip ripgrep fd-find fzf lazygit \
                    sqlite sqlite-devel lua51-devel luarocks nodejs npm python3-pip \
                    ImageMagick clang
                ;;
            *)
                warn "未知的 Linux 发行版 ($ID)，尝试根据包管理器安装..."
                if command -v pacman &>/dev/null; then
                    sudo pacman -S --needed ripgrep fd
                elif command -v apt-get &>/dev/null; then
                    sudo apt-get install -y ripgrep
                fi
                ;;
            esac
        fi
    fi

    # 公共工具补丁 (解决之前提到的 npm/pip 报错)
    log "安装公共语言工具..."
    sudo npm install -g markdownlint-cli2 @tailwindcss/language-server bash-language-server || true
    # 针对 Python 3.11+ 的环境限制使用 --break-system-packages
    pip install --user pynvim sqlfluff --break-system-packages 2>/dev/null || pip install --user pynvim sqlfluff || true
}

# --- 2. Neovim 二进制获取 (支持多架构) ---
install_nvim_binary() {
    mkdir -p "$NVIM_BIN_DIR"
    local OS_TYPE
    OS_TYPE=$(uname -s)

    if [ "$OS_TYPE" = "Darwin" ]; then
        log "下载 macOS 版 Neovim..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz
        tar -xzf nvim-macos-x86_64.tar.gz
        mv nvim-macos-x86_64/bin/nvim "$NVIM_BIN_DIR/nvim"
        # 简单移动二进制，若需完整 runtime，建议用 brew install nvim
        rm -rf nvim-macos-x86_64*
    else
        log "下载 Linux AppImage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
        chmod u+x nvim-linux-x86_64.appimage
        mv nvim-linux-x86_64.appimage "${NVIM_BIN_DIR}/nvim.appimage"
    fi
}

# --- 3. 隔离包装脚本 ---
create_wrapper() {
    local wrapper="${NVIM_BIN_DIR}/nvcode"
    local OS_TYPE
    OS_TYPE=$(uname -s)
    local BIN_TARGET="${NVIM_BIN_DIR}/nvim.appimage"
    [ "$OS_TYPE" = "Darwin" ] && BIN_TARGET="${NVIM_BIN_DIR}/nvim"

    log "生成包装脚本: $wrapper"
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

exec "$BIN_TARGET" "\$@"
EOF
    chmod +x "$wrapper"
}

# --- 4. 配置初始化 ---
setup_config() {
    local dest_conf="${NVIM_CONFIG_DIR}/${NVIM_APPNAME}"
    mkdir -p "$dest_conf"

    if [ -f "init.lua" ]; then
        cp -rv ./* "$dest_conf/"
    else
        log "克隆 NVCode 配置..."
        git clone https://github.com/quintin-lee/NVCode.git "$dest_conf" || true
    fi

    local NV_RUN="${NVIM_BIN_DIR}/nvcode"

    log "首次启动初始化插件 (Headless)..."
    "$NV_RUN" --headless "+Lazy! sync" +qa || true

    log "--------------------------------------------------"
    log "基础环境已就绪！"
    log "由于 Mason 和 Avante 等插件需要异步编译，建议按以下步骤完成最后安装："
    log "1. 输入命令启动: $NV_RUN"
    log "2. 在 Neovim 界面中等待插件自动下载完成。"
    log "3. 如果看到 Mason 报错，请执行 :MasonUpdate"
    log "4. 检查 Treesitter 状态: :checkhealth nvim-treesitter"
    log "--------------------------------------------------"
}

# --- 执行控制 ---
if [ "$IS_INSTALL" -eq 1 ]; then
    install_deps
    install_nvim_binary
    create_wrapper
    setup_config
    log "安装完成！运行方式: ${NVIM_BIN_DIR}/nvcode"
elif [ "$IS_UNINSTALL" -eq 1 ]; then
    if [ -d "$INSTALL_ROOT" ]; then
        rm -rf "$INSTALL_ROOT" && log "已清理路径: $INSTALL_ROOT"
    fi
else
    usage
fi
