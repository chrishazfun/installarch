#!/bin/bash


# https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/piratebay.py
# https://raw.githubusercontent.com/qbittorrent/search-plugins/master/nova3/engines/torlock.py

# plugin for aur pkg import at a later date
# "plugin": "https://raw.githubusercontent.com/chrishazfun/archinstall-aur/main/archinstall_aur/__init__.py",

# install custom bashrc commands, shortcuts to common commands, push this into config somehow
curl -Sk https://raw.githubusercontent.com/chrishazfun/installarch/main/.bashrc >> ~/.bashrc
source ~/.bashrc

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

# xbox-xcloud may be renamed as greenlight or greenlight-bin

# locale for australia
# en_AU.UTF-8
# en_AU ISO-8859-1

# kdocker chrome pwas
bash -c '/opt/google/chrome/google-chrome --profile-directory=Default --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo &'
while true; do
  sleep 5
  status=$(wmctrl -l | grep "Microsoft Teams")
  if [ "$status" != "" ]; then break; fi
done
WID="$(wmctrl -lx | grep "Microsoft Teams")"; kdocker -qw "${WID%% *}" -i /usr/share/icons/Numix-Circle/48/apps/teams.svg