#!/bin/bash
# DLP Validator 安装路径
DLP_PATH="/root/vana-dlp-chatgpt"

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

# 检查并安装Docker
if ! command -v docker &> /dev/null; then
    echo "未检测到 Docker，正在安装..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    echo "Docker 已安装。"
else
    echo "Docker 已安装。"
fi

echo "在 Docker 容器中安装 DLP Validator 节点..."
docker run -it --name dlp-validator-container -e PATH="/root/.local/bin:$PATH" -w /root ubuntu:22.04 /bin/bash
