#!/usr/bin/env bash
set -euo pipefail  # 启用严格模式，遇到错误立即退出

MIN_VERSION='0.11'  # 移除v前缀，便于版本比较
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")

# Log function for consistent output
function log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

function usage()
{
    echo "用法:"
    echo "      $(basename "$0") [-i | -u]"
    echo ""
    echo "  选项:"
    echo "      -i, --install      安装neovim及其插件"
    echo "      -u, --uninstall    卸载插件"
    exit 1
}

#######################################
# 参数解析
# Arguments:
#   $*
#######################################
function parser_param()
{
    while [ $# -ne 0 ]; do
        case "$1" in
            -i|--install)
                is_install=1
                shift
                ;;
            -u|--uninstall)
                is_uninstall=1
                shift
                ;;
            *)
                echo "错误：无效参数: $1" >&2
                usage
                ;;
        esac
    done

    # 确保只指定了一个选项
    if [ "${is_install:-0}" -eq 1 ] && [ "${is_uninstall:-0}" -eq 1 ]; then
        echo "错误：不能同时指定安装和卸载选项" >&2
        usage
    fi
}

#######################################
# 检查依赖项是否存在
# 支持多种类型: 命令(command)、文件(file)、目录(directory)、库(lib)
# Arguments:
#   $1 - 类型 (command/file/directory/lib)
#   $2 - 检查对象
# return:
#   0 存在
#   1 不存在
#######################################
function dependency_exists() {
    local type="$1"
    local target="$2"

    case "$type" in
        command)
            type "$target" >/dev/null 2>&1
            ;;
        file)
            [ -f "$target" ]
            ;;
        directory)
            [ -d "$target" ]
            ;;
        lib)
            # 检查动态链接库是否存在
            if command_exists ldconfig; then
                ldconfig -p | grep -q "$target"
            else
                # 回退方案：检查常见库目录
                local lib_dirs="/lib /usr/lib /usr/local/lib /lib64 /usr/lib64 /usr/local/lib64"
                for dir in $lib_dirs; do
                    if [ -f "${dir}/lib${target}.so" ] || [ -f "${dir}/lib${target}.a" ]; then
                        return 0
                    fi
                done
                return 1
            fi
            ;;
        *)
            echo "错误：不支持的检查类型: $type" >&2
            return 1
            ;;
    esac
}

# Helper function to check if a command exists
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

#######################################
# 检查并安装依赖
# 格式: 类型:目标:包名 (包名可选，默认与目标相同)
# 示例:
#   command:git
#   file:/etc/passwd
#   directory:/usr/share/doc
#   lib:ssl:openssl
# Arguments:
#   $1 - 依赖描述符
#   $2 - 包管理器命令
#   $3 - 包管理器安装参数
#######################################
function check_and_install_dependency() {
    # 解析依赖描述符
    # 格式: 类型:目标[:包名]
    local descriptor="$1"
    local package_manager="$2"
    local install_cmd="$3"
    local type=""
    local target=""
    local pkg_name=""

    # 分割描述符
    IFS=':' read -r -a parts <<< "$descriptor"

    if [ ${#parts[@]} -lt 2 ]; then
        log "错误：无效的依赖描述符: $descriptor" >&2
        exit 1
    fi

    type="${parts[0]}"
    target="${parts[1]}"
    pkg_name="${parts[2]:-$target}"  # 包名可选，默认与目标相同

    # 检查依赖是否存在
    if dependency_exists "$type" "$target"; then
        log "${type}: ${target} 已存在，跳过..."
        return 0
    fi

    # 特别处理翻译工具，它在某些Linux发行版上可能存在命令名差异
    if [[ "$target" == "translate-shell" ]]; then
        # 检查是否有 trans 命令作为替代
        if command_exists "trans"; then
            log "command: trans 已存在，替代 translate-shell，跳过..."
            return 0
        fi
    fi

    # 安装依赖
    log "${type}: ${target} 不存在，正在安装包 ${pkg_name}..."
    sudo $package_manager $install_cmd "$pkg_name" || {
        log "安装 ${pkg_name} 失败，跳过此依赖" >&2
        return 1  # 不终止安装流程，只是跳过这个依赖
    }

    # 验证安装
    if ! dependency_exists "$type" "$target"; then
        log "警告：安装 ${pkg_name} 后仍未找到 ${type}: ${target}" >&2
        # 再次检查是否有替代命令 (如 trans 替代 translate-shell)
        if [[ "$target" == "translate-shell" ]] && command_exists "trans"; then
            log "发现 trans 命令，可以作为 translate-shell 的替代"
            return 0
        fi
        # 对于在容器环境中的非关键依赖，我们允许继续
        if [[ "$target" == "translate-shell" ]] || [[ "$target" == "lazygit" ]] || [[ "$target" == "bash-language-server" ]] || [[ "$target" == "pyright" ]]; then
            log "警告：非关键依赖 ${target} 未安装，不影响主要功能"
            return 0
        fi
        return 1  # 对于关键依赖，返回错误
    fi
}

#######################################
# 判断版本号大小
# Arguments:
#   $1 - 版本号1
#   $2 - 版本号2
# return:
#   0 若$1 > $2
#   1 其他情况
#######################################
function version_gt() {
    # 移除可能的v前缀并比较
    local v1=$(echo "$1" | sed 's/^v//')
    local v2=$(echo "$2" | sed 's/^v//')
    [ "$(printf "%s\n" "$v1" "$v2" | sort -V | head -n1)" = "$v2" ]
}

#######################################
# 获取操作系统类型和包管理器
# return:
#   操作系统ID（小写）和包管理器
#######################################
function get_os_info()
{
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        local os_id="${ID,,}"  # 转为小写
        local pkg_manager=""

        case "$os_id" in
            arch|manjaro)
                pkg_manager="pacman"
                ;;
            ubuntu|debian|linuxmint)
                pkg_manager="apt"
                ;;
            fedora|centos|rhel|rocky|almalinux)
                pkg_manager="dnf"
                ;;
            opensuse*|sles)
                pkg_manager="zypper"
                ;;
            *)
                log "错误：不支持的操作系统: $os_id" >&2
                exit 1
                ;;
        esac

        echo "$os_id $pkg_manager"
    else
        log "错误: 无法确定操作系统类型" >&2
        exit 1
    fi
}

#######################################
# 安装neovim（Arch系）
#######################################
function arch_install_neovim()
{
    if dependency_exists "command" "nvim"; then
        log "正在卸载现有neovim..."
        sudo pacman -Rsnc neovim --noconfirm || {
            log "卸载neovim失败" >&2
            exit 1
        }
    fi

    log "正在安装neovim..."
    sudo pacman -S neovim --noconfirm || {
        log "安装neovim失败" >&2
        exit 1
    }

    # 创建vim/vi到nvim的符号链接
    log "设置nvim为默认编辑器..."
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
}

#######################################
# 安装neovim（Debian/Ubuntu系）
#######################################
function ubuntu_install_neovim()
{
    if dependency_exists "command" "nvim"; then
        echo "正在卸载现有neovim..."
        sudo apt remove neovim -y || {
            echo "卸载neovim失败" >&2
            exit 1
        }
    fi

    echo "正在安装neovim..."
    sudo apt update || echo "警告: apt update 失败，继续安装..."
    sudo apt install neovim -y || {
        echo "安装neovim失败，尝试添加PPA..."
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt update
        sudo apt install neovim -y || {
            echo "安装neovim失败" >&2
            exit 1
        }
    }

    # 创建vim/vi到nvim的符号链接
    echo "设置nvim为默认编辑器..."
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
}

#######################################
# 安装neovim（Fedora系）
#######################################
function fedora_install_neovim()
{
    if dependency_exists "command" "nvim"; then
        echo "正在卸载现有neovim..."
        sudo dnf remove neovim -y || {
            echo "卸载neovim失败" >&2
            exit 1
        }
    fi

    echo "正在安装neovim..."
    sudo dnf install neovim -y || {
        echo "安装neovim失败" >&2
        exit 1
    }

    # 创建vim/vi到nvim的符号链接
    echo "设置nvim为默认编辑器..."
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
}

#######################################
# 安装neovim（openSUSE系）
#######################################
function opensuse_install_neovim()
{
    if dependency_exists "command" "nvim"; then
        echo "正在卸载现有neovim..."
        sudo zypper remove neovim -y || {
            echo "卸载neovim失败" >&2
            exit 1
        }
    fi

    echo "正在安装neovim..."
    sudo zypper install neovim -y || {
        echo "安装neovim失败" >&2
        exit 1
    }

    # 创建vim/vi到nvim的符号链接
    echo "设置nvim为默认编辑器..."
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
}

#######################################
# 安装neovim主函数
#######################################
function install_neovim()
{
    if dependency_exists "command" "nvim"; then
        # 提取版本号（从"NVIM v0.9.1"中获取"0.9.1"）
        local version_output=$(nvim --version | grep -oP 'NVIM \Kv?\d+\.\d+\.\d+')
        local version=$(echo "$version_output" | sed 's/^v//')  # 移除v前缀
        log "已安装neovim版本: $version"

        if version_gt "$version" "$MIN_VERSION"; then
            log "neovim版本满足要求，无需重新安装"
            return 0
        else
            log "neovim版本低于最低要求($MIN_VERSION)，将进行升级..."
        fi
    else
        log "未检测到neovim，将进行安装..."
    fi

    # 检查是否在Docker容器中
    if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup; then
        log "检测到在Docker环境中运行，跳过neovim重新安装（假设已预安装）"
        return 0
    fi

    # 调用对应操作系统的安装函数
    if declare -f "${OS_TYPE}_install_neovim" > /dev/null; then
        "${OS_TYPE}_install_neovim"
    else
        log "错误：不支持的操作系统: $OS_TYPE" >&2
        exit 1
    fi
}

#######################################
# 安装依赖软件包（Arch系）
#######################################
function arch_install_requirements()
{
    log "正在检查并安装必要依赖..."

    # 定义依赖列表，格式: 类型:目标[:包名]
    local dependencies=(
        "command:wget"
        "command:unzip"
        "command:cmake"
        "command:make"
        "command:gcc"
        "command:trans:translate-shell"
        "command:lazygit"
        "command:bash-language-server"
        "command:pyright"
        "command:lua-language-server"
        "command:go"
        "command:gopls"
        "command:npm"
        "command:rg:ripgrep"
        "command:fd:fd"
        "command:xclip"
        "command:zathura"
        "command:fzf"
        "command:luarocks"
        "file:/usr/share/fonts/noto/NotoColorEmoji.ttf:noto-fonts-emoji"
    )

    # 检查并安装每个依赖
    for dep in "${dependencies[@]}"; do
        check_and_install_dependency "$dep" "pacman" "-S --noconfirm"
    done

    # 单独处理AUR包jdtls
    if ! dependency_exists "command" "jdtls"; then
        log "检测到未安装jdtls，正在安装..."
        if command_exists yay; then
            yay -S jdtls --noconfirm || {
                log "使用yay安装jdtls失败，尝试使用paru..."
                paru -S jdtls --noconfirm || {
                    log "安装jdtls失败" >&2
                    exit 1
                }
            }
        elif command_exists paru; then
            paru -S jdtls --noconfirm || {
                log "安装jdtls失败" >&2
                exit 1
            }
        else
            log "错误：未找到AUR助手 (yay 或 paru)，无法安装jdtls" >&2
            exit 1
        fi
    else
        log "jdtls 已安装，跳过..."
    fi
}

#######################################
# 安装依赖软件包（Debian/Ubuntu系）
#######################################
function ubuntu_install_requirements()
{
    echo "正在检查并安装必要依赖..."

    # 更新包列表
    sudo apt update || echo "警告: apt update 失败，继续安装..."

    # 定义依赖列表，格式: 类型:目标[:包名]
    local dependencies=(
        "command:wget"
        "command:unzip"
        "command:cmake"
        "command:make"
        "command:gcc"
        "command:translate-shell:translate-shell"
        "command:lazygit:lazygit"
        "command:bash-language-server:bash-language-server"
        "command:pyright:nodejs"
        "command:lua-language-server:lua-language-server"
        "command:go:golang-go"
        "command:gopls:golang-gopls"
        "command:npm:nodejs"
        "command:rg:ripgrep"
        "command:fd:fd-find"
        "command:xclip:xclip"
        "command:zathura:zathura"
        "command:fzf:fzf"
        "command:luarocks:luarocks"
        "file:/usr/share/fonts/truetype/noto/NotoColorEmoji.ttf:noto-color-emoji-fonts"
    )

    # 检查并安装每个依赖
    for dep in "${dependencies[@]}"; do
        check_and_install_dependency "$dep" "apt" "install -y"
    done

    # 安装 Python LSP server if not already installed
    if ! dependency_exists "command" "pylsp"; then
        sudo apt install python3-pip -y
        pip3 install 'python-lsp-server[all]'
    fi

    # 安装 jdtls separately
    if ! dependency_exists "command" "jdtls"; then
        echo "jdtls not found, installing manually..."
        sudo apt install openjdk-17-jdk -y
        mkdir -p ~/.local/share/lsp-server/jdtls
        local jdtls_version="1.29.0"
        local jdtls_url="https://download.eclipse.org/jdtls/milestones/${jdtls_version}/jdt-language-server-${jdtls_version}.tar.gz"
        wget "$jdtls_url" -O /tmp/jdtls.tar.gz
        tar -xzf /tmp/jdtls.tar.gz -C ~/.local/share/lsp-server/jdtls/
        rm /tmp/jdtls.tar.gz
        # Create a simple wrapper script
        cat > /usr/local/bin/jdtls << 'EOF'
#!/bin/bash
JVMPATH="$(which java)"
BASEDIR=$(dirname $0)
$JVMPATH -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.level=ALL \
    -Xms1G -Xmx2G \
    -jar $BASEDIR/../share/lsp-server/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $BASEDIR/../share/lsp-server/jdtls/config_linux \
    -data $BASEDIR/../share/lsp-server/jdtls/workspace \
    "$@"
EOF
        sudo chmod +x /usr/local/bin/jdtls
    fi
}

#######################################
# 安装依赖软件包（Fedora系）
#######################################
function fedora_install_requirements()
{
    echo "正在检查并安装必要依赖..."

    # 定义依赖列表，格式: 类型:目标[:包名]
    local dependencies=(
        "command:wget"
        "command:unzip"
        "command:cmake"
        "command:make"
        "command:gcc"
        "command:translate-shell"
        "command:lazygit"
        "command:bash-language-server:nodejs"
        "command:pyright:nodejs"
        "command:lua-language-server:lua-lgi"
        "command:go:golang"
        "command:gopls:golang-gopls"
        "command:npm:nodejs"
        "command:rg:ripgrep"
        "command:fd:fd-find"
        "command:xclip:xclip"
        "command:zathura:zathura"
        "command:fzf:fzf"
        "command:luarocks:luarocks"
        "file:/usr/share/fonts/google-noto-emoji/NotoColorEmoji.ttf:noto-emoji-fonts"
    )

    # 检查并安装每个依赖
    for dep in "${dependencies[@]}"; do
        check_and_install_dependency "$dep" "dnf" "install -y"
    done

    # 安装 Python LSP server if not already installed
    if ! dependency_exists "command" "pylsp"; then
        sudo dnf install python3-pip -y
        pip3 install 'python-lsp-server[all]'
    fi

    # Install jdtls separately
    if ! dependency_exists "command" "jdtls"; then
        sudo dnf install java-17-openjdk -y
        mkdir -p ~/.local/share/lsp-server/jdtls
        local jdtls_version="1.29.0"
        local jdtls_url="https://download.eclipse.org/jdtls/milestones/${jdtls_version}/jdt-language-server-${jdtls_version}.tar.gz"
        wget "$jdtls_url" -O /tmp/jdtls.tar.gz
        tar -xzf /tmp/jdtls.tar.gz -C ~/.local/share/lsp-server/jdtls/
        rm /tmp/jdtls.tar.gz
        # Create a simple wrapper script
        cat > /usr/local/bin/jdtls << 'EOF'
#!/bin/bash
JVMPATH="$(which java)"
BASEDIR=$(dirname $0)
$JVMPATH -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.level=ALL \
    -Xms1G -Xmx2G \
    -jar $BASEDIR/../share/lsp-server/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $BASEDIR/../share/lsp-server/jdtls/config_linux \
    -data $BASEDIR/../share/lsp-server/jdtls/workspace \
    "$@"
EOF
        sudo chmod +x /usr/local/bin/jdtls
    fi
}

#######################################
# 安装依赖软件包（openSUSE系）
#######################################
function opensuse_install_requirements()
{
    echo "正在检查并安装必要依赖..."

    # 定义依赖列表，格式: 类型:目标[:包名]
    local dependencies=(
        "command:wget"
        "command:unzip"
        "command:cmake"
        "command:make"
        "command:gcc"
        "command:translate-shell"
        "command:lazygit"
        "command:bash-language-server:nodejs"
        "command:pyright:nodejs"
        "command:lua-language-server:lua51-lgi"
        "command:go:golang"
        "command:gopls:golang-tools"
        "command:npm:nodejs"
        "command:rg:ripgrep"
        "command:fd:fd"
        "command:xclip:xclip"
        "command:zathura:zathura"
        "command:fzf:fzf"
        "command:luarocks:luarocks"
        "file:/usr/share/fonts/truetype/noto/NotoColorEmoji.ttc:noto-emoji-fonts"
    )

    # 检查并安装每个依赖
    for dep in "${dependencies[@]}"; do
        check_and_install_dependency "$dep" "zypper" "install -y"
    done

    # 安装 Python LSP server if not already installed
    if ! dependency_exists "command" "pylsp"; then
        sudo zypper install python3-pip -y
        pip3 install 'python-lsp-server[all]'
    fi

    # Install jdtls separately
    if ! dependency_exists "command" "jdtls"; then
        sudo zypper install java-17-openjdk -y
        mkdir -p ~/.local/share/lsp-server/jdtls
        local jdtls_version="1.29.0"
        local jdtls_url="https://download.eclipse.org/jdtls/milestones/${jdtls_version}/jdt-language-server-${jdtls_version}.tar.gz"
        wget "$jdtls_url" -O /tmp/jdtls.tar.gz
        tar -xzf /tmp/jdtls.tar.gz -C ~/.local/share/lsp-server/jdtls/
        rm /tmp/jdtls.tar.gz
        # Create a simple wrapper script
        cat > /usr/local/bin/jdtls << 'EOF'
#!/bin/bash
JVMPATH="$(which java)"
BASEDIR=$(dirname $0)
$JVMPATH -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.level=ALL \
    -Xms1G -Xmx2G \
    -jar $BASEDIR/../share/lsp-server/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $BASEDIR/../share/lsp-server/jdtls/config_linux \
    -data $BASEDIR/../share/lsp-server/jdtls/workspace \
    "$@"
EOF
        sudo chmod +x /usr/local/bin/jdtls
    fi
}

#######################################
# 安装依赖主函数
#######################################
function install_requirements()
{
    # 检查是否在Docker容器中
    local in_docker=0
    if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup || grep -q podman /proc/1/cgroup; then
        in_docker=1
        log "检测到在容器环境中运行"
    fi

    if [ $in_docker -eq 0 ]; then
        # 只有在非Docker环境中才执行系统依赖安装
        if declare -f "${OS_TYPE}_install_requirements" > /dev/null; then
            "${OS_TYPE}_install_requirements"
        else
            echo "错误：不支持的操作系统: $OS_TYPE" >&2
            exit 1
        fi
    else
        log "跳过系统依赖安装，假设已在Docker镜像中预安装"
    fi

    # 安装VSCode C++工具
    if ! dependency_exists "directory" "~/.local/vscode-cpptools"; then
        echo "正在安装VSCode C++工具..."
        local cpptools_version="v1.10.8"
        local cpptools_file="cpptools-linux.vsix"

        # Try with timeout and retries to handle network issues in containers
        if ! timeout 300 wget --tries=3 --timeout=30 "https://github.com/microsoft/vscode-cpptools/releases/download/${cpptools_version}/${cpptools_file}"; then
            echo "警告：下载cpptools失败，跳过安装（这在容器环境中是可接受的）"
            # If in container environment, this is acceptable
            if [ $in_docker -eq 1 ]; then
                return 0
            else
                exit 1
            fi
        fi

        mkdir -p vscode-cpptools || { echo "创建目录失败" >&2; exit 1; }
        pushd vscode-cpptools > /dev/null
        unzip "../${cpptools_file}" || { echo "解压失败" >&2; exit 1; }
        popd > /dev/null

        mkdir -p ~/.local/ || { echo "创建.local目录失败" >&2; exit 1; }
        mv vscode-cpptools ~/.local/ || { echo "移动文件失败" >&2; exit 1; }
        chmod +x ~/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7
        rm -f "${cpptools_file}"
    else
        echo "VSCode C++工具已安装，跳过..."
    fi

    # Install go tools for better Go development (only if go is available and not in container)
    if [ $in_docker -eq 0 ] && dependency_exists "command" "go"; then
        echo "安装 Go 工具..."
        # Use GOPROXY to speed up downloads and avoid timeouts
        go env -w GOPROXY=https://goproxy.cn,direct
        # Use timeout to prevent hanging
        timeout 300 bash -c 'go install golang.org/x/tools/gopls@latest || echo "警告：安装gopls失败"' 2>/dev/null
        timeout 300 bash -c 'go install github.com/go-delve/delve/cmd/dlv@latest || echo "警告：安装dlv失败"' 2>/dev/null
        timeout 300 bash -c 'go install github.com/cweill/gotests/...@latest || echo "警告：安装gotests失败"' 2>/dev/null
    fi
}

#######################################
# 安装插件
#######################################
function install_plugs()
{
    log "正在配置插件..."

    # 检查是否在Docker容器中
    local in_docker=0
    if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup || grep -q podman /proc/1/cgroup; then
        in_docker=1
        log "检测到在容器环境中运行"
    fi

    # Check if git is available
    if [ $in_docker -eq 0 ] && ! command_exists git; then
        log "错误：未找到git命令，请先安装git" >&2
        exit 1
    fi

    if [ $in_docker -eq 0 ]; then
        # 设置GitHub代理加速 (only outside container)
        # Try git clone with original URL if proxy fails
        if dependency_exists "directory" "~/.config/nvim"; then
            log "检测到已存在nvim配置，将其备份..."
            mv ~/.config/nvim ~/.config/nvim.bak."$(date +%Y%m%d%H%M%S)"
        fi

        # Try to clone with proxy first, then without proxy if it fails
        if ! git clone https://ghproxy.com/https://github.com/quintin-lee/NVCode.git ~/.config/nvim 2>/dev/null; then
            log "通过代理克隆失败，尝试直接克隆..."
            git clone https://github.com/quintin-lee/NVCode.git ~/.config/nvim || {
                log "克隆NVCode仓库失败" >&2; exit 1;
            }
        fi
    else
        # In container, the configuration should already be in place
        log "在容器环境中运行，跳过克隆，使用镜像中预配置的NVCode"
        # Ensure the configuration is in the right place
        if [ ! -d "/nvcode/lua" ]; then
            log "错误：在容器环境中未找到NVCode配置" >&2
            exit 1
        fi
        # Create a symbolic link to make it accessible from user's home
        mkdir -p ~/.config
        if [ -d ~/.config/nvim ]; then
            rm -rf ~/.config/nvim
        fi
        ln -s /nvcode ~/.config/nvim
    fi

    # 配置Go代理
    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.cn,direct

    # 启动nvim以安装插件
    log "启动neovim以安装/更新插件..."
    # nvim +PlugInstall +qall || true  # Note: nvim-plug is not used, lazy is used instead
    nvim --headless +Lazy! +q || log "警告：插件安装可能未完成或出现错误"
}

#######################################
# 安装字体
#######################################
function install_fonts()
{
    echo "正在安装字体..."
    local font_script="${SCRIPT_DIR}/install_fonts.sh"

    if dependency_exists "file" "${font_script}" && [ -x "${font_script}" ]; then
        "${font_script}" || {
            echo "字体安装脚本执行失败" >&2; exit 1;
        }
    else
        echo "错误：字体安装脚本不存在或不可执行: ${font_script}" >&2;
        exit 1;
    fi
}

#######################################
# 卸载插件
#######################################
function uninstall_plugs()
{
    echo "正在卸载插件..."
    if dependency_exists "directory" "~/.config/nvim"; then
        rm -rf ~/.config/nvim || {
            echo "删除nvim配置失败" >&2; exit 1;
        }
        echo "插件已卸载"
    else
        echo "未检测到已安装的插件"
    fi
}

#######################################
# 主函数
#######################################
function main()
{
    local is_install=0
    local is_uninstall=0

    # 解析参数
    if [ $# -eq 0 ]; then usage; fi
    parser_param "$@"

    # 检查是否在容器环境中
    local in_container=0
    if [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup || grep -q podman /proc/1/cgroup; then
        in_container=1
        log "检测到在容器环境中运行"
    fi

    # 获取操作系统类型和包管理器
    local os_info
    os_info=$(get_os_info)
    OS_TYPE=$(echo "$os_info" | cut -d' ' -f1)
    PKG_MANAGER=$(echo "$os_info" | cut -d' ' -f2)

    if [ $in_container -eq 1 ]; then
        log "容器环境中跳过包管理器依赖安装 - 假设已在镜像构建时预安装"
        # 在容器中，我们假设必要的依赖已经存在，不需要再次安装
        install_fonts
        install_plugs
        log "容器安装流程完成！"
    else
        log "检测到操作系统: ${OS_TYPE}, 包管理器: ${PKG_MANAGER}"

        # 执行安装流程
        if [ "${is_install}" -eq 1 ]; then
            log "开始安装流程..."
            install_neovim
            install_requirements
            install_fonts
            install_plugs
            log "安装完成！"
        fi
    fi

    # 执行卸载流程
    if [ "${is_uninstall}" -eq 1 ]; then
        uninstall_plugs
        log "卸载完成！"
    fi
}

# 启动主函数
main "$@"









