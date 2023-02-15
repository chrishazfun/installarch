# installarch
My method of installing Arch Linux, using a script that edits a config then uses the pre-installed archinstall command with it, more or less making my own distro.

## Wifi
In the case that you're not using Ethernet and have Wifi, you can connect to it through these 5 steps:
1. Run `iwctl`
2. Run `device list`, and find your device name.
3. Run `station [device name] scan`
4. Run `station [device name] get-networks`
5. Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`, and then Press Ctrl+C to stop the ping test.

## Prerequisite Part 1
Sometimes you may be required to execute a command like ```sgdisk -Zo <disk-to-install-arch-on>```, this completely clears a single disk, after this you should ```reboot``` to avoid any errors when you move forward with the installation.

## Prerequisite Part 2
You may encounter some errors when using Pacman (Arch Linux's default package manager) like that of syncing databases and we've found most of them get resolved by reinitializing its keyring by executing ```pacman-key --init```

## Installation
```
sudo pacman -Syy git
git clone https://github.com/chrishazfun/installarch
cd installarch
bash ./go.sh
```

## Notes
Premade configurations doesn't include selected disks and their layouts, you must manually configure that.