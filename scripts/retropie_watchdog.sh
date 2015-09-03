#!/bin/bash

# Script by mcobit

# wait a bit to give emulationstation time to start up

sleep 8

# check for emulationstation running

while [ true ]; do
	VAR1="$(pgrep emulatio)"

# if emulationstation is quit, clear the screen of virtual terminal 7 and show a message

		if [ ! "$VAR1" ]; then
			sudo openvt -c 7 -s -f clear
			sudo openvt -c 7 -s -f echo "Emulationstation quit... Starting KODI."

# wait a second to show the message

			sleep 1

# clear the screen again

			sudo openvt -c 7 -f clear

# restart kodi

			sudo su -c "sudo systemctl restart mediacenter &" &

# wait a second (probably for no good reason, but it seemed to work better this way)

			sleep 1

# exit script

			exit
		else

# if emulationstation is still running, wait 2 seconds and check again (could probably be longer, but doesn't seem to impact performance by much)

			sleep 2
fi
done
