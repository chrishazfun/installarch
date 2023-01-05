# installarch
My method of installing Arch Linux, using a script that edits a config then uses the pre-installed archinstall command with it, more or less making my own distro.

## Installation
```
sudo pacman -Syy git
git clone https://github.com/chrishazfun/installarch
cd installarch
bash ./go.sh
```

## Notes
Premade configurations used when executing ./go.sh doesn't include disk layouts or conditions for root access and sudo access for users, you must manually configure that.