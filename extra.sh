#!/bin/bash

echo "# pacman things"
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
sed -i 's/^#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf
sed -i 's/^#Color/Color/' /etc/pacman.conf

echo "# copy over mpv config to .config dir"
cp -r /usr/share/doc/mpv/ ~/.config/

echo "# scrolling fix (temp)"
xset r rate 200 30

echo "# clear out lsp and zam plugins in app menu"
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

echo "# easyeffects, related plugins"
pacman -Syy --needed easyeffects calf mda.lv2 lsp-plugins

echo "# prepping for qemu/virt-manager"
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
yay -S --needed --noconfirm darling-bin kdocker xboxdrv ttf-ms-fonts shutter-encoder octopi appimagelauncher flatseal microsoft-edge-stable-bin podman-desktop-bin protonup-qt-bin grapejuice

echo "# flatpak"
flatpak install -y --noninteractive io.mrarm.mcpelauncher com.heroicgameslauncher.hgl io.itch.itch re.chiaki.Chiaki io.github.mandruis7.xbox-cloud-gaming-electron