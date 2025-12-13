#!/bin/bash
set -euxo pipefail
cat package-list.txt | pacman -Syu --noconfirm -

