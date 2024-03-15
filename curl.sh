echo "killing gpg-agent processes and emptying out pacmans gnupg directory"
sleep 2
killall gpg-agent
rm -rf /etc/pacman.d/gnupg/*

echo "re-initializing and populating pacmans keyring"
sleep 2
pacman-key --init || { echo "failed to re-initialize pacmans keyring"; exit 1; }
pacman-key --populate archlinux || { echo "failed to populate pacmans keyring"; exit 1; }

doTheThing() {
	pacman -Syy git
	git clone https://github.com/chrishazfun/installarch
	cd installarch
	bash install.sh
}
if ! doTheThing; then
	echo "failed to execute"
	exit 1
fi