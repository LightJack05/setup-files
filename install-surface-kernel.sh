#!/bin/bash
curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | sudo pacman-key --add -
sudo pacman-key --finger 56C464BAAC421453
sudo pacman-key --lsign-key 56C464BAAC421453
echo << EOF >> /etc/pacman.conf
[linux-surface]
Server = https://pkg.surfacelinux.com/arch/
EOF

sudo pacman -Syu
sudo pacman -S linux-surface linux-surface-headers iptsd
sudo grub-mkconfig -o /boot/grub/grub.cfg
