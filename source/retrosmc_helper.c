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
    system("cd && PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin openvt -c 7 -f -s -w /home/osmc/install-retrosmc.sh");
    system("clear");
    system("sudo systemctl restart mediacenter");
    return 0;
 }

  if ( 0 == strcmp("setup", argv[1]) ) {
    printf("#####################################\n");
    printf("# Starting RetroPie Setup script... #\n");
    printf("#####################################\n");
    sleep(2);
    system("cd && PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin openvt -c 7 -f -s -w sudo /home/osmc/RetroPie-Setup/retropie_setup.sh");
    system("clear");
    system("sudo systemctl restart mediacenter");
    return 0;
  }

  if ( 0 == strcmp("es", argv[1]) ) {
    printf("################################\n");
    printf("# Starting Emulationstation... #\n");
    printf("################################\n");
    sleep(2);

    if ( 0 == strcmp("cec", argv[4]) ) {
      system("sudo /usr/osmc/bin/cec-client -p 1 &");
      sleep(1);
      system("sudo kill -9 $(pidof cec-client)");
    }

    if ( 0 == strcmp("hyperion", argv[5]) ) {
      system("sudo systemctl stop hyperion");
    }

    if ( 1 == strcmp("none", argv[2]) ) {
      char command[1024];
      sprintf(command, "\"%s\"", argv[2]);
      system(command);
    }

    system("cd && PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/osmc/bin:/opt/vc/bin openvt -c 7 -f -s -w emulationstation &");

    if ( 0 == strcmp("hyperion", argv[5]) ) {
      sleep(8);
      system("sudo systemctl start hyperion");
    }

    sleep(2);

    while (0 == system("pidof -x emulationstation > /dev/null")) {
      sleep(2);
    }

    system("clear");
    system("sudo systemctl restart mediacenter");

    if ( 1 == strcmp("none", argv[3]) ) {
      char command[1024];
      sprintf(command, "\"%s\"", argv[3]);
      system(command);
    }

    return 0;
  }

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
