#!/bin/bash
# Hypr-dots installer script for Arch Linux.
# Do NOT run this script as root...

sucmd=sudo # sudo or doas??

echo "This script will install necessary packages and overwrite any file that conflicts with Hypr-dots config files. You will NOT prompted for any change."
echo "Make sure to run this at Hypr-dots folder."
echo "Are you sure you want to continue? (Press any key to continue or ctrl + c to exit without making ANY change...)"
read
echo "Starting installation..."
tmp=/tmp/hypr-temp
mkdir $tmp
cp -r etc $tmp
cp -r config $tmp
cd
echo "Upgrading system..."
$sucmd pacman -Syu
echo "Checking if paru is installed..."
if paru --version 2&> /dev/null ; then
echo "Paru is installed."
else
echo "Paru is not is not installed."
echo "Installing paru..."
if ! git -v 2&> /dev/null ; then
$sucmd pacman -Sy git
fi
$sucmd pacman -Sy fakeroot go make gcc --noconfirm
cd /tmp
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd
echo "Installed paru."
fi

echo "Installing dependencies..."
$sucmd pacman -Sy hyprland waybar xdg-desktop-portal-hyprland polkit-kde-agent pamixer pulseaudio pavucontrol fish kitty starship noto-fonts dolphin mako wofi qt5ct kvantum lxappearance pkgconfig which neofetch --noconfirm
paru -S swww wlogout catppuccin-gtk-theme-mocha sddm-catppuccin-git catppuccin-cursors-mocha hyprshot ttf-jetbrains-mono-nerd kvantum-theme-catppuccin-git

swww init

echo "Enabling SDDM..."
$sucmd systemctl enable sddm

echo "Setting Kitty terminal theme..."
kitty +kitten themes --reload-in=all Catppuccin-Mocha

echo "Set fish as shell"
chsh -s $(which fish)

echo "Installing icons..."
cd /tmp
git clone https://github.com/vinceliuice/Tela-circle-icon-theme
cd Tela-circle-icon-theme
chmod +x install.sh
bash install.sh -c purple
cd

echo "Copying files..."
$sucmd cp $tmp/etc/environment /etc
$sucmd cp $tmp/etc/sddm.conf /etc
mkdir ~/.config bb&> /dev/null
cp -r $tmp/config/* ~/.config

echo "Installation finished!"
