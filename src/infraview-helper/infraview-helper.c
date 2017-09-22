#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char **argv) {
    char command[4096] = "";
    char cmdline[4096];
    int i;
    if (setuid(0) != 0) {
        perror("Setuid failed, no suid-bit set?");
        return 1;
    }
    for (i=1; i< argc; i++) {
        strcat(command,argv[i]);
        strcat(command," ");
    }
    setuid(0);
    if (argc == 1) {
        system("/usr/share/harbour-infraview/python/netstat.py");
    } else if (strcmp(command, "delete_arp ") == 0) {
        system("/sbin/ip -s -s neigh flush all");
    } else {
        sprintf(cmdline, "/sbin/arp -d %s", command);
        system(cmdline);
    }
    return 0;
}
