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

rust_install() {
    # install rust stable branch without user interaction
    log INFO "Install rustup"
    run_cmd curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | run_cmd sh -s -- -y --default-toolchain stable --no-modify-path
    # source the cargo .env file
    run_cmd . "$HOME/.cargo/env"

    log INFO "Install dependencies for cargo-generate and esp-generate"
    run_cmd apt install -y libssl-dev

    log INFO "Install cargo-generate"
    run_cmd cargo install cargo-generate
    log INFO "Install esp-generate"
    run_cmd cargo install esp-generate --locked
}

pipx_install() {
    log INFO "Install pipx"
    run_cmd apt install -y pipx
    run_cmd pipx ensurepath
    run_cmd export PATH=/home/jerry/.local/bin:$PATH
    run_cmd echo $PATH
    run_cmd source ~/.bashrc
    run_cmd source ~/.zshrc

    log INFO "Install yt-dlp via pipx"
    run_cmd pipx install yt-dlp
}

zed_install() {
    log INFO "Install zed editor"
    run_cmd curl -f https://zed.dev/install.sh | run_cmd sh
}

code_install() {
    log INFO "Install snap VsCode"
    run_cmd snap install --classic code
}

system_update
minimal_packages
setup_flatpak
rust_install
pipx_install
zed_install
code_install
