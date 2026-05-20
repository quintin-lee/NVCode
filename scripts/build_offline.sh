#!/usr/bin/env bash

# ==============================================================================
# NvCode 离线全量打包脚本
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
TMP_BIN="${DIST_DIR}/nvcode_tmp_bin"
nix bundle --bundler github:NixOS/bundlers#toAppImage "${PROJECT_ROOT}#nvcode" -o "$TMP_BIN"
cp -L "$TMP_BIN" "$BUNDLE_BIN"
rm "$TMP_BIN"
chmod +x "$BUNDLE_BIN"

# --- 3. 预同步插件和依赖 ---
echo "📥 阶段 2: 正在预下载插件 (需要联网)..."

export NVIM_APPNAME="nvcode"
export XDG_CONFIG_HOME="${OFFLINE_DATA_DIR}/config"
export XDG_DATA_HOME="${OFFLINE_DATA_DIR}/share"
export XDG_STATE_HOME="${OFFLINE_DATA_DIR}/state"
export XDG_CACHE_HOME="${OFFLINE_DATA_DIR}/cache"

mkdir -p "${XDG_CONFIG_HOME}/${NVIM_APPNAME}"

if command -v nix &>/dev/null; then
    echo "使用 nix run 进行插件同步..."
    nix run "${PROJECT_ROOT}#nvcode" -- --headless "+Lazy! sync" +qa || echo "⚠️ 插件同步完成"
else
    "$BUNDLE_BIN" --headless "+Lazy! sync" +qa || echo "⚠️ 插件同步完成"
fi

# 🚀 关键：清理数据
echo "🧹 正在清理冗余数据..."
find "$DIST_DIR" -name "*.log" -type f -delete || true
find "$DIST_DIR" -name ".git" -type d -exec rm -rf {} + || true
rm -rf "${OFFLINE_DATA_DIR}/state/nvcode/shada" || true
rm -rf "${OFFLINE_DATA_DIR}/cache/nvcode" || true

# 显示体积详情
echo "📊 离线包体积详情："
du -sh "$DIST_DIR"

# --- 4. 生成启动脚本 ---
echo "📝 阶段 3: 生成离线启动脚本..."

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

cat <<'EOF' > "${DIST_DIR}/run_gui_offline.sh"
#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NVIM_APPNAME="nvcode"
export XDG_CONFIG_HOME="${BASE_DIR}/nvcode_data/config"
export XDG_DATA_HOME="${BASE_DIR}/nvcode_data/share"
export XDG_STATE_HOME="${BASE_DIR}/nvcode_data/state"
export XDG_CACHE_HOME="${BASE_DIR}/nvcode_data/cache"
export NVIM_OFFLINE=1
export WINIT_UNIX_BACKEND=x11
export QT_QPA_PLATFORM=xcb
exec "${BASE_DIR}/nvcode_bin" --gui "$@"
EOF
chmod +x "${DIST_DIR}/run_gui_offline.sh"

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

cp "${PROJECT_ROOT}/scripts/setup_offline.sh" "${DIST_DIR}/setup.sh"
chmod +x "${DIST_DIR}/setup.sh"

# --- 5. 最终打包 ---
echo "📚 阶段 4: 正在使用 makeself 制作自解压安装包..."
INSTALLER_NAME="nvcode_installer_$(date +%Y%m%d).run"

MAKESELF_TMP="${PROJECT_ROOT}/makeself_tmp"
rm -rf "$MAKESELF_TMP" && mkdir -p "$MAKESELF_TMP"
export TMPDIR="$MAKESELF_TMP"

# 🚀 极致兼容方案：
# 1. 强制使用 POSIX 格式 (支持超长路径)
# 2. 强制解引用所有软链接 (-h / --dereference)，确保所有 Nix Store 文件都被物理打入包中
# 3. 明确指定 tar 路径
export TAR="tar -h --format=posix"

# 运行打包
makeself "$DIST_DIR" "$INSTALLER_NAME" "NvCode IDE 离线安装程序" ./setup.sh

rm -rf "$MAKESELF_TMP"

echo "=================================================="
echo "🎉 一键安装包制作完成！: ${INSTALLER_NAME}"
echo "=================================================="
