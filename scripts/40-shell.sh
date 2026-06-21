#!/bin/bash

oh_my_zsh() {
    log INFO "Install zsh"
    export RUNZSH=no
    export CHSH=no
    run_cmd touch "$HOME/.zshrc"
    run_cmd apt install zsh -y

    run_cmd sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


    # Install zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        run_cmd git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # Install zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        run_cmd git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi
}

alacritty() {
    log INFO "Install alacritty terminal"
    run_cmd apt install -y alacritty
    log INFO "Setup alacritty theme"
    local dst_dir="$HOME/.config/alacritty"
    run_cmd cp -r "conf/alacritty" "$dst_dir"
}

oh_my_zsh
alacritty
