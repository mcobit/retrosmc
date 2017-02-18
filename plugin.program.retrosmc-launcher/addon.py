"""
    Plugin for Launching programs
"""

# -*- coding: UTF-8 -*-
# main imports
import sys
import os
import xbmc
import xbmcgui
import xbmcaddon
import os.path

# plugin constants
__plugin__ = "retrosmc-launcher"
__author__ = "jcnventura/mcobit"
__url__ = "http://blog.petrockblock.com/retropie/"
__git_url__ = "https://github.com/mcobit/retrosmc/"
__credits__ = "mcobit"
__version__ = "0.0.1"
__settings__ = xbmcaddon.Addon(id="plugin.program.retrosmc-launcher")

dialog = xbmcgui.Dialog()
addon = xbmcaddon.Addon(id='plugin.program.retrosmc-launcher')

es_pre_set = __settings__.getSetting("es_pre")
es_post_set = __settings__.getSetting("es_post")
prescript_set = __settings__.getSetting("prescript")
postscript_set = __settings__.getSetting("postscript")
cec_set = __settings__.getSetting("cec")
hyperion_set = __settings__.getSetting("hyperion")

if es_pre_set == "false":
  prescript_set = "none"

if es_post_set == "false":
  postscript_set = "none"

if cec_set == "false":
  cec_set = "none"
else:
  cec_set = "cec"

if hyperion_set == "false":
  hyperion_set = "none"
else:
  hyperion_set = "hyperion"


cmd="/home/osmc/RetroPie/scripts/start-emulationstation.sh \""+prescript_set+"\" \""+postscript_set+"\" \""+cec_set+"\" \""+hyperion_set+"\""
dialog.ok("test",cmd)

if os.path.isdir( "/opt/retropie" ):
  os.popen(cmd)
else:
  if dialog.yesno("Warning","RetrOSMC is not installed. Should we start the installation?","Be sure to have a working internet connection and a joypad and/or keyboard connected!",""):
    os.popen("cd && wget https://raw.githubusercontent.com/mcobit/retrosmc/testing/install-retrosmc.sh")
    os.popen("cd && mkdir -p /home/osmc/RetroPie/scripts && wget -O /home/osmc/RetroPie/scripts/joy2key.py https://raw.githubusercontent.com/mcobit/retrosmc/testing/scripts/joy2key.py")
    os.popen("cd && mkdir -p /home/osmc/RetroPie/scripts && wget -O /home/osmc/RetroPie/scripts/start-install.sh https://raw.githubusercontent.com/mcobit/retrosmc/testing/scripts/start-install.sh")
    os.popen("cd && mkdir -p /home/osmc/RetroPie/bin && wget -O /home/osmc/RetroPie/bin/retrosmc_helper https://raw.githubusercontent.com/mcobit/retrosmc/testing/bin/retrosmc_helper")
    if os.path.exists( "/home/osmc/install-retrosmc.sh" ):
      os.popen("cd && chmod +x /home/osmc/install-retrosmc.sh && chmod +x /home/osmc/RetroPie/scripts/* && chmod +x /home/osmc/RetroPie/bin/*")
      os.popen("/home/osmc/RetroPie/scripts/start-install.sh")
    else:
      dialog.ok("Error","Could not download the installerscript.\n\nCheck your internetconnection and try again!")
  
