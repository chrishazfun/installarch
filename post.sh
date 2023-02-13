# not as important but still worth putting into a file
# bash ./post.sh when on the other end

# hiding lsp and zam plugins from application menu
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

yay -S chromium-widevine vscodium-bin darling-bin stable-diffusion-ui lxqt-less-theme-git kdocker pamac-nosnap shutter-encoder xboxdrv protonup-ng-git ttf-ms-fonts