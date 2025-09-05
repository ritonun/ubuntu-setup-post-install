#!/bin/bash

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

check_script_run_with_sudo
check_internet
