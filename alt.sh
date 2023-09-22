#!/bin/sh

# strict mode
set -euo pipefail
IFS=$'\n\t'

if [[ $EUID -ne 0 ]]; then
	# not root
	echo "must be run as root"
	exit 1
fi

if [ ! -f "/etc/arch-release" ]; then
	# not arch
	echo "this script is only intended to run on arch linux"
	exit 1
fi

preChecks() {

	echo "killing gpg-agent processes and emptying out pacmans gnupg directory"
	sleep 2
	killall gpg-agent
	rm -rf /etc/pacman.d/gnupg/*

	echo "re-initializing and populating pacmans keyring"
	sleep 2
	pacman-key --init
	pacman-key --populate archlinux

	echo "disabling download timeout on install"
	sleep 1
	perl -pi -e '$_ .= qq(DisableDownloadTimeout\n) if /# Misc options/' /etc/pacman.conf

	echo "PACMAN: Enabling parallel downloads and setting the max to 25"
	sleep 1
	sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 25/' /etc/pacman.conf

	echo "PACMAN: Enabling color in the terminal"
	sleep 1
	sed -i 's/#Color/Color/' /etc/pacman.conf

	echo "PACMAN: Adding xterm to the blocklist"
	sleep 1
	sed -i 's/#IgnorePkg   =/IgnorePkg=xterm/' /etc/pacman.conf

	# nvidia propritary drivers or vmware drivers for relevant systems, open-source generic drivers for everything else
	if [ 'lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i nvidia | wc -l' -gt 0 ]; then
		echo "nvidia drivers imported to pkg install"
	elif [ 'lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i vmware | wc -l' -gt 0 ]; then
		echo "vmware drivers imported to pkg install"
	else
		# import all open-source generic drivers
		echo "no nvidia card or vm info detected, importing generic open-source driver to pkg install"
	fi

	lsblk
	first_disk=$(lsblk -o NAME -n | grep -m 1 "^sd\|^nvme")
	read -e -p "primary disk for install (e.g: /dev/sda OR /dev/nvme0n0) | one has been suggested, you may backspace that if you want: " -i "/dev/$first_disk" TARGET_DEVICE

	read -p "timezone (eg. Australia/Sydney OR America/New_York): " TIMEZONE
	read -p "username: " USERNAME
	read -s -p "password (input hidden for security): " PASSWORD
	read -e -p "hostname: " -i "changethishostname" HOSTNAME

}
if ! preChecks; then
	echo "failed pre-checks"
	exit 1
fi

# update system clock
timedatectl set-ntp true

# partition the disk (example: using fdisk)
# be careful! this will delete all data on the target device
# modify this section based on your partitioning scheme
fdisk ${TARGET_DEVICE} <<EOF
g
n
1

+512M
t
1
n
2


w
EOF

# format and mount partitions
mkfs.ext4 ${TARGET_DEVICE}1
mkfs.ext4 ${TARGET_DEVICE}2

mount ${TARGET_DEVICE}2 /mnt
mkdir -p /mnt/boot
mount ${TARGET_DEVICE}1 /mnt/boot

# install base system
pacstrap /mnt base base-devel

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# set hostname
echo "${HOSTNAME}" > /mnt/etc/hostname

# set up locale
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# set timezone
arch-chroot /mnt ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
arch-chroot /mnt hwclock --systohc

# set root password
arch-chroot /mnt passwd

# create user and set password
arch-chroot /mnt useradd -m -G wheel ${USERNAME}
arch-chroot /mnt passwd ${USERNAME}

# configure sudo
echo "%wheel ALL=(ALL) ALL" > /mnt/etc/sudoers.d/wheel

# install and configure bootloader (example: using GRUB)
arch-chroot /mnt pacman -S grub
arch-chroot /mnt grub-install --target=i386-pc ${TARGET_DEVICE}
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# enable networking (example: using systemd-networkd)
arch-chroot /mnt systemctl enable systemd-networkd
arch-chroot /mnt systemctl enable systemd-resolved
echo "nameserver 8.8.8.8" > /mnt/etc/resolv.conf

# enable and start SSH server
arch-chroot /mnt systemctl enable sshd

# exit chroot and unmount
umount -R /mnt

echo "installation complete (hopefully)"