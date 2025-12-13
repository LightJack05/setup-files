#!/bin/bash
set -euxo pipefail

# Create user LightJack05 and add to wheel group
useradd -m LightJack05
usermod -aG wheel LightJack05
usermod --shell /usr/bin/zsh LightJack05

# Change password for LightJack05
echo "Please change password of user LightJack05"
passwd LightJack05
