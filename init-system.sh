#!/bin/bash
set -euxo pipefail

trap 'on_error $?' ERR

on_error() {
    local exit_code=$?
    local last_command=${BASH_COMMAND}

    echo "ERROR: Script failed"
    echo "Exit code: ${exit_code}"
    echo "Last command: ${last_command}" >&2

    exit "${exit_code}"
}

# Move to setup files directory
cd /init/setup-files/

# Set up timezone and localization
echo 'Setting up base system...'
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# Localization
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen

# set LANG locale
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# set Keymap
echo 'KEYMAP=us' > /etc/vconsole.conf

# Set hostname
read -rp "Enter hostname: " HOSTNAME < /dev/tty
echo "$HOSTNAME" > /etc/hostname

# Set up initramfs with hooks for encryption and LVM
echo 'Setting up initramfs...'
sed -i 's/^HOOKS=(.*)/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P


# Install grub bootloader
echo 'Installing GRUB bootloader...'
pacman -S --noconfirm grub efibootmgr dosfstools os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# Set up grub for possible full disk encryption
lsblk
read -p "We will open a vim window for you to copy the disk UUID of your root partition. Press enter to continue..." < /dev/tty
ls -lah /dev/disk/by-uuid/ | vim -

echo 'You will now be able to edit the /etc/default/grub file to add the disk UUID to the GRUB_CMDLINE_LINUX_DEFAULT line.'
echo 'Format reminder: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash cryptdevice=UUID=your-disk-uuid:cryptroot root=/dev/mapper/cryptroot"'
read -p "Press enter to continue..." < /dev/tty
vim /etc/default/grub

# Generate grub configuration
grub-mkconfig -o /boot/grub/grub.cfg

# Set up sudo for wheel group
sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers

# Enable the multilib repository
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

pacman -Sy

./user.sh
sudo -u LightJack05 '/init/setup-files/yay.sh'
sudo -u LightJack05 '/init/setup-files/aur-packages.sh'
./packages.sh
./services.sh
./dotfiles.sh

# Regenerate grub config and initramfs in case user scripts made changes
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P

# Set root password
echo 'Please set root password'
passwd

# Final message
echo 'System initialization complete!'
echo 'Finalize any configuration as needed and then reboot.'
echo 'Have a great day! :)'
