#!/bin/bash

echo "# pacman things"
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
sed -i 's/^#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

echo "# mpv config > .config dir"
cp -r /usr/share/doc/mpv/ ~/.config/

echo "# scrolling fix for x11 (temp)"
xset r rate 200 30

echo "# scrub lsp and zam plugins from app menu"
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

echo "# easyeffects and related plugins"
pacman -Syy --needed easyeffects calf mda.lv2 lsp-plugins

echo "# qemu/virt-manager"
pacman -Syy --needed qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils libguestfs ovmf swtpm openbsd-netcat
systemctl start libvirtd
systemctl enable libvirtd
sed -i 's/^#unix_sock_group = \"libvirt\"/unix_sock_group = \"libvirt\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_ro_perms = \"0777\"/unix_sock_ro_perms = \"0777\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_rw_perms = \"0770\"/unix_sock_rw_perms = \"0770\"/' /etc/libvirt/libvirtd.conf
usermod -aG libvirt $USERNAME

echo "# yay/aur"
git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
yay -Syy --needed darling-bin kdocker xboxdrv ttf-ms-fonts shutter-encoder octopi flatseal protonup-qt-bin brave-bin chromium-bypass-paywalls-clean-git chiaki itch-setup-bin heroic-games-launcher-bin mcbelauncher-bin devtoolbox powershell-bin

echo "# xbox xcloud"
yay -Syy --needed xbox-xcloud
# yay -S --needed --noconfirm greenlight-bin
# ^ eventually probably as project has been renamed to greenlight

echo "# flatpaks"
flatpak install io.github.Bavarder.Bavarder io.github.jliljebl.Flowblade