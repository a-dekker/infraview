#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define DELIM "."
const char DEL_ARP[] = "delete_arp";
const char NETSTAT_PY[] = "/usr/share/harbour-infraview/python/netstat.py";
char *IP_FLUSH_APP[] = {
        "/sbin/ip", "-s", "-s", "neigh", "flush", "all", NULL
        };

/**
 * wraps the call to execvp including perror output
 *
 * @param args  NULL terminated array of C strings to execute
 *
 * This function wraps the call to execvp and the error handling.
 * The first item in args is used as command to execute, so it is passed
 * as first argument to execvp. The whole array args is then passes as
 * second argument to execvp.
 */
void execa(char * const args[]) {
    execvp(*args, args);
    perror(*args);
}

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
    char command[20] = "";
    int i;      /* loop index */
    char **arpcmd;  /* complete arp command with arguments */

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
    /* no command line argument: call netstat.py */
    if (argc == 1) {
        execlp(NETSTAT_PY, NETSTAT_PY, (char*)NULL);
        perror(NETSTAT_PY);
    }
    /* 1 certain command line argument */
    else if (argc == 2 &&
        strncmp(argv[1], DEL_ARP, sizeof(DEL_ARP)) == 0)
    {
        execa(IP_FLUSH_APP);
    } else {
        char ip[16];
        strcpy (ip, command);
        if (is_valid_ip(ip)) {
            printf("Valid IP\n");
        } else {
            printf("Invalid IP\n");
            return 1;
        }
        /* We have to allocate a new array as we extend argv by
         * two more items. This array holds enough pointers (!)
         * for the strings in argv + our two strings.
         */
        if ((arpcmd = (char**) calloc(argc+2, sizeof(char*))) == NULL)
        {
            perror("calloc failed");
            return 1;
        }

        arpcmd[0] = "/sbin/arp";
        arpcmd[1] = "-d";

        /* We can do here a cheap copy by just let the array items
         * point to the items in argv. If argv is going to be
         * changed you should do a real copy with strdup.
         */
        for (i = 1; i <= argc; ++i) {
            arpcmd[i+1] = argv[i];
        }

        execa(arpcmd);
        /* If the exec fails we can be so kind an free our memory. */
        free(arpcmd);
    }
    return 1;
}
