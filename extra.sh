#!/bin/bash

# read command needed for lsp/zam shortcut flush
echo '[Desktop Entry]
Hidden=true' > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

# read command needed for qemu vm setup
pacman -S --needed qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils libguestfs ovmf swtpm openbsd-netcat
sed -i 's/^#unix_sock_group = \"libvirt\"/unix_sock_group = \"libvirt\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_ro_perms = \"0777\"/unix_sock_ro_perms = \"0777\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_rw_perms = \"0770\"/unix_sock_rw_perms = \"0770\"/' /etc/libvirt/libvirtd.conf
usermod -aG libvirt $USERNAME
sudo systemctl enable libvirtd

yay -S --needed protonup-qt-bin itch-setup-bin heroic-games-launcher-bin mcbelauncher-bin xbox-xcloud flowblade kdocker xboxdrv shutter-encoder ytmdesktop-git

# xbox-xcloud may be renamed as greenlight or greenlight-bin