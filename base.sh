#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
passwd root

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub efibootmgr base-devel doas networkmanager wpa_supplicant reflector bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack openssh tlp firewalld 

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable tlp 
systemctl enable reflector.timer
systemctl enable fstrim.timer

useradd -m nick
passwd nick
usermod -aG wheel nick

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
