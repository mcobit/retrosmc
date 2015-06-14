#!/bin/bash

# Version 0.001

# This is a script by mcobit to install retrosmc to OSMC.
# I am not responsible for any harm done to your system.
# Using this is on your own risk.

CURRENT_ARCHIVE="https://raw.githubusercontent.com/mcobit/retrosmc/master/retrosmc-alpha-0.001.tar.bz2"

# Greet the user and ask what he wants to do

cmd=(dialog --backtitle "retrosmc installation" --menu "Welcome to the retrosmc installation.\nWhat would you like to do?\n " 13 50 16)

options=(1 "Install retrosmc"
         2 "Uninstall retrosmc"
         3 "Create menu shortcut"
         4 "Remove menu shortcut")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
            wget --no-check-certificate -O install.tar.bz2 $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  7 60
            (pv -n install.tar.bz2 | sudo tar xjf - -C / ) 2>&1 | dialog --title "Extracting installation file" --gauge "\nPlease wait...\n" 6 70
            sudo chown -R osmc:osmc /opt/retropie | dialog --title "Fixing permissions for retropie" --gauge "\nPlease wait...\n" 6 70
            sudo chown -R osmc:osmc /home/osmc/RetroPie | dialog --title "Fixing permissions for retropie" --gauge "\nPlease wait...\n" 6 70
            sudo chown -R osmc:osmc /etc/emulationstation | dialog --title "Fixing permissions for emulationstation" --gauge "\nPlease wait...\n" 8 70
            sudo chown -R osmc:osmc /home/osmc/.emulationstation | dialog --title "Fixing permissions for emulationstation" --gauge "\nPlease wait...\n" 8 70
            ./install-retrosmc.sh
            ;;
        2)
            echo "Uninstalling retrosmc ..."
            ./install-retrosmc.sh
            ;;
        3)
            echo "Creating menu shortcut ..."
            ./install-retrosmc.sh
            ;;
        4)
            echo "Removing menu shortcut ..."
            ./install-retrosmc.sh
            ;;
    esac
done
