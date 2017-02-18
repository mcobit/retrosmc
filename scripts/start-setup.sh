#!/bin/bash
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin:/usr/local/sbin

  cd
  sudo su osmc -c "/home/osmc/RetroPie/bin/retrosmc_helper setup &" & disown
  sleep 0.5
  sudo su -c "systemctl stop mediacenter &" &

exit
