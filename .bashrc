alias getmp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"
alias getmp3="yt-dlp -x --audio-format mp3"
alias downloadwebsite="wget -mkEpnp"

dropvideo () {
	echo "dropvideo format = dropvideo filenoext mp3tobenoext" && sleep 1
	echo "dropvideo: $1 to $2.mp3" && sleep 1
	ffmpeg -i $1 -vn "$2.mp3"
}

webm_mp4 () {
	echo "webm_mp4 format = dropvideo webm_no_ext mp3_no_ext" && sleep 1
	echo "dropvideo: $1 to $2.mp3" && sleep 1
	ffmpeg -i "$1.webm" -qscale 0 "$2.mp4"
}

updateall () {
	yay # updates aur and official repo packages
	flatpak update # updates flatpaks
	# sudo pacman -Scc (cleans cache)
	sudo pacman -Rns $(pacman -Qdtq)
	flatpak uninstall --unused
}