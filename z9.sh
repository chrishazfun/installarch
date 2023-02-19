# not sure if worthy of post.sh
# just random stuff

# backup xfce configs:
xfconf-query -c xfce4-keyboard-shortcuts -lv > backup

# restore xfce config using file
while read line; do; xfconf-query -c xfce4-keyboard-shortcuts -p "$(echo $line | awk '{print $1}')" -s "$(echo $line | awk '{print $2}')" -n; done < backup;

# prints cache
find ~/.cache/ -type f -atime +30 -print

# deletes cache
find ~/.cache/ -type f -atime +30 -delete

# prints empty dirs (dangerous)
find . -type d -empty -print

# deletes empty dirs (dangerous)
find . -type d -empty -delete

# one line converter, open dir in term and paste (ogv/mkv to mp4, wip)
for a in *.mkv; do ffmpeg -i "$a" -c copy "${a%.mkv}.mp4"; done; for b in *.ogv; do ffmpeg -i "$b" -vcodec libx264 "${f%}.mp4"; done;

# better compiler steam launch option
RADV_PERFTEST=aco %command%

rofi config @ ~/.config/rofi/config.rasi
echo "text" >| 'Users/Name/Desktop/TheAccount.txt'

# https://gist.github.com/lbrame/1678c00213c2bd069c0a59f8733e0ee6#fonts font processing stuff

# install nixOS package manager
curl -L https://nixos.org/nix/install | sh

# setting firefox settings programatically (wip)
touch ~/.mozilla/firefox/*.default/prefs.js
$prefs=ls ~/.mozilla/firefox/*.default -d
echo 'user_pref("media.ffmpeg.vaapi.enabled", true);' >> ~/.mozilla/firefox/*.default/prefs.js
echo 'user_pref("browser.uidensity", 1);' >> ~/.mozilla/firefox/*.default/prefs.js
echo 'user_pref("extensions.pocket.enabled", false);' >> ~/.mozilla/firefox/*.default/prefs.js