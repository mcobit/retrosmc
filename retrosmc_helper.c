#include <stdlib.h>
#include <stdio.h>

int main( int argc, char *argv[] ) {

system("clear");

  if (0 == system("ls /dev/input/by-path 2>/dev/null | grep kbd > /dev/null 2>&1") || 0 == system("ls /dev/input/by-path 2>/dev/null | grep joystick > /dev/null 2>&1")){


  if ( 0 == strcmp("install", argv[1]) ) {
    printf("#######################################\n");
    printf("# Starting RetrOSMC Install script... #\n");
    printf("#######################################\n");
    sleep(2);
    system("PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin openvt -c 7 -f -s -w /home/osmc/install-retrosmc.sh");
 }

  if ( 0 == strcmp("setup", argv[1]) ) {
    printf("#####################################\n");
    printf("# Starting RetroPie Setup script... #\n");
    printf("#####################################\n");
    sleep(2);
    system("PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin openvt -c 7 -f -s -w sudo /home/osmc/RetroPie-Setup/retropie_setup.sh");
  }

  if ( 0 == strcmp("es", argv[1]) ) {
    printf("################################\n");
    printf("# Starting Emulationstation... #\n");
    printf("################################\n");
    sleep(2);
    system("PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin openvt -c 7 -f -s -w emulationstation");
  }

    system("clear");
    system("sudo systemctl restart mediacenter");
    return 0;


} else {

    printf("###################################################################\n");
    printf("# You need a Joypad or Keyboard! Restarting KODI in 10 seconds... #\n");
    printf("###################################################################\n");

    int i;
for (i = 10; i > -1; i = i - 1) {
printf("%d",i);
printf("-----");
fflush(stdout);
sleep(1);
   }

    system("sudo systemctl restart mediacenter &");
    system("clear");
    return 0;
 }
}
