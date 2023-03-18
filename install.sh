#!/bin/bash
# bash ./go.sh
if [ -f "/etc/arch-release" ]; then

	echo "Enabling parallel downloads, color in the terminal and ignoring lxqt-themes pkg in favor of single lxqt-less-theme-git theme"
	sleep 1
	sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
	sed -i 's/^#Color/Color/' /etc/pacman.conf
	sed -i 's/^#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf

	echo "Updating database and checking for updates specific to archlinux-keyring, archinstall and reflector, silently skipping if they're already up to date"
	sleep 1
	sudo pacman -Syy --needed archlinux-keyring archinstall reflector

	#echo "Seperately scanning for optimal mirrors, disabled mirror check in archinstall config as its not returning great results"
	#reflector -a 48 -c Australia,Sydney -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

	echo "Installing with partly generated config in 3.. 2.. 1.." && sleep 2
	archinstall --config config.json --creds creds.json

	echo 'SETTING GTK THEMES TO FLATPAK APPS: itsfoss.com/flatpak-app-apply-theme'
	sleep 2

	echo "Done!... hopefully | Post-install script from repo available in installarch repo re-cloned in installation"

else
	echo "This isn't Arch *flies away*"
fi