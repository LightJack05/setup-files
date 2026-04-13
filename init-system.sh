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

# Set up sudo for wheel group
sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers

# Enable the multilib repository
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

pacman -Sy

## Set up Initramfs, kernel cmdline and UKI build
# Set up initramfs with hooks for encryption and LVM
echo 'Setting up initramfs...'
sed -i 's/^HOOKS=(.*)/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf


mkdir -p /efi/EFI/BOOT/
mkdir -p /efi/EFI/Linux/

echo 'Setting up mkinitcpio config preset...'
cat << EOF > /etc/mkinitcpio.d/linux.preset
# mkinitcpio preset file for the 'linux' package

#ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default' 'fallback')

#default_config="/etc/mkinitcpio.conf"
#default_image="/boot/initramfs-linux.img"
default_uki="/efi/EFI/BOOT/BOOTX64.EFI"
default_options="--cmdline /etc/kernel/cmdline"

#fallback_config="/etc/mkinitcpio.conf"
#fallback_image="/boot/initramfs-linux-fallback.img"
fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
EOF

lsblk
read -p "We will open a vim window for you to copy the disk UUID of your root partition. Press enter to continue..." < /dev/tty
ls -lah /dev/disk/by-uuid/ | vim -

echo 'You will now be able to edit the /etc/kernel/cmdline file to add the disk UUID to the kernel cmdline.'
echo 'Format reminder: cryptdevice=UUID=your-disk-uuid:cryptroot root=/dev/mapper/cryptroot'
read -p "Press enter to continue..." < /dev/tty
vim /etc/kernel/cmdline

mkinitcpio -P


## Setup secure boot
# setup secure boot keys
sbctl create-keys
# Enroll keys and microsoft CA
sbctl enroll-keys -m
# Sign files
sbctl sign -s /efi/EFI/BOOT/BOOTX64.EFI
sbctl sign -s /efi/EFI/Linux/arch-linux-fallback.efi



# Set root password
echo 'Please set root password'
passwd


## Software Installation, dotfiles
./user.sh
sudo -u LightJack05 '/init/setup-files/yay.sh'
sudo -u LightJack05 '/init/setup-files/aur-packages.sh'
./packages.sh
./services.sh
./dotfiles.sh


# Final message
echo 'System initialization complete!'
echo 'Finalize any configuration as needed and then reboot.'
echo 'Have a great day! :)'
