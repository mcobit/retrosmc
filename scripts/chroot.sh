#!/bin/bash

# Script by mcobit

# import config file

source /home/osmc/RetroPie/scripts/retrosmc-config.cfg

# Preparing the chroot

# Inserting the sound module for alsa output

sudo /sbin/modprobe snd-bcm2835

# check if emulationstation script in chroot is changed and if so, create altered script

if [ $(grep "while" "$INSTALLDIR/retrosmc/usr/bin/emulationstation") ]; then

echo '#!/bin/bash
es_bin="/opt/retropie/supplementary/emulationstation/emulationstation"

if [[ $(id -u) -eq 0 ]]; then
    echo "emulationstation should not be run as root. If you used 'sudo emulationstation' please run without sudo."
    exit 1
fi

if [[ -n "$(pidof X)" ]]; then
    echo "X is running. Please shut down X in order to mitigate problems with loosing keyboard input. For example, logout from LXDE."
    exit 1
fi

$es_bin "$@"' > "$INSTALLDIR/retrosmc/usr/bin/emulationstation"
fi

# copy current resolv.conf to chroot

sudo cp /etc/resolv.conf "$INSTALLDIR/retrosmc/etc/resolv.conf"

# mount the needed host directories to chroot

sudo mount -o bind /dev "$INSTALLDIR/retrosmc/dev"
sudo mount -o bind /sys "$INSTALLDIR/retrosmc/sys"
sudo mount -o bind /proc "$INSTALLDIR/retrosmc/proc"
sudo mount -o bind /boot "$INSTALLDIR/retrosmc/boot"
sudo mount -o bind /srv "$INSTALLDIR/retrosmc/srv"
sudo mount -o bind /run "$INSTALLDIR/retrosmc/run"
sudo mount -o bind /selinux "$INSTALLDIR/retrosmc/selinux"

# run emulationstation in the chroot with user pi (uuid 1000)

sudo HOME="/home/pi" /usr/sbin/chroot --userspec 1000:1000 "$INSTALLDIR/retrosmc" emulationstation

# kill processes still using the mountpoints and unmount the hostdirs from chroot

sudo fuser -k "$INSTALLDIR/retrosmc/dev"
sudo fuser -k "$INSTALLDIR/retrosmc/sys"
sudo fuser -k "$INSTALLDIR/retrosmc/proc"
sudo fuser -k "$INSTALLDIR/retrosmc/boot"
sudo fuser -k "$INSTALLDIR/retrosmc/srv"
sudo fuser -k "$INSTALLDIR/retrosmc/run"

sudo umount "$INSTALLDIR/retrosmc/dev"
sudo umount "$INSTALLDIR/retrosmc/sys"
sudo umount "$INSTALLDIR/retrosmc/proc"
sudo umount "$INSTALLDIR/retrosmc/boot"
sudo umount "$INSTALLDIR/retrosmc/srv"
sudo umount "$INSTALLDIR/retrosmc/run"
sudo umount "$INSTALLDIR/retrosmc/selinux"

