#!/bin/bash -e

# Variables
country=Germany
kbmap=en
output=Virtual-1
resolution=1920x1080

# Options
aur_helper=true
gen_xprofile=true

doas timedatectl set-ntp true
doas hwclock --systohc

mkdir -p repos

if [[ $aur_helper = true ]]; then
    cd repos
    git clone https://aur.archlinux.org/paru.git 
    cd paru/;makepkg -si --noconfirm;cd
fi

# Install packages
doas pacman -S xorg-server xorg-xinit xorg-xrandr xorg-xsetroot firefox feh alacritty

# TODO: Install fonts

# Pull Git repositories and install
# TODO: personal forks
cd /repos
repos=( "dmenu" "dwm" "slstatus" "slock" )
for repo in ${repos[@]}
do
    git clone git://git.suckless.org/$repo
    cd $repo;make;doas make install;cd ..
done

# XSessions and dwm.desktop
if [[ ! -d /usr/share/xsessions ]]; then
    doas mkdir /usr/share/xsessions
fi

cat > ./temp << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=Dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession
EOF
doas cp ./temp /usr/share/xsessions/dwm.desktop;rm ./temp

# .xprofile
if [[ $gen_xprofile = true ]]; then
cat > ~/.xprofile << EOF
setxkbmap $kbmap
xrandr --output $output --mode $resolution
EOF
fi

printf "\e[1;32mDone! you can now reboot.\n\e[0m\n"

