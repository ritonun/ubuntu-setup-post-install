#!/bin/bash

# Colors
RED="\e[31m"      # Error
GREEN="\e[32m"    # Success
YELLOW="\e[33m"   # Warning
BLUE="\e[34m"     # Info
MAGENTA="\e[35m"  # Debug
NC="\e[0m"        # No Color / Reset

timestamp() {
     date +"%Y-%m-%d %H:%M:%S"
}

log() {
    # called like: LOG LEVEL "Message"
    local level=$1 # assign LEVEL var from the first argument
    shift   # remove first argument, left only with "Message"
    case "$level" in
        INFO)    echo -e "${BLUE}[INFO] $*${NC} " ;;
        WARN)    echo -e "${YELLOW}[WARN] $*${NC}" ;;
        ERROR)   echo -e "${RED}[ERROR] $*${NC}" ;;
        DEBUG)   echo -e "${MAGENTA}[DEBUG] $*${NC}" ;;
        SUCCESS) echo -e "${GREEN}[OK] $*${NC}" ;;
        *)       echo -e "[LOG] $*" ;;
    esac
}
echo -e "[$(timestamp)] ${RED} Hello"
