#!/bin/bash

cleanup_apt() {
    log INFO "Cleanup apt"
    run_cmd apt autoremove
    run_cmd apt clean
}

cleanup_apt
