retrosmc by mcobit
An easier way to get a partial retropie onto osmc without altering system-relevant stuff.

This contains work from the RetroPie project as well as some open source libraries and binaries like SDL1.2/2 etc.
Also this is an alpha release right now. So I am not responsible for anything you do with this to your system.

Please download and run install-retrosmc.sh from this repository on your osmc home directory.

retrosmc alpha

I got something for the brave who want to test it:

Disclaimer and other useful information. Read BEFORE installing!

First things first: I am NOT responsible if this does any harm to your system!

    I suggest only to install this on a system that the old installer wasn't run on already.

    You should have at least 3 GB of free space on your sdcard.

    If you update from a previous version, be sure to save your configfiles if you altered them! Roms and Bios files should not be overwritten by an update.

    Please report bugs and don't expect everything to work.

    This is now a full RetroPie installation, all scripts and files should be present

    This does not change your system or download packages from dubious sources, all files needed are distributed by the package

    This has an uninstallation option in the menu. It will remove the whole package if you don't want to have it anymore, but it will also remove any ROMS, BIOS, savefiles or configurationfiles you may have added or altered. So please make a backup of those if you want to use them later!

    This will only work on a Raspberry Pi 1 or 2! NOT on the Vero

Installation

If you want to update an older installation, please uninstall it first with the script.

cd

./install-retrosmc.sh


Then delete the old script


rm /home/osmc/install-retrosmc.sh

Then follow the instructions below.

SSH into your osmc installation.

Download the installation script to your osmc home directory:

cd /home/osmc
wget https://raw.githubusercontent.com/mcobit/retrosmc/master/install-retrosmc.sh

Make it executable by running:

chmod +x install-retrosmc.sh

Then run it:

./install-retrosmc.sh

You will see a pretty selfexplanatory menu.

Choose what you want to do and wait for a while.

You can exit the menu by choosing Cancel at the bottom after every task.

If you have installed the Launcher Addon, you will find your shortcut in the Programaddons in kodi.

If you want to create a custom menuitem, here is a little symbol for you, that I hope, matches the OSMC skin style.

The link should contain the following command:

System.Exec(/home/osmc/RetroPie/scripts/retropie.sh)

Have fun!

Credits

- RetroPie (Took the rootfs from the RetroPie project - You guys rock!)
- OSMC (Our beloved platform this is running on - Keep up the good work!)
- jcnventura3 for the launcher addon - Just works
- thanks to all testers
