# 💤 nvcode - Enhanced LazyVim Configuration

A comprehensive Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim) with additional customizations and tools tailored for enhanced productivity.

## 🚀 Features

### Core Enhancements

- **LazyVim Foundation**: Built on top of LazyVim's robust plugin ecosystem
- **Custom Dashboard**: Beautiful ASCII art welcome screen using Snacks.nvim
- **Enhanced Options**: Optimized settings including relative numbering, 4-space tabs, and clipboard integration
- **Smart Keymaps**: Custom shortcuts including terminal toggle and gitmoji commits

### Development Tools

- **Floating Terminal**: FTerm.nvim for seamless terminal access with `<A-i>` shortcut
- **Gitmoji Integration**: Enhanced commit workflow with emoji selection via `<leader>gc`
- **Code Companion**: AI-assisted coding capabilities
- **File Headers**: Automatic insertion of file headers with author/date info

### UI/UX Improvements

- **Modern Color Schemes**: Multiple theme options including TokyoNight
- **Snacks.nvim**: Enhanced dashboard and notifications
- **Double Border Windows**: Consistent window styling
- **Transparency Effects**: Subtle transparency for floating windows

## ⚙️ Key Bindings

| Mode     | Shortcut     | Description                  |
| -------- | ------------ | ---------------------------- |
| Normal   | `<A-i>`      | Toggle floating terminal     |
| Terminal | `<A-i>`      | Close floating terminal      |
| Normal   | `<leader>gc` | Open gitmoji commit selector |

## 🔧 Custom Configuration

### Editor Options

- Map leader to space (` `)
- Relative line numbers enabled
- Tab settings: 4 spaces, expand tabs
- Clipboard integration with system clipboard
- Current line highlighting

### Plugin Categories

1. **UI**: Snacks.nvim for dashboard and notifications
2. **Colorscheme**: Enhanced theme management
3. **Tools**: FTerm, Telescope with gitmoji extension
4. **Code Companion**: AI coding assistance
5. **Header**: Automatic file header templates

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
│   │   ├── ui.lua          # UI enhancements
│   │   ├── colorscheme.lua # Theme configurations
│   │   ├── tools.lua       # Development tools
│   │   ├── codecompanion.lua # AI coding tools
│   │   └── header.lua      # File header templates
│   └── tools/
├── config/
│   └── header/             # Template files for various languages
└── README.md
```

## 🛠️ System Dependencies

Before installing this configuration, ensure you have the following system dependencies:

- **Neovim**: Version 0.11+ (required)
- **Git**: Version 2.19+ (required for plugin management)
- **Node.js**: Latest LTS version (for LSP and formatters)
- **npm** or **yarn**: Package managers for JavaScript/TypeScript tools
- **Python**: Version 3.8+ with `pynvim` (for Python LSP)
- **ripgrep**: `rg` command for telescope fuzzy finder
- **fzf**: Fuzzy finder command-line tool
- **GCC/G++**: For compiling certain plugins and LSP servers
- **CMake**: For building some Neovim plugins
- **Go**: If you plan to work with Go projects (optional)
- **Java JDK**: For Java LSP support (optional)
- **LazyGit**: For enhanced git functionality (optional)

## 🛠️ Setup

1. This configuration requires Neovim 0.9+ and Git
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

- TokyoNight (default)
- Habamax
- Additional themes can be added in `lua/plugins/colorscheme.lua`

## 🤖 Code Companion

Integrated AI-powered coding assistance for enhanced productivity and code completion.

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
