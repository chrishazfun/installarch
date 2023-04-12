#!/bin/bash

if [ -f "/etc/arch-release" ]; then

	echo "Killing gpg-agent processes and emptying out pacmans gnupg directory"
	sleep 2
	killall gpg-agent
	rm -rf /etc/pacman.d/gnupg/*

	echo "Initializing and populating pacmans keyring"
	sleep 2
	pacman-key --init
	pacman-key --populate archlinux

	echo "Disabling timeout on downloading packages, enabling parallel downloads and setting them to 25 max, color in the terminal and blocking xterm from being installed"
	sleep 2
	perl -pi -e '$_ .= qq(DisableDownloadTimeout\n) if /# Misc options/' /etc/pacman.conf
	sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf
	sed -i 's/#Color/Color/' /etc/pacman.conf
	sed -i 's/#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf

	read -p "Enter username: " un
	sed -i "s/#username/$un/" creds.json
	sleep 1

	read -s -p "Enter password (Input hidden for security): " pd
	sed -i "s/#password/$pd/" creds.json
	sleep 1

	echo "Updating database and checking for updates specific to archlinux-keyring, archinstall, reflector and python-setuptools. Silently skipping if they're already up to date."
	sleep 2
	sudo pacman -Syy --needed archlinux-keyring archinstall reflector python-setuptools

	echo "Installing with partly generated config in 3.. 2.. 1.."
	sleep 2
	archinstall --config config.json --creds creds.json

	echo "SETTING GTK THEMES TO FLATPAK APPS: itsfoss.com/flatpak-app-apply-theme"
	sleep 2

	echo "Done!... hopefully | Post-install script from repo available in installarch repo re-cloned in installation"

else
	echo "This isn't Arch *flies away*"
fi