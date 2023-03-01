# not as important but still worth putting into a file
# bash ./post.sh when on the other end

# hiding lsp and zam plugins from application menu
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

git clone https://aur.archlinux.org/yay-bin /tmp/yay-bin
cd /tmp/yay-bin
makepkg -si
cd

yay -S --noconfirm darling-bin sublime-text-4 stable-diffusion-ui kdocker shutter-encoder xboxdrv ttf-ms-fonts