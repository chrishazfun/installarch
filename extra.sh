#!/bin/bash

echo "# pacman stuff"
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
sed -i 's/^#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf


echo "# installing easyeffects, lsp and zam plugins and scrubing them from the app menu"
pacman -S easyeffects calf mda.lv2 lsp-plugins
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

echo "# installing qemu/virt-manager, sed'ing config to work"
pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils libguestfs ovmf swtpm openbsd-netcat
sed -i 's/^#unix_sock_group = \"libvirt\"/unix_sock_group = \"libvirt\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_ro_perms = \"0777\"/unix_sock_ro_perms = \"0777\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_rw_perms = \"0770\"/unix_sock_rw_perms = \"0770\"/' /etc/libvirt/libvirtd.conf
usermod -aG libvirt $USERNAME
systemctl enable libvirtd

yay -S appimagelauncher ungoogled-chromium-xdg-bin chromium-widevine chromium-extension-web-store bitwarden-chromium protonup-qt-bin chiaki itch-setup-bin heroic-games-launcher-bin mcbelauncher-bin xbox-xcloud bleachbit-admin darling-bin flowblade kdocker xboxdrv ttf-ms-fonts shutter-encoder octopi flatseal devtoolbox powershell-bin

# yay -S --needed --noconfirm greenlight-bin
# ^ eventually probably as xbox-xcloud may be been renamed to greenlight at some point