#!/bin/bash

install_gnome_extension() {
    log INFO "Install Gnome Extension Manager - Flatpak"
    run_cmd flatpak install flathub com.mattjakeman.ExtensionManager

    log INFO "Install Gnome Extensions Cli - gext"
    run_cmd pipx install gnome-extensions-cli --system-site-packages

    log INFO "Install extension OpenBar"
    run_cmd gext install openbar@neuromorph
    run_cmd gext enable openbar@neuromorph

    log INFO "Install extension User Theme"
    run_cmd gext install user-theme@gnome-shell-extensions.gcampax.github.com
    run_cmd gext enable user-theme@gnome-shell-extensions.gcampax.github.com

    log INFO "Install extension Blur My Shell"
    run_cmd gext install blur-my-shell@aunetx
    run_cmd gext enable blur-my-shell@aunetx

    log INFO "Install extension Just Perfection"
    run_cmd gext install just-perfection-desktop@just-perfection
    run_cmd gext enable just-perfection-desktop@just-perfection

    log INFO "Install extension Vitals"
    run_cmd gext install Vitals@CoreCoding.com
    run_cmd gext enable Vitals@CoreCoding.com

    log INFO "Install extension Dask to Dock"
    run_cmd gext install dash-to-dock@micxgx.gmail.com
    run_cmd gext enable dash-to-dock@micxgx.gmail.com
}

install_gnome_extension
