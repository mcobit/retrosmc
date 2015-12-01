
#!/bin/bash

# This scripts starts the emulationstation watchdog deamon and
# emulationstation itself while stopping KODI afterwards.
# Script by mcobit

#clear the virtaul terminal 7 screen

sudo openvt -c 7 -s -f clear

# start the watchdog script

sudo su osmc -c "sh /home/osmc/RetroPie/scripts/retropie_watchdog.sh &" &

# check if emulationstation script in chroot is changed and if so, create altered script

sudo chown osmc:osmc /usr/bin/emulationstation

echo '#!/bin/bash
es_bin="/opt/retropie/supplementary/emulationstation/emulationstation"
export PATH=$PATH:/opt/vc/bin
if [[ $(id -u) -eq 0 ]]; then
    echo "emulationstation should not be run as root. If you used 'sudo emulationstation' please run without sudo."
    exit 1
fi
if [[ -n "$(pidof X)" ]]; then
    echo "X is running. Please shut down X in order to mitigate problems with loosing keyboard input. For example, logout from LXDE."
    exit 1
fi
$es_bin "$@"' > "/usr/bin/emulationstation"

# start emulationstation on vitrual terminal 7 and detach it

sudo su osmc -c "nohup openvt -c 7 -f -s emulationstation >/dev/null 2>&1 &" &

# clear the screen again

sudo openvt -c 7 -s -f clear

# wait a bit to make sure emulationstation is running detached from kodi

sleep 0.5

# stop kodi to free input devices for emulationstation

sudo su -c "systemctl stop mediacenter &" &

exit
