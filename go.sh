#!/bin/bash

# execute in root after following eos/arch guide at chrishaz.fun/eos
# curl -s https://chrishaz.fun/eos/go.sh | bash
## .ps1 for w10 vm: irm chrishaz.fun/eos/win.ps1 | iex

# essentials {
	# backup xfce configs: xfconf-query -c xfce4-keyboard-shortcuts -lv > backup
	# script to restore using file: while read line; do; xfconf-query -c xfce4-keyboard-shortcuts -p "$(echo $line | awk '{print $1}')" -s "$(echo $line | awk '{print $2}')" -n; done < backup;
# }

# odds n' ends: {
	# download and mv dunstrc to .config: curl -O https://chrishaz.fun/fun/dunstrc;mv dunstrc /home/$USER/.config/dunst/dunstrc
	# find ~/.cache/ -type f -atime +30 -print (prints cache)
	# find ~/.cache/ -type f -atime +30 -delete (deletes cache)
	# find . -type d -empty -print (prints empty dirs, probably shouldn't use)
	# find . -type d -empty -delete (deletes empty dirs, probably shouldn't use)
	# for a in *.png; do echo "${a%}"; done; (testing for one-line converter)
	# for a in *.mkv; do ffmpeg -i "$a" -c copy "${a%.mkv}.mp4"; done; for b in *.ogv; do ffmpeg -i "$b" -vcodec libx264 "${f%}.mp4"; done; (ogv/mkv to mp4, wip)
	# RADV_PERFTEST=aco %command% (steam launch option with better compiler)
	# cat ~/.config/rofi/config.rasi (output rofi config)
	# echo "text" >| 'Users/Name/Desktop/TheAccount.txt'
	# https://gist.github.com/lbrame/1678c00213c2bd069c0a59f8733e0ee6#fonts
	# nixOS package manager: curl -L https://nixos.org/nix/install | sh
# }

curl https://chrishaz.fun/

sudo pacman -S --noconfirm archlinux-keyring # update keyrings to latest to prevent packages failing to install

if [ -f "/etc/arch-release" ]; then
	archinstall --config https://chrishaz.fun/arch/config.json
fi

#echo "setting appropriate firefox settings" && sleep 2
#touch ~/.mozilla/firefox/*.default/prefs.js
#$prefs=ls ~/.mozilla/firefox/*.default -d
#echo 'user_pref("media.ffmpeg.vaapi.enabled", true);' >> ~/.mozilla/firefox/*.default/prefs.js
#echo 'user_pref("browser.uidensity", 1);' >> ~/.mozilla/firefox/*.default/prefs.js
#echo 'user_pref("extensions.pocket.enabled", false);' >> ~/.mozilla/firefox/*.default/prefs.js

echo "done! god i hope this works"