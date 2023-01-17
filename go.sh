#!/bin/bash
# curl -s https://chrishaz.fun/arch/go.sh | bash
if [ -f "/etc/arch-release" ]; then

	echo "Enabling parallel downloads"
	sleep 1
	sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf

	echo "Updating database and checking for updates specific to archlinux-keyring and archinstall, silently skipping if they're already up to date"
	sleep 1
	sudo pacman -Syy --needed archlinux-keyring archinstall

	echo "Installing with partly generated config in 3.. 2.. 1.." && sleep 2
	archinstall --config config.json --creds creds.json

	echo "Done!... hopefully"

else
	echo "This isn't Arch *flies away*"
fi