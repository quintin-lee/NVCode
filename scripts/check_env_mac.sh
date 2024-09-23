#!/bin/bash

check_command() {
    if command -v $1 &> /dev/null
    then
        echo "$1 is already installed"
    else
        echo "$1 is not installed"
    fi
}

echo "Checking environment..."

check_command make
check_command trans
check_command lazygit
check_command bash-language-server
check_command pyright
check_command lua-language-server
check_command go
check_command gopls
check_command npm
check_command rg
check_command fd
check_command fzf
check_command unzip
check_command pbcopy  # Mac equivalent of xsel
check_command zathura
check_command rust-analyzer
check_command luarocks
check_command jdtls
check_command cmake-language-server

# Check for Noto Color Emoji font
if [ -f "/Library/Fonts/NotoColorEmoji.ttf" ]; then
    echo "Noto Color Emoji font is installed"
else
    echo "Noto Color Emoji font is not installed"
fi
