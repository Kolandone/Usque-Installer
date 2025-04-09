#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

check_usque() {
    if command -v usque >/dev/null 2>&1; then
        return 0
    else                                                        return 1
    fi
}

install_usque() {
    echo -e "${BLUE}Installing usque...${NC}"
    pkg update -y && pkg install git golang -y
    mkdir -p "$HOME/usque"
    cd "$HOME/usque" || exit
    git clone https://github.com/Diniboy1123/usque.git
    cd usque || exit
    go build .
    if [ $? -eq 0 ]; then
        chmod +x usque
        echo "export PATH=\$PATH:$HOME/usque/usque" >> "$HOME/.bashrc"
        source "$HOME/.bashrc"
    else
        echo -e "${RED}Error installing usque${NC}"
        exit 1
    fi
}

stop_usque() {
    echo -e "${BLUE}Stopping usque processes...${NC}"
    pkill -f usque
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}usque processes stopped.${NC}"
    else
        echo -e "${RED}No processes found to stop.${NC}"
    fi
}

run_usque() {
    stop_usque
    case $1 in
        1) echo -e "${BLUE}Running HTTP Proxy on IPv4${NC}"; usque http-proxy --ipv4 ;;
        2) echo -e "${BLUE}Running HTTP Proxy on IPv6${NC}"; usque http-proxy --ipv6 ;;
        3) echo -e "${BLUE}Running SOCKS5 on IPv4${NC}"; usque socks --ipv4 ;;
        4) echo -e "${BLUE}Running SOCKS5 on IPv6${NC}"; usque socks --ipv6 ;;
        5) echo -e "${BLUE}Register${NC}"; usque register ;;
        6) echo -e "${BLUE}Show usque version${NC}"; usque version ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
}

show_menu() {
    clear
    echo -e "${GREEN}=== usque Manager ===${NC}"
    echo "1) Run HTTP Proxy on IPv4 (port 8000)"
    echo "2) Run HTTP Proxy on IPv6 (port 8000)"
    echo "3) Run SOCKS5 on IPv4 (port 1080)"
    echo "4) Run SOCKS5 on IPv6 (port 1080)"
    echo "5) Register"
    echo "6) Show usque version"
    echo "7) Stop usque processes"
    echo "8) Exit"
    echo -e "${BLUE}Select an option (1-8): ${NC}"
}

main() {
    if ! check_usque; then
        echo -e "${RED}usque is not installed.${NC}"
        install_usque
    fi

    while true; do
        show_menu
        read -r choice
        case $choice in
            1|2|3|4|5|6) run_usque "$choice" ;;
            7) stop_usque ;;
            8) echo -e "${GREEN}Exiting script...${NC}"; break ;;
            *) echo -e "${RED}Invalid option, try again.${NC}" ;;
        esac
        echo -e "${BLUE}Press Enter to continue...${NC}"
        read -r
    done
}

main
