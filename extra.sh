#!/bin/bash
# optional adjustments for ease of use

read -p "Remove LSP and Zam plugin shortcuts from application menu? (e.g. yes/no)" $clearlspzam
if [ $clearlspzam -eq "yes" ]; then;
    echo "[Desktop Entry]
    Hidden=true" > /tmp/1
    find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
    find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
fi;