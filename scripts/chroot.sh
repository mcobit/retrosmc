#!/bin/bash

# Preparing the chroot

# Inserting the sound module for alsa output

sudo /sbin/modprobe snd-bcm2835sudo /sbin/modprobe snd-bcm2835

# mount the needed host directories to chroot

sudo mount -o bind /dev /opt/retropie-rootfs/dev
sudo mount -o bind /sys /opt/retropie-rootfs/sys
sudo mount -o bind /proc /opt/retropie-rootfs/proc
sudo mount -o bind /boot /opt/retropie-rootfs/boot
sudo mount -o bind /srv /opt/retropie-rootfs/srv
sudo mount -o bind /run /opt/retropie-rootfs/run
sudo mount -o bind /selinux /opt/retropie-rootfs/selinux

# run emulationstation in the chroot with user pi

sudo HOME="/home/pi" /usr/sbin/chroot --userspec 1000:1000 /opt/retropie-rootfs emulationstation

# unmount the hostdirs from chroot

sudo umount /opt/retropie-rootfs/dev
sudo umount /opt/retropie-rootfs/sys
sudo umount /opt/retropie-rootfs/proc
sudo umount /opt/retropie-rootfs/boot
sudo umount /opt/retropie-rootfs/srv
sudo umount /opt//retropie-rootfs/run
sudo umount /opt/retropie-rootfs/selinux

