#!/bin/bash

# "bash strict mode"
set -euo pipefail
IFS=$'\n\t'

if [[ $EUID -ne 0 ]]; then
	# root only
	echo "This script must be run as root."
	exit 1
fi

if [ ! -f "/etc/arch-release" ]; then
	# arch only
	echo "This script is only intended to run on Arch Linux."
	exit 1
fi

echo "Killing gpg-agent processes and emptying out pacmans gnupg directory"
sleep 2
killall gpg-agent
rm -rf /etc/pacman.d/gnupg/*

echo "Initializing and populating pacmans keyring"
sleep 2
pacman-key --init || { echo "Failed to initialize pacmans keyring."; exit 1; }
pacman-key --populate archlinux || { echo "Failed to populate pacmans keyring."; exit 1; }

echo "Disabling download timeout on pkgs"
sleep 1
if ! perl -pi -e '$_ .= qq(DisableDownloadTimeout\n) if /# Misc options/' /etc/pacman.conf; then
	echo "Failed to disable download timeout on pkgs"
	exit 1
fi

echo "Enabling parallel downloads and setting the max to 25"
sleep 1
if ! sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf; then
	echo "Failed to enable parallel downloads"
	exit 1
fi

echo "Enabling color in the terminal"
sleep 1
if ! sed -i 's/#Color/Color/' /etc/pacman.conf; then
	echo "Failed to enable color in the terminal"
	exit 1
fi

echo "Adding xterm to the blocklist"
sleep 1
if ! sed -i 's/#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf; then
	echo "Failed to add xterm to the blocklist"
	exit 1
fi

echo "Updating internal database and checking for updates specific to these pkgs: archlinux-keyring, archinstall, reflector, python, python-setuptools, jq"
sleep 2
if ! pacman -Syy --needed archlinux-keyring archinstall reflector python python-setuptools jq; then
	echo "Failed to update internal database and failed to check for updates specific to these pkgs: archlinux-keyring, archinstall, reflector, python, python-setuptools, jq"
fi

# <<< "$configData"
config="config.json"

# nvidia propritary drivers or vmware drivers for relevant systems, open-source generic drivers for everything else
if [ 'lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l' -gt 0 ]; then
	modified_config=$(jq --arg items "Nvidia (proprietary)" '.profile_config.gfx_driver = $item)' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
	echo "Nvidia proprietary drivers imported to config"
elif [ 'lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i vmware | wc -l' -gt 0 ]; then
	modified_config=$(jq --arg items "VMware / VirtualBox (open-source)" '.profile_config.gfx_driver = $item)' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
	echo "VMWare drivers imported to config"
else
	echo "No Nvidia card detected, generic driver imported"
fi

hostnamePush () {
	read -e -p "Hostname: " -i "changethishostname" hostname
	modified_config=$(jq --arg item "$hostname" '.hostname = $item' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
}
if ! hostnamePush; then
	echo "SYSTEM: Hostname import failed";
fi

aurPkgsParse() {
	read -e -p "Optional AUR Pkgs (preferred apps prefilled): " -i "yay-bin protonup-qt-bin itch-setup-bin heroic-games-launcher-bin xboxdrv shutter-encoder github-desktop-bin boatswain jamesdsp streamlink-handoff-host" aur_pkgs
	modified_config=$(jq --arg items "$aur_pkgs" '.packages += ($items | split(" "))' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
}
if ! aurPkgsParse; then
	echo "SYSTEM: AUR packages import failed";
fi

addDrivesToConfig() {
	lsblk
	first_disk=$(lsblk -o NAME -n | grep -m 1 "^sd\|^nvme")
	read -e -p "SYSTEM: Primary Disk for Install (e.g: /dev/sda OR /dev/nvme0n0) | One has been suggested, you may backspace that if you want: " -i "/dev/$first_disk" hdds
	modified_config=$(jq --arg items "$hdds" '.harddrives += ($items | split(" "))' <<< $(cat "$config"))
	echo "$modified_config" >> temp.json
	mv temp.json "$config"
}
if ! addDrivesToConfig; then
	echo "SYSTEM: Unable to add drives to config";
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