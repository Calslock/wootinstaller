#!/bin/bash
# Author: Calslock
# Version 0.1

# [Deck] Check if password set
if [[ `passwd -S $USER | cut -d" " -f2` != "P" ]]
	then
	zenity --warning --text="Password not set! \nPlease run passwd in terminal to set password for your account, then run the installer again"
	exit 0
fi

# Ask for sudo password
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Install udev rules
echo "Installing udev rules..."

sudo echo '# Wooting One Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

# Wooting One update mode 
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

# Wooting Two Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

# Wooting Two update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

# Generic Wootings
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"' > /etc/udev/rules.d/70-wooting.rules

# Restart udevadm
sudo udevadm control --reload-rules
sudo udevadm trigger

# Install Wootility
echo "Installing Wootility..."
if curl -L "https://api.wooting.io/public/wootility/download?os=linux&branch=lekker" --output /home/$SUDO_USER/Desktop/Wootility.AppImage
	then 
	chown $SUDO_UID:$SUDO_GID /home/$SUDO_USER/Desktop/Wootility.AppImage
	echo "Wootility has been installed!"
else
	echo "Couldn't download Wootility. Please try download it manually from https://wooting.io/wootility"
fi
