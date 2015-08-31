#!/bin/bash

# This is a script by mcobit to install retrosmc to OSMC.
# I am not responsible for any harm done to your system.
# Using this is on your own risk.

CURRENT_VERSION="Alpha 0.006"
CURRENT_ARCHIVE="https://github.com/mcobit/retrosmc/releases/download/Alpha0.006/retrosmc-3.0-rpi2.tar.bz2"
CURRENT_SIZE="696975403"
source "/home/osmc/RetroPie/scripts/retrosmc-config.cfg"
#wget --no-check-certificate -O versioncheck https://raw.githubusercontent.com/mcobit/retrosmc/master/install-retrosmc.sh 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Checking for update" --gauge "\nPlease wait...\n"  11 70

#if [ "$(grep CURRENT_VERSION ./versioncheck)" != "$(grep CURRENT_VERSION ./install-retrosmc.sh)" ]; then
# cp ./versioncheck ./install-retrosmc.sh
# rm ./versioncheck
# dialog --title "Script updated" --msgbox "\nSuccessfully updated install-retrosmc script.\nPress OK to restart it!\n" 11 70
# ./install-retrosmc.sh
# exit 0
#fi
#rm ./versioncheck

cmd=(dialog --backtitle "retrosmc installation - Version $CURRENT_VERSION" --menu "Welcome to the retrosmc installation.\nWhat would you like to do?\n " 13 50 16)

options=(1 "Install retrosmc"
         2 "Uninstall retrosmc"
         3 "Install Launcher Addon"
         4 "Remove Launcher Addon")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
            mkdir -p /home/osmc/RetroPie/scripts
            if [ ! "/home/osmc/RetroPie/scripts/retrosmc-config.cfg" ]; then
               touch "/home/osmc/RetroPie/scripts/retrosmc-config.cfg"
            fi
            INSTALLDIR="$(dialog --inputbox "Enter the path, retrosmc should be installed to.\nYou need at least 2.8GB of free space!\nDefault directory is /opt\nIf not sure, just press enter." 10 60 /opt 3>&1 1>&2 2>&3 3>&- )"
            dialog --title "Show install path." --clear --msgbox "\nretrosmc will be installed to $INSTALLDIR/retrosmc\n" 11 70
            sed -i '/INSTALLDIR/d' /home/osmc/RetroPie/scripts/retrosmc-config.cfg
            echo INSTALLDIR="$INSTALLDIR" >> /home/osmc/RetroPie/scripts/retrosmc-config.cfg
            sudo apt-get update 2>&1 | dialog --title "Updating package database..." --infobox "\nPlease wait...\n" 11 70
            sudo apt-get --show-progress -y install dialog pv bzip2 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Installing dialog and pv programs if they are not present" --gauge "\nPlease wait...\n" 11 70
            wget --no-check-certificate -w 4 -O install.tar.bz2 $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  11 70
            while [ $(stat -c%s install.tar.bz2) != $CURRENT_SIZE ]; do
            wget --no-check-certificate -w 4 -O install.tar.bz2 $CURRENT_ARCHIVE 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading installation file" --gauge "\nPlease wait...\n"  11 70
            done
            (pv -n install.tar.bz2 | sudo tar xjf - -C $INSTALLDIR/ ) 2>&1 | dialog --title "Extracting installation file" --gauge "\nPlease wait...\n" 11 70
            rm install.tar.bz2 | dialog --title "Deleting temporary installation file" --infobox "\nPlease wait...\n" 11 70
            sudo chown root:root "$INSTALLDIR/retrosmc/etc/sudoers"
            sudo chown -R root:root "$INSTALLDIR/retrosmc/etc/sudoers.d"
            sudo chown root:root "$INSTALLDIR/retrosmc/usr/bin/sudo"
            sudo chown root:root "$INSTALLDIR/retrosmc/usr/lib/sudo/sudoers.so"
            sudo chmod u+s "$INSTALLDIR/retrosmc/etc/sudoers"
            sudo chmod -R u+s "$INSTALLDIR/retrosmc/etc/sudoers.d"
            sudo chmod u+s "$INSTALLDIR/retrosmc/usr/bin/sudo"
            sudo chmod u+s "$INSTALLDIR/retrosmc/usr/lib/sudo/sudoers.so"
            unlink "$INSTALLDIR/retrosmc/etc/resolv.conf"
            ln -s "$INSTALLDIR/retrosmc/home/pi/RetroPie/roms" /home/osmc/RetroPie/roms
            ln -s "$INSTALLDIR/retrosmc/home/pi/RetroPie/BIOS" /home/osmc/RetroPie/BIOS
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/chroot.sh https://raw.githubusercontent.com/mcobit/retrosmc/chroot-approach/scripts/chroot.sh
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie.sh https://raw.githubusercontent.com/mcobit/retrosmc/chroot-approach/scripts/retropie.sh
            wget --no-check-certificate -w 4 -O /home/osmc/RetroPie/scripts/retropie_watchdog.sh https://raw.githubusercontent.com/mcobit/retrosmc/chroot-approach/scripts/retropie_watchdog.sh
if [ ! "$(grep Action $INSTALLDIR/retrosmc/home/pi/.emulationstation/es_input.cfg)" ]; then
                mkdir "$INSTALLDIR/retrosmc/home/pi/.emulationstation"
    cat > "$INSTALLDIR/retrosmc/home/pi/.emulationstation/es_input.cfg" << _EOF_
<?xml version="1.0"?>
<inputList>
  <inputAction type="onfinish">
    <command>/opt/retropie/supplementary/emulationstation/scripts/inputconfiguration.sh</command>
  </inputAction>
</inputList>
_EOF_
fi
            dialog --title "FINISHED!" --msgbox "\nEnjoy your retrosmc installation!\nPress OK to return to the menu.\n" 11 70
            ./install-retrosmc.sh
            ;;
        2)
            dialog --title "Really remove retrosmc?" --clear \
            --yesno "\nDo you really want to uninstall retrosmc?\nAll ROMS, configuration files etc. will also be removed\n" 11 70
            case $? in
                 0)
		 sudo rm -r "$INSTALLDIR/retrosmc"
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
	  wget --no-check-certificate -w 4 -O plugin.program.retropie-launcher-0.0.1.tgz https://raw.githubusercontent.com/jcnventura/retrosmc/feature/launcher-plugin/plugin.program.retropie-launcher-0.0.1.tgz 2>&1 | grep --line-buffered -oP "(\d+(\.\d+)?(?=%))" | dialog --title "Downloading Addon" --gauge "\nPlease wait...\n"  11 70
	  (pv -n plugin.program.retropie-launcher-0.0.1.tgz | sudo tar xzf - -C /home/osmc/ ) 2>&1 | dialog --title "Extracting Addon" --gauge "\nPlease wait...\n" 11 70
	  dialog --backtitle "RetroPie-OSMC setup script" --title "Installing Addon" --msgbox "\nAddon installed.\n" 11 70
          rm plugin.program.retropie-launcher-0.0.1.tgz
            ./install-retrosmc.sh
            ;;
        4)
	   rm -r /home/osmc/.kodi/addons/plugin.program.retropie-launcher
	   dialog --backtitle "RetroPie-OSMC setup script" --title "Removing Addon" --msgbox "\nAddon removed.\n" 11 70
            ./install-retrosmc.sh
            ;;
    esac
done
