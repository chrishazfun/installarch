#!/bin/bash

echo "# scrub lsp and zam plugins from app menu"
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

yay -S appimagelauncher ungoogled-chromium-xdg-bin chromium-widevine chromium-extension-web-store bitwarden-chromium protonup-qt-bin chiaki itch-setup-bin heroic-games-launcher-bin mcbelauncher-bin xbox-xcloud bleachbit-admin darling-bin flowblade kdocker xboxdrv ttf-ms-fonts shutter-encoder octopi flatseal devtoolbox powershell-bin

# yay -S --needed --noconfirm greenlight-bin
# ^ eventually probably as xbox-xcloud may be been renamed to greenlight at some point