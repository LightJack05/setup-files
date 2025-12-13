#!/usr/bin/bash
set -euxo pipefail
echo 'Downloading and running setup script...'

# Install git if not present
pacman -Sy git --noconfirm

# Clone the setup files repository and run the bootstrap script
git clone https://github.com/LightJack05/setup-files.git /tmp/setup-files
/tmp/setup-files/bootstrap.sh
