import logging
import archinstall
from archinstall import Installer

__version__ = 0.1

class Plugin:
    TEMPORARY_USER_NAME = "tempsudo"
    DEPENDENCIES = ["git"]
    AUR_HELPER_REPOSITORY = "https://aur.archlinux.org/yay-bin.git"

    def on_install(self, installer: Installer):
        packages_aur = archinstall.arguments['packages-aur']
        if len(packages_aur) > 0:
            self.install_dependencies(installer)
            self.create_temporary_user(installer)
            self.enable_passwordless_sudo(installer)
            self.install_helper(installer)
            self.install_packages_aur(packages_aur, installer)
            self.disable_passwordless_sudo(installer)
            self.delete_temporary_user(installer)

    def install_dependencies(self, installer: Installer):
        installer.log(f"Installing dependencies needed for package installations: {self.DEPENDENCIES}", level=logging.INFO)
        installer.pacstrap(self.DEPENDENCIES)

    def create_temporary_user(self, installer: Installer):
        installer.log(installer.user_create(self.TEMPORARY_USER_NAME), level=logging.DEBUG)

    def delete_temporary_user(self, installer: Installer):
        installer.log(f'Deleting user {self.TEMPORARY_USER_NAME}', level=logging.INFO)
        installer.log(installer.arch_chroot(f"userdel {self.TEMPORARY_USER_NAME}"), level=logging.DEBUG)

    def enable_passwordless_sudo(self, installer: Installer):
        installer.log("Temporarily enabling passwordless sudo to use makepkg.", level=logging.INFO)
        installer.log(installer.arch_chroot(r"sed -i 's/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers"), level=logging.DEBUG)

    def disable_passwordless_sudo(self, installer: Installer):
        installer.log("Disabling passwordless sudo.", level=logging.INFO)
        installer.log(installer.arch_chroot(r"sed -i 's/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers"), level=logging.DEBUG)

    def install_helper(self, installer: Installer):
        installer.log("Installing Yay AUR helper.", level=logging.INFO)
        installer.log(installer.arch_chroot(f"su tempsudo -c 'cd $(mktemp -d) && git clone {self.AUR_HELPER_REPOSITORY} . && makepkg -sim --noconfirm'"), level=logging.DEBUG)

    def install_packages_aur(self, packages_aur, installer: Installer):
        installer.log(f"Installing AUR packages: {' '.join(packages_aur)}", level=logging.INFO)
        installer.log(installer.arch_chroot(f'su {self.TEMPORARY_USER_NAME} -c "yay -Sy --nosudoloop --needed --noconfirm {" ".join(packages_aur)}"'),level=logging.DEBUG)