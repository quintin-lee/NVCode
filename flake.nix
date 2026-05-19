{
  description = "NvCode - A comprehensive Neovim IDE configuration bundled with its dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # 核心依赖工具：包含 LSP, 格式化工具和运行环境
      ide-tools = with pkgs; [
        # 基础命令
        git ripgrep fd fzf lazygit sqlite
        gnumake gcc binutils coreutils
        curl wget unzip cmake
        
        # 运行时
        nodejs
        python3
        python3Packages.pynvim
        
        # 语言服务 (LSP) & 格式化工具
        lua-language-server
        stylua
        clang-tools # 包含 clangd
        shfmt
        shellcheck
        nil         # Nix LSP
        
        # 图形化客户端
        neovide
        
        # 图形化基础库 (全量协议支持)
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrender
        libGL
        libxkbcommon
        wayland
        fontconfig
        vulkan-loader
        
        # 树解析器
        tree-sitter
      ];

      # 将配置目录打包到 Nix store
      # 我们将所有的配置文件都包含在内
      nvcode-config = pkgs.stdenv.mkDerivation {
        name = "nvcode-config";
        src = ./.;
        installPhase = ''
          mkdir -p $out/nvcode
          # 复制核心配置文件
          cp -r init.lua lua config stylua.toml lazyvim.json $out/nvcode/
          # 如果存在 lock 文件也一并带走
          [ -f lazy-lock.json ] && cp lazy-lock.json $out/nvcode/
        '';
      };

      # 使用原始的 Neovim 二进制文件，避免 Nix 包装干扰配置加载
      neovim-pkg = pkgs.neovim-unwrapped;

      # 包装脚本：
      # 1. 自动处理 XDG 环境，实现配置隔离
      # 2. 将配置从 Nix Store 同步到可写的本地目录（LazyVim 需要写权限）
      # 3. 将所有依赖工具注入 PATH
      nvcode-ide = pkgs.stdenv.mkDerivation {
        pname = "nvcode";
        version = "1.0.0";
        
        # 包装脚本不需要源码，我们直接在 installPhase 中生成
        phases = [ "installPhase" ];

        installPhase = ''
          mkdir -p $out/bin
          cat <<'EOF' > $out/bin/nvcode
          #!/usr/bin/env bash
          set -e
          export NVIM_APPNAME="nvcode"
          
          # 默认使用隔离路径
          export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"
          export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
          export XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"
          export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"
          
          CONFIG_DIR="$XDG_CONFIG_HOME/$NVIM_APPNAME"
          
          # 如果目录不存在，创建它
          mkdir -p "$CONFIG_DIR"

          # 同步配置到本地可写目录
          # 使用 -u (update) 仅同步较新的文件，保留本地可能存在的修改
          ${pkgs.rsync}/bin/rsync -rlptD --chmod=u+w "${nvcode-config}/nvcode/" "$CONFIG_DIR/"

          # 注入依赖到 PATH
          export PATH="${pkgs.lib.makeBinPath ide-tools}:$PATH"

          # 检查是否请求图形界面 (--gui)
          IS_GUI=false
          ARGS=()
          for arg in "$@"; do
            if [ "$arg" == "--gui" ]; then
              IS_GUI=true
            else
              ARGS+=("$arg")
            fi
          done

          if [ "$IS_GUI" = true ]; then
            # 策略：将 Nix 的库路径附加到末尾，优先使用宿主机的驱动库 (如 NVIDIA/Mesa 驱动)
            # 这解决了 libGL 版本不匹配导致的 display handle 错误
            NIX_GUI_LIBS="${pkgs.lib.makeLibraryPath (with pkgs; [ xorg.libX11 libGL libxkbcommon wayland fontconfig vulkan-loader ])}"
            export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$NIX_GUI_LIBS"
            
            # 确保关键环境变量存在
            export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/tmp}"
            
            # 尝试启动函数
            run_neovide() {
              export WINIT_UNIX_BACKEND="$1"
              # 如果是 Wayland，设置对应的环境变量
              [ "$1" == "wayland" ] && export QT_QPA_PLATFORM=wayland || export QT_QPA_PLATFORM=xcb
              
              echo "正在尝试以 $1 后端启动 Neovide..."
              "${pkgs.neovide}/bin/neovide" --neovim-bin "${neovim-pkg}/bin/nvim" "''${ARGS[@]}"
            }

            # 优先尝试 X11，兼容性最强
            if run_neovide x11; then
              exit 0
            fi
            
            # 备选 Wayland
            if run_neovide wayland; then
              exit 0
            fi

            echo "❌ 错误：所有图形后端启动均失败。"
            exit 1
          fi

          # 启动终端版 Neovim
          exec "${neovim-pkg}/bin/nvim" "''${ARGS[@]}"
          EOF
          chmod +x $out/bin/nvcode
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

      devShells.default = pkgs.mkShell {
        name = "nvcode-dev";
        packages = [ nvcode-ide ] ++ ide-tools;
        shellHook = ''
          export NVIM_APPNAME="nvcode"
          export XDG_CONFIG_HOME="$PWD/.config"
          export XDG_DATA_HOME="$PWD/.local/share"
          export XDG_STATE_HOME="$PWD/.local/state"
          export XDG_CACHE_HOME="$PWD/.cache"
          
          mkdir -p "$XDG_CONFIG_HOME/$NVIM_APPNAME"
          # 链接当前目录到配置目录，方便开发
          ln -sf "$PWD"/* "$XDG_CONFIG_HOME/$NVIM_APPNAME/" 2>/dev/null || true
          
          echo "Welcome to NvCode development shell!"
          echo "Run 'nvcode' to start the IDE with local configuration."
        '';
      };
    });
}
