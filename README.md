<h1 align="center">NVCode</h1>
<h2 align="center">The Neovim configuration to achieve the power of Modern IDE</h2>

<p align="center">
  <img alt="Stargazers" src="https://img.shields.io/github/stars/quintin-lee/NVCode?logo=starship" />
  <img alt="Made with lua" src="https://img.shields.io/badge/Made%20with%20Lua-blue.svg?logo=lua" />
  <img alt="Minimum neovim version" src="https://img.shields.io/badge/Neovim-0.10.0+-blueviolet.svg?logo=Neovim" />
  <img alt="forks" src="https://img.shields.io/github/forks/quintin-lee/NVCode?logo=forks" />
  <img alt="Issues" src="https://img.shields.io/github/issues/quintin-lee/NVCode?logo=gitbook" />
</p>

English | [中文版](README.zh-CN.md)

# 💤 nvcode - Enhanced LazyVim Configuration

A comprehensive Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim) with additional customizations and tools tailored for enhanced productivity.

<p float="center" align="middle">
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/startup.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/autocomp.png" width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/filebrowser.png " width="33%" />
  <img src="https://raw.githubusercontent.com/quintin-lee/NVCode/master/screenshots/debug.png " width="33%" />
</p>

## 🚀 Features

### Core Enhancements

- **LazyVim Foundation**: Built on top of LazyVim's robust plugin ecosystem
- **Custom Dashboard**: Beautiful ASCII art welcome screen using Snacks.nvim
- **Enhanced Options**: Optimized settings including 4-space tabs and column cursor highlighting
- **Smart Keymaps**: Custom shortcuts including dual-mode terminal and gitmoji commits

### Development Tools

- **Dual Terminal**: Floating terminal (`<A-i>`) and bottom split terminal (`<A-\>`) powered by Snacks
- **Snacks Picker**: 40+ built-in picker sources for files, grep, buffers, LSP, git, and GitHub
- **Gitmoji Integration**: Enhanced commit workflow with emoji selection via `<leader>gc`
- **Git Hunk Management**: Full gitsigns integration with hunk navigation, staging, blame, and diff
- **Code Companion**: AI-assisted coding with OpenCode, Gemini, and Qwen adapters
- **File Headers**: Automatic insertion of file headers with author/date info
- **Quick File Jump**: grapple.nvim for cross-project file tagging with `<leader>1-5` navigation
- **Text Objects**: nvim-surround for managing brackets, quotes, and HTML tags
- **Task Runner**: overseer.nvim for running builds, tests, and LSP-discovered tasks from a unified panel
- **Multi-Cursor**: vim-visual-multi for batch editing with `<C-n>` word selection

### UI/UX Improvements

- **Modern Color Schemes**: Kanagawa (default) and OneDark themes
- **Snacks.nvim**: Dashboard, notifications, animations, indent guides, and picker
- **Edgy Panels**: IDE-style edge panels (neo-tree left, outline right) via `<leader>te`
- **Image Rendering**: Inline image display in Kitty terminal via image.nvim

## ⚙️ Key Bindings

### Terminal

| Mode     | Shortcut       | Description                  |
| -------- | -------------- | ---------------------------- |
| Normal   | `<A-i>`        | Toggle floating terminal     |
| Terminal | `<A-i>`        | Close floating terminal      |
| Normal   | `<A-\>`        | Toggle split terminal        |

### Git (gitsigns)

| Shortcut       | Description                  |
| -------------- | ---------------------------- |
| `]h` / `[h`    | Next / previous hunk         |
| `<leader>hs`   | Stage hunk                   |
| `<leader>hr`   | Reset hunk                   |
| `<leader>hu`   | Undo stage hunk              |
| `<leader>hp`   | Preview hunk                 |
| `<leader>hb`   | Blame line (popup)           |
| `<leader>hB`   | Blame buffer                 |
| `<leader>htb`  | Toggle line blame            |
| `<leader>hd`   | Diff this                    |
| `<leader>hts`  | Toggle signs                 |
| `<leader>htn`  | Toggle line number highlight |
| `<leader>htw`  | Toggle word diff             |

### Others

| Shortcut       | Description                  |
| -------------- | ---------------------------- |
| `<leader>gc`   | Open gitmoji commit selector |
| `<leader>ga`   | Tag / untag file (grapple)   |
| `<leader>1-5`  | Jump to tagged file by index |
| `<leader>gt`   | Open grapple tags panel      |
| `<leader>te`   | Toggle edgy side panels      |

### Surround (nvim-surround)

| Sequence      | Description                  |
| ------------- | ---------------------------- |
| `ysiw'`       | Wrap word with single quotes |
| `cs'"`        | Change `'` to `"`            |
| `ds"`         | Delete surrounding `"`       |
| `yssb`        | Wrap line with parentheses   |

### Task Runner (overseer)

| Shortcut       | Description                         |
| -------------- | ----------------------------------- |
| `<leader>oo`   | Toggle task panel                   |
| `<leader>or`   | Run a task                          |
| `<leader>oa`   | Quick action (smart recommendation) |
| `<leader>ob`   | Build                               |
| `<leader>ox`   | Clear task cache                    |

### Multi-Cursor (vim-visual-multi)

| Shortcut      | Description                       |
| ------------- | --------------------------------- |
| `<C-n>`       | Select word and add cursor        |
| `<C-x>`       | Skip current match                |
| `<C-p>`       | Remove previous cursor            |
| `n`           | Extend selection to next          |
| `q`           | Skip current, add next            |
| `I`           | Insert at all cursor starts       |
| `A`           | Insert at all cursor ends         |

## 🔧 Custom Configuration

### Editor Options

- Map leader to space (` `)
- Tab settings: 4 spaces (overrides LazyVim's default 2)
- Current column highlighting enabled

### Plugin Categories

1. **UI**: Snacks.nvim (dashboard, picker, terminal, indent guides), edgy.nvim (edge panels)
2. **Colorscheme**: Kanagawa (default) + OneDark
3. **Git**: gitsigns (inline blame, hunk ops) + vgit.nvim (visual diff) + grapple.nvim (file tags)
4. **AI**: copilot.lua (inline completion) + CodeCompanion (chat/edit/agent)
5. **Code**: blink.cmp (completion), nvim-surround (text objects), vim-visual-multi (multi-cursor), IDE features (treesitter-context, todo-comments)
6. **Task**: overseer.nvim (build/test runner, LSP task discovery)
7. **Media**: image.nvim (inline image rendering in Kitty terminal)
8. **Header**: Automatic file header templates
9. **PlatformIO**: Embedded development toolchain

## 📁 Project Structure

```
nvcode/
├── init.lua                 # Main entry point
├── .neoconf.json           # Neovim LSP configuration
├── stylua.toml             # Lua code formatter config
├── lazy-lock.json          # Plugin lock file
├── lazyvim.json            # LazyVim configuration
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Custom key mappings
│   │   ├── lazy.lua        # Lazy plugin manager setup
│   │   └── options.lua     # Editor options
│   ├── plugins/
│   │   ├── ai/             # AI (copilot, CodeCompanion)
│   │   ├── editor/         # Text editing (surround, multi-cursor, context, headers)
│   │   ├── tools/          # Tools (git, blink, LSP, task runner, PlatformIO)
│   │   └── ui/             # UI (dashboard, edgy, media, colorscheme)
│   └── tools/
│   ├── tools/
│   │   ├── emojis.lua      # Gitmoji emoji data
│   │   └── git-commit.lua  # Gitmoji commit picker
│   └── header-templates/   # File header template files
├── scripts/
│   ├── install.sh          # Full installation logic
│   ├── build-offline.sh    # Build offline bundle
│   ├── setup-offline.sh    # Setup offline environment
│   ├── install-fonts.sh    # Font installation
│   ├── docker/             # Docker packaging
│   └── README.md           # Scripts documentation
├── .github/
├── docker/                 # (moved to scripts/docker/)
├── config/                 # (moved to lua/header-templates/)
├── after/                  # (removed)
└── README.md
```

## 🛠️ System Dependencies

Before installing this configuration, ensure you have the following system dependencies:

- **Neovim**: Version 0.11+ (required)
- **Git**: Version 2.19+ (required for plugin management)
- **Node.js**: Latest LTS version (for LSP and formatters)
- **npm** or **yarn**: Package managers for JavaScript/TypeScript tools
- **Python**: Version 3.8+ with `pynvim` (for Python LSP)
- **ripgrep**: `rg` command for content searching
- **GCC/G++**: For compiling certain plugins and LSP servers
- **CMake**: For building some Neovim plugins
- **Go**: If you plan to work with Go projects (optional)
- **Java JDK**: For Java LSP support (optional)
- **LazyGit**: For enhanced git functionality (optional)

## 🛠️ Setup

### Nix (Recommended)

If you have [Nix](https://nixos.org/) installed, you can run NvCode directly without manually installing any dependencies:

```bash
# Run directly
nix run github:quintin-lee/NVCode

# Or if you have the repo cloned locally
nix run .
```

This will automatically pull all required LSPs, formatters, and tools into an isolated environment.

### Portable Release (Offline & One-Click)

For users on machines without Nix or internet access:

1. Go to the [Releases](https://github.com/quintin-lee/NVCode/releases) page.
2. Download the latest `nvcode_portable_*.zip`.
3. Extract the ZIP and run `./run_offline.sh` (Terminal) or `./run_gui_offline.sh` (Graphical).
4. Run `./install.sh` inside the extracted folder for full system integration.

### Manual Installation

1. This configuration requires Neovim 0.11+ and Git
2. Clone LazyVim if not already installed (automatically handled by lazy.lua)
3. Install plugins with `:Lazy sync` after first launch
4. Customize plugins by modifying files in the `lua/plugins/` directory

## 📁 Environment Configuration

For proper isolation and portability, this configuration uses custom environment variables to redirect Neovim's directories:

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

This script ensures that all configuration, data, and state files are contained within the nvcode directory structure, keeping your system clean and organized.

## 📝 File Header Templates

Automatic file header generation for multiple languages:

- Bash scripts
- C/C++
- Java
- Go
- And more...

Headers include author, date, and description fields that are automatically filled.

## 🎨 Themes

Multiple color schemes available with optimized settings:

- Kanagawa (default)
- OneDark
- Additional themes can be added in `lua/plugins/colorscheme.lua`

## 🤖 AI Coding Assistance

- **Copilot**: Inline code completion as you type
- **CodeCompanion**: Multi-model AI chat, inline editing, and agent mode (OpenCode, Gemini, Qwen)
  - Custom commit message generation from staged changes (`/commit`)
  - Adapter switching via `<leader>Ct`
  - Offline mode via `NVIM_OFFLINE=1` environment variable

## 🚦 Common Workflows

**Git Commit:** `<leader>gc` → pick emoji and scope → write message → `<C-s>` commit / `<C-c>` cancel.

**Code Review:** `<leader>hd` to diff → `]h`/`[h` navigate → `<leader>hp` preview → `<leader>hs`/`<leader>hr` stage/reset hunk.

**Multi-Cursor Edit:** `<C-n>` on a word to start → continue `<C-n>` for more → `<C-x>` to skip → `I`/`A` to insert at cursor start/end → `<Esc>` to exit.

**Task & Build:** `<leader>oo` open panel → `<leader>or` list tasks → auto-detected from LSP → `<leader>ob` quick re-run.

**Diagnostics:** `]e`/`[e` errors, `]w`/`[w` warnings → `<leader>cd` line float → `<leader>xx` Trouble panel → `<leader>ud` toggle all.

## 📦 Plugin Management

- Using lazy.nvim for efficient plugin loading
- Version set to latest commit for cutting-edge features
- Periodic plugin update checking enabled
- Performance optimizations with disabled default plugins

## 💡 Philosophy

This configuration aims to provide a balance between power and simplicity, offering advanced features while maintaining intuitive usage. It builds upon LazyVim's excellent foundation while adding custom workflows and tools that enhance the development experience.

## 🙏 Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) for the amazing foundation
- All the plugin authors whose work makes this configuration possible
- The Neovim community for continuous inspiration and support

## 🌐 Contributing

Feel free to fork and customize this configuration to suit your needs. Pull requests for improvements are welcome!
