## installarch
My personal method of installing Arch Linux, using [`archinstall`](https://www.github.com/archlinux/archinstall) as a base.

### Wifi
In the case that you're not using a wired connection and have Wifi, you can connect to it through these 5 steps:
1. Run [`iwctl`](https://wiki.archlinux.org/index.php/Iwd#iwctl) to access the cli interface for `iw`
2. Run `device list`, and find your device name.
3. Run `station [device name] scan` to scan for nearby connections
4. Run `station [device name] get-networks` to grab info on said connections, the scan command is a seperate function to execute if you're wondering.
5. Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`.
6. (Optional) If you don't know if you're connected you can test it by running `ping google.com`, press Ctrl+C to stop the ping test.

### Prerequisite Part 1
Sometimes you may be required to execute a command like ```sgdisk -Zo <disk-to-install-arch-on>```, this completely clears a single disk, after this you should execute ```reboot``` to avoid any errors when you move forward with the installation.

### Prerequisite Part 2
You may encounter some errors when using Pacman (Arch Linux's default package manager) like that of syncing databases, we've found most of them get resolved by reinitializing its keyring by executing ```pacman-key --init```, theres no need to ```reboot``` after this but if you feel like you need to go ahead :)

### Installation
```bash
sudo pacman -Syy git
git clone https://github.com/chrishazfun/installarch
cd installarch
bash ./install.sh
```