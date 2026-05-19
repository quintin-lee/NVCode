#!/usr/bin/env bash

# ==============================================================================
# NvCode 离线集成安装脚本 (makeself 专用)
# 功能：将解压后的离线包永久安装到系统中
# ==============================================================================

set -euo pipefail

# 默认安装路径
DEFAULT_DEST="$HOME/.local/lib/nvcode"
DEST_DIR="$DEFAULT_DEST"

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}NvCode IDE 一键安装向导${NC}"

# 1. 确认安装路径
read -p "程序将安装到 $DEST_DIR (Y/n): " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    read -p "请输入自定义安装路径: " custom_path
    DEST_DIR="${custom_path/#\~/$HOME}"
fi

# 2. 拷贝文件到永久目录
echo "正在部署文件到 $DEST_DIR ..."
mkdir -p "$DEST_DIR"
# . (当前目录) 是 makeself 解压后的临时目录
cp -r ./* "$DEST_DIR/"

# 3. 注册桌面快捷方式
echo "正在注册桌面快捷方式..."
mkdir -p "$HOME/.local/share/applications"
DESKTOP_FILE="$HOME/.local/share/applications/nvcode.desktop"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=NvCode IDE
Comment=Graphical Neovim IDE (Offline)
Exec=${DEST_DIR}/run_gui_offline.sh %F
Icon=nvim
Terminal=false
Type=Application
Categories=Development;TextEditor;
EOF
chmod +x "$DESKTOP_FILE"

# 4. 添加命令行快捷方式 (通过 Shell 别名或环境变量)
echo "正在配置命令行快捷方式..."

# 检测当前 Shell
CURRENT_SHELL=$(basename "$SHELL")
RC_FILE=""
ALIAS_CMD="alias nvcode='${DEST_DIR}/run_offline.sh'"
GUI_ALIAS_CMD="alias gnvcode='${DEST_DIR}/run_gui_offline.sh'"

case "$CURRENT_SHELL" in
    zsh)  RC_FILE="$HOME/.zshrc" ;;
    bash) RC_FILE="$HOME/.bashrc" ;;
    fish) RC_FILE="$HOME/.config/fish/config.fish" 
          ALIAS_CMD="alias nvcode '${DEST_DIR}/run_offline.sh'"
          GUI_ALIAS_CMD="alias gnvcode '${DEST_DIR}/run_gui_offline.sh'"
          ;;
    *)    RC_FILE="" ;;
esac

if [ -n "$RC_FILE" ]; then
    echo "检测到 $CURRENT_SHELL，准备写入 $RC_FILE ..."
    if ! grep -q "nvcode" "$RC_FILE"; then
        echo -e "\n# NvCode IDE Aliases" >> "$RC_FILE"
        echo "$ALIAS_CMD" >> "$RC_FILE"
        echo "$GUI_ALIAS_CMD" >> "$RC_FILE"
        echo "别名已添加到 $RC_FILE"
    else
        echo "别名已存在于 $RC_FILE，跳过写入。"
    fi
else
    # 回退方案：创建一个绝对路径的包装脚本，而不是软链接
    echo "未识别的 Shell，正在创建绝对路径包装脚本..."
    mkdir -p "$HOME/.local/bin"
    cat <<EOF > "$HOME/.local/bin/nvcode"
#!/usr/bin/env bash
exec "${DEST_DIR}/run_offline.sh" "\$@"
EOF
    chmod +x "$HOME/.local/bin/nvcode"
fi

# 5. 提示
echo -e "\n${GREEN}==================================================${NC}"
echo -e "${BOLD}安装成功！${NC}"
echo -e "--------------------------------------------------"
echo -e "1. 您现在可以在应用菜单中找到 ${BOLD}NvCode IDE${NC}。"
echo -e "2. ${BOLD}请重启终端${NC} 或执行 ${BOLD}source $RC_FILE${NC} 以使命令生效。"
echo -e "3. 终端命令: ${BOLD}nvcode${NC} (命令行) 或 ${BOLD}gnvcode${NC} (图形界面)"
echo -e "4. 安装位置: $DEST_DIR"
echo -e "${GREEN}==================================================${NC}\n"
