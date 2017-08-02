#!/bin/bash
#
set -uo pipefail
IFS=$'\n\t'

DNS="?"
DHCP="?"
BROADCAST="?"
DOMAIN="?"
SUBNET_MASK="?"

# first determine active device
ROUTE_INFO=$(/sbin/ip route|head -1)

# get further info
NETW_DEV=$(echo ${ROUTE_INFO}|grep -oP "dev\s+\K\w+")
GATEWAY=$(echo ${ROUTE_INFO}|sed '/via/s/.*via \([^ ][^ ]*\)[ ]*.*/\1/')
IP=$(/sbin/ip -o -4 addr list ${NETW_DEV} | awk '{print $4}' | cut -d/ -f1)
NETWORK_MASK=$(/sbin/ip route|grep ${NETW_DEV}|grep "proto kernel"|cut -f1 -d" ")

if [ ${NETW_DEV} == "wlan0" ]
then
    # does not work on GPRS etc
    NMAP_INFO=$(/usr/share/nmap-suid/bin/nmap --script broadcast-dhcp-discover -e ${NETW_DEV} 2>/dev/null)
    for record in ${NMAP_INFO}
    do
        echo "${record}"|grep -q "Domain Name Server:"
        if [ $? -eq 0 ]
        then
            # remove leading/trailing spaces using xargs
            DNS=$(echo "${record}"|cut -f2 -d":"|xargs)
        fi
        echo "${record}"|grep -q "Server Identifier:"
        if [ $? -eq 0 ]
        then
            DHCP=$(echo "${record}"|awk '{print $NF}')
        fi
        echo "${record}"|grep -q "Broadcast Address:"
        if [ $? -eq 0 ]
        then
            BROADCAST=$(echo "${record}"|awk '{print $NF}')
        fi
        echo "${record}"|grep -q "Domain Name:"
        if [ $? -eq 0 ]
        then
            DOMAIN=$(echo "${record}"|awk '{print $NF}')
        fi
        echo "${record}"|grep -q "Subnet Mask:"
        if [ $? -eq 0 ]
        then
            SUBNET_MASK=$(echo "${record}"|awk '{print $NF}')
        fi
    done
fi

# return values
printf "${NETW_DEV};${GATEWAY};${IP};${NETWORK_MASK};${DNS};${DHCP};${BROADCAST};${DOMAIN};${SUBNET_MASK}"
