#!/bin/bash

read -p "Clear out LSP and Zam Plugins? (e.g. y/N)" $clearoutlspzam
if [ $clearoutlspzam -eq "y" ]; then;
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
fi;