#!/bin/bash

echo "# scrub lsp and zam plugins from app menu"
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

# yay -S --needed --noconfirm greenlight-bin
# ^ eventually probably as xbox-xcloud may be been renamed to greenlight at some point