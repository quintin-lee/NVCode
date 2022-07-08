## 1. 依赖

+ neovim > 0.7
+ patched font (see [nerd fonts](https://github.com/ryanoasis/nerd-fonts))
+ translate-shell
+ lazygit
+ clangd
+ bash-language-server
+ pyright
+ go
+ gopls
+ npm
+ ripgrep
+ fd
+ lua-language-server
+ vscode-cpp-tools

## 2. manjaro/archlinux 系统安装

### 2.1 安装 neovim 软件

```shell
sudo pacman -S neovim
sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
```

### 2.2 安装依赖

```shell
sudo pacman -S make
sudo pacman -S translate-shell
sudo pacman -S lazygit
sudo pacman -S bash-language-server
sudo pacman -S pyright
sudo pacman -S lua-language-server
sudo pacman -S go
sudo pacman -S gopls
sudo pacman -S npm
sudo pacman -S ripgrep
sudo pacman -S fd

## 安装 vscode-cpp-tools 用于 debug c/cpp
wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.10.8/cpptools-linux.vsix
mkdir vscode-cpptools
pushd vscode-cpptools
unzip ../cpptools-linux.vsix
popd
mv vscode-cpptools ~/.local/
chmod +x  ~/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7
```

### 2.3 安装插件

```shell
git clone http://github.com/quintin-lee/neovim-config.git ~/.config/nvim
nvim +PackerSync


### 如果 LspInstall gopls 无法拉取则，设置代理
# 报错信息：spawn: go failed with no exit code. go is not executable
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

### 2.4 安装 Nerd 字体

```shell
Nerd 字体： https://github.com/ryanoasis/nerd-fonts.git
推荐 JetBrainsMono 字体
```
