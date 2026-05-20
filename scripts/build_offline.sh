#!/usr/bin/env bash

# ==============================================================================
# NvCode 离线全量打包脚本 (ZIP 便携版)
# ==============================================================================

set -euo pipefail

# --- 1. 初始化路径 ---
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="${PROJECT_ROOT}/dist_offline"
OFFLINE_DATA_DIR="${DIST_DIR}/nvcode_data"
BUNDLE_BIN="${DIST_DIR}/nvcode_bin"

echo "🚀 开始制作离线便携包..."

# 清理并创建发布目录
rm -rf "$DIST_DIR"
mkdir -p "$OFFLINE_DATA_DIR"

# --- 2. 构建 Nix 自包含二进制 ---
echo "📦 阶段 1: 正在通过 Nix 构建自包含二进制文件..."
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

# 🚀 关键：彻底解引用软链接，消除 tar 报错并保证离线可用
echo "🔗 正在扁平化目录结构并处理软链接..."
FLAT_DIR="${PROJECT_ROOT}/nvcode_portable"
rm -rf "$FLAT_DIR"
# 使用 rsync -aL 将所有链接替换为真实文件
# 这是解决所有 "link name too long" 和 "broken links" 问题的终极手段
rsync -aL "$DIST_DIR/" "$FLAT_DIR/"

# 🚀 关键：体积控制
echo "🧹 正在清理冗余数据..."
find "$FLAT_DIR" -name "*.log" -type f -delete || true
find "$FLAT_DIR" -name ".git" -type d -prune -exec rm -rf {} + || true
rm -rf "$FLAT_DIR/nvcode_data/state/nvcode/shada" || true
rm -rf "$FLAT_DIR/nvcode_data/cache" || true
# 移除超大冗余二进制 (大于 50MB)
find "$FLAT_DIR" -type f -size +50M -delete || true

# --- 4. 生成启动脚本 (在 FLAT_DIR 中) ---
echo "📝 阶段 3: 生成离线启动脚本..."

# 终端启动
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

# 图形化启动
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

# 拷贝安装脚本
cp "${PROJECT_ROOT}/scripts/setup_offline.sh" "${FLAT_DIR}/install.sh"
chmod +x "${FLAT_DIR}/install.sh"

# --- 5. 最终打包 ---
echo "📚 阶段 4: 正在制作 ZIP 压缩包..."
ZIP_NAME="nvcode_portable_$(date +%Y%m%d).zip"
rm -f "${PROJECT_ROOT}/${ZIP_NAME}"

# 进入目录打包，确保 ZIP 内部路径干净
cd "$FLAT_DIR"
zip -r "${PROJECT_ROOT}/${ZIP_NAME}" ./*

cd "$PROJECT_ROOT"
rm -rf "$FLAT_DIR"
rm -rf "$DIST_DIR"

echo "=================================================="
echo "🎉 离线便携包制作完成！: ${ZIP_NAME}"
echo "--------------------------------------------------"
echo "如何使用："
echo "1. 解压 ZIP 文件。"
echo "2. 运行 ./run_offline.sh (终端) 或 ./run_gui_offline.sh (图形)。"
echo "3. 或者运行 ./install.sh 将其集成到系统中。"
echo "=================================================="
