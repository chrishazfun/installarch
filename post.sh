#!/bin/bash

# pacman tweaks, blocking xterm as it's a common optional dep that we don't need
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
sed -i 's/^#IgnorePkg   =/IgnorePkg=xterm,xfce4-artwork/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

# cloning yay-bin in the chrooted post-install script instead of the custom-commands like we COULD but can't rn
git clone https://aur.archlinux.org/yay-bin /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
cd

# getting them aur pkgs
yay -S --noconfirm --needed darling-bin kdocker xboxdrv ttf-ms-fonts spacecadetpinball-git shutter-encoder octopi chromium-widevine

# essential flatpaks
flatpak install -y --noninteractive com.github.tchx84.Flatseal com.microsoft.Edge io.podman_desktop.PodmanDesktop

# more flatpaks, minecraft bedrock anyone? dedicated xbox cloud client?
flatpak install -y --noninteractive io.github.mandruis7.xbox-cloud-gaming-electron io.mrarm.mcpelauncher net.davidotek.pupgui2 com.heroicgameslauncher.hgl io.itch.itch net.brinkervii.grapejuice com.gitlab.JakobDev.jdMinecraftLauncher

# setting the awesomewm config
mkdir -p ~/.config/awesome/
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
sed -i 's/^terminal = \"xterm\"/terminal = \"qterminal\"/' ~/.config/awesome/rc.lua
sed -i 's/^editor = os.getenv(\"EDITOR\") or \"nano\"/editor = os.getenv(\"EDITOR\") or \"vim\"/' ~/.config/awesome/rc.lua

# setting mpv config, might set some things idk
cp -r /usr/share/doc/mpv/ ~/.config/

# scrolling fix (temporary)
xset r rate 200 30