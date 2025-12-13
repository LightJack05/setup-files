#!/bin/bash
set -euxo pipefail

echo 'Bootstrapping new system...'
pacstrap -K /mnt base linux linux-firmware networkmanager sudo nvim vim
genfstab -U /mnt >> /mnt/etc/fstab

mkdir -p /mnt/tmp/setup-files
git clone https://github.com/LightJack05/setup-files.git /mnt/tmp/setup-files

echo 'Chrooting into the new system...'
arch-chroot /mnt "/mnt/tmp/setup-files/init-system.sh"
