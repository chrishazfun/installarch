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

# Check if the /etc/arch-release file exists
if [ ! -f "/etc/arch-release" ]; then
   echo "This script is only intended to run on Arch Linux"
   exit 1
fi

# Kill gpg-agent processes and empty out pacmans gnupg directory
echo "Killing gpg-agent processes and emptying out pacmans gnupg directory"
sleep 2
killall gpg-agent
rm -rf /etc/pacman.d/gnupg/*

# Initialize and populate pacmans keyring
echo "Initializing and populating pacmans keyring"
sleep 2
pacman-key --init || { echo "Failed to initialize pacmans keyring"; exit 1; }
pacman-key --populate archlinux || { echo "Failed to populate pacmans keyring"; exit 1; }

# Disable timeout on downloading packages, enable parallel downloads and set them to 25 max, enable color in the terminal and block xterm from being installed
echo "Disabling timeout on downloading packages, enabling parallel downloads and setting them to 25 max, enabling color in the terminal and blocking xterm from being installed"
sleep 2
if ! perl -pi -e '$_ .= qq(DisableDownloadTimeout\n) if /# Misc options/' /etc/pacman.conf; then
    echo "Failed to disable download timeout"
    exit 1
fi

if ! sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf; then
    echo "Failed to enable parallel downloads"
    exit 1
fi

if ! sed -i 's/#Color/Color/' /etc/pacman.conf; then
    echo "Failed to enable color in the terminal"
    exit 1
fi

if ! sed -i 's/#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf; then
    echo "Failed to add xterm to the blocklist so as to prevent being installed when archinstall is executed"
    exit 1
fi

# Prompt for username and password
read -p "Enter username: " un
sed -i "s/#username/$un/" creds.json || { echo "Failed to update username in creds.json"; exit 1; }
sleep 1

read -s -p "Enter password (Input hidden for security): " pd
sed -i "s/#password/$pd/" creds.json || { echo "Failed to update password in creds.json"; exit 1; }
sleep 1

# Update database and check for updates specific to archlinux-keyring, archinstall, reflector and python-setuptools
echo "Updating database and checking for updates specific to archlinux-keyring, archinstall, reflector and python-setuptools. Silently skipping if they're already up to date."
sleep 2
if ! sudo pacman -Syy --needed archlinux-keyring archinstall reflector python-setuptools; then
    echo "Failed to update packages"
    exit 1
fi

# Install with partly generated config
echo "Installing with partly generated config in 3.. 2.. 1.."
sleep 2
if ! archinstall --config config.json --creds creds.json; then
    echo "Failed to install"
    exit 1
fi

echo "APPLYING GTK THEMES TO GTK FLATPAK APPS: itsfoss.com/flatpak-app-apply-theme"
sleep 2

echo "Done!... hopefully | Post-install script available at github.com/chrishazfun/linux in /arch under extra.sh"