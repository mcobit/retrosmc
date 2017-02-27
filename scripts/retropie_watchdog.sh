#!/bin/bash

# Script by mcobit

. /home/osmc/RetroPie/scripts/retrosmc-config.cfg

# ugly fix for people having trouble with CEC

if [ "$CECFIX" = 1 ]; then
sudo /usr/osmc/bin/cec-client -p 1 &
sleep 1
sudo kill -9 $(pidof cec-client)
fi

# deactivate the hyperion deamon if it is running

if [ "$HYPERIONFIX" = 1 ]; then
   if [ $(pgrep hyperion) ]; then
      sudo service hyperion stop
   fi
fi

# give emulationstation time to start up

sleep 8

# activate hyperion daemon if it is not running

if [ "$HYPERIONFIX" = 1 ]; then
   if [ ! $(pgrep hyperion) ]; then
      sudo service hyperion start
   fi
fi

# check for emulationstation running

while [ true ]; do
	VAR1="$(pgrep emulatio)"

# if emulationstation is quit, clear the screen of virtual terminal 7 and show a message

		if [ ! "$VAR1" ]; then
			sudo openvt -c 7 -s -f clear

# exit scripts                                      
        if [ -d /home/osmc/RetroPie/scripts/exit.d/ ]; then
                for script in /home/osmc/RetroPie/scripts/exit.d/*.sh; do               
                        [ -r "$script" ] && . "$script"                                 
                done                                                                    
                unset script                                                            
        fi

# restart kodi

	sudo su -c "sudo systemctl restart mediacenter &" &

# exit script

			exit
		else

# if emulationstation is still running, wait 2 seconds and check again (could probably be longer, but doesn't seem to impact performance by much)

			sleep 2
fi
done
exit
