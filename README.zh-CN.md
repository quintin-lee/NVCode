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
- 支持多种语言，包括 C/C++、Shell、Python、Lua、Java、Rust、Go 和 Markdown。
- 支持 C/C++、Python、Java、Go 等语言的调试。
- 集成 REST 客户端，适用于 web 开发和测试。
- 默认主题：OneDark，现代而时尚的界面。
- 性能优化，使用懒加载实现更快的启动速度。
- AI 驱动的编码辅助，支持 Avante 和 CodeCompanion。
- 增强的 UI，包括优化的滚动条和通知处理。

## 1. 依赖

- neovim > 0.11
- patched font ([nerd fonts](https://github.com/ryanoasis/nerd-fonts))
- translate-shell
- lazygit
- clangd
- bash-language-server
- pylsp
- go
- gopls
- npm
- ripgrep
- fd
- fzf
- lua-language-server
- vscode-cpp-tools
- vscode-go
- delve
- cmake-language-server
- jdtls
- rust-analyzer
- xsel
- zathura
- noto-fonts-emoji
- noto-color-emoji-fontconfig-no-binding
- luarocks
- btop

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
sudo pacman -S delve
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

## 安装 vscode-go 为 go 调试
wget https://github.com/golang/vscode-go/releases/download/v0.49.1/go-0.49.1.vsix
mkdir vscode-go
pushd vscode-go
unzip ../go-0.49.1.vsix
popd
mv vscode-go ~/.local/
```

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

要配置 AI 驱动的编码辅助功能，您可以设置 Avante 或 CodeCompanion。

#### Avante 配置

对于 Avante，设置以下环境变量：

```
AVANTE_API_ENDPOINT
AVANTE_MODEL_NAME
AVANTE_API_KEY
```

- 以智谱清言为例配置如下:

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

#### CodeCompanion 配置

CodeCompanion 支持多种 AI 提供商，包括 OpenAI、Anthropic 和本地模型。根据不同提供商配置相应的环境变量。

## 3. Docker

[quintinlee/neovim][1] 是基于 Archlinux 的 NVCode Docker 镜像。无需安装 NVCode，即可快速体验 NVCode 带来的乐趣。

```shell
docker run -it --rm --privileged -e TERM=screen-256color -v ~/workspace:/workspace -w /workspace crpi-cofuzswrnwwx9atk.cn-beijing.personal.cr.aliyuncs.com/quintinlee/nvcode:0.10 /opt/nvcode/bin/nvcode
```

## 4. AI 工具配置

此配置允许您选择使用哪个 AI 工具，以避免同时运行多个 AI 工具而导致的性能问题。

### 可用选项

- `avante`: 使用 Avante AI 助手
- `copilot`: 使用 GitHub Copilot
- `tabnine`: 使用 Tabnine
- `codecompanion`: 使用 CodeCompanion (默认)
- `all`: 使用所有 AI 工具 (不推荐，可能影响性能)
- `none`: 禁用所有 AI 工具

### 如何设置首选的 AI 工具

在您的 shell 配置文件中设置 `AI_PROVIDER` 环境变量 (例如 `.bashrc`, `.zshrc`):

```bash
export AI_PROVIDER=codecompanion  # 使用 CodeCompanion (默认)
# 或
export AI_PROVIDER=avante  # 使用 Avante
# 或
export AI_PROVIDER=copilot  # 使用 Copilot
# 或
export AI_PROVIDER=tabnine  # 使用 Tabnine
```

或者，您可以在启动 Neovim 时设置：

```bash
AI_PROVIDER=copilot nvim
```

### 默认行为

如果未设置环境变量，则默认使用 CodeCompanion。

## 5. 插件列表

| 插件名称               | 插件地址                                                      | 备注                                                      |
| ---------------------- | ------------------------------------------------------------- | --------------------------------------------------------- |
| lazy                   | https://github.com/folke/lazy.nvim                            | 插件管理                                                  |
| DAPInstall             | https://github.com/ravenxrz/DAPInstall.nvim                   | 调试管理                                                  |
| LuaSnip                | https://github.com/L3MON4D3/LuaSnip                           |                                                           |
| bufferline             | https://github.com/akinsho/bufferline.nvim                    | Buffer 栏                                                 |
| cmp-cmdline            | https://github.com/hrsh7th/cmp-cmdline                        |                                                           |
| cmp-nvim-lsp           | https://github.com/hrsh7th/cmp-nvim-lsp                       |                                                           |
| cmp-path               | https://github.com/hrsh7th/cmp-path                           |                                                           |
| cmp_luasnip            | https://github.com/saadparwaiz1/cmp_luasnip                   |                                                           |
| completion             | https://github.com/nvim-lua/completion-nvim                   | 自动补全                                                  |
| dashboard              | https://github.com/glepnir/dashboard-nvim                     | 启动页                                                    |
| diffview               | https://github.com/sindrets/diffview.nvim                     | git diff                                                  |
| dressing               | https://github.com/stevearc/dressing.nvim                     | 优化 tui                                                  |
| FTerm                  | https://github.com/numToStr/FTerm.nvim                        | 浮动终端                                                  |
| git-blame-virt         | https://github.com/robert-oleynik/git-blame-virt.nvim         | 显示 git blame                                            |
| gitsigns               | https://github.com/lewis6991/gitsigns.nvim                    | 显示 git 文件变化                                         |
| indent-blankline       | https://github.com/lukas-reineke/indent-blankline.nvim        | 对齐线                                                    |
| lazygit                | https://github.com/kdheepak/lazygit.nvim                      | lazygit                                                   |
| lualine                | https://github.com/nvim-lualine/lualine.nvim                  | 状态栏                                                    |
| neogen                 | https://github.com/danymat/neogen                             | 注释生成                                                  |
| nightfox               | https://github.com/EdenEast/nightfox.nvim                     | 主题                                                      |
| nlua                   | https://github.com/tjdevries/nlua.nvim                        |                                                           |
| nvim-cmp               | https://github.com/hrsh7th/nvim-cmp                           |                                                           |
| nvim-code-action-menu  | https://github.com/weilbith/nvim-code-action-menu             |                                                           |
| nvim-comment           | https://github.com/terrortylor/nvim-comment                   | Toggle comments                                           |
| nvim-dap               | https://github.com/mfussenegger/nvim-dap                      | 代码调试插件                                              |
| nvim-dap-python        | https://github.com/mfussenegger/nvim-dap-python               |                                                           |
| nvim-dap-ui            | https://github.com/rcarriga/nvim-dap-ui                       |                                                           |
| nvim-dap-virtual-text  | https://github.com/theHamsta/nvim-dap-virtual-text            |                                                           |
| nvim-lsp-installer     | https://github.com/williamboman/nvim-lsp-installer            |                                                           |
| nvim-lspconfig         | https://github.com/neovim/nvim-lspconfig                      | lsp 客户端                                                |
| nvim-tree              | https://github.com/kyazdani42/nvim-tree.lua                   | 文件树                                                    |
| nvim-treesitter        | https://github.com/nvim-treesitter/nvim-treesitter            | 增强语法高亮                                              |
| nvim-web-devicons      | https://github.com/kyazdani42/nvim-web-devicons               | 字符图标                                                  |
| onedark                | https://github.com/navarasu/onedark.nvim                      | 主题                                                      |
| plenary                | https://github.com/nvim-lua/plenary.nvim                      |                                                           |
| rest                   | https://github.com/NTBBloodbath/rest.nvim                     | REST 客户端                                               |
| sessions               | https://github.com/natecraddock/sessions.nvim                 | Session 管理                                              |
| smart-pairs            | https://github.com/ZhiyuanLck/smart-pairs                     | 智能括号                                                  |
| sqlite                 | https://github.com/tami5/sqlite.lua                           |                                                           |
| telescope-file-browser | https://github.com/nvim-telescope/telescope-file-browser.nvim | 文件浏览                                                  |
| telescope-frecency     | https://github.com/nvim-telescope/telescope-frecency.nvim     | 搜索最近访问文件                                          |
| telescope-fzf-native   | https://github.com/nvim-telescope/telescope-fzf-native.nvim   |                                                           |
| telescope              | https://github.com/nvim-telescope/telescope.nvim              | 搜索插件                                                  |
| telescope-symbols      | https://github.com/nvim-telescope/telescope-symbols.nvim      | 搜索字符图标                                              |
| telescope-gitmoji      | https://github.com/olacin/telescope-gitmoji.nvim              | 支持 gitmoji                                              |
| todo-comments          | https://github.com/folke/todo-comments.nvim                   | TODO 注释高亮                                             |
| translate              | https://github.com/translate.nvim                             | 翻译                                                      |
| vim-illuminate         | https://github.com/RRethy/vim-illuminate                      | 高亮光标下的词                                            |
| which-key              | https://github.com/folke/which-key.nvim                       | 绑定快捷键                                                |
| workspaces             | https://github.com/natecraddock/workspaces.nvim               | Workspace 管理                                            |
| nvim-bqf               | https://github.com/kevinhwang91/nvim-bqf                      | 优化 Quickfix Window                                      |
| openscad.nvim          | https://github.com/salkin-mada/openscad.nvim                  | 支持 OpenSCAD 语法                                        |
| avante.nvim            | https://github.com/yetone/avante.nvim                         | 模拟 Cursor AI IDE 的行为。为用户提供 AI 驱动的代码建议。 |
| codecompanion          | https://github.com/olimorris/codecompanion.nvim               | AI 驱动的编码助手，支持多提供商                           |
| leap.nvim              | https://github.com/ggandor/leap.nvim                          | 光标跳转                                                  |
| noice.nvim             | https://github.com/folke/noice.nvim                           | 现代通知 UI，改进的通知体验                               |
| nvim-scrollbar         | https://github.com/petertriho/nvim-scrollbar                  | 增强的滚动条，带诊断指示器                                |

---

### 插件功能简述

| 分类   | 主要插件                                                                      | 说明                                               |
| ------ | ----------------------------------------------------------------------------- | -------------------------------------------------- |
| UI     | bufferline, lualine, dressing, themify, dashboard, noice.nvim, nvim-scrollbar | 状态栏、Buffer栏、主题、美化、启动页、通知、滚动条 |
| Coding | nvim-cmp, luasnip, treesitter, tabnine, neogen                                | 补全、片段、语法高亮、AI、注释生成                 |
| LSP    | nvim-lspconfig, mason, lspsaga, null-ls                                       | 语言服务器、安装、UI增强、格式化/诊断              |
| Debug  | nvim-dap, nvim-dap-ui, DAPInstall, dap-virtual                                | 调试器、UI、安装、虚拟文本                         |
| Git    | gitsigns, diffview, lazygit                                                   | Git 标记、差异视图、lazygit 集成                   |
| Tools  | telescope, nvim-tree, fterm, translate, workspaces                            | 模糊查找、文件树、终端、翻译、工作区               |
| Editor | comment, pairs, ufo, markdown, todo, illuminate                               | 注释、自动配对、折叠、markdown、TODO、高亮         |
| AI     | avante, codecompanion, copilot (通过环境变量选择，默认: codecompanion)        | AI 代码建议、聊天、补全                            |

---

## 6. 常见问题（FAQ）

**Q1: 插件安装失败或很慢？**

- A: 建议使用 GitHub 代理，或检查网络连接。也可以手动克隆插件。

**Q2: LSP 或补全无效？**

- A: 请确保所有依赖已安装。在 Neovim 中运行 `:checkhealth` 进行诊断。检查语言服务器是否在 PATH 中。

**Q3: 字体或图标显示异常？**

- A: 请确保已安装 Nerd Fonts，并将终端字体设置为 Nerd Font（如 JetBrainsMono Nerd Font）。

**Q4: 如何更新插件？**

- A: 在 Neovim 中使用 `:Lazy update` 或 `:Lazy sync` 更新所有插件。

**Q5: 如何重置或清理插件？**

- A: 使用 `:Lazy clean` 移除未使用插件。

**Q6: 如何启用 AI 代码建议？**

- A: 按上述说明设置所需环境变量（`AVANTE_API_ENDPOINT`、`AVANTE_MODEL_NAME`、`AVANTE_API_KEY`），以及参考 AI 工具配置章节。

**Q7: 如何快速恢复默认配置？**

- A: 删除 `~/.config/nvim` 并重新克隆本仓库。

---

## 7. 一键安装脚本

你可以使用提供的 `install.sh` 脚本自动安装所有依赖、字体和插件：

```sh
cd ~/.config/nvim
bash install.sh -i
```

- `-i` 或 `--install`：安装 Neovim、依赖、字体和插件。
- `-u` 或 `--uninstall`：卸载插件。

脚本会自动检测你的操作系统（Manjaro/Archlinux）并安装所有必需软件包。请根据需要查看脚本并自定义。

---

## 8. 参考

[awesome neovim][2]

[1]: https://cr.console.aliyun.com/repository/cn-beijing/quintinlee/nvcode
[2]: https://github.com/rockerBOO/awesome-neovim/blob/main/README.md
