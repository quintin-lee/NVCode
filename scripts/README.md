# NVCode Installation Scripts

This directory contains various installation scripts for setting up NVCode on different systems.

## Scripts

- `install.sh`: Main installation script that supports multiple Linux distributions
- `install_fonts.sh`: Downloads and installs JetBrains Mono fonts
- `install_env_mac.sh`: macOS environment setup script
- `check_env_mac.sh`: macOS environment checking script

## Linux Installation

### install.sh Features

The main installation script (`install.sh`) has been enhanced to support multiple Linux distributions:

#### Supported Distributions

- **Arch Linux / Manjaro**: Using `pacman` package manager
- **Ubuntu / Debian / Linux Mint**: Using `apt` package manager
- **Fedora / CentOS / RHEL / Rocky Linux / AlmaLinux**: Using `dnf` package manager
- **openSUSE / SLES**: Using `zypper` package manager

#### Installation Options

```bash
# Install NVCode
./scripts/install.sh -i

# Uninstall NVCode
./scripts/install.sh -u
```

#### What the script does

1. **Detects your Linux distribution** and uses the appropriate package manager
2. **Installs Neovim** (version 0.11 or higher) with proper symlinks
3. **Installs all required dependencies** specific to your distribution
4. **Sets up AI tools** and development utilities
5. **Installs JetBrains Mono fonts** for the best experience
6. **Clones the NVCode configuration** to `~/.config/nvim`
7. **Installs all plugins** using Lazy.nvim
8. **Configures Go proxy** for faster downloads

#### Requirements

- Root privileges (for package installation)
- Git
- Internet connection

#### Customization

If you need to customize the installation for your specific setup, you can:

1. Check the OS detection logic in the `get_os_info()` function
2. Modify the dependency lists in the corresponding `*_install_requirements()` functions
3. Adjust the package names as needed for your distribution

#### Troubleshooting

If you encounter issues during installation:

1. Ensure you have the required permissions for package installation
2. Check that your system is up to date
3. Verify that the required tools (curl, wget, etc.) are available
4. Run the script with `bash -x` to get more detailed output

#### Adding Support for New Distributions

To add support for a new Linux distribution:

1. Add the distribution ID to the `get_os_info()` function
2. Create a new `*_install_neovim()` function for the distribution
3. Create a new `*_install_requirements()` function with the appropriate packages
4. Test the installation thoroughly

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

