Custom Ubuntu Setup Post-Install
======================

Custom scripts for a clean ubuntu install.

## Run the scripts
Prerequisites: an internet connection
It is recommended to first update the distro:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove
sudo snap refresh
sudo reboot
```

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
git clone https://github.com/ritonun/ubuntu-setup-post-install
cd ubuntu-setup-post-install
chmod +x post-install.sh
chmod +x scripts/*.sh
sudo ./post-install.sh
```

## Option
```
sudo ./post-install.sh DRY_RUN=1   # run a dry run
```
```
sudo ./post-install.sh SBS=1  # run step by step
```
