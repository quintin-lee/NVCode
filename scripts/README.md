# NVCode Installation Scripts

This directory contains various installation scripts for setting up NVCode on different systems.

## Scripts

- `install.sh`: Main installation script that creates an isolated Neovim environment with automatic dependency installation
- `install_fonts.sh`: Downloads and installs JetBrains Mono fonts
- `install_env_mac.sh`: macOS environment setup script
- `check_env_mac.sh`: macOS environment checking script

## Linux Installation

### install.sh Features

The main installation script (`install.sh`) creates an isolated Neovim environment (NVCode) with automatic dependency installation:

#### Installation Options

```bash
# Install NVCode (isolated Neovim environment)
./scripts/install.sh -i

# Uninstall NVCode
./scripts/install.sh -u

# Install with custom path
./scripts/install.sh -i -p /custom/path

# Show help
./scripts/install.sh -h
```

#### What the script does

1. **Installs system dependencies** using pacman (Manjaro/Arch-focused):
   - Development tools (base-devel, git, curl, wget, etc.)
   - Search tools (ripgrep, fd, fzf, lazygit)
   - Programming languages (Lua, Node.js, Python)
   - Formatting tools (prettier, sqlfluff, shfmt, stylua)
   - Compiler tools (clang, imagemagick)

2. **Downloads Neovim AppImage** and sets up in isolation mode:
   - Creates an isolated environment with separate config/state/data directories
   - Uses XDG Base Directory specification for clean separation
   - Sets `NVIM_APPNAME=nvcode` to distinguish from regular Neovim

3. **Creates a wrapper script** (`nvcode`) that:
   - Properly sets environment variables (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`)
   - Executes the Neovim AppImage with proper isolation
   - Passes through all arguments to Neovim

4. **Sets up configuration and plugins**:
   - Copies local configuration files or clones from the repository
   - Performs headless plugin installation using Lazy.nvim
   - Pre-installs essential Tree-sitter parsers

#### Isolation Environment

NVCode creates a completely isolated Neovim environment separate from any existing Neovim configuration:

- **Installation Path**: `~/.local/nvcode` (by default)
- **Configuration**: `$INSTALL_ROOT/config/nvcode/`
- **Data Directory**: `$INSTALL_ROOT/share/`
- **State Directory**: `$INSTALL_ROOT/state/`
- **Runtime Directory**: `/tmp/nvcode-$USER/`

This isolation ensures that NVCode won't interfere with existing Neovim configurations and can be safely removed without affecting other setups.

#### Requirements

- Root privileges (for system package installation)
- Git
- Internet connection
- pacman package manager (currently script is optimized for Manjaro/Arch Linux)

#### Customization

The script currently focuses on Manjaro/Arch Linux systems but can be extended to support other distributions by modifying:

1. The `install_deps()` function to use appropriate package managers
2. The dependency lists to match packages available on other distributions

#### Troubleshooting

If you encounter issues during installation:

1. Ensure you have the required permissions for package installation
2. Check that your system is up to date
3. Verify that the required tools (curl, git, etc.) are available
4. Run the script with `bash -x install.sh` to get more detailed output

## macOS Installation

For macOS systems, we provide dedicated scripts to set up the NVCode environment:

### install_env_mac.sh

The `install_env_mac.sh` script automates the setup process for macOS:

#### Installation Options

```bash
# Make the script executable
chmod +x scripts/install_env_mac.sh

# Run the installation
./scripts/install_env_mac.sh
```

#### What the script does

1. **Installs Homebrew** if not already present
2. **Installs all required dependencies** using Homebrew
3. **Installs required fonts** (Noto Color Emoji)
4. **Installs Python-based tools** using pip
5. **Configures the development environment** for optimal performance

#### macOS Requirements

- Xcode Command Line Tools:

  ```bash
  xcode-select --install
  ```

### check_env_mac.sh

The `check_env_mac.sh` script helps verify that all required tools are installed:

```bash
# Make the script executable
chmod +x scripts/check_env_mac.sh

# Run the environment check
./scripts/check_env_mac.sh
```

This script checks for all required tools and reports whether they are installed or missing.
