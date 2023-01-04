#!/bin/bash
# bash ./go.sh
if [ -f "/etc/arch-release" ]; then
	sudo pacman -S --noconfirm archinstall archlinux-keyring # update keyrings and archinstall pkg to latest to prevent packages failing to install
	echo "checking gpu and adjusting accordingly"
	gpu_type=$(lspci)
	if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
		echo "gpu detected as nvidia"
		sleep 1
		sed -i 's/"gfx_driver": "",/"gfx_driver": "Nvidia",/' config.json
	else
		echo "not nvidia, falling back to open-source drivers"
		sleep 1
		sed -i 's/"gfx_driver": "",/"gfx_driver": "All open-source (default)",/' config.json
	fi
	lsblk
	read -p "please enter primary installation disk (e.g. /dev/sda /dev/nvme0n1): " harddrive
	if [[ "${harddrive,,}" =~ (\/\S*) ]]; then
		sed -i "s|\"harddrives\": [\"\"],|\"harddrives\": [\"$harddrive\"],|g" config.json
		echo "installing in 3.. 2.. 1.." && sleep 2
		archinstall --config config.json
	else
		echo "invalid disk format, exiting script"
		exit 0
	fi
else
	echo "this ain't arch *flies away*"
fi