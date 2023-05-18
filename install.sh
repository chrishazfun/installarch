#!/bin/bash

# generated with suggestions from chatgpt, combed through just in case, god help us all

# Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f "/etc/arch-release" ]; then
   echo "This script is only intended to run on Arch Linux"
   exit 1
fi

echo "Killing gpg-agent processes and emptying out pacmans gnupg directory"
sleep 2
killall gpg-agent
rm -rf /etc/pacman.d/gnupg/*

echo "Initializing and populating pacmans keyring"
sleep 2
pacman-key --init || { echo "Failed to initialize pacmans keyring"; exit 1; }
pacman-key --populate archlinux || { echo "Failed to populate pacmans keyring"; exit 1; }

echo "Disabling timeout on downloading packages"
sleep 2
if ! perl -pi -e '$_ .= qq(DisableDownloadTimeout\n) if /# Misc options/' /etc/pacman.conf; then
    echo "Failed to disable download timeout"
    exit 1
fi

echo "Enabling parallel downloads and setting them to 25 max"
if ! sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf; then
    echo "Failed to enable parallel downloads"
    exit 1
fi

echo "Enabling color in the terminal"
if ! sed -i 's/#Color/Color/' /etc/pacman.conf; then
    echo "Failed to enable color in the terminal"
    exit 1
fi

echo "Adding xterm to the pkg blocklist"
if ! sed -i 's/#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf; then
    echo "Failed to add xterm to the blocklist so as to prevent being installed when archinstall is executed"
    exit 1
fi

echo "Adjusting makeflags for makepkg"
nc=$(grep -c ^processor /proc/cpuinfo)
if ! sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf; then
    echo "Step 1 in adjusting makeflags for makepkg failed"
    exit 1
fi
if ! sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf; then
    echo "Step 2 in adjusting makeflags for makepkg failed"
    exit 1
fi

# read -p "Enter username: " un
# sed -i "s/#username/$un/" creds.json || { sed -i "s/$un/#username/" creds.json; echo "Failed to update username in creds.json, reverted username in file back to dummy."; exit 1; }
# sed -i "s/#username/$un/" config.json || { sed -i "s/$un/#username/" config.json; echo "Failed to update username in config.json, reverted username in file back to dummy."; exit 1; }
# sleep 1

# read -s -p "Enter password (Input hidden for security): " pd
# sed -i "s/#password/$pd/" creds.json || { sed -i "s/$pd/#password/" creds.json; echo "Failed to update password in creds.json, reverted password in file back to dummy."; exit 1; }
# sleep 1

echo "Updating internal database and checking for updates specific to archlinux-keyring, archinstall, reflector and python-setuptools. Silently skipping if they're already up to date."
sleep 2
if ! pacman -Syy --needed archlinux-keyring archinstall reflector python python-setuptools; then
    echo "Failed to update packages"
    exit 1
fi

# --creds creds.json
echo "Installing with partly generated config in 3.. 2.. 1.."
sleep 2
if ! archinstall --config config.json; then
    echo "Failed to install"
    exit 1
fi

echo "APPLYING GTK THEMES TO GTK FLATPAK APPS: itsfoss.com/flatpak-app-apply-theme"
sleep 2

echo "Done!... hopefully | More to do at github.com/chrishazfun/installarch under extra.sh if you want :)"