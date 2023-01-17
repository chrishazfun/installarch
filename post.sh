# not as important but still worth putting into a file
# bash ./post.sh when in the cloned repo dir after rebooting into system

echo "hiding lsp and zam plugins from application menu"
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

echo "installing yay aur helper"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

echo "installing aur packages"
yay -S --noconfirm sand-lxqt-theme kdocker pamac-nosnap shutter-encoder microsoft-edge-stable-bin chromium-widevine sublime-text-4 xboxdrv protonup-ng-git ttf-ms-fonts

echo "installing flatpaks"
flatpak install -y --noninteractive org.firestormviewer.FirestormViewer com.steamgriddb.steam-rom-manager

echo "adding bash aliases"
curl https://chrishaz.fun/arch/.bashrc >> ~/.bashrc