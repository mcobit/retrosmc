retrosmc by mcobit
Easy script to get RetroPie installed alongside OSMC

This contains work from the RetroPie project as well as some open source libraries and binaries like SDL1.2/2 etc.
Also this is an alpha release right now. So I am not responsible for anything you do with this to your system.

Please download and run install-retrosmc.sh from this repository on your osmc home directory.
https://github.com/mcobit/retrosmc/blob/direct/install-retrosmc.sh

retrosmc alpha

I got something for the brave who want to test it:

Disclaimer and other useful information. Read BEFORE installing!

First things first: I am NOT responsible if this does any harm to your system!

    I suggest only to install this on a system that the old installer wasn't run on already.

    You should have at least 2 GB of free space on your sdcard.

    Please be sure to uninstall any older versions of retrosmc. Save your ROMS and BIOS files before doing so! 

    Please report bugs and don't expect everything to work.

    This is now a full RetroPie installation, all scripts and files should be present

    This will only work on a Raspberry Pi 1 or 2! NOT on the Vero

Installation

SSH into your osmc installation.

Download the installation script to your osmc home directory:

cd /home/osmc
https://github.com/mcobit/retrosmc/blob/direct/install-retrosmc.sh

Make it executable by running:

chmod +x install-retrosmc.sh

Then run it:

./install-retrosmc.sh

You will see a pretty selfexplanatory menu.

Choose what you want to do and wait for a while.

You can exit the menu by choosing Cancel at the bottom after every task.

If you have installed the Launcher Addon, after a restart of kodi, you will find your shortcut in the Programaddons in kodi.

If you want to create a custom menuitem, here is a little symbol for you, that I hope, matches the OSMC skin style.

The link should contain the following command:

System.Exec(/home/osmc/RetroPie/scripts/retropie.sh)

Have fun!

Credits

- RetroPie (Took the rootfs from the RetroPie project - You guys rock!)
- OSMC (Our beloved platform this is running on - Keep up the good work!)
- jcnventura3 for the launcher addon - Just works
- thanks to all testers
