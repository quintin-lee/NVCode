{
  description = "NvCode - A comprehensive Neovim IDE configuration bundled with its dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
        isLinux = pkgs.stdenv.isLinux;
        isDarwin = pkgs.stdenv.isDarwin;

        # ============================================================
        # 核心依赖 —— 所有系统都必须
        # ============================================================
        coreDeps = with pkgs; [
          git
          ripgrep
          fd
          fzf
          lazygit
          sqlite
          curl
          wget
          unzip
          gnumake
          gcc
          rsync
        ];

        # ============================================================
        # LSP & 格式化工具 —— 按平台筛选
        # ============================================================
        lspDeps = with pkgs; [
          lua-language-server
          stylua
          nodejs
          python3
          python3Packages.pynvim
          tree-sitter
        ]
        ++ lib.optionals isLinux [
          clang-tools # clangd
          shfmt
          shellcheck
          nil # Nix LSP
        ]
        ++ lib.optionals isDarwin [
          shfmt
          shellcheck
          nil
        ];

        # ============================================================
        # 图形化 GUI 依赖 —— 仅终端模式则无需
        # ============================================================
        guiLibs = with pkgs;
          lib.optionals isLinux [
            libx11
            libxcursor
            libxext
            libxfixes
            libxi
            libxrender
            libGL
            libglvnd
            libxkbcommon
            wayland
            fontconfig
            vulkan-loader
            mesa
            # CJK 字体支持
            noto-fonts
            noto-fonts-color-emoji
          ]
          ++ lib.optionals isDarwin [];

        # ============================================================
        # 打包发布工具（仅构建环境）
        # ============================================================
        buildDeps = with pkgs; [
          makeself
          gnutar
          zip
        ];

        # ============================================================
        # 配置目录 —— 导出到 Nix Store
        # ============================================================
        nvcode-config = pkgs.stdenv.mkDerivation {
          name = "nvcode-config";
          src = ./.;
          installPhase = ''
            mkdir -p $out/nvcode
            cp -r init.lua lua stylua.toml lazyvim.json $out/nvcode/
            [ -f lazy-lock.json ] && cp lazy-lock.json $out/nvcode/
            [ -f .neoconf.json ] && cp .neoconf.json $out/nvcode/
            [ -d lua/header-templates ] && cp -r lua/header-templates $out/nvcode/lua/
          '';
        };

        # ============================================================
        # Neovim 原始二进制（跳过 Nix 包装）
        # ============================================================
        neovim-bin = pkgs.neovim-unwrapped;

        # ============================================================
        # 启动脚本
        # ============================================================
        nvcode-ide = pkgs.stdenv.mkDerivation {
          pname = "nvcode";
          version = "1.0.0";
          phases = ["installPhase"];

          installPhase = ''
            mkdir -p $out/bin
            cat <<'SCRIPT' > $out/bin/nvcode
            #!/usr/bin/env bash
            set -euo pipefail

            export NVIM_APPNAME="nvcode"

            # ---- XDG 路径 ----
            export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
            export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
            export XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
            export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"

            CONFIG_DIR="$XDG_CONFIG_HOME/$NVIM_APPNAME"
            mkdir -p "$CONFIG_DIR"

            # ---- 同步配置 ----
            ${pkgs.rsync}/bin/rsync -rlptD --chmod=u+w "${nvcode-config}/nvcode/" "$CONFIG_DIR/"

            # ---- 注入 PATH ----
            export PATH="${pkgs.lib.makeBinPath (coreDeps ++ lspDeps)}:$PATH"

            # ---- 参数解析 ----
            IS_GUI=false
            ARGS=()
            for arg in "$@"; do
              case "$arg" in
                --gui) IS_GUI=true ;;
                *) ARGS+=("$arg") ;;
              esac
            done

            # ========================================
            # GUI 模式
            # ========================================
            if [ "$IS_GUI" = true ]; then
              case "$(uname -s)" in
                Linux)
                  GUI_LIBS="${pkgs.lib.makeLibraryPath guiLibs}:''${LD_LIBRARY_PATH:-}"
                  export LD_LIBRARY_PATH="$GUI_LIBS"
                  export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/tmp}"
                  export WINIT_UNIX_BACKEND="''${WINIT_UNIX_BACKEND:-wayland}"
                  ;;
                Darwin)
                  # macOS: Neovide 使用 Metal，无需额外 libs
                  ;;
              esac

              NEOVIM_BIN="${neovim-bin}/bin/nvim"

              ${pkgs.neovide}/bin/neovide --neovim-bin "$NEOVIM_BIN" "''${ARGS[@]}"
              exit $?
            fi

            # ========================================
            # 终端模式
            # ========================================
            exec "${neovim-bin}/bin/nvim" "''${ARGS[@]}"
            SCRIPT
            chmod +x $out/bin/nvcode
          '';
        };

        # ============================================================
        # devShell —— 构建与开发环境
        # ============================================================
        devShell = pkgs.mkShell {
          name = "nvcode-dev";
          packages = [nvcode-ide neovim-bin] ++ coreDeps ++ lspDeps ++ buildDeps;
          shellHook = ''
            export NVIM_APPNAME="nvcode"
            export XDG_CONFIG_HOME="$PWD/.config"
            export XDG_DATA_HOME="$PWD/.local/share"
            export XDG_STATE_HOME="$PWD/.local/state"
            export XDG_CACHE_HOME="$PWD/.cache"

            mkdir -p "$XDG_CONFIG_HOME/$NVIM_APPNAME"
            ln -sf "$PWD"/* "$XDG_CONFIG_HOME/$NVIM_APPNAME/" 2>/dev/null || true

            echo "NvCode devShell active"
            echo "  nvcode       → 终端模式（当前配置）"
            echo "  nvcode --gui → 图形模式"
            echo "  nvim         → 原始 Neovim（无配置）"
          '';
        };
      in {
        packages = {
          default = nvcode-ide;
          nvcode = nvcode-ide;
          config = nvcode-config;
        };

        apps.default = {
          type = "app";
          program = "${nvcode-ide}/bin/nvcode";
        };

        devShells.default = devShell;
      });
}
