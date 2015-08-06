#!/bin/bash

# Version 0.002

# This is a script by mcobit to install retrosmc to OSMC.
# I am not responsible for any harm done to your system.
# Using this is on your own risk.

CURRENT_ARCHIVE="https://github.com/mcobit/retrosmc/releases/download/Alpha0.002/retrosmc-alpha-0.002.tar.xz"
CURRENT_SIZE="101163748"
# Greet the user and ask what he wants to do

cmd=(dialog --backtitle "retrosmc installation" --menu "Welcome to the retrosmc installation.\nWhat would you like to do?\n " 13 50 16)

options=(1 "Install retrosmc"
         2 "Uninstall retrosmc"
         3 "Install Launcher Addon")
         4 "Remove Launcher Addon")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
            sudo apt-get update 2>&1 | dialog --title "Updating package database..." --infobox "\nPlease wait...\n" 11 70
            sudo apt-get --show-progress -y install dialog pv xz-utils 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Installing dialog and pv programs if they are not present" --gauge "\nPlease wait...\n" 11 70
            wget --no-check-certificate -w 4 -O install.tar.bz2 $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  11 70
            while [ $(stat -c%s install.tar.xz) != $CURRENT_SIZE ]; do
            wget --no-check-certificate -w 4 -O install.tar.xz $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  11 70
            done
            (pv -n install.tar.xz | sudo tar xJf - -C / ) 2>&1 | dialog --title "Extracting installation file" --gauge "\nPlease wait...\n" 11 70
            sudo chown -R osmc:osmc /opt/retropie | dialog --title "Fixing permissions for retropie" --infobox "\nPlease wait...\n" 11 70
            sudo chown -R osmc:osmc /home/osmc/RetroPie | dialog --title "Fixing permissions for retropie" --infobox "\nPlease wait...\n" 11 70
            sudo chown -R osmc:osmc /etc/emulationstation | dialog --title "Fixing permissions for emulationstation" --infobox "\nPlease wait...\n" 11 70
            sudo chown -R osmc:osmc /home/osmc/.emulationstation | dialog --title "Fixing permissions for emulationstation" --infobox "\nPlease wait...\n" 11 70
            rm install.tar.bz2 | dialog --title "Deleting temporary installation file" --infobox "\nPlease wait...\n" 11 70
            dialog --title "FINISHED!" --msgbox "\nEnjoy your retrosmc installation!\nPress OK to return to the menu.\n" 11 70
            ./install-retrosmc.sh
            ;;
        2)
            dialog --title "Really remove retrosmc?" --clear \
            --yesno "\nDo you really want to uninstall retrosmc?\nAll ROMS, configuration files etc. will also be removed\n" 11 70
            case $? in
                 0)
                 sudo rm -r /opt/retropie | dialog --title "Removing /opt/retropie" --infobox "\nPlease wait...\n" 11 70
                 sudo rm -r /home/osmc/RetroPie | dialog --title "Removing /home/osmc/RetroPie" --infobox "\nPlease wait...\n" 11 70
                 sudo rm -r /etc/emulationstation | dialog --title "Removing /etc/emulationstation" --infobox "\nPlease wait...\n" 11 70
                 sudo rm -r /home/osmc/.emulationstation | dialog --title "Removing /home/osmc/.emulationstation" --infobox "\nPlease wait...\n" 11 70
                 sudo rm /usr/bin/emulationstation | dialog --title "Removing /usr/bin/emulationstation" --infobox "\nPlease wait...\n" 11 70
                 dialog --title "FINISHED!" --msgbox "\nSuccessfully uninstalled retrosmc!\nPress OK to return to the menu.\n" 11 70
                 ;;
	         1)
                 dialog --title "Uninstallation aborted" --msgbox "\nNot uninstalling retrosmc\n" 11 70
                 ;;
                 255)
                 dialog --title "Uninstallation aborted" --msgbox "\nNot uninstalling retrosmc\n" 11 70
                 ;;
                 esac
                 ./install-retrosmc.sh
                 ;;
        3)
	  wget https://github.com/jcnventura/retrosmc/blob/feature/launcher-plugin/plugin.program.retropie-launcher-0.0.1.tgz
	  wget --no-check-certificate -w 4 -O plugin.program.retropie-launcher-0.0.1.tgz https://github.com/jcnventura/retrosmc/blob/feature/launcher-plugin/plugin.program.retropie-launcher-0.0.1.tgz 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Addon" --gauge "\nPlease wait...\n"  11 70
	  (pv -n plugin.program.retropie-launcher-0.0.1.tgz | sudo tar xzf - -C /home/osmc/ ) 2>&1 | dialog --title "Extracting Addon" --gauge "\nPlease wait...\n" 11 70
	  dialog --backtitle "RetroPie-OSMC setup script" --title "Installing Addon" --msgbox "\nAddon installed.\n" 11 70
            ./install-retrosmc.sh
            ;;
        4)
	   rm -r /home/osmc/.kodi/addons/plugin.program.retropie-launcher
	   dialog --backtitle "RetroPie-OSMC setup script" --title "Removing Addon" --msgbox "\nAddon removed.\n" 11 70
            ./install-retrosmc.sh
            ;;
    esac
done
