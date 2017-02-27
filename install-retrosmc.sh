#!/bin/bash

# This is a script by mcobit to install retrosmc to OSMC.
# I am not responsible for any harm done to your system.
# Using this is on your own risk.
# Script by mcobit

# Version 0.008

# Check if we are root. If so, cancel installation

if [[ $(id -u) -eq 0 ]]; then
    echo "This script should not be run as root. Please run as user osmc!"
    exit 1
fi

# import variables from configfile

source "/home/osmc/RetroPie/scripts/retrosmc-config.cfg"

# Shut down KODI if it is running

if [[ $(pgrep kodi) ]]; then
  echo "Detected a running instance of KODI. Shutting it down to free memory for installation"
  sudo systemctl stop mediacenter
fi

# setting up the menu

cmd=(dialog --backtitle "retrosmc installation - Version $CURRENT_VERSION" --menu "Welcome to the retrosmc installation.\nWhat would you like to do?\n " 14 50 16)

options=(1 "Install retrosmc"
         2 "Install Launcher Addon"
         3 "Remove Launcher Addon"
         4 "Update scripts")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
# create the config directory and file

            mkdir -p /home/osmc/RetroPie/scripts
            mkdir -p /home/osmc/RetroPie/scripts/init.d
            mkdir -p /home/osmc/RetroPie/scripts/exit.d
            touch "/home/osmc/RetroPie/scripts/retrosmc-config.cfg"

# install some programs needed to run the installation and retrosmc

            sudo apt-get update 2>&1 | dialog --title "Updating package database..." --infobox "\nPlease wait...\n" 11 70
            sudo apt-get --show-progress -y install dialog git pv bzip2 psmisc libusb-1.0 alsa-utils 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Installing dialog and pv programs if they are not present" --gauge "\nPlease wait...\n" 11 70

# download the retrosmc scripts and files

            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie.sh https://raw.githubusercontent.com/mcobit/retrosmc/master/scripts/retropie.sh
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie_watchdog.sh https://raw.githubusercontent.com/mcobit/retrosmc/master/scripts/retropie_watchdog.sh
            chmod +x /home/osmc/RetroPie/scripts/retropie.sh
            chmod +x /home/osmc/RetroPie/scripts/retropie_watchdog.sh

# add fix to config.txt for sound

if [[ ! $(grep "dtparam=audio=on" "/boot/config.txt") ]]; then
sudo su -c 'echo -e "dtparam=audio=on" >> "/boot/config.txt"'
fi

# set the output volume

amixer set PCM 100

# clone the retropie git and start the installation

            cd
            git clone https://github.com/RetroPie/RetroPie-Setup.git
            cd /home/osmc/RetroPie-Setup
            sudo ./retropie_setup.sh

# check for the right configuration and existance of the es_input file to ensure joystick autoconfig to work (important on update)

            if [ ! "$(grep Action /home/osmc/.emulationstation/es_input.cfg)" ]; then
                mkdir "/home/osmc/.emulationstation"
                cat > "/home/osmc/.emulationstation/es_input.cfg" << _EOF_
<?xml version="1.0"?>
<inputList>
  <inputAction type="onfinish">
    <command>/opt/retropie/supplementary/emulationstation/scripts/inputconfiguration.sh</command>
  </inputAction>
</inputList>
_EOF_
            fi

# end installation

            dialog --title "FINISHED!" --msgbox "\nEnjoy your retrosmc installation!\nPress OK to return to the menu.\n" 11 70

# restart script

            exec /home/osmc/install-retrosmc.sh
            ;;
        2)

# get the addon archive file from github

	  wget --no-check-certificate -w 4 -O plugin.program.retrosmc-launcher-0.0.2.tgz https://github.com/mcobit/retrosmc/raw/master/plugin.program.retrosmc-launcher-0.0.2.tgz 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Addon" --gauge "\nPlease wait...\n"  11 70

# extract the addon to the kodi addon directory
          if [[ -d /home/osmc/.kodi/addons/plugin.program.retropie-launcher ]]; then
          rm -r /home/osmc/.kodi/addons/plugin.program.retropie-launcher
	  fi
	  (pv -n plugin.program.retrosmc-launcher-0.0.2.tgz | sudo tar xzf - -C /home/osmc/.kodi/addons/ ) 2>&1 | dialog --title "Extracting Addon" --gauge "\nPlease wait...\n" 11 70
	  dialog --backtitle "RetroPie-OSMC setup script" --title "Installing Addon" --msgbox "\nAddon installed.\n" 11 70

# remove archive file

          rm plugin.program.retrosmc-launcher-0.0.2.tgz

# restart script

            exec /home/osmc/install-retrosmc.sh
            ;;
        3)

# delete the addon from kodi addon directory
           if [[ -d /home/osmc/.kodi/addons/plugin.program.retrosmc-launcher ]]; then
	   rm -r /home/osmc/.kodi/addons/plugin.program.retrosmc-launcher
	   fi
	   if [[ -d /home/osmc/.kodi/addons/plugin.program.retropie-launcher ]]; then
	   rm -r /home/osmc/.kodi/addons/plugin.program.retropie-launcher
	   fi
	   dialog --backtitle "RetroPie-OSMC setup script" --title "Removing Addon" --msgbox "\nAddon removed.\n" 11 70

# restart script

            exec /home/osmc/install-retrosmc.sh
            ;;
        4)

# download new versions of all scripts and make them executable

            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie.sh.1 https://raw.githubusercontent.com/mcobit/retrosmc/master/scripts/retropie.sh
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie_watchdog.sh.1 https://raw.githubusercontent.com/mcobit/retrosmc/master/scripts/retropie_watchdog.sh
            wget --no-check-certificate -w 4 -O /home/osmc/install-retrosmc.sh.1 https://raw.githubusercontent.com/mcobit/retrosmc/master/install-retrosmc.sh
            chmod +x /home/osmc/RetroPie/scripts/retropie.sh.1
            chmod +x /home/osmc/RetroPie/scripts/retropie_watchdog.sh.1
            chmod +x /home/osmc/install-retrosmc.sh.1

# replace old with new scripts

            mv /home/osmc/install-retrosmc.sh.1 /home/osmc/install-retrosmc.sh
            mv /home/osmc/RetroPie/scripts/retropie.sh.1 /home/osmc/RetroPie/scripts/retropie.sh
            mv /home/osmc/RetroPie/scripts/retropie_watchdog.sh.1 /home/osmc/RetroPie/scripts/retropie_watchdog.sh

# restart script

            exec /home/osmc/install-retrosmc.sh
            ;;
    esac
done

sudo systemctl restart mediacenter
