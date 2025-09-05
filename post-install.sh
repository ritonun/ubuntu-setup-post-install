#!/bin/bash

# Ensure the computer is properly setup for the scripts
if . scripts/00-precheck.sh; then
    log INFO "Prerequisites are completed. Continuing with scripts install."
else
    log ERROR "Ending the post-install script."
    exit 1
fi
