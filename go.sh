#!/bin/bash
# bash ./go.sh
if [ -f "/etc/arch-release" ]; then

	echo "Enabling parallel downloads"
	sleep 1
	sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf

	echo "Updating database and checking for updates specific to archlinux-keyring and archinstall, silently skipping if they're already up to date"
	sleep 1
	sudo pacman -Syy --needed archlinux-keyring archinstall

	echo "Installing with partly generated config in 3.. 2.. 1.." && sleep 2
	archinstall --config config.json --creds creds.json

	echo "Done!... hopefully | Post-install script from repo available in installarch repo re-cloned in installation"

else
	echo "This isn't Arch *flies away*"
fi