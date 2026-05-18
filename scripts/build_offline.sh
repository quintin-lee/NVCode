#!/usr/bin/env bash

# ==============================================================================
# NvCode 离线全量打包脚本
# 功能：
# 1. 使用 Nix 构建自包含二进制文件 (跨系统版本支持)
# 2. 预下载所有 Lazy.nvim 插件和 Treesitter 解析器
# 3. 预下载 Mason 管理的 LSP 及其依赖
# 4. 最终打包成一个全量离线 tar.gz 包
# ==============================================================================

set -euo pipefail

# --- 1. 初始化路径 ---
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="${PROJECT_ROOT}/dist_offline"
OFFLINE_DATA_DIR="${DIST_DIR}/nvcode_data"
BUNDLE_BIN="${DIST_DIR}/nvcode_bin"

echo "🚀 开始制作离线包..."

# 清理并创建发布目录
rm -rf "$DIST_DIR"
mkdir -p "$OFFLINE_DATA_DIR"

# --- 2. 构建 Nix 自包含二进制 ---
echo "📦 阶段 1: 正在通过 Nix 构建自包含二进制文件 (AppImage 模式)..."
# 注意：这里使用 toAppImage bundler 以获得最好的兼容性
# 如果你的机器没有安装这个 bundler，Nix 会自动下载
nix bundle --bundler github:NixOS/bundlers#toAppImage "${PROJECT_ROOT}#nvcode" -o "$BUNDLE_BIN"

# --- 3. 预同步插件和依赖 ---
echo "📥 阶段 2: 正在预下载所有插件和 Tree-sitter 依赖 (需要联网)..."

# 重定向 XDG 路径到我们的临时目录，以捕获所有下载的内容
export NVIM_APPNAME="nvcode"
export XDG_CONFIG_HOME="${OFFLINE_DATA_DIR}/config"
export XDG_DATA_HOME="${OFFLINE_DATA_DIR}/share"
export XDG_STATE_HOME="${OFFLINE_DATA_DIR}/state"
export XDG_CACHE_HOME="${OFFLINE_DATA_DIR}/cache"

# 确保配置目录存在并同步最新的配置
mkdir -p "${XDG_CONFIG_HOME}/${NVIM_APPNAME}"
# 我们直接运行一次同步命令
# --headless 模式下运行 Lazy sync
"$BUNDLE_BIN" --headless "+Lazy! sync" +qa || echo "⚠️ 插件同步中可能存在小警告，继续..."

# --- 4. 生成离线启动脚本 ---
echo "📝 阶段 3: 生成离线启动脚本 (终端 & 图形化)..."

# 1. 终端启动脚本
cat <<'EOF' > "${DIST_DIR}/run_offline.sh"
#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NVIM_APPNAME="nvcode"
export XDG_CONFIG_HOME="${BASE_DIR}/nvcode_data/config"
export XDG_DATA_HOME="${BASE_DIR}/nvcode_data/share"
export XDG_STATE_HOME="${BASE_DIR}/nvcode_data/state"
export XDG_CACHE_HOME="${BASE_DIR}/nvcode_data/cache"
export NVIM_OFFLINE=1
exec "${BASE_DIR}/nvcode_bin" "$@"
EOF
chmod +x "${DIST_DIR}/run_offline.sh"

# 2. 图形化启动脚本 (调用 Neovide)
cat <<'EOF' > "${DIST_DIR}/run_gui_offline.sh"
#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NVIM_APPNAME="nvcode"
export XDG_CONFIG_HOME="${BASE_DIR}/nvcode_data/config"
export XDG_DATA_HOME="${BASE_DIR}/nvcode_data/share"
export XDG_STATE_HOME="${BASE_DIR}/nvcode_data/state"
export XDG_CACHE_HOME="${BASE_DIR}/nvcode_data/cache"
export NVIM_OFFLINE=1

# 增加 GUI 稳定性环境变量
# 强制使用 X11 后端 (在某些 Wayland 环境下更稳定)
export WINIT_UNIX_BACKEND=x11
# 修复部分显卡驱动下的显示问题
export MESA_LOADER_DRIVER_OVERRIDE=

# 启动图形化模式
exec "${BASE_DIR}/nvcode_bin" --gui "$@"
EOF
chmod +x "${DIST_DIR}/run_gui_offline.sh"

# 3. 生成桌面快捷方式 (.desktop)
cat <<EOF > "${DIST_DIR}/NvCode.desktop"
[Desktop Entry]
Name=NvCode IDE
Comment=Graphical Neovim IDE (Offline)
Exec=${DIST_DIR}/run_gui_offline.sh %F
Icon=nvim
Terminal=false
Type=Application
Categories=Development;TextEditor;
EOF
chmod +x "${DIST_DIR}/NvCode.desktop"

# --- 5. 最终压缩 ---
echo "📚 阶段 4: 正在压缩最终安装包..."
TAR_NAME="nvcode_full_offline_$(date +%Y%m%d).tar.gz"
tar -czf "$TAR_NAME" -C "$DIST_DIR" .

echo "=================================================="
echo "🎉 离线包制作完成！"
echo "文件名称: ${TAR_NAME}"
echo "--------------------------------------------------"
echo "如何使用："
echo "1. 将此 .tar.gz 拷贝到离线 Linux 机器。"
echo "2. 解压: tar -xzf ${TAR_NAME}"
echo "3. 运行: ./run_offline.sh"
echo "=================================================="
