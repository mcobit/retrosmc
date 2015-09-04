#!/bin/bash

# Script by mcobit

# play the transition video and wait a bit to give emulationstation time to start up

/home/osmc/RetroPie/scripts/video.sh in &

sleep 8

# check for emulationstation running

while [ true ]; do
	VAR1="$(pgrep emulatio)"

# if emulationstation is quit, clear the screen of virtual terminal 7 and show a message

		if [ ! "$VAR1" ]; then
			sudo openvt -c 7 -s -f clear
# play the transition video and restart kodi

			/home/osmc/RetroPie/scripts/video.sh out &
			sleep 4
			sudo su -c "sudo systemctl restart mediacenter &" &

# exit script

			exit
		else

# if emulationstation is still running, wait 2 seconds and check again (could probably be longer, but doesn't seem to impact performance by much)

			sleep 2
fi
done
exit
