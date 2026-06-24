#!/bin/bash


check_not_root() {
    # Ensure the user is NOT running the script via sudo
        if [ "$(id -u)" = 0 ]; then
            log ERROR "Do NOT run this script as root. Run it as your normal user."
            log ERROR "It will prompt for sudo credentials once at the beginning."
            exit 1
        fi
}

ask_sudo_password() {
    log INFO "Caching sudo credentials for automated execution..."
    sudo -v
    # Keep-alive: update existing sudo time stamp until script finishes
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

check_script_run_with_sudo() {
    # check the script is run with the sudo command
    # if the user is root, $EUID should be 0
    if ! [ $(id -u) = 0 ]; then
        log ERROR "The script need to be run as root."
        exit 1
    fi
}

check_internet() {
    # check internet connection by pinging cloudflare dns (1.1.1.1) and google dns (8.8.8.8)
    if run_cmd ping -c 1 -w 1 8.8.8.8 &> /dev/null || run_cmd ping -c 1 -w 1 1.1.1.1 &> /dev/null; then
        log INFO "Internet check: OK"
    else
        log ERROR "No internet connection. An internet connection is necessary to run the script."
        exit 1
    fi
}

# check_not_root
# ask_sudo_password
check_script_run_with_sudo
check_internet
