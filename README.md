<h1 align="center">NVCode</h1>
<h2 align="center">The Neovim configuration to achieve the power of Modern IDE</h2>

<p align="center">
  <img alt="Stargazers" src="https://img.shields.io/github/stars/quintin-lee/NVCode?logo=starship" />
  <img alt="Made with lua" src="https://img.shields.io/badge/Made%20with%20Lua-blue.svg?logo=lua" />
  <img alt="Minimum neovim version" src="https://img.shields.io/badge/Neovim-0.10.0+-blueviolet.svg?logo=Neovim" />
  <img alt="forks" src="https://img.shields.io/github/forks/quintin-lee/NVCode?logo=forks" />
  <img alt="Issues" src="https://img.shields.io/github/issues/quintin-lee/NVCode?logo=gitbook" />
</p>

## Language Switching

 [简体中文 (Chinese Simplified)](README.zh-CN.md)

## Interface Preview

<p float="center" align="middle">
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/startup.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/autocomp.png" width="33%" /> 
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/filebrowser.png " width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/debug.png " width="33%" />
</p>

## Features

- Completely written in Lua for enhanced performance and customization.
- Easy setup with minimal configuration required.
- Automatic formatting on save for a clean codebase.
- Intelligent autocompletion for increased productivity.
- Utilizes Neovim's built-in LSP for robust language support.
- Comprehensive language support including C/C++, Shell, Python, Lua, Java, Rust, and Markdown.
- Debugging support for C/C++, Python, and other languages.
- Integrated REST client for web development and testing.
- Default theme: OneDark, for a modern and sleek interface.

## 1. Dependencies

+ neovim > 0.10
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

## 2. Installation on Manjaro/Archlinux

### 2.1 Install neovim

```shell
sudo pacman -S neovim
sudo ln -sf /usr/bin/nvim /usr/local/bin/vi
sudo ln -sf /usr/bin/nvim /usr/local/bin/vim
```

### 2.2 Install dependencies

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
yay -S jdtls
yay -S noto-color-emoji-fontconfig-no-binding

pip install cmake-language-server

## Install vscode-cpp-tools for debugging c/cpp
wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.10.8/cpptools-linux.vsix
mkdir vscode-cpptools
pushd vscode-cpptools
unzip ../cpptools-linux.vsix
popd
mv vscode-cpptools ~/.local/
chmod +x  ~/.local/vscode-cpptools/extension/debugAdapters/bin/OpenDebugAD7
```

### 2.3 Install pluings

```shell
git clone https://github.com/quintin-lee/NVCode.git ~/.config/nvim
nvim


### If LspInstall gopls fails to fetch, set up a proxy
# Error msg：spawn: go failed with no exit code. go is not executable
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

### 2.4 Install Nerd Fonts

```shell
Nerd Fonts： https://github.com/ryanoasis/nerd-fonts.git
Recommend JetBrainsMono font

cd ~/.config/nvim
bash install_fonts.sh
```

### 2.5 AI Code Suggestions Configuration

To configure the OpenAI API interface directly, set the following environment variables.

```
AVANTE_API_ENDPOINT
AVANTE_MODEL_NAME
AVANTE_API_KEY
```

+ As an example, configuring with ZhiPu Qingyan:

[Official Documentation of ZhiPu Qingyan](https://open.bigmodel.cn/dev/api/normal-model/glm-4)

1. Obtain API Keys

You can visit the [API Keys page](https://bigmodel.cn/usercenter/apikeys) to find the API Key you will use in the request.

2. Verify whether the API Keys can access GLM4

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

3. Configure environment variables

```shell
export AVANTE_API_ENDPOINT=https://open.bigmodel.cn/api/paas/v4
export AVANTE_MODEL_NAME=GLM-4
export AVANTE_API_KEY=f1xxxxxxxxxxxxx05aa5b9b9.wLgWjdxxxxxxRwr  (use your own API_KEY)
```

## 3. Docker

[quintinlee/neovim][1] is the Docker image of NVCode based on Archlinux. You can quickly experience the joy brought by NVCode without installing NVCode.

```shell
docker run -it --rm --privileged -e TERM=screen-256color -v ~/workspace:/workspace -w /workspace crpi-cofuzswrnwwx9atk.cn-beijing.personal.cr.aliyuncs.com/quintinlee/nvcode:0.10 /opt/nvcode/bin/nvcode
```


## 4. Plugin List

| Plugin Name            | Plugin Address                                                | Notes              |
| ---------------------- | ------------------------------------------------------------- | --------------- |
| lazy                   | https://github.com/folke/lazy.nvim                            | Plugin Manager           |
| DAPInstall             | https://github.com/ravenxrz/DAPInstall.nvim                   | Debuggers Manager    |
| LuaSnip                | https://github.com/L3MON4D3/LuaSnip                           |                 |
| bufferline             | https://github.com/akinsho/bufferline.nvim                    | Buffer Bar        |
| cmp-cmdline            | https://github.com/hrsh7th/cmp-cmdline                        |                 |
| cmp-nvim-lsp           | https://github.com/hrsh7th/cmp-nvim-lsp                       |                 |
| cmp-path               | https://github.com/hrsh7th/cmp-path                           |                 |
| cmp_luasnip            | https://github.com/saadparwaiz1/cmp_luasnip                   |                 |
| completion             | https://github.com/nvim-lua/completion-nvim                   | Auto Completion            |
| dashboard              | https://github.com/glepnir/dashboard-nvim                     | Startup screen             |
| diffview               | https://github.com/sindrets/diffview.nvim                     | git diff        |
| dressing               | https://github.com/stevearc/dressing.nvim                     | Optimized tui          |
| FTerm                  | https://github.com/numToStr/FTerm.nvim                        | Floating Terminal            |
| git-blame-virt         | https://github.com/robert-oleynik/git-blame-virt.nvim         | Display git blame    |
| gitsigns               | https://github.com/lewis6991/gitsigns.nvim                    | Display git File Changes     |
| indent-blankline       | https://github.com/lukas-reineke/indent-blankline.nvim        | Alignment Line             |
| lazygit                | https://github.com/kdheepak/lazygit.nvim                      | lazygit         |
| lualine                | https://github.com/nvim-lualine/lualine.nvim                  | Status Bar             |
| neogen                 | https://github.com/danymat/neogen                             | Generate Comments            |
| nightfox               | https://github.com/EdenEast/nightfox.nvim                     | Theme              |
| nlua                   | https://github.com/tjdevries/nlua.nvim                        |                 |
| nvim-cmp               | https://github.com/hrsh7th/nvim-cmp                           |                 |
| nvim-code-action-menu  | https://github.com/weilbith/nvim-code-action-menu             |                 |
| nvim-comment           | https://github.com/terrortylor/nvim-comment                   | Toggle comments |
| nvim-dap               | https://github.com/mfussenegger/nvim-dap                      | Debugging Plugin            |
| nvim-dap-python        | https://github.com/mfussenegger/nvim-dap-python               |                 |
| nvim-dap-ui            | https://github.com/rcarriga/nvim-dap-ui                       |                 |
| nvim-dap-virtual-text  | https://github.com/theHamsta/nvim-dap-virtual-text            |                 |
| nvim-lsp-installer     | https://github.com/williamboman/nvim-lsp-installer            |                 |
| nvim-lspconfig         | https://github.com/neovim/nvim-lspconfig                      | lsp Client         |
| nvim-tree              | https://github.com/kyazdani42/nvim-tree.lua                   | File Tree             |
| nvim-treesitter        | https://github.com/nvim-treesitter/nvim-treesitter            | Enhanced Syntax Highlighting          |
| nvim-web-devicons      | https://github.com/kyazdani42/nvim-web-devicons               | Text Icons            |
| onedark                | https://github.com/navarasu/onedark.nvim                      | Theme              |
| plenary                | https://github.com/nvim-lua/plenary.nvim                      |                 |
| rest                   | https://github.com/NTBBloodbath/rest.nvim                     | REST Client        |
| sessions               | https://github.com/natecraddock/sessions.nvim                 | Session Management      |
| smart-pairs            | https://github.com/ZhiyuanLck/smart-pairs                     | Smart Parentheses            |
| sqlite                 | https://github.com/tami5/sqlite.lua                           |                 |
| symbols-outline        | https://github.com/simrat39/symbols-outline.nvim              | Outline              |
| telescope-file-browser | https://github.com/nvim-telescope/telescope-file-browser.nvim | File Browsing            |
| telescope-frecency     | https://github.com/nvim-telescope/telescope-frecency.nvim     | Search Recently Visited Files |
| telescope-fzf-native   | https://github.com/nvim-telescope/telescope-fzf-native.nvim   |                 |
| telescope              | https://github.com/nvim-telescope/telescope.nvim              | Search Plugin            |
| telescope-symbols      | https://github.com/nvim-telescope/telescope-symbols.nvim      | Search Character Icons        |
| telescope-gitmoji      | https://github.com/olacin/telescope-gitmoji.nvim              | gitmoji Support        |
| todo-comments          | https://github.com/folke/todo-comments.nvim                   | TODO Comment Highlighting       |
| translate              | https://github.com/translate.nvim                             | Translation              |
| vim-illuminate         | https://github.com/RRethy/vim-illuminate                      | Highlight Word Under Cursor         |
| which-key              | https://github.com/folke/which-key.nvim                       | Shortcut Binding           |
| workspaces             | https://github.com/natecraddock/workspaces.nvim               | Workspace Management          |
| nvim-bqf               | https://github.com/kevinhwang91/nvim-bqf                      | Optimized Quickfix Window   |
| openscad.nvim          | https://github.com/salkin-mada/openscad.nvim                  | Support OpenSCAD Syntax   |
| avante.nvim            | https://github.com/yetone/avante.nvim                         | Simulates the behavior of Cursor AI IDE. Provides AI-driven code suggestions to the user. |
| leap.nvim              | https://github.com/ggandor/leap.nvim                          | Cursor Jumping Plugin  |

## 5. References

[awesome neovim][2]


[1]: https://cr.console.aliyun.com/repository/cn-beijing/quintinlee/nvcode
[2]: https://github.com/rockerBOO/awesome-neovim/blob/main/README.md

