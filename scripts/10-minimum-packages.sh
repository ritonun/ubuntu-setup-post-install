#!/bin/bash

system_update() {
    # perfom system update if not already done
    log INFO "System update via apt"
    run_cmd apt update
    run_cmd apt upgrade -y
    log INFO "Snap refresh"
    run_cmd snap refresh
}

minimal_packages() {
    # install a minimum number of packages
    log INFO "Install utility packages: git, curl, unzip"
    run_cmd apt install -y curl \
    git \
    unzip
}

setup_flatpak() {
    log INFO "Setup flatpak"
    run_cmd apt install -y flatpak gnome-software-plugin-flatpak
    run_cmd flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    log INFO "Install obsidian"
    run_cmd flatpak install -y md.obsidian.Obsidian
    log INFO "Install KeePassXC"
    run_cmd flatpak install -y org.keepassxc.KeePassXC
}

system_update
minimal_packages
setup_flatpak
