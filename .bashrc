alias getmp4="yt-dlp -f 'bestvideo+bestaudio[ext=m4a]' --recode-video mp4"
alias getmp3="yt-dlp -x --audio-format mp3"
alias downloadwebsite="wget -mkEpnp"

flushall () {
	sudo pacman -Scc
	sudo pacman -Rns $(pacman -Qdtq)
	flatpak uninstall --unused
}

updateall () {
	yay
	flatpak update
	while
		read -p "Clear cache and uninstall orphans? (y/N)" answer
	do
		case $answer in
			([yY][eE][sS] | [yY]) flushall;;
			(*) break;;
		esac
	done
}

downloadimagesfromwebsite () {
	# download images from website (jpg png gifs) [WIP]
	for line in $1; do
		# replace http://
		stripped_url=`echo $line | cut -c8-`
		target_folder="downloads/`echo $stripped_url | sed 's/\//_/g'`"
		echo "scraping $stripped_url ..."
		echo "-----------------------------------"
		echo "> creating folder ..."
		echo $target_folder
		mkdir -p $target_folder
		echo "> scraping $stripped_url ..."
		wget -e robots=off \
			-H -nd -nc -np \
			--recursive -p \
			--level=1 \
			--accept jpg,jpeg,png,gif \
			--convert-links -N \
			--limit-rate=200k \
			--wait 1.0 \
			-P $target_folder $stripped_url
		echo "> done scraping $stripped_url"
	done
}