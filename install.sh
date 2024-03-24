#!/bin/bash
# Author: Calslock
# Version 0.2.1

# [Deck] Check if password set
if [[ `passwd -S $USER | cut -d" " -f2` != "P" ]]
then
	zenity --warning --title="WootInstaller" --text="Password not set! \nPlease run passwd in terminal to set password for your account, then run the installer again"
	exit 0
fi

# Ask for sudo password
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Install udev rules
echo "Installing udev rules..."

echo '# Wooting One Legacy
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
echo "Restarting udevadm..."
udevadm control --reload-rules
udevadm trigger

# Install Wootility
echo "Installing Wootility..."

CHANNEL=$(zenity --title="WootInstaller" --list --radiolist --text="Choose update channel:" --hide-header \
       	--column "X" --column "Channel" \
	TRUE "stable" \
	FALSE "beta")

if [[ -z "$CHANNEL" ]]
then
	zenity --title="WootInstaller" --info --text="Installation cancelled!"
	exit 0
fi	

URL="https://api.wooting.io/public/wootility/download?os=linux&branch=lekker&channel=$CHANNEL"

if curl -L $URL --output /home/$SUDO_USER/Desktop/Wootility-$CHANNEL.AppImage
then 
	chown $SUDO_UID:$SUDO_GID /home/$SUDO_USER/Desktop/Wootility-$CHANNEL.AppImage
	chmod +x /home/$SUDO_USER/Desktop/Wootility-$CHANNEL.AppImage
	echo "Wootility has been installed!"
	zenity --title="WootInstaller" --info --text="Wootility has been installed! You can now run it from your desktop."
else
	zenity --info --title="WootInstaller" --text="Couldn't download Wootility. Please try download it manually from https://wooting.io/wootility"
fi

