#!/bin/bash

. scripts/lib.sh

# parse command with user argument
parse_commands "$@"
# validate global variable value before starting the script
validate_global_value

log DEBUG "DRY_RUN=$DRY_RUN"

# Ensure the computer is properly setup for the scripts
if . scripts/00-precheck.sh; then
    log INFO "Prerequisites are completed. Continuing with scripts install."
else
    log ERROR "Ending the post-install script."
    exit 1
fi

# run package install
. scripts/10-minimum-packages.sh
