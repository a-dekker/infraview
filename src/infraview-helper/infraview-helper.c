#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

const char DEL_ARP[] = "delete_arp";
const char NETSTAT_PY[] = "/usr/share/harbour-infraview/python/netstat.py";
char *IP_FLUSH_APP[] = {
		"/sbin/ip", "-s", "-s", "neigh", "flush", "all", NULL
		};

/**
 * wraps the call to execvp including perror output
 *
 * @param args	NULL terminated array of C strings to execute
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

int main(int argc, char **argv) {
	int i;		/* loop index */
	char **arpcmd;	/* complete arp command with arguments */

	if (setuid(0) != 0) {
		perror("Setuid failed, no suid-bit set?");
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
