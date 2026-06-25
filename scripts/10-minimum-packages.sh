#!/bin/bash

# supress apt config prompts
export DEBIAN_FRONTEND=noninteractive

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
    run_cmd apt install -y curl git unzip
}

setup_flatpak() {
    log INFO "Setup flatpak"
    run_cmd apt install -y flatpak gnome-software-plugin-flatpak
    run_cmd flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    log INFO "Install obsidian"
    run_cmd flatpak install -y flathub md.obsidian.Obsidian
    log INFO "Install KeePassXC"
    run_cmd flatpak install -y flathub org.keepassxc.KeePassXC
}

rust_install() {
    # install rust stable branch without user interaction
    log INFO "Install rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | run_cmd sh -s -- -y --default-toolchain stable --no-modify-path
    # source the cargo .env file
    . "$HOME/.cargo/env"

    log INFO "Install dependencies for cargo-generate and esp-generate"
    run_cmd apt install -y libssl-dev

    log INFO "Install cargo-generate"
    run_cmd cargo install cargo-generate
    log INFO "Install esp-generate"
    run_cmd cargo install esp-generate --locked
    log INFO "Install cargo-binstall"
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
}

pipx_install() {
    log INFO "Install pipx"
    run_cmd apt install -y pipx
    run_cmd pipx ensurepath

    export PATH=/home/jerry/.local/bin:$PATH
    run_cmd echo $PATH
    run_cmd source ~/.bashrc
    run_cmd source ~/.zshrc

    log INFO "Install yt-dlp via pipx"
    run_cmd pipx install yt-dlp

    log INFO "Install uv with pipx"
    run_cmd pipx install uv

    log INFO "Install ytpu with pipx"
    run_cmd pipx install ytpu
}

zed_install() {
    log INFO "Install zed editor"
    run_cmd curl -f https://zed.dev/install.sh | run_cmd sh
}

full_flatpak_install() {
    log INFO "Install ArduinoIDE v2"
    run_cmd flatpak install -y flathub cc.arduino.IDE2
    log INFO "Install Brave"
    run_cmd flatpak install -y flathub com.brave.Browser
    log INFO "Install Minecraft"
    run_cmd flatpak install -y flathub com.mojang.Minecraft
    log INFO "Install PokeMMO"
    run_cmd flatpak install -y flathub com.pokemmo.PokeMMO
    log INFO "Install KiCad"
    run_cmd flatpak install -y flathub org.kicad.KiCad
    log INFO "Install FreeCAD"
    run_cmd flatpak install -y flathub org.freecad.FreeCAD
    log INFO "Install Document Scanner"
    run_cmd flatpak install -y flathub org.gnome.SimpleScan
    log INFO "Install Okular"
    run_cmd flatpak install -y flathub org.kde.okular
    log INFO "Install qBittorrent"
    run_cmd flatpak install -y flathub org.qbittorrent.qBittorrent
    log INFO "Install LocalSend"
    run_cmd flatpak install -y flathub org.localsend.localsend_app
}

full_package_install() {
    log INFO "Install app/utility packages"
    run_cmd apt install -y 7zip \
    7zip \
    aria2 \
    fastfetch \
    ffmpeg \
    ffmpegthumbnailer \
    flatpak \
    gh \
    git \
    handbrake-cli \
    htop \
    libreoffice \
    pipx \
    syncthing \
    unrar \
    unzip \
    vlc \
    wget

    log INFO "Install dev packages"
    run_cmd apt install -y build-essential \
    cmake \
    pkg-config \
    g++ \
    clang \
    lld \
    python3-dev \
    libgl1-mesa-dev
}

vscode_install() {
    log INFO "Install VS Code"
    run_cmd apt install -y wget gpg

    if [[ ! -f /usr/share/keyrings/microsoft.gpg ]]; then
        run_cmd bash -c \
            'wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg'
    fi

    run_cmd tee /etc/apt/sources.list.d/vscode.sources > /dev/null/ <<'EOF'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF

    run_cmd apt update
    run_cmd apt install -y code
}

system_update
minimal_packages
full_package_install
setup_flatpak
rust_install
pipx_install
zed_install
full_flatpak_install
vscode_install
