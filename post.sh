# not as important but still worth putting into a file
# bash ./post.sh when in the cloned repo dir after rebooting into system

sudo pacman -S wine-gecko wine-mono wine-staging neofetch yt-dlp calf mda.lv2 lsp-plugins vlc steam kdenlive obs-studio libreoffice-fresh gimp bleachbit easyeffects ardour blender jami-qt meld

echo "Hiding LSP and ZAM plugins from application menu"
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

echo "Installing yay AUR helper"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

echo "Installing AUR packages"
yay -S --noconfirm sand-lxqt-theme kdocker pamac-nosnap shutter-encoder microsoft-edge-stable-bin chromium-widevine sublime-text-4 xboxdrv protonup-ng-git ttf-ms-fonts

echo "Installing flatpaks"
flatpak install -y --noninteractive org.firestormviewer.FirestormViewer com.steamgriddb.steam-rom-manager

#echo "Adding bash aliases"
#curl https://chrishaz.fun/arch/.bashrc >> ~/.bashrc
#source ~/.bashrc