#!/bin/bash
chmod +x install-yay.sh
chmod +x install-packages.sh
chmod +x install-packer-nvim.sh

echo """
[multilib]
Include = /etc/pacman.d/mirrorlist
""" >> /etc/pacman.conf

./install-yay.sh
./install-packages.sh
./install-packer-nvim.sh
