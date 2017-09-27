#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define DELIM "."

/* return 1 if string contain only digits, else return 0 */
int valid_digit(char *ip_str)
{
    while (*ip_str) {
        if (*ip_str >= '0' && *ip_str <= '9')
            ++ip_str;
        else
            return 0;
    }
    return 1;
}

/* return 1 if IP string is valid, else return 0 */
int is_valid_ip(char *ip_str)
{
    int num, dots = 0;
    char *ptr;

    if (ip_str == NULL)
        return 0;

    // See following link for strtok()
    // http://pubs.opengroup.org/onlinepubs/009695399/functions/strtok_r.html
    ptr = strtok(ip_str, DELIM);

    if (ptr == NULL)
        return 0;

    while (ptr) {

        /* after parsing string, it must contain only digits */
        if (!valid_digit(ptr))
            return 0;

        num = atoi(ptr);

        /* check for valid IP */
        if (num >= 0 && num <= 255) {
            /* parse remaining string */
            ptr = strtok(NULL, DELIM);
            if (ptr != NULL)
                ++dots;
        } else
            return 0;
    }

    /* valid IP string must contain 3 dots */
    if (dots != 3)
        return 0;
    return 1;
}

int main(int argc, char **argv) {
    char command[4096] = "";
    char cmdline[4096];
    if (setuid(0) != 0) {
        perror("Setuid failed, no suid-bit set?");
        return 1;
    }
    if (argc == 2) {
        strncat(command,argv[1], 16);
    }
    if (argc > 2) {
        perror("Too many arguments");
        return 1;
    }
    if (argc == 1) {
        int netstatCall = system("/usr/share/harbour-infraview/python/netstat.py");
        if (netstatCall == -1) {
            perror("Could not execute netstat.py");
        }
    } else if (strcmp(command, "delete_arp") == 0) {
        int flushCall = system("/sbin/ip -s -s neigh flush all");
        if (flushCall == -1) {
            perror("Could not execute arpflush");
        }
    } else {
        char ip[16];
        strcpy (ip, command);
        if (is_valid_ip(ip)) {
            printf("Valid IP\n");
        } else {
            printf("Invalid IP\n");
            return 1;
        }
        sprintf(cmdline, "/sbin/arp -d %s", command);
        int arpDel = system(cmdline);
        if (arpDel == -1) {
            perror("Could not clear arp entry");
        }
    }
    return 0;
}
