#!/bin/bash
set -euxo pipefail

# Enable services based on package-list.txt
systemctl enable NetworkManager.service || true
systemctl enable avahi-daemon.service || true
systemctl enable bluetooth.service || true
systemctl enable cups.service || true
systemctl enable illuminanced.service || true
systemctl enable libvirtd.service || true
systemctl enable ly@tty2.service || true
systemctl enable power-profiles-daemon.service || true
systemctl enable systemd-timesyncd.service || true
systemctl enable ufw.service || true
systemctl enable vmware-networks.service || true
systemctl enable vmware-usbarbitrator.service || true

