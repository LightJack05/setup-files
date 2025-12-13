#!/bin/bash
set -euxo pipefail

echo 'Bootstrapping new system...'
pacstrap -K /mnt base linux linux-firmware networkmanager sudo nvim vim
genfstab -U /mnt >> /mnt/etc/fstab

mkdir -p /mnt/init/setup-files
git clone https://github.com/LightJack05/setup-files.git /mnt/init/setup-files
chmod -R 777 /mnt/init/

echo 'Chrooting into the new system...'
arch-chroot /mnt /usr/bin/bash -i -c "source /init/setup-files/init-system.sh"
