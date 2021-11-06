#!/bin/bash -e

# Locale
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Hostname
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# Users
printf "Set root password:"
passwd root
useradd -m nick
usermod -aG wheel nick
printf "Set user password:"
passwd nick

# Packages
pacman -S grub base-devel doas networkmanager wpa_supplicant reflector bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack openssh tlp firewalld

echo "permit :wheel" >> /etc/doas.conf
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf
doas -C /etc/doas.conf

# Bootloader
grub-install --target=i386-pc /dev/sdX
# pacman -S efibootmgr
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable tlp 
systemctl enable reflector.timer
systemctl enable fstrim.timer

printf "\e[1;32mDone! Type exit, umount -a and reboot.\n[0m"
