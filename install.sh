#!/bin/bash

# Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
	echo "SYSTEM: This script must be run as root"
	exit 1
fi

if [ ! -f "/etc/arch-release" ]; then
	echo "SYSTEM: This script is only intended to run on Arch Linux"
	exit 1
fi

echo "GPG: Killing gpg-agent processes and emptying out pacmans gnupg directory"
sleep 2
killall gpg-agent
rm -rf /etc/pacman.d/gnupg/*

echo "PACMAN/GPG: Initializing and populating pacmans keyring"
sleep 2
pacman-key --init || { echo "PACMAN/GPG: Failed to initialize pacmans keyring"; exit 1; }
pacman-key --populate archlinux || { echo "PACMAN/GPG: Failed to populate pacmans keyring"; exit 1; }

echo "PACMAN: Disabling download timeout on pkgs"
sleep 1
if ! perl -pi -e '$_ .= qq(DisableDownloadTimeout\n) if /# Misc options/' /etc/pacman.conf; then
	echo "PACMAN: Failed to disable download timeout"
	exit 1
fi

echo "PACMAN: Enabling parallel downloads and setting the max to 25"
sleep 1
if ! sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf; then
	echo "PACMAN: Failed to enable parallel downloads"
	exit 1
fi

echo "PACMAN: Enabling color in the terminal"
sleep 1
if ! sed -i 's/#Color/Color/' /etc/pacman.conf; then
	echo "PACMAN: Failed to enable color in the terminal"
	exit 1
fi

echo "PACMAN: Adding xterm to the blocklist"
sleep 1
if ! sed -i 's/#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf; then
	echo "PACMAN: Failed to add xterm to the blocklist"
	exit 1
fi

# if ! read -p "SYSTEM: Username: " un && sed -i "s/#username/$un/" creds.json && sed -i "s/#username/$un/" config.json; then
# 	sed -i "s/$un/#username/" creds.json
# 	sed -i "s/$un/#username/" config.json
# 	echo "Failed to update username in creds.json and config.json, reverted username in file back to dummy."
# 	sleep 1
# 	exit 1
# fi

# if ! read -s -p "SYSTEM: Password (Input hidden for security): " pd && sed -i "s/#password/$pd/" creds.json; then
# 	sed -i "s/$pd/#password/" creds.json
# 	echo "Failed to update password in creds.json, reverted password in file back to dummy."
# 	sleep 1
# 	exit 1
# fi

echo "PACMAN: Updating internal database and checking for updates specific to archlinux-keyring, archinstall, reflector, python and python-setuptools"
sleep 2
if ! pacman -Syy --needed archlinux-keyring archinstall reflector python python-setuptools jq; then
	echo "PACMAN: Failed to update internal database and packages specific to archlinux-keyring, archinstall, reflector, python, python-setuptools and jq"
	exit 1
fi

# <<< "$configData"
config="config.json"

# nvidia propritary drivers or vmware drivers for relevant systems, open-source generic drivers for everything else
if [ 'lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l' -gt 0 ]; then
	modified_config=$(jq --arg items "Nvidia (proprietary)" '.profile_config.gfx_driver = $item)' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
	echo "SYSTEM: Nvidia drivers imported to config"
elif [ 'lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i vmware | wc -l' -gt 0 ]; then
	modified_config=$(jq --arg items "VMware / VirtualBox (open-source)" '.profile_config.gfx_driver = $item)' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
	echo "SYSTEM: VMWare drivers imported to config"
else
	echo "SYSTEM: No Nvidia card detected, skipping driver pkg import"
fi

hostnamePush () {
	read -e -p "SYSTEM: Hostname: " -i "changethishostname" hostname
	modified_config=$(jq --arg item "$hostname" '.hostname = $item' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
}
if ! hostnamePush; then
	echo "SYSTEM: Hostname import failed";
	exit 1
fi

aurPkgsParse () {
	read -e -p "SYSTEM: Optional AUR Pkgs (preferred apps prefilled): " -i "yay-bin obs-captions-plugin-bin kdocker-git plex-media-server protonup-qt-bin itch-setup-bin heroic-games-launcher-bin xboxdrv shutter-encoder github-desktop-bin boatswain jamesdsp streamlink-handoff-host" aur_pkgs
	modified_config=$(jq --arg items "$aur_pkgs" '.packages += ($items | split(" "))' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
	if [[ "$aur_pkgs" == *plex-media-server* ]]; then
		# add plexmediaserver systemd service if plex-media-server is in the aur_pkgs variable
		modified_config=$(jq --arg item "plexmediaserver" '.services += $item' <<< $(cat "$config"))
		echo "$modified_config" >> temp.json
		mv temp.json "$config"
	fi
}
if ! aurPkgsParse; then
	echo "SYSTEM: AUR packages import failed";
	exit 1
fi

addDrivesToConfig () {
	lsblk
	first_disk=$(lsblk -o NAME -n | grep -m 1 "^sd\|^nvme")
	read -e -p "SYSTEM: Primary Disk for Install (e.g: /dev/sda OR /dev/nvme0n0) | One has been suggested, you may backspace that if you want: " -i "/dev/$first_disk" hdds
	modified_config=$(jq --arg items "$hdds" '.harddrives += ($items | split(" "))' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
}
if ! addDrivesToConfig; then
	echo "SYSTEM: Unable to add drives to config";
	exit 1
fi

echo "SYSTEM: Installing with partly generated config..."
sleep 2

echo "..."
sleep 3
echo "DON'T FORGET TO CREATE"
echo "A USER WITH SUDO PRIVLEDGES"
sleep 3

# --creds creds.json
if ! archinstall --config config.json; then
	echo "SYSTEM: Failed to install"
	exit 1
fi

echo "APPLYING GTK THEMES TO GTK FLATPAK APPS: itsfoss.com/flatpak-app-apply-theme"
sleep 2

echo "IF YOU INSTALLED PLEX ACCESS http://localhost:32400/web/ FOR CONFIGURATION"
sleep 2

echo "Done!... hopefully | More to do at github.com/chrishazfun/installarch under extra.sh if you want :)"