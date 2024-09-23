#!/bin/bash

# Function to install a package using Homebrew
install_brew_package() {
    if brew list $1 &>/dev/null; then
        echo "${1} is already installed"
    else
        echo "Installing ${1}..."
        brew install $1
    fi
}

# Make sure Homebrew is installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

# Update Homebrew
# brew update

# Install packages
install_brew_package make
install_brew_package translate-shell
install_brew_package lazygit
install_brew_package bash-language-server
install_brew_package pyright
install_brew_package lua-language-server
install_brew_package go
install_brew_package gopls
install_brew_package npm
install_brew_package ripgrep
install_brew_package fd
install_brew_package fzf
install_brew_package unzip
install_brew_package zathura
install_brew_package rust-analyzer
install_brew_package luarocks
install_brew_package jdtls

# Install Noto Color Emoji font
if [ ! -f "/Library/Fonts/NotoColorEmoji.ttf" ]; then
    echo "Installing Noto Color Emoji font..."
    brew tap homebrew/cask-fonts
    brew install --cask font-noto-color-emoji
else
    echo "Noto Color Emoji font is already installed"
fi

# Install CMake Language Server using pip
if ! command -v cmake-language-server &> /dev/null
then
    echo "Installing cmake-language-server..."
    pip install cmake-language-server
else
    echo "cmake-language-server is already installed"
fi

echo "Installation complete!"
