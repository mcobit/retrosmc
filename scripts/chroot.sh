#!/bin/bash

source /home/osmc/RetroPie/scripts/retrosmc-config.cfg

# Preparing the chroot

# Inserting the sound module for alsa output

sudo /sbin/modprobe snd-bcm2835sudo /sbin/modprobe snd-bcm2835

# mount the needed host directories to chroot

sudo mount -o bind /dev "$INSTALLDIR/retrosmc/dev"
sudo mount -o bind /sys "$INSTALLDIR/retrosmc/sys"
sudo mount -o bind /proc "$INSTALLDIR/retrosmc/proc"
sudo mount -o bind /boot "$INSTALLDIR/retrosmc/boot"
sudo mount -o bind /srv "$INSTALLDIR/retrosmc/srv"
sudo mount -o bind /run "$INSTALLDIR/retrosmc/run"
sudo mount -o bind /selinux "$INSTALLDIR/retrosmc/selinux"

# run emulationstation in the chroot with user pi

sudo HOME="/home/pi" /usr/sbin/chroot --userspec 1000:1000 "$INSTALLDIR/retrosmc" emulationstation

# unmount the hostdirs from chroot

sudo umount "$INSTALLDIR/retrosmc/dev"
sudo umount "$INSTALLDIR/retrosmc/sys"
sudo umount "$INSTALLDIR/retrosmc/proc"
sudo umount "$INSTALLDIR/retrosmc/boot"
sudo umount "$INSTALLDIR/retrosmc/srv"
sudo umount "$INSTALLDIR/retrosmc/run"
sudo umount "$INSTALLDIR/retrosmc/selinux"

