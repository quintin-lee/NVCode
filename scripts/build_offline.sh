#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST_DIR="${PROJECT_ROOT}/dist_offline"
OFFLINE_DATA_DIR="${DIST_DIR}/nvcode_data"
BUNDLE_BIN="${DIST_DIR}/nvcode_bin"

echo "🚀 开始制作离线便携包..."
rm -rf "$DIST_DIR"
mkdir -p "$OFFLINE_DATA_DIR"

# Stage 1: nix bundle creates self-contained AppImage with tools
echo "📦 阶段 1: 使用 nix bundle 创建自包含二进制..."
nix bundle --bundler github:NixOS/bundlers#toAppImage "${PROJECT_ROOT}#nvcode" -o "$BUNDLE_BIN"
chmod +x "$BUNDLE_BIN" || true

# Stage 2: Pre-sync plugins
echo "📥 阶段 2: 正在预下载插件 (需要联网)..."
export NVIM_APPNAME="nvcode"
export XDG_CONFIG_HOME="${OFFLINE_DATA_DIR}/config"
export XDG_DATA_HOME="${OFFLINE_DATA_DIR}/share"
export XDG_STATE_HOME="${OFFLINE_DATA_DIR}/state"
export XDG_CACHE_HOME="${OFFLINE_DATA_DIR}/cache"
mkdir -p "${XDG_CONFIG_HOME}/${NVIM_APPNAME}"

if [ -f "$BUNDLE_BIN" ]; then
    "$BUNDLE_BIN" --headless "+Lazy sync" +qa 2>&1 || echo "⚠️ 插件同步完成"
fi

# Stage 3: Flatten symlinks
FLAT_DIR="${PROJECT_ROOT}/nvcode_portable"
rm -rf "$FLAT_DIR"

# Flatten with rsync (exclude lock/tmp files to avoid "vanished" errors)
rsync -aL --exclude="*.lock" --exclude="*~" --exclude="*.tmp" --exclude="*.part" \
    --ignore-errors "$DIST_DIR/" "$FLAT_DIR/"

# Cleanup
find "$FLAT_DIR" -name "*.log" -type f -delete || true
rm -rf "$FLAT_DIR/nvcode_data/state/nvcode/shada" || true
rm -rf "$FLAT_DIR/nvcode_data/cache" || true
find "$FLAT_DIR" -type f -size +50M -delete || true

# Generate startup scripts
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

cp "${PROJECT_ROOT}/scripts/setup_offline.sh" "${FLAT_DIR}/install.sh"
chmod +x "${FLAT_DIR}/install.sh"

# Create ZIP
ZIP_NAME="nvcode_portable_$(date +%Y%m%d).zip"
rm -f "${PROJECT_ROOT}/${ZIP_NAME}"
cd "$FLAT_DIR"
zip -r "${PROJECT_ROOT}/${ZIP_NAME}" ./*
cd "$PROJECT_ROOT"
rm -rf "$FLAT_DIR"
rm -rf "$DIST_DIR"

echo "🎉 离线便携包制作完成！: ${ZIP_NAME}"
