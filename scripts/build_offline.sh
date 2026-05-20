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
# 使用临时位置存放软链接
TMP_BIN="${DIST_DIR}/nvcode_tmp_bin"
nix bundle --bundler github:NixOS/bundlers#toAppImage "${PROJECT_ROOT}#nvcode" -o "$TMP_BIN"

# 将软链接指向的真实文件拷贝出来，确保包内是原始文件而非链接
cp -L "$TMP_BIN" "$BUNDLE_BIN"
rm "$TMP_BIN"
chmod +x "$BUNDLE_BIN"

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

# 在 CI 环境或本地有 Nix 的环境下，直接使用 nix run 来同步插件
# 这比运行打包后的 AppImage 更可靠，避免了权限和 FUSE 问题
if command -v nix &>/dev/null; then
    echo "使用 nix run 进行插件同步..."
    nix run "${PROJECT_ROOT}#nvcode" -- --headless "+Lazy! sync" +qa || echo "⚠️ 插件同步完成 (忽略退出码)"
else
    echo "使用构建好的二进制进行插件同步..."
    "$BUNDLE_BIN" --headless "+Lazy! sync" +qa || echo "⚠️ 插件同步完成 (忽略退出码)"
fi

# 清理同步产生的临时日志和数据，减小体积并提高兼容性
echo "🧹 正在清理打包环境 (logs/shada/sockets)..."
# 彻底清理日志
find "$DIST_DIR" -name "*.log" -type f -delete || true
# 清理 Neovim 状态
rm -rf "${OFFLINE_DATA_DIR}/state/nvcode/shada" || true
# 清理缓存
rm -rf "${OFFLINE_DATA_DIR}/cache/nvcode" || true
# 关键：清理可能导致 tar 失败的套接字 (sockets) 和管道 (pipes)
find "$DIST_DIR" -type s -delete || true
find "$DIST_DIR" -type p -delete || true

# --- 4. 生成离线启动脚本 (终端 & 图形化)...

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

# --- 图形化稳定性增强 (离线包专用) ---
# 强制使用 X11 后端 (通过 XWayland)。这在打包环境下是解决显示句柄错误最有效的办法。
export WINIT_UNIX_BACKEND=x11
export QT_QPA_PLATFORM=xcb

echo "启动图形化界面 (强制 X11 模式以提高兼容性)..."

# 启动图形化模式
exec "${BASE_DIR}/nvcode_bin" --gui "$@"
EOF
chmod +x "${DIST_DIR}/run_gui_offline.sh"

# 3. 生成桌面快捷方式 (.desktop)
cat <<EOF > "${DIST_DIR}/NvCode.desktop"
[Desktop Entry]
Name=NvCode IDE
Comment=Graphical Neovim IDE (Offline)
Exec=run_gui_offline.sh %F
Icon=nvim
Terminal=false
Type=Application
Categories=Development;TextEditor;
EOF
chmod +x "${DIST_DIR}/NvCode.desktop"

# 4. 包含一键集成脚本
cp "${PROJECT_ROOT}/scripts/setup_offline.sh" "${DIST_DIR}/setup.sh"
chmod +x "${DIST_DIR}/setup.sh"

# --- 5. 最终打包 ---
echo "📚 阶段 4: 正在使用 makeself 制作自解压安装包..."
INSTALLER_NAME="nvcode_installer_$(date +%Y%m%d).run"

# 设置一个在当前工作区内的临时目录，确保拥有完全的读写权限，避免 CI 环境下的权限限制
MAKESELF_TMP="${PROJECT_ROOT}/makeself_tmp"
mkdir -p "$MAKESELF_TMP"
export TMPDIR="$MAKESELF_TMP"

# 使用 makeself 打包
# 参数: <目录> <输出文件名> <描述> <解压后运行的命令>
makeself "$DIST_DIR" "$INSTALLER_NAME" "NvCode IDE 离线安装程序" ./setup.sh

# 清理打包临时目录
rm -rf "$MAKESELF_TMP"

echo "=================================================="
echo "🎉 一键安装包制作完成！"
echo "文件名称: ${INSTALLER_NAME}"
echo "--------------------------------------------------"
echo "如何使用："
echo "1. 将此 .run 文件拷贝到离线 Linux 机器。"
echo "2. 运行: bash ${INSTALLER_NAME}"
echo "=================================================="
