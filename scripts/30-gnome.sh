#!/bin/bash

install_gnome_extension() {
    log INFO "Install Gnome Extension Manager - Flatpak"
    run_cmd flatpak install flathub com.mattjakeman.ExtensionManager

    log INFO "Install Gnome Extensions Cli - gext"
    run_cmd pipx install gnome-extensions-cli --system-site-packages

    # log INFO "Install extension OpenBar"
    # run_cmd gext install openbar@neuromorph
    # run_cmd gext enable openbar@neuromorph

    # log INFO "Install extension User Theme"
    # run_cmd gext install user-theme@gnome-shell-extensions.gcampax.github.com
    # run_cmd gext enable user-theme@gnome-shell-extensions.gcampax.github.com

    # log INFO "Install extension Blur My Shell"
    # run_cmd gext install blur-my-shell@aunetx
    # run_cmd gext enable blur-my-shell@aunetx

    # log INFO "Install extension Just Perfection"
    # run_cmd gext install just-perfection-desktop@just-perfection
    # run_cmd gext enable just-perfection-desktop@just-perfection

    log INFO "Install extension Vitals"
    run_cmd gext install Vitals@CoreCoding.com
    run_cmd gext enable Vitals@CoreCoding.com
    log INFO "Apply conf to Vitals"
    run_cmd dconf load /org/gnome/shell/extensions/vitals/ < conf/vitals.conf

    log INFO "Install extension Dask to Dock"
    run_cmd gext install dash-to-dock@micxgx.gmail.com
    run_cmd gext enable dash-to-dock@micxgx.gmail.com
    log INFO "Apply conf to Dash-To-Dock"
    run_cmd dconf load /org/gnome/shell/extensions/dash-to-dock/ < conf/dash-to-dock.conf
}

install_nemo_file_manager() {
    log INFO "Install nemo as file manager"
    run_cmd apt install -y nemo gnome-shell-extension-manager
    run_cmd gext disable ding@rastersoft.com
    run_cmd xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
    run_cmd gsettings set org.nemo.desktop show-desktop-icons true
    log INFO "Add nemo-desktop to startup"
    AUTOSTART_DIR="$HOME/.config/autostart"
    run_cmd mkdir -p $AUTOSTART_DIR
    run_cmd cp config/nemo-desktop "$HOME/.config/autostart"
}

apply_app_config() {
    log INFO "Apply config to Text Editor"
    run_cmd dconf load /org/gnome/Texteditor/ < conf/TextEditor.conf
    log INFO "Apply config to desktop"
    run_cmd dconf load /org/gnome/desktop/ < conf/desktop-interface.conf
    log INFO "Apply config to nautilus"
    run_cmd dconf load /org/gnome/nautilus/ < conf/nautilus.conf
}

install_gnome_extension
apply_app_config
# install_nemo_file_manager
