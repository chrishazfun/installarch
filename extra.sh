#!/bin/bash

# locales for australia, iso codes too
# en_AU.UTF-8
# en_AU ISO-8859-1

# install custom bashrc commands, shortcuts to common commands, push this into config somehow
curl -Sk https://raw.githubusercontent.com/chrishazfun/installarch/main/.bashrc >> ~/.bashrc
source ~/.bashrc

# read command needed for lsp/zam shortcut flush, if we're to install them
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