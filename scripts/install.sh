#!/usr/bin/bash
set -euo pipefail  # 启用严格模式，遇到错误立即退出

MIN_VERSION='0.11'  # 移除v前缀，便于版本比较
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")

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
#######################################
function check_and_install_dependency() {
    # 解析依赖描述符
    # 格式: 类型:目标[:包名]
    local descriptor="$1"
    local type=""
    local target=""
    local pkg_name=""
    
    # 分割描述符
    IFS=':' read -r -a parts <<< "$descriptor"
    
    if [ ${#parts[@]} -lt 2 ]; then
        echo "错误：无效的依赖描述符: $descriptor" >&2
        exit 1
    fi
    
    type="${parts[0]}"
    target="${parts[1]}"
    pkg_name="${parts[2]:-$target}"  # 包名可选，默认与目标相同
    
    # 检查依赖是否存在
    if dependency_exists "$type" "$target"; then
        echo "${type}: ${target} 已存在，跳过..."
        return 0
    fi
    
    # 安装依赖
    echo "${type}: ${target} 不存在，正在安装包 ${pkg_name}..."
    sudo pacman -S "$pkg_name" --noconfirm || {
        echo "安装 ${pkg_name} 失败" >&2
        exit 1
    }
    
    # 验证安装
    if ! dependency_exists "$type" "$target"; then
        echo "错误：安装 ${pkg_name} 后仍未找到 ${type}: ${target}" >&2
        exit 1
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
# 获取操作系统类型
# return:
#   操作系统ID（小写）
#######################################
function get_os_type()
{
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "${ID,,}"  # 转为小写
    else
        echo "未知操作系统" >&2
        exit 1
    fi
}

#######################################
# 安装neovim（Manjaro/Arch专用）
#######################################
function manjaro_install_neovim()
{
    if dependency_exists "command" "nvim"; then
        echo "正在卸载现有neovim..."
        sudo pacman -Rsnc neovim --noconfirm || {
            echo "卸载neovim失败" >&2
            exit 1
        }
    fi

    echo "正在安装neovim..."
    sudo pacman -S neovim --noconfirm || {
        echo "安装neovim失败" >&2
        exit 1
    }

    # 创建vim/vi到nvim的符号链接
    echo "设置nvim为默认编辑器..."
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
}

# Arch使用与Manjaro相同的安装逻辑
arch_install_neovim()
{
    manjaro_install_neovim    
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
        echo "已安装neovim版本: $version"

        if version_gt "$version" "$MIN_VERSION"; then
            echo "neovim版本满足要求，无需重新安装"
            return 0
        else
            echo "neovim版本低于最低要求($MIN_VERSION)，将进行升级..."
        fi
    else
        echo "未检测到neovim，将进行安装..."
    fi

    # 调用对应操作系统的安装函数
    if declare -f "${OS_TYPE}_install_neovim" > /dev/null; then
        "${OS_TYPE}_install_neovim"
    else
        echo "错误：不支持的操作系统: $OS_TYPE" >&2
        exit 1
    fi
}

#######################################
# 安装依赖软件包（Manjaro/Arch专用）
#######################################
function manjaro_install_requirements()
{
    echo "正在检查并安装必要依赖..."
    
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
        "command:fd:fd-find"
        "command:xsel"
        "command:zathura"
        "command:fzf"
        "command:luarocks"
        "file:/usr/share/fonts/noto/NotoColorEmoji.ttf:noto-fonts-emoji"
    )

    # 检查并安装每个依赖
    for dep in "${dependencies[@]}"; do
        check_and_install_dependency "$dep"
    done

    # 单独处理AUR包jdtls
    if ! dependency_exists "command" "jdtls"; then
        echo "检测到未安装jdtls，正在安装..."
        yay -S jdtls --noconfirm || {
            echo "安装jdtls失败" >&2
            exit 1
        }
    else
        echo "jdtls 已安装，跳过..."
    fi
}

# Arch使用与Manjaro相同的依赖安装逻辑
arch_install_requirements()
{
    manjaro_install_requirements
}

#######################################
# 安装依赖主函数
#######################################
function install_requirements()
{
    if declare -f "${OS_TYPE}_install_requirements" > /dev/null; then
        "${OS_TYPE}_install_requirements"
    else
        echo "错误：不支持的操作系统: $OS_TYPE" >&2
        exit 1
    fi

    # 安装VSCode C++工具
    if ! dependency_exists "directory" "~/.local/vscode-cpptools"; then
        echo "正在安装VSCode C++工具..."
        local cpptools_version="v1.10.8"
        local cpptools_file="cpptools-linux.vsix"
        
        wget "https://github.com/microsoft/vscode-cpptools/releases/download/${cpptools_version}/${cpptools_file}" \
            || { echo "下载cpptools失败" >&2; exit 1; }

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
}

#######################################
# 安装插件
#######################################
function install_plugs()
{
    echo "正在配置插件..."
    # 设置GitHub代理加速
    git config --global url."https://ghproxy.com/https://github.com".insteadOf https://github.com

    # 克隆配置仓库
    if dependency_exists "directory" "~/.config/nvim"; then
        echo "检测到已存在nvim配置，将其备份..."
        mv ~/.config/nvim ~/.config/nvim.bak."$(date +%Y%m%d%H%M%S)"
    fi

    git clone https://github.com/quintin-lee/neovim-config.git ~/.config/nvim || {
        echo "克隆配置仓库失败" >&2; exit 1;
    }

    # 配置Go代理
    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.cn,direct

    # 启动nvim以安装插件
    echo "启动neovim以安装插件..."
    nvim +PlugInstall +qall || true
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

    # 获取操作系统类型
    OS_TYPE=$(get_os_type)
    echo "检测到操作系统: ${OS_TYPE}"

    # 执行安装流程
    if [ "${is_install}" -eq 1 ]; then
        echo "开始安装流程..."
        install_neovim
        install_requirements
        install_fonts
        install_plugs
        echo "安装完成！"
    fi

    # 执行卸载流程
    if [ "${is_uninstall}" -eq 1 ]; then
        uninstall_plugs
        echo "卸载完成！"
    fi
}

# 启动主函数
main "$@"
