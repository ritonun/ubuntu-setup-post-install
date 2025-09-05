Custom Ubuntu Setup Post-Install
======================

Custom scripts for a clean ubuntu install.

## Run the scripts
Prerequisites: an internet connection
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git
git clone https://github.com/ritonun/ubuntu-setup-post-install
chmod +x post-install.sh
chmod +x scripts/*.sh
sudo ./post-install.sh
```
