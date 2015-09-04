
#!/bin/bash

# This scripts starts the emulationstation watchdog deamon and
# emulationstation itself while stopping KODI afterwards.
# Script by mcobit

#clear the virtaul terminal 7 screen

sudo openvt -c 7 -s -f clear

# start the watchdog script

sudo su osmc -c "sh /home/osmc/RetroPie/scripts/retropie_watchdog.sh &" &

# start chroot.sh script on virtual terminal 7 and detach it

sudo su osmc -c "nohup openvt -c 7 -f -s /home/osmc/RetroPie/scripts/chroot.sh >/dev/null 2>&1 &" &

# clear the screen again

sudo openvt -c 7 -s -f clear

# wait a bit to make sure emulationstation is running detached from kodi

sleep 0.5

# stop kodi to free input devices for emulationstation

sudo su -c "systemctl stop mediacenter &" &

exit
