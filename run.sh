#!/bin/bash


if ! command -v curl >/dev/null 2>&1; then
    echo -e "\033[0;31mError: curl is not installed.\033[0m"
    echo -e "\033[0;34mPlease install curl with: pkg install curl\033[0m"
    exit 1
fi


SCRIPT_URL="https://raw.githubusercontent.com/Kolandone/Usque-Installer/main/usque.sh"


echo -e "\033[0;34mDownloading and running usque manager...\033[0m"
if curl -fsSL "$SCRIPT_URL" | source /dev/stdin; then
    echo -e "\033[0;32mUsque manager executed successfully.\033[0m"
else
    echo -e "\033[0;31mError: Failed to download or execute the script.\033[0m"
    exit 1
fi
