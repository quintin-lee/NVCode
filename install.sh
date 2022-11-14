#!/usr/bin/bash
OS_TYPE='manjaro'
MIN_VERSION='v0.7'
SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=$(dirname ${SCRIPT_PATH})

function usage()
{
    echo "Usage:"
    echo "      $(basename $0) [-i | -u]"
    echo ""
    echo "  -i, --install      install neovim and plugins"
    echo "  -u, --uninstall    uninstall plugins"
    exit -1
}

#######################################
# 参数解析
# Arguments:
#   $*
#######################################
function parser_param()
{
    while [ $# != 0 ]
    do
        case $1 in
            -i|--install)
                is_install=1
                shift
                ;;
            -u|--uninstall)
                is_uninstall=1
                shift
                ;;
            *)
                echo "Invalid parameter"
                usage
                ;;
        esac
    done
}

#######################################
# 判断命令是否存在
# Arguments:
#   $1
# return:
#   0 不存在
#   1 存在
#######################################
function is_exists()
{
    type $1>/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        return 1
    fi
    return 0
}

#######################################
# 判断版本号大小
# Arguments:
#   $1
#   $2
#######################################
function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" != "$1"; }

function get_os_type()
{
    echo $(cat /etc/os-release | grep ^ID= | awk -F '=' '{print $2}' | awk '{print tolower($0)}')
}

function manjaro_install_neovim()
{
    if [ ${is_exist_nvim} -eq 1 ]
    then
        sudo pacman -Rsnc neovim --noconfirm
        [ $? -eq 0 ] || exit 1
    fi
    sudo pacman -S neovim --noconfirm
    [ $? -eq 0 ] || exit 1
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
    sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
}

function arch_install_neovim()
{
    manjaro_install_neovim    
}

function install_neovim()
{
    is_exists nvim
    is_exist_nvim=$?
    if [ ${is_exist_nvim} -eq 1 ]
    then
        version=$(nvim --version | grep NVIM)
        echo "neovim version: ${version}"
        if version_gt ${version} ${MIN_VERSION}
        then
            return 0
        else
            echo "neovim 版本低于 v0.7, 重新安装 neovim"
        fi
    fi

    ${OS_TYPE}_install_neovim
    [ $? -eq 0 ] || exit 1
}

function manjaro_install_requirements()
{
    sudo pacman -S wget --noconfirm
    sudo pacman -S unzip --noconfirm
    sudo pacman -S cmake --noconfirm
    sudo pacman -S make --noconfirm
    sudo pacman -S gcc --noconfirm
    sudo pacman -S translate-shell --noconfirm
    sudo pacman -S lazygit --noconfirm
    sudo pacman -S bash-language-server --noconfirm
    sudo pacman -S pyright --noconfirm
    sudo pacman -S lua-language-server --noconfirm
    sudo pacman -S go --noconfirm
    sudo pacman -S gopls --noconfirm
    sudo pacman -S npm --noconfirm
    sudo pacman -S ripgrep --noconfirm
    sudo pacman -S fd --noconfirm
    sudo pacman -S xsel --noconfirm
    sudo pacman -S noto-fonts-emoji --noconfirm
    sudo pacman -S zathura --noconfirm
    yay -S jdtls -language-server --noconfirm
}

function arch_install_requirements()
{
    manjaro_install_requirements
}

function install_requirements()
{
    ${OS_TYPE}_install_requirements
    [ $? -eq 0 ] || exit 1

    wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.10.8/cpptools-linux.vsix
    mkdir vscode-cpptools
    pushd vscode-cpptools
    unzip ../cpptools-linux.vsix
    popd
    mv vscode-cpptools ~/.local/
    chmod +x  ~/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7
    rm -f cpptools-linux.vsix
}

function install_plugs()
{
    # github proxy
    git config --global url."https://ghproxy.com/https://github".insteadOf https://github

    git clone http://github.com/quintin-lee/neovim-config.git ~/.config/nvim

    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.cn,direct
    nvim +PackerSync
    exit 0
}

function install_fonts()
{
    ${SCRIPT_DIR}/install_fonts.sh
    [ $? -eq 0 ] || exit 1
    exit 0
}

function main()
{
    is_install=0
    is_uninstall=0

    # parser parameter
    if [ $# -eq 0 ]; then usage; fi
    parser_param $*

    # get type of os
    OS_TYPE=$(get_os_type)
    echo "OS: ${OS_TYPE}"

    # install neovim and plugin
    if [ ${is_install} -eq 1 ]
    then
        echo "Begin ..."
        install_neovim
        [ $? -eq 0 ] || exit 1
        install_requirements
        [ $? -eq 0 ] || exit 1
        install_fonts
        [ $? -eq 0 ] || exit 1
        install_plugs
        echo "Finished!!"
    fi
}

main $*
