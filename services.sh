#!/bin/bash
set -euxo pipefail

# Enable services based on package-list.txt
systemctl enable NetworkManager.service
systemctl enable avahi-daemon.service
systemctl enable bluetooth.service
systemctl enable cups.service
systemctl enable cups-browsed.service
systemctl enable illuminanced.service
systemctl enable libvirtd.service
systemctl enable ly.service
systemctl enable power-profiles-daemon.service
systemctl enable systemd-timesyncd.service
systemctl enable ufw.service
systemctl enable vmware-netwworks.service
systemctl enable vmware-usbarbitrator.service

