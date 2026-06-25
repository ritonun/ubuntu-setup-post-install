#!/bin/bash

add_templates_documents() {
    TEMPLATES_DIR="$TARGET_HOME/Templates"
    run_cmd echo "TEMPLATES PATH: $TEMPLATES_DIR"
    # Create the text.txt file in Templates if it doesn't already exist
    if [ ! -f "$TEMPLATES_DIR/text.txt" ]; then
        run_cmd touch "$TEMPLATES_DIR/text.txt"
        run_cmd echo "text.txt added to Templates."
    else
        run_cmd echo "text.txt already exists in Templates."
    fi
    # Create the text.txt file in Templates if it doesn't already exist
    if [ ! -f "$TEMPLATES_DIR/doc.odt" ]; then
        run_cmd touch "$TEMPLATES_DIR/doc.odt"
        run_cmd echo "doc.odt added to Templates."
    else
        run_cmd echo "doc.odt already exists in Templates."
    fi
}

ubuntu_settings() {
    log INFO "Deactivating DIM Screen"
    run_cmd gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    run_cmd gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 100

    log INFO "Minimize on click"
    run_cmd gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

    log INFO "Activate firewall"
    run_cmd ufw enable
    log INFO "Allow port 22 (ssh)"
    run_cmd ufw allow 22
    run_cmd ufw reload

    log INFO "Set the first day of the calendar as Monday"
    run_cmd bash -c 'echo "LC_TIME=\"en_IE.UTF-8\"" >> /etc/default/locale'

    log INFO "Add templates document: text.txt, doc.odt"
    add_templates_documents

}
