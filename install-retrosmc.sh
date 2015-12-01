#!/bin/bash

# This is a script by mcobit to install retrosmc to OSMC.
# I am not responsible for any harm done to your system.
# Using this is on your own risk.
# Script by mcobit

# import variables from configfile

source "/home/osmc/RetroPie/scripts/retrosmc-config.cfg"

# check for newer version of this script

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
# create the config directory

            mkdir -p /home/osmc/RetroPie/scripts
            if [ ! "/home/osmc/RetroPie/scripts/retrosmc-config.cfg" ]; then
               touch "/home/osmc/RetroPie/scripts/retrosmc-config.cfg"
            fi

# install some programs needed to run the installation and retrosmc

            sudo apt-get update 2>&1 | dialog --title "Updating package database..." --infobox "\nPlease wait...\n" 11 70
            sudo apt-get --show-progress -y install dialog git pv bzip2 psmisc libusb-1.0 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Installing dialog and pv programs if they are not present" --gauge "\nPlease wait...\n" 11 70

# clone the retropie git and start the installation

            cd
            git clone git://github.com/petrockblog/RetroPie-Setup.git
            cd /home/osmc/RetroPie-Setup
            sudo ./retropie_setup.sh

# download the retrosmc scripts and files

            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie.sh http://collaborate.osmc.tv/index.php/s/wQFzG95ZK9rxUdP/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie_watchdog.sh http://collaborate.osmc.tv/index.php/s/rkWCRvikjPQUlGE/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/video.sh http://collaborate.osmc.tv/index.php/s/vLxapLqD9i7HBpr/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/kodi_es.mp4 http://collaborate.osmc.tv/index.php/s/npHU07Xuuo47L9Q/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/es_kodi.mp4 http://collaborate.osmc.tv/index.php/s/wpDPrnWlxcgaAbe/download
            chmod +x /home/osmc/RetroPie/scripts/retropie.sh
            chmod +x /home/osmc/RetroPie/scripts/retropie_watchdog.sh
            chmod +x /home/osmc/RetroPie/scripts/video.sh

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

            ./install-retrosmc.sh
            ;;
        2)

# get the addon archive file from github

	  wget --no-check-certificate -w 4 -O plugin.program.retropie-launcher-0.0.1.tgz https://raw.githubusercontent.com/jcnventura/retrosmc/feature/launcher-plugin/plugin.program.retropie-launcher-0.0.1.tgz 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Addon" --gauge "\nPlease wait...\n"  11 70

# extract the addon to the kodi addon directory

	  (pv -n plugin.program.retropie-launcher-0.0.1.tgz | sudo tar xzf - -C /home/osmc/ ) 2>&1 | dialog --title "Extracting Addon" --gauge "\nPlease wait...\n" 11 70
	  dialog --backtitle "RetroPie-OSMC setup script" --title "Installing Addon" --msgbox "\nAddon installed.\n" 11 70

# remove archive file

          rm plugin.program.retropie-launcher-0.0.1.tgz

# restart script

            ./install-retrosmc.sh
            ;;
        3)

# delete the addon from kodi addon directory

	   rm -r /home/osmc/.kodi/addons/plugin.program.retropie-launcher
	   dialog --backtitle "RetroPie-OSMC setup script" --title "Removing Addon" --msgbox "\nAddon removed.\n" 11 70

# restart script

            ./install-retrosmc.sh
            ;;
        4)

# download new versions of all scripts and make them executable

            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie.sh.1 http://collaborate.osmc.tv/index.php/s/wQFzG95ZK9rxUdP/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie_watchdog.sh.1 http://collaborate.osmc.tv/index.php/s/rkWCRvikjPQUlGE/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/video.sh.1 http://collaborate.osmc.tv/index.php/s/vLxapLqD9i7HBpr/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/kodi_es.mp4.1 http://collaborate.osmc.tv/index.php/s/npHU07Xuuo47L9Q/download
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/es_kodi.mp4.1 http://collaborate.osmc.tv/index.php/s/wpDPrnWlxcgaAbe/download
            wget --no-check-certificate -w 4 -O /home/osmc/install-retrosmc.sh.1 http://collaborate.osmc.tv/index.php/s/pUnX187z29OGN9H/download
            chmod +x /home/osmc/RetroPie/scripts/chroot.sh.1
            chmod +x /home/osmc/RetroPie/scripts/retropie.sh.1
            chmod +x /home/osmc/RetroPie/scripts/retropie_watchdog.sh.1
            chmod +x /home/osmc/RetroPie/scripts/video.sh.1
            chmod +x /home/osmc/install-retrosmc.sh.1

# replace old with new scripts

            mv /home/osmc/install-retrosmc.sh.1 /home/osmc/install-retrosmc.sh
            mv /home/osmc/RetroPie/scripts/retropie.sh.1 /home/osmc/RetroPie/scripts/retropie.sh
            mv /home/osmc/RetroPie/scripts/retropie_watchdog.sh.1 /home/osmc/RetroPie/scripts/retropie_watchdog.sh
            mv /home/osmc/RetroPie/scripts/video.sh.1 /home/osmc/RetroPie/scripts/video.sh
            mv /home/osmc/RetroPie/scripts/kodi_es.mp4.1 /home/osmc/RetroPie/scripts/kodi_es.mp4
            mv /home/osmc/RetroPie/scripts/es_kodi.mp4.1 /home/osmc/RetroPie/scripts/es_kodi.mp4

# restart script

            ./install-retrosmc.sh
            ;;
    esac
done
