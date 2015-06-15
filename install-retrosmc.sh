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
         3 "Create menu shortcut")
#         4 "Remove menu shortcut")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
            sudo apt-get update 2>&1 | dialog --title "Updating package database..." --infobox "\nPlease wait...\n" 11 70
            sudo apt-get --show-progress -y install dialog pv bzip2 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Installing dialog and pv programs if they are not present" --gauge "\nPlease wait...\n" 11 70
            wget --no-check-certificate -w 4 -O install.tar.bz2 $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  11 70
            while [ $(stat -c%s install.tar.bz2) != 95827784 ]; do
            wget --no-check-certificate -w 4 -O install.tar.bz2 $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  11 70
            done
            (pv -n install.tar.bz2 | sudo tar xjf - -C / ) 2>&1 | dialog --title "Extracting installation file" --gauge "\nPlease wait...\n" 11 70
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
           if [ ! "$(grep retropie.sh /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml 2>&1)" ]; then
           cp /usr/share/kodi/addons/skin.osmc/shortcuts/mainmenu.DATA.xml /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml
           sudo chown osmc:osmc /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml

CONTENT='        <shortcut>\
                <defaultID />\
                <label>RetroPie</label>\
                <label2>Custom Shortcut</label2>\
                <icon>DefaultShortcut.png</icon>\
                <thumb />\
                <action>System.Exec(/home/osmc/RetroPie/scripts/retropie.sh)</action>\
      </shortcut>'

sed -i.bak '/<\/shortcuts>/i\'"$CONTENT" /home/osmc/.kodi/userdata/addon_data/script.skinshortcuts/mainmenu.DATA.xml 

dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --msgbox "\nShortcut created.\n" 11 70

else

dialog --backtitle "RetroPie-OSMC setup script" --title "Creating shortcut" --msgbox "\nShortcut already exists.\n" 11 70

fi
            ./install-retrosmc.sh
            ;;
#        4)
#            ./install-retrosmc.sh
#            ;;
    esac
done
