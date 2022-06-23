#!/usr/bin/bash
OS_TYPE='manjaro'

function usage()
{
    echo "Usage:"
    exit -1
}

function parser_param()
{
    while [ $# != 0 ]
    do
        case $1 in
            -i|--install)
                install_neovim
                install_requirements
                install_plugs
                shift
                ;;
            -u|--uninstall)
                shift
                ;;
            *)
                usage
                ;;
        esac
    done
}

function is_exists()
{
    type $1>/dev/null 2>&1
    if [ $? -eq 0 ]
    then
        return 1
    fi
    return 0
}

function get_os_type()
{
    echo $(cat /etc/os-release | grep ^ID= | awk -F '=' '{print $2}')
}

function manjaro_install_neovim()
{
    is_exists yay
    if [ $? ]
    then
        sudo pacman -S yay
    fi
    yay -S neovim --noconfirm
}

function install_neovim()
{
    is_exists nvim
    if [ $? ]
    then
        nvim --version | grep NVIM
        return 0
    fi

    ${OS_TYPE}_install_neovim
}

function install_requirements()
{
    exit 0
}

function install_plugs()
{
    exit 0
}

function main()
{
    OS_TYPE=$(get_os_type)
    parser_param $*
}

main $*
