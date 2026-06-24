#!/bin/bash

oh_my_zsh() {
    log INFO "Install Zsh + Oh My ZSH"
    export RUNZSH=no
    export CHSH=no

    run_cmd apt install zsh -y
    run_cmd test -f "$HOME/.zshrc" || touch "$HOME/.zshrc"

    # ensure file exist
    run_cmd cp "conf/.zshrc" "$HOME"
    run_cmd cp "conf/.p10k.zsh" "$HOME/.p10k.zsh"

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log INFO "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Install zsh-autosuggestions
    run_cmd git clone \
    https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
    || true

    # Install zsh-syntax-highlighting
    run_cmd git clone \
    https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
    || true

    # Install power10k theme
    run_cmd git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"

    # make sh default shell
    TARGET_USER="${SUDO_USER:-$USER}"
    ZSH_PATH="$(command -v zsh)"
    run_cmd usermod -s "$ZSH_PATH" "$TARGET_USER"
}

alacritty() {
    log INFO "Install alacritty terminal"
    run_cmd apt install -y alacritty
    log INFO "Setup alacritty theme"
    local dst_dir="$HOME/.config/alacritty"
    run_cmd cp -r "conf/alacritty" "$dst_dir"
}

yazi_file_explorer() {
    log INFO "Install yazi dependencies"
    run_cmd apt install -y jq \
    poppler-utils \
    fd-find \
    ripgrep \
    fzf \
    zoxide \
    resvg
    log INFO "Install yazi with binstall"
    run_cmd cargo binstall -y yazi-fm
}

oh_my_zsh
alacritty
yazi_file_explorer
