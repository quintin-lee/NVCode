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
- **增强选项**: 优化设置，包括 4 空格缩进和当前列高亮
- **智能键映射**: 自定义快捷键，包括双模式终端和 Gitmoji 提交

### 开发工具

- **双模式终端**: 浮动终端 (`<A-i>`) + 底部分割终端 (`<A-\>`)，由 Snacks 驱动
- **Snacks Picker**: 40+ 内置搜索源（文件、全文搜索、缓冲区、LSP、Git、GitHub）
- **Gitmoji 集成**: 通过 `<leader>gc` 实现带有表情符号选择的增强提交工作流
- **Git Hunk 管理**: 完整的 gitsigns 集成（hunk 导航、暂存、Blame、Diff）
- **AI 编程助手**: 支持 OpenCode、Gemini、Qwen 等多种模型
- **文件头**: 自动插入包含作者/日期信息的文件头
- **快速文件跳转**: grapple.nvim 跨项目文件标记，`<leader>1-5` 编号直达
- **文本对象**: nvim-surround 管理括号、引号、HTML 标签包围
- **任务运行器**: overseer.nvim 统一管理构建、测试和 LSP 发现的 task
- **多光标**: vim-visual-multi 多光标批量编辑，`<C-n>` 选词后同时编辑

### UI/UX 改进

- **现代配色方案**: Kanagawa（默认）和 OneDark 主题
- **Snacks.nvim**: 仪表板、通知、动画、缩进参考线、Picker
- **Edgy 面板**: IDE 风格侧边栏（neo-tree 左 / outline 右）
- **图片渲染**: Kitty 终端内嵌显示图片

## ⚙️ 关键绑定

### 终端

| 模式     | 快捷键        | 描述            |
| -------- | ------------- | --------------- |
| 普通模式 | `<A-i>`       | 切换浮动终端    |
| 终端模式 | `<A-i>`       | 关闭浮动终端    |
| 普通模式 | `<A-\>`       | 切换底部分割终端 |

### Git (gitsigns)

| 快捷键            | 描述                   |
| ----------------- | ---------------------- |
| `]h` / `[h`       | 下一个 / 上一个 hunk   |
| `<leader>hs`      | 暂存 hunk              |
| `<leader>hr`      | 重置 hunk              |
| `<leader>hu`      | 撤销暂存               |
| `<leader>hp`      | 预览 hunk              |
| `<leader>hb`      | Blame 弹窗（当前行）   |
| `<leader>hB`      | Blame 全文件           |
| `<leader>htb`     | 切换行尾 blame         |
| `<leader>hd`      | Diff 对比              |
| `<leader>hts`     | 切换 sign 列           |
| `<leader>htn`     | 切换行号高亮            |
| `<leader>htw`     | 切换单词级 diff        |

### 其他

| 快捷键        | 描述                 |
| ------------- | -------------------- |
| `<leader>gc`  | 打开 Gitmoji 提交选择器 |
| `<leader>ga`  | 标记/取消标记文件（grapple） |
| `<leader>1-5` | 按编号跳转已标记文件 |
| `<leader>gt`  | 打开 grapple tags 面板 |
| `<leader>te`  | 切换 edgy 侧栏 |

### Task Runner (overseer)

| 快捷键        | 描述                   |
| ------------- | ---------------------- |
| `<leader>oo`  | 切换任务面板           |
| `<leader>or`  | 运行任务               |
| `<leader>oa`  | 快速操作（智能推荐）    |
| `<leader>ob`  | 构建                   |
| `<leader>ox`  | 清除任务缓存           |

### 多光标 (vim-visual-multi)

| 按键     | 描述                       |
| -------- | -------------------------- |
| `<C-n>`  | 选中单词并添加光标         |
| `<C-x>`  | 跳过当前匹配               |
| `<C-p>`  | 移除上一个光标             |
| `n`      | 扩展选区到下一处           |
| `q`      | 跳过当前并添加下一处       |
| `I`      | 在所有光标行首插入         |
| `A`      | 在所有光标行尾插入         |

### Surround (nvim-surround)

| 按键          | 描述                   |
| ------------- | ---------------------- |
| `ysiw'`       | 给单词加单引号          |
| `cs'"`        | 双引号 → 单引号         |
| `ds"`         | 删除周围双引号          |
| `yssb`        | 给整行加括号            |

## 🔧 自定义配置

### 编辑器选项

- 将 leader 键映射到空格 (` `)
- 制表符设置：4 个空格（覆盖 LazyVim 默认的 2 空格）
- 当前列高亮显示

### 插件分类

1. **UI**: Snacks.nvim（仪表板、Picker、终端、缩进参考线）、edgy.nvim（边缘面板）
2. **颜色主题**: Kanagawa（默认）+ OneDark
3. **Git**: gitsigns（行内 blame、hunk 操作）+ vgit.nvim（可视化 diff）+ grapple.nvim（文件标记）
4. **AI**: copilot.lua（行内补全）+ CodeCompanion（对话/编辑/Agent）
5. **代码**: blink.cmp（补全引擎）、nvim-surround（文本对象）、vim-visual-multi（多光标）、IDE 功能（上下文保持、TODO 高亮）
6. **任务**: overseer.nvim（构建/测试运行器，LSP task 发现）
7. **多媒体**: image.nvim（Kitty 终端内嵌图片渲染）
8. **文件头**: 自动文件头模板
9. **PlatformIO**: 嵌入式开发工具链

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
│   │   ├── ai.lua          # AI 插件 (copilot, CodeCompanion)
│   │   ├── blink.lua       # 补全引擎 (blink.cmp)
│   │   ├── code-features.lua # 代码上下文 & TODO 高亮
│   │   ├── codecompanion.lua # AI 对话 & Agent 配置
│   │   ├── colorscheme.lua # 主题配置
│   │   ├── edgy.lua        # 边缘面板
│   │   ├── git.lua         # Git 工具 (gitsigns, vgit)
│   │   ├── header.lua      # 文件头模板
│   │   ├── lsp.lua         # LSP 服务器覆盖
│   │   ├── media.lua       # 图片渲染
│   │   ├── navigation.lua  # 快速文件跳转 (grapple)
│   │   ├── overseer.lua    # 任务运行器
│   │   ├── platformio.lua  # PlatformIO 嵌入式开发
│   │   ├── surround.lua    # 包围字符管理
│   │   ├── ui.lua          # Snacks 仪表板与缩进参考线
│   │   └── vim-visual-multi.lua # 多光标编辑
│   ├── tools/
│   │   ├── emojis.lua      # Gitmoji 表情数据
│   │   └── git-commit.lua  # Gitmoji 提交选择器
│   └── header-templates/   # 文件头模板文件
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
- **ripgrep**: `rg` 命令，用于内容搜索
- **GCC/G++**: 用于编译某些插件和LSP服务器
- **CMake**: 用于构建一些 Neovim 插件
- **Go**: 如果您计划处理 Go 项目 (可选)
- **Java JDK**: 用于 Java LSP 支持 (可选)
- **LazyGit**: 用于增强的 git 功能 (可选)

## 🛠️ 安装

### Nix (推荐)

如果您安装了 [Nix](https://nixos.org/)，可以直接运行 NvCode 而无需手动安装任何依赖：

```bash
# 直接运行
nix run github:quintin-lee/NVCode

# 或者如果您已在本地克隆了仓库
nix run .
```

这将自动将所有必需的 LSP、格式化工具和工具拉取到隔离的环境中。

### 便携离线版 (一键式 & 离线使用)

对于没有安装 Nix 或无法访问互联网的机器：

1. 前往 [Releases](https://github.com/quintin-lee/NVCode/releases) 页面。
2. 下载最新的 `nvcode_portable_*.zip`。
3. 解压 ZIP 并运行 `./run_offline.sh` (终端版) 或 `./run_gui_offline.sh` (图形版)。
4. 运行解压文件夹内的 `./install.sh` 进行全系统集成。

### 手动安装

1. 此配置需要 Neovim 0.11+ 和 Git
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

- Kanagawa（默认）
- OneDark
- 可在 `lua/plugins/colorscheme.lua` 中添加其他主题

## 🤖 AI 编程助手

- **Copilot**: 行内代码补全
- **CodeCompanion**: 多模型 AI 对话、内联编辑和 Agent 模式（OpenCode、Gemini、Qwen）
  - 从暂存更改生成提交消息（`/commit` 命令）
  - 通过 `<leader>Ct` 切换适配器
  - 通过 `NVIM_OFFLINE=1` 环境变量支持离线模式

## 🚦 常用工作流

**Git 提交:** `<leader>gc` → 选 emoji/scope → 写信息 → `<C-s>` 提交 / `<C-c>` 取消。

**Code Review:** `<leader>hd` 对比 → `]h`/`[h` 导航 → `<leader>hp` 预览 → `<leader>hs`/`<leader>hr` 暂存/重置 hunk。

**多光标编辑:** `<C-n>` 开始选词 → 继续 `<C-n>` 添加更多 → `<C-x>` 跳过 → `I`/`A` 行首尾插入 → `<Esc>` 退出。

**任务与构建:** `<leader>oo` 面板 → `<leader>or` 列表（自动从 LSP 发现）→ `<leader>ob` 快速重跑。

**诊断导航:** `]e`/`[e` 错误，`]w`/`[w` 警告 → `<leader>cd` 浮动窗 → `<leader>xx` Trouble 面板 → `<leader>ud` 切换显示。

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
