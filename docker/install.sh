#!/usr/bin/env bash

# ==============================================================================
# NVCode 自动化安装/卸载脚本 (Docker/Linux/macOS 通用版)
# 功能：全自动安装 Neovim 隔离环境，修复了 Docker 下 FUSE 和 URL 错误问题
# ==============================================================================

set -euo pipefail

# 默认参数
DEFAULT_INSTALL_ROOT="$HOME/.local/nvcode"
INSTALL_ROOT=$DEFAULT_INSTALL_ROOT
NVIM_APPNAME="nvcode"
IS_INSTALL=0
IS_UNINSTALL=0

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # 无颜色

# --- 工具函数 ---
log() { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    exit 1
}
info() { echo -e "${CYAN}>>${NC} $*"; }

usage() {
    cat <<EOF
${BLUE}NVCode 隔离环境管理工具${NC}

${BOLD}用法:${NC}
  $(basename "$0") [选项]

${BOLD}选项:${NC}
  -i, --install      安装隔离环境、依赖及配置
  -u, --uninstall    卸载指定路径下的环境
  -p, --path PATH    指定安装路径 (当前默认: $DEFAULT_INSTALL_ROOT)
  -h, --help         显示此帮助信息

${BOLD}示例:${NC}
  ./install.sh -i
  ./install.sh -i -p ~/my-nvim
EOF
    exit 1
}

# --- 参数解析 ---
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
        [ -n "${2:-}" ] || error "路径参数缺失"
        INSTALL_ROOT=$(mkdir -p "$2" && readlink -f "$2")
        shift 2
        ;;
    -h | --help) usage ;;
    *)
        echo -e "${RED}未知参数: $1${NC}"
        usage
        ;;
    esac
done

# 路径推导
NVIM_BIN_DIR="${INSTALL_ROOT}/bin"
NVIM_CONFIG_DIR="${INSTALL_ROOT}/config"

# --- 1. 环境检查 ---
check_env() {
    info "正在检查运行环境..."
    # 既然改用了 tar.gz，不再强制检查 fuse，但在 Docker 外为了某些插件可能仍需要
    if [[ "$OSTYPE" == "linux-gnu"* ]] && [ ! -f /.dockerenv ]; then
        if ! command -v fusermount &>/dev/null && ! command -v fusermount3 &>/dev/null; then
            warn "提示: 系统未检测到 fuse，虽然 Neovim 本体已不需要，但部分插件可能依赖它。"
        fi
    fi
}

# --- 2. 依赖安装 ---
install_deps() {
    local OS_TYPE=$(uname -s)
    log "阶段 1: 正在安装系统级依赖..."

    # 注意：在 Dockerfile 中通常已经安装好了，这里主要是为了本地安装脚本的兼容性
    if [ "$OS_TYPE" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
            warn "未找到 Homebrew，跳过依赖安装..."
        else
            brew install git curl wget unzip ripgrep fd fzf lazygit \
                sqlite lua@5.1 luarocks node npm python@3.11 imagemagick gcc stylua shfmt || true
        fi
    elif [ "$OS_TYPE" = "Linux" ]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            # 简单尝试安装，如果在 Docker 中没权限 sudo 可能会失败，忽略错误继续
            case "$ID" in
            arch | manjaro)
                sudo pacman -Syu --needed --noconfirm base-devel git curl wget unzip ripgrep fd fzf lazygit \
                    sqlite lua51 luarocks nodejs npm python-pip imagemagick clang stylua shfmt || true
                ;;
            debian | ubuntu | pop | linuxmint)
                sudo apt-get update && sudo apt-get install -y build-essential git curl wget unzip ripgrep fd-find fzf \
                    sqlite3 libsqlite3-dev lua5.1 liblua5.1-0-dev luarocks nodejs npm \
                    python3-pip python3-venv imagemagick clang locales || true
                ;;
            esac
        fi
    fi

    # 针对 Python 隔离环境的优化
    log "安装公共语言工具 (Node/Python)..."
    # 如果 npm 失败（通常是权限问题或网络），不要中断整个脚本
    sudo npm install -g markdownlint-cli2 @tailwindcss/language-server bash-language-server 2>/dev/null || warn "NPM 全局工具安装跳过或失败"

    if command -v pip3 &>/dev/null; then
        pip3 install --user pynvim sqlfluff --break-system-packages 2>/dev/null ||
            pip3 install --user pynvim sqlfluff ||
            warn "Python 依赖安装受限，建议在 Neovim 内通过 :Mason 安装"
    fi
}

# --- 3. Neovim 二进制获取 (已修复 Docker/URL 问题) ---
install_nvim_binary() {
    log "阶段 2: 下载 Neovim 二进制文件..."
    mkdir -p "$NVIM_BIN_DIR"
    local OS_TYPE=$(uname -s)
    local ARCH=$(uname -m)
    local TEMP_DIR=$(mktemp -d)
    
    local DOWNLOAD_URL=""
    local EXTRACT_DIR=""

    pushd "$TEMP_DIR" >/dev/null

    # === URL 和 架构判断 ===
    if [ "$OS_TYPE" = "Darwin" ]; then
        info "检测到 macOS..."
        DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-macos-x86_64.tar.gz"
        EXTRACT_DIR="nvim-macos-x86_64"
    else
        info "检测到 Linux ($ARCH)..."
        # 即使是 Linux，也区分 x86 和 ARM (M1/M2 Docker)
        if [ "$ARCH" = "x86_64" ]; then
            DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz"
            EXTRACT_DIR="nvim-linux-x86_64"
        elif [ "$ARCH" = "aarch64" ]; then
            DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-arm64.tar.gz"
            EXTRACT_DIR="nvim-linux-arm64"
        else
            error "不支持的 CPU 架构: $ARCH"
        fi
    fi

    info "下载地址: $DOWNLOAD_URL"
    # 使用 -L 跟随重定向，-f 连接失败时不输出 HTML
    curl -L -f -O "$DOWNLOAD_URL" || error "下载失败，请检查网络连接。"

    local FILENAME=$(basename "$DOWNLOAD_URL")

    # === 关键修复：检查文件有效性 ===
    # 只要小于 1KB 就认为是无效文件 (比如 404 页面)
    if [ ! -s "$FILENAME" ] || [ $(wc -c < "$FILENAME") -lt 1000 ]; then
        echo "文件内容:"
        cat "$FILENAME"
        error "下载的文件无效 (大小异常)，可能是 URL 错误或 IP 限制。"
    fi

    info "解压中..."
    tar -xzf "$FILENAME"

    # 安装：将解压后的内容移动到 INSTALL_ROOT
    # tar 包结构通常是 nvim-linux64/{bin,lib,share,man}
    if [ -d "$EXTRACT_DIR" ]; then
        # 覆盖式复制，保持目录结构
        cp -r "$EXTRACT_DIR"/* "$INSTALL_ROOT/"
    else
        ls -la
        error "解压后未找到预期目录: $EXTRACT_DIR"
    fi

    popd >/dev/null
    rm -rf "$TEMP_DIR"
}


# --- 4. 生成隔离包装脚本 (适配 Tarball 结构) ---
create_wrapper() {
    log "阶段 3: 生成隔离启动脚本..."
    local wrapper="${NVIM_BIN_DIR}/nvcode"
    
    # 这里的 BIN_TARGET 指向 tar 解压后的 bin/nvim 真实路径
    local BIN_TARGET="${NVIM_BIN_DIR}/nvim" 

    # 再次确认二进制存在
    if [ ! -f "$BIN_TARGET" ]; then
        error "未找到 Neovim 二进制文件: $BIN_TARGET"
    fi

    cat <<EOF >"$wrapper"
#!/usr/bin/env bash
# NVCode 隔离启动器
# 自动重定向配置与数据目录

# 获取当前脚本所在目录的绝对路径
SOURCE_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="\$(dirname "\$SOURCE_DIR")"

# 隔离环境变量
export NVIM_APPNAME="$NVIM_APPNAME"
export XDG_CONFIG_HOME="\${BASE_DIR}/config"
export XDG_DATA_HOME="\${BASE_DIR}/share"
export XDG_STATE_HOME="\${BASE_DIR}/state"
export XDG_CACHE_HOME="\${BASE_DIR}/cache"

# 运行二进制
# "\$@" 传递所有参数
exec "\$BASE_DIR/bin/nvim" "\$@"
EOF
    chmod +x "$wrapper"
    info "启动器已创建: $wrapper"
}

# --- 5. 配置初始化 ---
setup_config() {
    log "阶段 4: 初始化配置文件..."
    local dest_conf="${NVIM_CONFIG_DIR}/${NVIM_APPNAME}"
    mkdir -p "$dest_conf"

    # 如果当前目录下有配置，则复制；否则从 Git 克隆
    if [ -f "init.lua" ]; then
        info "从当前目录同步配置..."
        cp -rv ./* "$dest_conf/"
    else
        info "从远程仓库克隆配置..."
        # 这里的 URL 可以根据你的实际仓库修改
        git clone --depth 1 https://github.com/quintin-lee/NVCode.git "$dest_conf" || warn "配置克隆失败，将使用空配置"
    fi

    log "尝试进行 headless 插件同步 (可能需要较长时间)..."
    # 使用新的 wrapper 运行 headless 模式
    "${NVIM_BIN_DIR}/nvcode" --headless "+Lazy! sync" +qa || warn "Headless 同步中断，请进入编辑器后手动运行 :Lazy sync"
}

# --- 6. 完成提示 ---
show_success() {
    echo -e "\n${GREEN}==================================================${NC}"
    echo -e "${BOLD}NVCode 安装成功！${NC}"
    echo -e "--------------------------------------------------"
    echo -e "1. ${CYAN}运行命令:${NC} ${NVIM_BIN_DIR}/nvcode"
    echo -e "2. ${CYAN}建议别名:${NC} echo \"alias nv='${NVIM_BIN_DIR}/nvcode'\" >> ~/.bashrc"
    echo -e "3. ${CYAN}隔离路径:${NC} $INSTALL_ROOT"
    echo -e ""
    echo -e "${YELLOW}注意:${NC} 首次进入如果 UI 错乱，请运行 :Lazy 并按下 I 进行同步。"
    echo -e "${GREEN}==================================================${NC}\n"
}

# --- 主逻辑控制 ---

# 执行卸载
if [ "$IS_UNINSTALL" -eq 1 ]; then
    echo -e "${RED}警告: 将彻底删除 $INSTALL_ROOT 及其所有配置和数据！${NC}"
    read -p "确定要继续吗? (y/N) " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_ROOT"
        log "已清理路径: $INSTALL_ROOT"
    else
        log "已取消卸载。"
    fi
    exit 0
fi

# 执行安装
if [ "$IS_INSTALL" -eq 1 ]; then
    check_env
    install_deps
    install_nvim_binary
    create_wrapper
    setup_config
    show_success
else
    usage
fi
