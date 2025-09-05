#!/bin/bash

# load library function and var
. scripts/lib.sh

check_internet() {
    if ping -c 1 -w 1 8.8.8.8 &> /dev/null || ping -c 1 -w 1 1.1.1.1 &> /dev/null; then
        log INFO "Internet check: OK"
    else
        log ERROR "No internet connection. An internet connection is necessary to run the script."
        exit 1
    fi
}

check_internet
