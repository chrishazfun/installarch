# installarch
My personal method of installing Arch Linux, using a script that sets up the ideal conditions for a system installation and uses the pre-installed [archinstall](https://github.com/archlinux/archinstall) command with a premade config to install my ideal Arch Linux system, styled somewhat but not too much for others so as to feel more inviting.

## Wifi
In the case that you're not using a wired connection and have Wifi, you can connect to it through these 5 steps:
1. Run `iwctl` to access the cli interface for `iw`
2. Run `device list`, and find your device name.
3. Run `station [device name] scan`
4. Run `station [device name] get-networks`
5. Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`.
6. (Optional) If you don't know if you're connected you can test it by running `ping google.com`, press Ctrl+C to stop the ping test.

## Prerequisite Part 1
Sometimes you may be required to execute a command like ```sgdisk -Zo <disk-to-install-arch-on>```, this completely clears a single disk, after this you should execute ```reboot``` to avoid any errors when you move forward with the installation.

## Prerequisite Part 2
You may encounter some errors when using Pacman (Arch Linux's default package manager) like that of syncing databases, we've found most of them get resolved by reinitializing its keyring by executing ```pacman-key --init```, theres no need to ```reboot``` after this but if you feel like you need to go ahead :)

## Installation
```
sudo pacman -Syy git
git clone https://github.com/chrishazfun/installarch
cd installarch
bash ./go.sh
```

## Notes
Premade configurations doesn't include selected disks and their layouts, you must manually configure that.