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
            echo "CMD:"
            printf ' %q ' "$@"
            echo
            read -rp "[y] run, [s] skip, [q] quit: " ans < /dev/tty

            case "$ans" in
                y|Y) break ;;
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

    local start=$(date +%s)

    log INFO "Executing: $*"
    if "$@"; then
        local rc=0
        local elapsed=$(( $(date +%s) - start ))
        log SUCCESS "Succeeded (${elapsed}s): $*"
        return 0
    else
        local rc=$?
        local elapsed=$(( $(date +%s) - start ))
        log ERROR "Failed (rc=$rc, ${elapsed}s): $*"
        return "$rc"
    fi
}

timestamp() {
     date +"%Y-%m-%d %H:%M:%S"
}

log() {
    local level=$1
    shift

    local msg

    case "$level" in
        INFO)    msg="[$(timestamp)] [INFO] $*" ;;
        WARN)    msg="[$(timestamp)] [WARN] $*" ;;
        ERROR)   msg="[$(timestamp)] [ERROR] $*" ;;
        DEBUG)   msg="[$(timestamp)] [DEBUG] $*" ;;
        SUCCESS) msg="[$(timestamp)] [OK] $*" ;;
        DRY_RUN) msg="[$(timestamp)] [DRY_RUN] $*" ;;
        *)       msg="[$(timestamp)] [LOG] $*" ;;
    esac

    # Colored output to terminal/full-output.log
    case "$level" in
        INFO)    echo -e "${BLUE}${msg}${NC}" ;;
        WARN)    echo -e "${YELLOW}${msg}${NC}" ;;
        ERROR)   echo -e "${RED}${msg}${NC}" ;;
        DEBUG)   echo -e "${MAGENTA}${msg}${NC}" ;;
        SUCCESS) echo -e "${GREEN}${msg}${NC}" ;;
        DRY_RUN) echo -e "${CYAN}${msg}${NC}" ;;
        *)       echo -e "$msg" ;;
    esac

    # Plain text to script.log
    echo "$msg" >&3
}

confirm() {
    echo "$1"
    read -rp "Do you want to continue? (y/n): " ans
    [[ "$ans" =~ ^[Yy]$ ]]
}
