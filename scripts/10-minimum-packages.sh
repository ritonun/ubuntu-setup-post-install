#!/bin/bash

# load library function and var
. scripts/lib.sh

system_update() {
    # perfom system update if not already done
    log INFO "System update via apt"
    apt update
    apt upgrade -y
    log INFO "Snap refresh"
    snap refresh
}

minimal_packages() {
    # install a minimum number of packages
    apt install -y curl \
    git \
    unzip
}

setup_flatpak() {
    log INFO "Setup flatpak"
    apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    log INFO "Install obsidian"
    flatpak install -y md.obsidian.Obsidian
    log INFO "Install KeePassXC"
    flatpak install -y org.keepassxc.KeePassXC
}

system_update
minimal_packages
setup_flatpak
