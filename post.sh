#!/bin/bash

# pacman tweaks, blocking xterm as it's a common optional dep that we don't need
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
sed -i 's/^#IgnorePkg   =/IgnorePkg=xterm,xfce4-artwork/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

# setting up for qemu/virt-manager
sed -i 's/^#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_ro_perms = "0777"/unix_sock_ro_perms = "0777"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf
usermod -aG libvirt $USERNAME

# hiding lsp,zam plugin shortcuts on gnome menu
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}


# cloning yay-bin in the chrooted post-install script instead of the custom-commands like we COULD but can't rn
git clone https://aur.archlinux.org/yay-bin /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
cd

# getting them aur pkgs, might expand on the selection if this chrooted script plan works
yay -S --noconfirm --needed darling-bin kdocker xboxdrv ttf-ms-fonts spacecadetpinball-git shutter-encoder octopi chromium-widevine

# essential flatpaks
flatpak install -y --noninteractive com.github.tchx84.Flatseal com.microsoft.Edge io.podman_desktop.PodmanDesktop

# more flatpaks, minecraft bedrock anyone? dedicated xbox cloud client?
flatpak install -y --noninteractive io.github.mandruis7.xbox-cloud-gaming-electron io.mrarm.mcpelauncher net.davidotek.pupgui2 com.heroicgameslauncher.hgl io.itch.itch net.brinkervii.grapejuice com.gitlab.JakobDev.jdMinecraftLauncher

# setting mpv config, might set some things idk
cp -r /usr/share/doc/mpv/ ~/.config/

# scrolling fix (temporary)
xset r rate 200 30