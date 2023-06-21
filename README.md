# installarch
My personal method of installing Arch Linux, using [`archinstall`](https://www.github.com/archlinux/archinstall) as a base.

### Installation (all commands required and in order, refer to sections below for more info)
```bash
pacman-key --init
sudo pacman -Syy git
git clone https://github.com/chrishazfun/installarch
cd installarch
bash install.sh
```

### Additional Notes
1. The initial startup before the actual archinstall screen comes up may take a while, the plugin used to gather AUR pkgs is just preparing itself, this may take ~10 minutes.
2. You will be required to create an account in the archinstall screen, also make sure to set sudo access to true if you wanna use temporary admin features.

### Wifi
In the case that you're not using a wired connection and have Wifi, you can connect to it through these 5 steps:
1. Run [`iwctl`](https://wiki.archlinux.org/index.php/Iwd#iwctl) to access the cli interface for `iw`
2. Run `device list`, and find your device name.
3. Run `station [device name] scan` to scan for nearby connections
4. Run `station [device name] get-networks` to grab info on said connections, the scan command is a seperate function to execute if you're wondering.
5. Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`.
6. (Optional) If you don't know if you're connected you can test it by running `ping google.com`, press Ctrl+C to stop the ping test.

### Prerequisite Part 1
Sometimes before installation you may be required to execute a command like ```sgdisk -Zo <disk-to-install-arch-on>```, this command completely clears whatever disk you select on execution so backup your stuff, after this you should ```reboot``` to avoid any disk-related errors when you move forward with the installation.