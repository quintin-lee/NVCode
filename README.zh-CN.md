<h1 align="center">NVCode</h1>
<h2 align="center">实现现代 IDE 强大功能的 Neovim 配置</h2>

<p align="center">
  <img alt="Stargazers" src="https://img.shields.io/github/stars/quintin-lee/NVCode?logo=starship" />
  <img alt="Made with lua" src="https://img.shields.io/badge/Made%20with%20Lua-blue.svg?logo=lua" />
  <img alt="Minimum neovim version" src="https://img.shields.io/badge/Neovim-0.10.0+-blueviolet.svg?logo=Neovim" />
  <img alt="forks" src="https://img.shields.io/github/forks/quintin-lee/NVCode?logo=forks" />
  <img alt="Issues" src="https://img.shields.io/github/issues/quintin-lee/NVCode?logo=gitbook" />
</p>

[English](README.md) | 中文版

## 界面预览

<p float="center" align="middle">
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/startup.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/autocomp.png" width="33%" /> 
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/filebrowser.png " width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/debug.png " width="33%" />
</p>

## 特性

- 完全使用 Lua 编写，以增强性能和自定义性。
- 简化安装过程，仅需少量配置。
- 保存时自动格式化，确保代码整洁。
- 智能自动补全，提高生产力。
- 利用 Neovim 内置的 LSP，提供强大的语言支持。
- 支持多种语言，包括 C/C++、Shell、Python、Lua、Java、Rust 和 Markdown。
- 支持 C/C++、Python 等语言的调试。
- 集成 REST 客户端，适用于 web 开发和测试。
- 默认主题：OneDark，现代而时尚的界面。

## 1. 依赖

+ neovim > 0.10
+ patched font ([nerd fonts](https://github.com/ryanoasis/nerd-fonts))
+ translate-shell
+ lazygit
+ clangd
+ bash-language-server
+ pylsp
+ go
+ gopls
+ npm
+ ripgrep
+ fd
+ fzf
+ lua-language-server
+ vscode-cpp-tools
+ cmake-language-server
+ jdtls
+ rust-analyzer
+ xsel
+ zathura
+ noto-fonts-emoji
+ noto-color-emoji-fontconfig-no-binding
+ luarocks
+ btop

## 2. Manjaro/Archlinux 系统安装

### 2.1 安装 neovim

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
sudo pacman -S fzf
sudo pacman -S unzip
sudo pacman -S xsel
sudo pacman -S zathura
sudo pacman -S noto-fonts-emoji --noconfirm
sudo pacman -S rust-analyzer
sudo pacman -S luarocks
sudo pacman -S btop
yay -S jdtls
yay -S noto-color-emoji-fontconfig-no-binding

pip install cmake-language-server

## 安装 vscode-cpp-tools 为 c/cpp 调试
wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.10.8/cpptools-linux.vsix
mkdir vscode-cpptools
pushd vscode-cpptools
unzip ../cpptools-linux.vsix
popd
mv vscode-cpptools ~/.local/
chmod +x  ~/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7
```

## 安装 lombok.jar 为 java lsp
wget https://projectlombok.org/downloads/lombok.jar

mv lombok.jar $XDG_DATA_HOME/mason/packages/jdtls/lombok.jar

### 2.3 安装插件

```shell
git clone https://github.com/quintin-lee/NVCode.git ~/.config/nvim
nvim


### 如果 LspInstall gopls 失败, 则设置代理
# 错误信息：spawn: go failed with no exit code. go is not executable
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

### 2.4 安装 Nerd Fonts

```shell
Nerd Fonts： https://github.com/ryanoasis/nerd-fonts.git
推荐使用 JetBrainsMono 字体

cd ~/.config/nvim
bash install_fonts.sh
```

### 2.5 AI 配置

通过环境变量配置 OpenAI API 接口

```
AVANTE_API_ENDPOINT
AVANTE_MODEL_NAME
AVANTE_API_KEY
```

+ 以智谱清言为例配置如下:

[智谱清言官方文档](https://open.bigmodel.cn/dev/api/normal-model/glm-4)

1. 获取 API 密钥

访问 [API 密钥页面](https://bigmodel.cn/usercenter/apikeys) 获取请求中使用的 API 密钥。

2. 验证 API key 是否可以正常访问

```shell
curl --location 'https://open.bigmodel.cn/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer <你的apikey>' \
--header 'Content-Type: application/json' \
--data '{
    "model": "glm-4",
    "messages": [
        {
            "role": "user",
            "content": "Hello"
        }
    ]
}'
```

3. 配置环境变量

```shell
export AVANTE_API_ENDPOINT=https://open.bigmodel.cn/api/paas/v4
export AVANTE_MODEL_NAME=GLM-4
export AVANTE_API_KEY=f1xxxxxxxxxxxxx05aa5b9b9.wLgWjdxxxxxxRwr  (use your own API_KEY)
```

## 3. Docker

[quintinlee/neovim][1] 是基于 Archlinux 的 NVCode Docker 镜像。无需安装 NVCode，即可快速体验 NVCode 带来的乐趣。

```shell
docker run -it --rm --privileged -e TERM=screen-256color -v ~/workspace:/workspace -w /workspace crpi-cofuzswrnwwx9atk.cn-beijing.personal.cr.aliyuncs.com/quintinlee/nvcode:0.10 /opt/nvcode/bin/nvcode
```


## 4. 插件列表

| 插件名称               | 插件地址                                                      | 备注            |
| ---------------------- | ------------------------------------------------------------- | --------------- |
| lazy                   | https://github.com/folke/lazy.nvim                            | 插件管理           |
| DAPInstall             | https://github.com/ravenxrz/DAPInstall.nvim                   | 调试管理 |
| LuaSnip                | https://github.com/L3MON4D3/LuaSnip                           |                 |
| bufferline             | https://github.com/akinsho/bufferline.nvim                    | Buffer 栏        |
| cmp-cmdline            | https://github.com/hrsh7th/cmp-cmdline                        |                 |
| cmp-nvim-lsp           | https://github.com/hrsh7th/cmp-nvim-lsp                       |                 |
| cmp-path               | https://github.com/hrsh7th/cmp-path                           |                 |
| cmp_luasnip            | https://github.com/saadparwaiz1/cmp_luasnip                   |                 |
| completion             | https://github.com/nvim-lua/completion-nvim                   | 自动补全 |
| dashboard              | https://github.com/glepnir/dashboard-nvim                     | 启动页 |
| diffview               | https://github.com/sindrets/diffview.nvim                     | git diff        |
| dressing               | https://github.com/stevearc/dressing.nvim                     | 优化 tui          |
| FTerm                  | https://github.com/numToStr/FTerm.nvim                        | 浮动终端 |
| git-blame-virt         | https://github.com/robert-oleynik/git-blame-virt.nvim         | 显示 git blame    |
| gitsigns               | https://github.com/lewis6991/gitsigns.nvim                    | 显示 git 文件变化     |
| indent-blankline       | https://github.com/lukas-reineke/indent-blankline.nvim        | 对齐线             |
| lazygit                | https://github.com/kdheepak/lazygit.nvim                      | lazygit         |
| lualine                | https://github.com/nvim-lualine/lualine.nvim                  | 状态栏 |
| neogen                 | https://github.com/danymat/neogen                             | 注释生成 |
| nightfox               | https://github.com/EdenEast/nightfox.nvim                     | 主题             |
| nlua                   | https://github.com/tjdevries/nlua.nvim                        |                 |
| nvim-cmp               | https://github.com/hrsh7th/nvim-cmp                           |                 |
| nvim-code-action-menu  | https://github.com/weilbith/nvim-code-action-menu             |                 |
| nvim-comment           | https://github.com/terrortylor/nvim-comment                   | Toggle comments |
| nvim-dap               | https://github.com/mfussenegger/nvim-dap                      | 代码调试插件 |
| nvim-dap-python        | https://github.com/mfussenegger/nvim-dap-python               |                 |
| nvim-dap-ui            | https://github.com/rcarriga/nvim-dap-ui                       |                 |
| nvim-dap-virtual-text  | https://github.com/theHamsta/nvim-dap-virtual-text            |                 |
| nvim-lsp-installer     | https://github.com/williamboman/nvim-lsp-installer            |                 |
| nvim-lspconfig         | https://github.com/neovim/nvim-lspconfig                      | lsp 客户端 |
| nvim-tree              | https://github.com/kyazdani42/nvim-tree.lua                   | 文件树             |
| nvim-treesitter        | https://github.com/nvim-treesitter/nvim-treesitter            | 增强语法高亮 |
| nvim-web-devicons      | https://github.com/kyazdani42/nvim-web-devicons               | 字符图标            |
| onedark                | https://github.com/navarasu/onedark.nvim                      | 主题             |
| plenary                | https://github.com/nvim-lua/plenary.nvim                      |                 |
| rest                   | https://github.com/NTBBloodbath/rest.nvim                     | REST 客户端 |
| sessions               | https://github.com/natecraddock/sessions.nvim                 | Session 管理 |
| smart-pairs            | https://github.com/ZhiyuanLck/smart-pairs                     | 智能括号 |
| sqlite                 | https://github.com/tami5/sqlite.lua                           |                 |
| telescope-file-browser | https://github.com/nvim-telescope/telescope-file-browser.nvim | 文件浏览 |
| telescope-frecency     | https://github.com/nvim-telescope/telescope-frecency.nvim     | 搜索最近访问文件 |
| telescope-fzf-native   | https://github.com/nvim-telescope/telescope-fzf-native.nvim   |                 |
| telescope              | https://github.com/nvim-telescope/telescope.nvim              | 搜索插件    |
| telescope-symbols      | https://github.com/nvim-telescope/telescope-symbols.nvim      | 搜索字符图标 |
| telescope-gitmoji      | https://github.com/olacin/telescope-gitmoji.nvim              | 支持 gitmoji |
| todo-comments          | https://github.com/folke/todo-comments.nvim                   | TODO 注释高亮 |
| translate              | https://github.com/translate.nvim                             | 翻译 |
| vim-illuminate         | https://github.com/RRethy/vim-illuminate                      | 高亮光标下的词 |
| which-key              | https://github.com/folke/which-key.nvim                       | 绑定快捷键 |
| workspaces             | https://github.com/natecraddock/workspaces.nvim               | Workspace 管理 |
| nvim-bqf               | https://github.com/kevinhwang91/nvim-bqf                      | 优化 Quickfix Window   |
| openscad.nvim          | https://github.com/salkin-mada/openscad.nvim                  | 支持 OpenSCAD 语法   |
| avante.nvim            | https://github.com/yetone/avante.nvim                         | 模拟 Cursor AI IDE 的行为。为用户提供 AI 驱动的代码建议。 |
| leap.nvim              | https://github.com/ggandor/leap.nvim                          | 光标跳转 |

## 5. 参考

[awesome neovim][2]


[1]: https://cr.console.aliyun.com/repository/cn-beijing/quintinlee/nvcode
[2]: https://github.com/rockerBOO/awesome-neovim/blob/main/README.md

