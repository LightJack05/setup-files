#!/bin/bash
set -euxo pipefail

# Set up login for github on user LightJack05
sudo -u LightJack05 gh auth login
# Set up dotfiles for LightJack05
sudo -u LightJack05 git clone https://github.com/LightJack05/dotfiles --recursive ~/dotfiles
sudo -u LightJack05 ~/dotfiles/setup-complete.sh
