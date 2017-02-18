#!/bin/bash
  cd
  sudo chown osmc:osmc /usr/bin/emulationstation
  sudo chmod +x /usr/bin/emulationstation

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin

cat > /usr/bin/emulationstation << _EOF_
#!/bin/bash
if [[ $(id -u) -eq 0 ]]; then
    echo "emulationstation should not be run as root. If you used 'sudo emulationstation' please run without sudo."
    exit 1
fi
if [[ "$(uname --machine)" != *86* ]]; then
    if [[ -n "$(pidof X)" ]]; then
        echo "X is running. Please shut down X in order to mitigate problems with losing keyboard input. For example, logout from LXDE."
        exit 1
    fi
fi
# save current tty/vt number for use with X so it can be launched on the correct tty
tty=$(tty)
export TTY="{tty:8:1}"
clear
tput civis
/opt/retropie/supplementary/emulationstation/emulationstation.sh "$@"
if [[ $? -eq 139 ]]; then
    dialog --cr-wrap --no-collapse --msgbox "Emulation Station crashed!\n\nIf this is your first boot of RetroPie - make sure you are using the correct image for your system.\n\\nCheck your rom file/folder permissions and if running on a Raspberry Pi, make sure your gpu_split is set high enough and/or switch back to using carbon theme.\n\nFor more help please use the RetroPie forum." 20 60 >/dev/tty$
fi
tput cnorm
_EOF_

  sudo su osmc -c "/home/osmc/RetroPie/bin/retrosmc_helper es &" &Âdisown

  sleep 0.5

  sudo su -c "systemctl stop mediacenter &" &

exit

