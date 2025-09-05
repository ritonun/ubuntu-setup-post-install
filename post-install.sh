#!/bin/bash

# load lib function and var
. scripts/lib.sh

log INFO "This is information"
log WARN "This is a warning"
log ERROR "This is an error"
log DEBUG "This is a debug"
log SUCCESS "This is a success"
log ANFH "This does not exist"
