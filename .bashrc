alias getmp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"
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
		printf "Clear cache and uninstall orphans? " && read answer
	do
		case $answer in
			([yY][eE][sS] | [yY]) flushall;;
			(*) break;;
		esac
	done
}