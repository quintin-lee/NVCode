ARG OS=ubuntu:22.04
FROM ${OS}

ENV DEBIAN_FRONTEND=noninteractive

# 阶段 1: 安装依赖
# 注意 Fedora 行增加了 shadow-utils 和 passwd
RUN case $(cat /etc/os-release | grep ^ID= | cut -d'=' -f2) in \
    ubuntu) \
        apt-get update && apt-get install -y sudo curl ca-certificates locales git build-essential && rm -rf /var/lib/apt/lists/* ;; \
    arch) \
        pacman -Syu --noconfirm sudo curl grep git base-devel;; \
    esac

# 修复 Locale
RUN if [ -f /etc/debian_version ]; then \
        locale-gen en_US.UTF-8; \
    fi

# 阶段 2: 创建用户 (Fedora 修复版)
# 使用 chpasswd 设置密码，而不是删除密码
RUN useradd -m -s /bin/bash tester && \
    echo "tester:123456" | chpasswd && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/tester && \
    chmod 0440 /etc/sudoers.d/tester

USER tester
WORKDIR /home/tester

# 阶段 3: 脚本
COPY --chown=tester:tester install.sh .
RUN chmod +x install.sh

# 执行安装
RUN ./install.sh -i && \
    ls -la ~/.local/nvcode/bin/nvcode

ENTRYPOINT ["/home/tester/.local/nvcode/bin/nvcode"]
