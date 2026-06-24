#!/bin/bash

# Colors
RED="\e[31m"      # Error
GREEN="\e[32m"    # Success
YELLOW="\e[33m"   # Warning
BLUE="\e[34m"     # Info
MAGENTA="\e[35m"  # Debug
CYAN="\e[36m"     # Dry Run
NC="\e[0m"        # No Color / Reset

# variable
DRY_RUN=0
SBS=0

parse_commands() {
    # $@ expand into a list of parameter, so we iterate other the arguments
    for arg in "$@"; do

        # check proper format of the argument: VAR=VALUE
        if [[ $arg == *=* ]]; then
            varname="${arg%%=*}"
            value="${arg#*=}"

            # check if the variable actually exist
            if [[ -v $varname ]]; then
                declare -g "$varname=$value"
            else
                log ERROR "Unknown variable $varname"
                exit 1
            fi
        else
            log ERROR "Invalid argument format: $arg"
            exit 1
        fi
    done
}

validate_global_value() {
    if [[ "$DRY_RUN" != "0" && "$DRY_RUN" != "1"  ]]; then
        log ERROR "DRY_RUN can only take 0 or 1 (1=enabled)"
        exit 1
    fi
}

run_cmd() {
    if [[ $SBS -eq 1 ]]; then
        while true; do
            echo
            echo "cmd: $*"
            read -rp "[y] run, [s] skip, [q] quit: " ans
            case "$ans" in
                y|Y)
                    break
                    ;;
                s|S)
                    log INFO "Skipped: $*"
                    return 0
                    ;;
                q|Q)
                    log INFO "Aborted by user"
                    exit 1
                    ;;
                *)
                    echo "Please enter y, s, or q."
                    ;;
            esac
        done
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
        log DRY_RUN "$*"
        return 0
    fi

    log INFO "Executing: $*"
    "$@"
}

timestamp() {
     date +"%Y-%m-%d %H:%M:%S"
}

log() {
    # called like: LOG LEVEL "Message"
    local level=$1 # assign LEVEL var from the first argument
    shift   # remove first argument, left only with "Message"
    case "$level" in
        INFO)    echo -e "[$(timestamp)] ${BLUE}[INFO]${NC} $*" ;;
        WARN)    echo -e "[$(timestamp)] ${YELLOW}[WARN]$*${NC}" ;;
        ERROR)   echo -e "[$(timestamp)] ${RED}[ERROR]$*${NC}" ;;
        DEBUG)   echo -e "[$(timestamp)] ${MAGENTA}[DEBUG]${NC} $*" ;;
        SUCCESS) echo -e "[$(timestamp)] ${GREEN}[OK]$*${NC}" ;;
        DRY_RUN) echo -e "[$(timestamp)] ${CYAN}[DRY_RUN] $*${NC}" ;;
        *)       echo -e "[$(timestamp)] [LOG]$*${NC}" ;;
    esac
}

confirm() {
    echo "$1"
    read -rp "Do you want to continue? (y/n): " ans
    [[ "$ans" =~ ^[Yy]$ ]]
}
