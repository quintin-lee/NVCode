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

# 🚀 关键：彻底解引用软链接，消除 tar 的 "link name too long" 报错
echo "🔗 正在创建无链接的扁平化副本 (dereferencing everything)..."
FLAT_DIR="${PROJECT_ROOT}/flat_dist"
rm -rf "$FLAT_DIR"
# 使用 rsync -aL 将所有链接替换为真实文件
rsync -aL "$DIST_DIR/" "$FLAT_DIR/"

# 🚀 关键：体积控制 - 删除冗余的大型二进制文件
# 这些文件已经包含在 AppImage 的 Nix Store 中了，无需在 data 目录重复
echo "🧹 正在清理冗余数据以减小体积..."
# 删除日志、缓存
find "$FLAT_DIR" -name "*.log" -type f -delete || true
rm -rf "$FLAT_DIR/nvcode_data/state/nvcode/shada" || true
rm -rf "$FLAT_DIR/nvcode_data/cache" || true
# 删除所有 .git
find "$FLAT_DIR" -name ".git" -type d -prune -exec rm -rf {} + || true

# 精细化体积控制：删除 data 目录下由于解引用而拷贝进来的大型 Nix Store 依赖
# 我们只保留插件源码 (Lua) 和配置。大型二进制 (clangd, node, etc.) 应该在 PATH 里。
echo "🔍 检查并移除超大冗余文件..."
find "$FLAT_DIR" -type f -size +30M -delete || true

# 显示最终体积
echo "📊 最终打包目录体积："
du -sh "$FLAT_DIR"

# --- 4. 生成启动脚本 (在 FLAT_DIR 中生成) ---
echo "📝 阶段 3: 生成离线启动脚本..."

# 1. 终端启动脚本
cat <<'EOF' > "${FLAT_DIR}/run_offline.sh"
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
chmod +x "${FLAT_DIR}/run_offline.sh"

# 2. 图形化启动脚本
cat <<'EOF' > "${FLAT_DIR}/run_gui_offline.sh"
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
chmod +x "${FLAT_DIR}/run_gui_offline.sh"

# 3. 生成桌面快捷方式
cat <<EOF > "${FLAT_DIR}/NvCode.desktop"
[Desktop Entry]
Name=NvCode IDE
Comment=Graphical Neovim IDE (Offline)
Exec=run_gui_offline.sh %F
Icon=nvim
Terminal=false
Type=Application
Categories=Development;TextEditor;
EOF

# 4. 拷贝安装向导
cp "${PROJECT_ROOT}/scripts/setup_offline.sh" "${FLAT_DIR}/setup.sh"
chmod +x "${FLAT_DIR}/setup.sh"

# --- 5. 最终打包 ---
echo "📚 阶段 4: 正在使用 makeself 制作自解压安装包..."
INSTALLER_NAME="nvcode_installer_$(date +%Y%m%d).run"

MAKESELF_TMP="${PROJECT_ROOT}/makeself_tmp"
rm -rf "$MAKESELF_TMP" && mkdir -p "$MAKESELF_TMP"
export TMPDIR="$MAKESELF_TMP"

# 使用 POSIX 格式提高兼容性
export TAR_OPTIONS="--format=posix"

# 运行打包
makeself "$FLAT_DIR" "$INSTALLER_NAME" "NvCode IDE 离线安装程序" ./setup.sh

# 清理
rm -rf "$MAKESELF_TMP"
rm -rf "$FLAT_DIR"

echo "=================================================="
echo "🎉 一键安装包制作完成！: ${INSTALLER_NAME}"
echo "=================================================="
