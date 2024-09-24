<h1 align="center">NVCode</h1>
<h2 align="center">The Neovim configuration to achieve the power of Modern IDE</h2>

<p align="center">
  <img alt="Stargazers" src="https://img.shields.io/github/stars/quintin-lee/NVCode?logo=starship" />
  <img alt="Made with lua" src="https://img.shields.io/badge/Made%20with%20Lua-blue.svg?logo=lua" />
  <img alt="Minimum neovim version" src="https://img.shields.io/badge/Neovim-0.10.0+-blueviolet.svg?logo=Neovim" />
  <img alt="forks" src="https://img.shields.io/github/forks/quintin-lee/NVCode?logo=forks" />
  <img alt="Issues" src="https://img.shields.io/github/issues/quintin-lee/NVCode?logo=gitbook" />
</p>

## 界面预览

<p float="center" align="middle">
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/startup.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/autocomp.png" width="33%" /> 
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/filebrowser.png " width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/debug.png " width="33%" />
</p>

## 特性

- Fully written in lua
- Easy to install
- Format on save
- Autocompletion
- Uses neovim's native lsp
- Support c/c++, shell, python, lua, java, rust, markdown
- Support c/c++/python Debug

## 1. 依赖

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
git clone https://github.com/quintin-lee/NVCode.git ~/.config/nvim
nvim


### 如果 LspInstall gopls 无法拉取则，设置代理
# 报错信息：spawn: go failed with no exit code. go is not executable
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct
```

### 2.4 安装 Nerd 字体

```shell
Nerd 字体： https://github.com/ryanoasis/nerd-fonts.git
推荐 JetBrainsMono 字体

cd ~/.config/nvim
bash install_fonts.sh
```

### 2.5 AI 代码建议配置

OpenAI 的 API 接口协议直接配置下面的环境变量即可。

```
AVANTE_API_ENDPOINT
AVANTE_MODEL_NAME
AVANTE_API_KEY
```

+ 以智谱清言为例配置如下：

智谱清言[官方文档](https://open.bigmodel.cn/dev/api/normal-model/glm-4)

1. 获取 API Keys

可以访问[API Keys 页面](https://bigmodel.cn/usercenter/apikeys)查找您将在请求中使用的 API Key。

2. 验证 API Keys 是否可以正常访问 GLM4

```shell
curl --location 'https://open.bigmodel.cn/api/paas/v4/chat/completions' \
--header 'Authorization: Bearer <你的apikey>' \
--header 'Content-Type: application/json' \
--data '{
    "model": "glm-4",
    "messages": [
        {
            "role": "user",
            "content": "你好"
        }
    ]
}'
```

3. 配置环境变量

```shell
export AVANTE_API_ENDPOINT=https://open.bigmodel.cn/api/paas/v4
export AVANTE_MODEL_NAME=GLM-4
export AVANTE_API_KEY=f1xxxxxxxxxxxxx05aa5b9b9.wLgWjdxxxxxxRwr  (使用自己的 API_KEY)
```

## 3. Docker

[quintinlee/neovim][1] 是 NVCode 基于 archlinux 的docker镜像，无需安装 NVCode，即可快速体验 NVCode 带来的快乐

```shell
docker run -it quintinlee/neovim
```


## 4. 插件列表

| 插件名                    | 插件地址                                                          | 备注              |
| ---------------------- | ------------------------------------------------------------- | --------------- |
| lazy                   | https://github.com/folke/lazy.nvim                            | 插件管理器           |
| DAPInstall             | https://github.com/ravenxrz/DAPInstall.nvim                   | debuggers 管理    |
| LuaSnip                | https://github.com/L3MON4D3/LuaSnip                           |                 |
| bufferline             | https://github.com/akinsho/bufferline.nvim                    | buffer 栏        |
| cmp-cmdline            | https://github.com/hrsh7th/cmp-cmdline                        |                 |
| cmp-nvim-lsp           | https://github.com/hrsh7th/cmp-nvim-lsp                       |                 |
| cmp-path               | https://github.com/hrsh7th/cmp-path                           |                 |
| cmp_luasnip            | https://github.com/saadparwaiz1/cmp_luasnip                   |                 |
| completion             | https://github.com/nvim-lua/completion-nvim                   | 自动补全            |
| dashboard              | https://github.com/glepnir/dashboard-nvim                     | 启动页             |
| diffview               | https://github.com/sindrets/diffview.nvim                     | git diff        |
| dressing               | https://github.com/stevearc/dressing.nvim                     | 优化 tui          |
| FTerm                  | https://github.com/numToStr/FTerm.nvim                        | 浮动终端            |
| git-blame-virt         | https://github.com/robert-oleynik/git-blame-virt.nvim         | 显示 git blame    |
| gitsigns               | https://github.com/lewis6991/gitsigns.nvim                    | 显示 git 文件变更     |
| indent-blankline       | https://github.com/lukas-reineke/indent-blankline.nvim        | 对齐线             |
| lazygit                | https://github.com/kdheepak/lazygit.nvim                      | lazygit         |
| lualine                | https://github.com/nvim-lualine/lualine.nvim                  | 状态栏             |
| neogen                 | https://github.com/danymat/neogen                             | 生成注释            |
| nightfox               | https://github.com/EdenEast/nightfox.nvim                     | 主题              |
| nlua                   | https://github.com/tjdevries/nlua.nvim                        |                 |
| nvim-cmp               | https://github.com/hrsh7th/nvim-cmp                           |                 |
| nvim-code-action-menu  | https://github.com/weilbith/nvim-code-action-menu             |                 |
| nvim-comment           | https://github.com/terrortylor/nvim-comment                   | Toggle comments |
| nvim-dap               | https://github.com/mfussenegger/nvim-dap                      | 调试插件            |
| nvim-dap-python        | https://github.com/mfussenegger/nvim-dap-python               |                 |
| nvim-dap-ui            | https://github.com/rcarriga/nvim-dap-ui                       |                 |
| nvim-dap-virtual-text  | https://github.com/theHamsta/nvim-dap-virtual-text            |                 |
| nvim-lsp-installer     | https://github.com/williamboman/nvim-lsp-installer            |                 |
| nvim-lspconfig         | https://github.com/neovim/nvim-lspconfig                      | lsp 客户端         |
| nvim-tree              | https://github.com/kyazdani42/nvim-tree.lua                   | 文件树             |
| nvim-treesitter        | https://github.com/nvim-treesitter/nvim-treesitter            | 语法高亮增强          |
| nvim-web-devicons      | https://github.com/kyazdani42/nvim-web-devicons               | 文字图标            |
| onedark                | https://github.com/navarasu/onedark.nvim                      | 主题              |
| plenary                | https://github.com/nvim-lua/plenary.nvim                      |                 |
| rest                   | https://github.com/NTBBloodbath/rest.nvim                     | REST 客户端        |
| sessions               | https://github.com/natecraddock/sessions.nvim                 | session 管理      |
| smart-pairs            | https://github.com/ZhiyuanLck/smart-pairs                     | 智能括号            |
| sqlite                 | https://github.com/tami5/sqlite.lua                           |                 |
| symbols-outline        | https://github.com/simrat39/symbols-outline.nvim              | 大纲              |
| telescope-file-browser | https://github.com/nvim-telescope/telescope-file-browser.nvim | 文件浏览            |
| telescope-frecency     | https://github.com/nvim-telescope/telescope-frecency.nvim     | 搜索最近访问文件        |
| telescope-fzf-native   | https://github.com/nvim-telescope/telescope-fzf-native.nvim   |                 |
| telescope              | https://github.com/nvim-telescope/telescope.nvim              | 搜索插件            |
| telescope-symbols      | https://github.com/nvim-telescope/telescope-symbols.nvim      | 搜索字符图标        |
| telescope-gitmoji      | https://github.com/olacin/telescope-gitmoji.nvim              | 支持 gitmoji        |
| todo-comments          | https://github.com/folke/todo-comments.nvim                   | TODO 注释高亮       |
| translate              | https://github.com/translate.nvim                             | 翻译              |
| vim-illuminate         | https://github.com/RRethy/vim-illuminate                      | 高亮光标下的词         |
| which-key              | https://github.com/folke/which-key.nvim                       | 快捷键绑定           |
| workspaces             | https://github.com/natecraddock/workspaces.nvim               | 工作空间管理          |
| nvim-bqf               | https://github.com/kevinhwang91/nvim-bqf                      | 优化 quickfix 窗口    |
| openscad.nvim          | https://github.com/salkin-mada/openscad.nvim                  | 支持 openscad 语法    |
| avante.nvim            | https://github.com/yetone/avante.nvim                         | 模拟 Cursor AI IDE 的行为。 它为用户提供人工智能驱动的代码建议 |
| leap.nvim              | https://github.com/ggandor/leap.nvim                          | 光标跳转插件 |

## 5. 参考

[awesome neovim](https://github.com/rockerBOO/awesome-neovim/blob/main/README.md)


[1]: https://hub.docker.com/repository/docker/quintinlee/neovim

