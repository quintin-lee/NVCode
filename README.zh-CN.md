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

# 💤 nvcode - 增强版 LazyVim 配置

一个基于 [LazyVim](https://github.com/LazyVim/LazyVim) 的全面 Neovim 配置，包含额外的自定义功能和工具，旨在提高工作效率。

<p float="center" align="middle">
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/startup.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/autocomp.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/filebrowser.png " width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/debug.png " width="33%" />
</p>

## 🚀 功能特性

### 核心增强

- **LazyVim 基础**: 建立在 LazyVim 稳定的插件生态系统之上
- **自定义仪表板**: 使用 Snacks.nvim 创建美观的 ASCII 艺术欢迎屏幕
- **增强选项**: 优化设置，包括相对行号、4 空格缩进和剪贴板集成
- **智能键映射**: 自定义快捷键，包括终端切换和 Gitmoji 提交

### 开发工具

- **浮动终端**: 通过 FTerm.nvim 实现无缝终端访问，快捷键为 `<A-i>`
- **Gitmoji 集成**: 通过 `<leader>gc` 实现带有表情符号选择的增强提交工作流
- **代码助手**: AI 辅助编码功能
- **文件头**: 自动插入包含作者/日期信息的文件头

### UI/UX 改进

- **现代配色方案**: 多种主题选项，包括 TokyoNight
- **Snacks.nvim**: 增强的仪表板和通知
- **双边框窗口**: 统一的窗口样式
- **透明效果**: 浮动窗口的微妙透明度

## ⚙️ 关键绑定

| 模式     | 快捷键       | 描述                    |
| -------- | ------------ | ----------------------- |
| 普通模式 | `<A-i>`      | 切换浮动终端            |
| 终端模式 | `<A-i>`      | 关闭浮动终端            |
| 普通模式 | `<leader>gc` | 打开 Gitmoji 提交选择器 |

## 🔧 自定义配置

### 编辑器选项

- 将 leader 键映射到空格 (` `)
- 启用相对行号
- 制表符设置：4 个空格，展开制表符
- 与系统剪贴板集成
- 当前行高亮

### 插件分类

1. **UI**: Snacks.nvim 用于仪表板和通知
2. **颜色主题**: 增强的主题管理
3. **工具**: FTerm, 集成 Gitmoji 扩展的 Telescope
4. **代码助手**: AI 编码辅助
5. **头部**: 自动文件头模板

## 📁 项目结构

```
nvcode/
├── init.lua                 # 主入口点
├── .neoconf.json           # Neovim LSP 配置
├── stylua.toml             # Lua 代码格式化配置
├── lazy-lock.json          # 插件锁定文件
├── lazyvim.json            # LazyVim 配置
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # 自动命令
│   │   ├── keymaps.lua     # 自定义键映射
│   │   ├── lazy.lua        # Lazy 插件管理器设置
│   │   └── options.lua     # 编辑器选项
│   ├── plugins/
│   │   ├── ui.lua          # UI 增强
│   │   ├── colorscheme.lua # 主题配置
│   │   ├── tools.lua       # 开发工具
│   │   ├── codecompanion.lua # AI 编码工具
│   │   └── header.lua      # 文件头模板
│   └── tools/
├── config/
│   └── header/             # 各种语言的模板文件
└── README.md
```

## 🛠️ 系统依赖

在安装此配置之前，请确保您已安装以下系统依赖：

- **Neovim**: 版本 0.11+ (必需)
- **Git**: 版本 2.19+ (插件管理必需)
- **Node.js**: 最新LTS版本 (用于LSP和格式化工具)
- **npm** 或 **yarn**: JavaScript/TypeScript 工具包管理器
- **Python**: 版本 3.8+ 并安装 `pynvim` (用于Python LSP)
- **ripgrep**: `rg` 命令，用于 telescope 模糊查找
- **fzf**: 模糊查找命令行工具
- **GCC/G++**: 用于编译某些插件和LSP服务器
- **CMake**: 用于构建一些 Neovim 插件
- **Go**: 如果您计划处理 Go 项目 (可选)
- **Java JDK**: 用于 Java LSP 支持 (可选)
- **LazyGit**: 用于增强的 git 功能 (可选)

## 🛠️ 安装

1. 此配置需要 Neovim 0.9+ 和 Git
2. 如果尚未安装，请克隆 LazyVim（由 lazy.lua 自动处理）
3. 首次启动后使用 `:Lazy sync` 安装插件
4. 通过修改 `lua/plugins/` 目录中的文件来自定义插件

## 📁 环境配置

为了实现适当的隔离和便携性，此配置使用自定义环境变量来重定向 Neovim 的目录：

```bash
#!/bin/bash

NVIM_PATH=$(readlink -f $0)
NVIM_BIN_PATH=$(dirname ${NVIM_PATH})
NVIM_DIR=${NVIM_BIN_PATH}/../

NVIM_APPNAME=nvcode
XDG_CONFIG_HOME=${NVIM_DIR}/config
XDG_DATA_HOME=${NVIM_DIR}/share
XDG_STATE_HOME=${NVIM_DIR}/state

NVIM_APPNAME=$NVIM_APPNAME XDG_CONFIG_HOME=$XDG_CONFIG_HOME XDG_DATA_HOME=$XDG_DATA_HOME XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_STATE_HOME=$XDG_STATE_HOME ${NVIM_BIN_PATH}/nvim-linux-x86_64.appimage "$@"
```

此脚本确保所有配置、数据和状态文件都包含在 nvcode 目录结构中，保持系统清洁有序。

## 📝 文件头模板

多种语言的自动文件头生成：

- Bash 脚本
- C/C++
- Java
- Go
- 以及更多...

文件头包含自动填充的作者、日期和描述字段。

## 🎨 主题

提供多种配色方案，具有优化设置：

- TokyoNight (默认)
- Habamax
- 可在 `lua/plugins/colorscheme.lua` 中添加其他主题

## 🤖 代码助手

集成 AI 驱动的编码辅助，以增强生产力和代码补全。

## 📦 插件管理

- 使用 lazy.nvim 进行高效的插件加载
- 版本设置为最新提交，以获取前沿功能
- 启用定期插件更新检查
- 通过禁用默认插件进行性能优化

## 💡 哲学

此配置旨在在功能强大和简单易用之间取得平衡，在保持直观使用的同时提供高级功能。它建立在 LazyVim 出色的基础之上，同时添加了自定义工作流和工具，以增强开发体验。

## 🙏 致谢

- [LazyVim](https://github.com/LazyVim/LazyVim) 提供了惊人的基础
- 所有贡献插件的作者们，他们的工作使此配置成为可能
- Neovim 社区提供的持续灵感和支持

## 🌐 贡献

欢迎 Fork 并自定义此配置以满足您的需求。欢迎提交改进的拉取请求！
