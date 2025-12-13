#!/bin/bash
set -euxo pipefail
yay
cat aur-package-list.txt | yay -S --noconfirm --answerclean N --answerdiff N --answeredit N -

