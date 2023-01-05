#!/bin/bash
# bash ./go.sh OR archinstall --config config.json
if [ -f "/etc/arch-release" ]; then

	echo "Updating keyrings and archinstall to latest to prevent packages failing to install"
	sudo pacman -S --noconfirm --needed archinstall archlinux-keyring

	echo "Enabling parallel downloads, using all threads for better compilation"
	sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 20/' /etc/pacman.conf
	NC=$(grep -c ^processor /proc/cpuinfo)
	sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$NC\"/g" /etc/makepkg.conf
	sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $NC -z -)/g" /etc/makepkg.conf

	echo "Adjusting GPU drivers"
	GPU_TYPE=$(lspci)
	if grep -E "NVIDIA|GeForce" <<< ${GPU_TYPE}; then
		echo "GPU detected as Nvidia"
		sed -i 's/#gfx_driver/"gfx_driver": "Nvidia",/' config.json
	else
		echo "Not Nvidia, falling back to open-source drivers"
		sleep 1
		sed -i 's/#gfx_driver/"gfx_driver": "All open-source (default)",/' config.json
	fi

	# select disk/s
	lsblk -n
	read -p "Please enter primary installation disk (e.g. /dev/sda /dev/nvme0n1): " drive
	if [[ "${drive,,}" =~ (\/\S*) ]]; then
		sed -i "s|#harddrives|\"harddrives\": [\"$drive\"]|g" config.json
		echo "Installing with partly generated config in 3.. 2.. 1.." && sleep 2
		archinstall --config config.json
		echo "Done!... hopefully"
	else
		echo "Invalid disk format, exiting script"
		exit 0
	fi

else
	echo "This isn't Arch *flies away*"
fi