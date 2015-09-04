#!/bin/bash

source /home/osmc/RetroPie/scripts/retrosmc-config.cfg

export LD_LIBRARY_PATH="$INSTALLDIR/retrosmc/usr/lib/omxplayer"

if [ $1 == in ]; then
$INSTALLDIR/retrosmc/usr/bin/omxplayer -z --layer 100000 /home/osmc/RetroPie/scripts/kodi_es.mp4 &
else
$INSTALLDIR/retrosmc/usr/bin/omxplayer -z --layer 0 /home/osmc/RetroPie/scripts/es_kodi.mp4 &
fi
