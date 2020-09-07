#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e -u

echo 'Warning: customize_airootfs.sh is deprecated! Support for it will be removed in a future archiso version.'

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

usermod -s /usr/bin/zsh root

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist

# User configuration
useradd -m -p $(openssl passwd muhmuh) -g users -G "adm,audio,video,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/zsh muhmuh
chown -R muhmuh:users /home/muhmuh

# Services
systemctl set-default graphical.target
systemctl enable NetworkManager.service
systemctl enable lightdm.service

# Mods
sed -i -e 's/MODULES=()/MODULES=(i915? amdgpu? radeon? nouveau? vboxvideo? vmwgfx?)/g' /etc/mkinitcpio.conf
sed -i 's/HOOKS.*/HOOKS=(base udev modconf block filesystems keyboard fsck)/g' /etc/mkinitcpio.conf

# St
(cd /etc/skel/st && sudo make clean install)

## Disto Info
cat > /etc/os-release <<EOL
NAME="MuhArch"
PRETTY_NAME="MuhArch"
ID=arch
BUILD_ID=rolling
EOL
