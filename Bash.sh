#!/bin/bash

set -e
set -x

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}错误: 请提供提交信息!${NC}"
    echo -e "${YELLOW}用法: $0 \"您的提交信息\"${NC}"
    exit 1
fi

COMMIT_MESSAGE="$*"

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo -e "${RED}错误: 当前目录不是一个 Git 仓库。${NC}"
    exit 1
fi

echo -e "${GREEN}Git 自动化脚本启动...${NC}"

if git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}工作区是干净的，没有需要提交的更改。${NC}"
    # 询问是否要强制推送（例如，如果远程分支被重置了）
    read -p "是否要尝试强制推送到远程仓库? (y/N): " force_push_choice
    if [[ "$force_push_choice" == "y" || "$force_push_choice" == "Y" ]]; then
        echo -e "${YELLOW}正在尝试推送到远程...${NC}"
        git push --force-with-lease main main
        exit 0
    else
        echo "操作取消。"
        exit 0
    fi
fi

echo -e "\n${GREEN}>>> 步骤 1/3: 执行 'git add -A'${NC}"

git add -A

if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 'git add -A' 执行失败。${NC}"
    exit 1
fi
echo "所有更改已暂存。"

echo -e "\n${GREEN}>>> 步骤 2/3: 执行 'git commit'${NC}"

git commit -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 'git commit' 执行失败。${NC}"
    exit 1
fi
echo "提交成功，信息: \"$COMMIT_MESSAGE\""

echo -e "\n${GREEN}>>> 步骤 3/3: 执行 'git push main main'${NC}"

git push main main

if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 'git push main main' 执行失败。${NC}"
    echo -e "${YELLOW}请检查：\n1. 网络连接是否正常。\n2. 是否有远程冲突 (可尝试手动 'git pull' 后再试)。\n3. 您是否有推送到该仓库的权限。${NC}"
    exit 1
fi

echo -e "\n${GREEN}✅ 操作成功！所有更改已成功推送到远程仓库。${NC}"

exit 0