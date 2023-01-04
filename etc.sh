# .ps1 for w10 vm: irm chrishaz.fun/eos/win.ps1 | iex

## not sure how to add the stuff here to the config

# hiding lsp and zam plugin icons from gnome menu
echo "[Desktop Entry]
Hidden=true" > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

# add bash aliases
curl https://chrishaz.fun/arch/.bashrc >> ~/.bashrc

# essentials {
	# backup xfce configs: xfconf-query -c xfce4-keyboard-shortcuts -lv > backup
	# restore xfce config using file
    while read line; do; xfconf-query -c xfce4-keyboard-shortcuts -p "$(echo $line | awk '{print $1}')" -s "$(echo $line | awk '{print $2}')" -n; done < backup;
# }

# odds n' ends: {
	# download and mv dunstrc to .config:
    curl -O https://chrishaz.fun/fun/dunstrc;
    mv dunstrc /home/$USER/.config/dunst/dunstrc
	# prints cache
    find ~/.cache/ -type f -atime +30 -print
	# deletes cache
    find ~/.cache/ -type f -atime +30 -delete
	# prints empty dirs (danger)
    find . -type d -empty -print
	# deletes empty dirs (danger)
    find . -type d -empty -delete
	# one line converter, open dir in term and paste (ogv/mkv to mp4, wip)
	for a in *.mkv; do ffmpeg -i "$a" -c copy "${a%.mkv}.mp4"; done; for b in *.ogv; do ffmpeg -i "$b" -vcodec libx264 "${f%}.mp4"; done;
	# better compiler steam launch option
    RADV_PERFTEST=aco %command%
	# rofi config @ ~/.config/rofi/config.rasi
	# echo "text" >| 'Users/Name/Desktop/TheAccount.txt'
	# https://gist.github.com/lbrame/1678c00213c2bd069c0a59f8733e0ee6#fonts font processing stuff
	# install nixOS package manager
    curl -L https://nixos.org/nix/install | sh
# }

# setting firefox settings programatically
touch ~/.mozilla/firefox/*.default/prefs.js
$prefs=ls ~/.mozilla/firefox/*.default -d
echo 'user_pref("media.ffmpeg.vaapi.enabled", true);' >> ~/.mozilla/firefox/*.default/prefs.js
echo 'user_pref("browser.uidensity", 1);' >> ~/.mozilla/firefox/*.default/prefs.js
echo 'user_pref("extensions.pocket.enabled", false);' >> ~/.mozilla/firefox/*.default/prefs.js