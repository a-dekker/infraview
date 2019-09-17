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
ROUTE_INFO=$(/sbin/ip route | head -1)

# get further info
NETW_DEV=$(echo "${ROUTE_INFO}" | grep -oP "dev\s+\K\w+")
GATEWAY=$(echo "${ROUTE_INFO}" | sed '/via/s/.*via \([^ ][^ ]*\)[ ]*.*/\1/')
IP=$(/sbin/ip -o -4 addr list "${NETW_DEV}" | awk '{print $4}' | cut -d/ -f1)
NETWORK_MASK=$(/sbin/ip route | grep "${NETW_DEV}" | grep "proto kernel" | cut -f1 -d" ")

if [ "${NETW_DEV}" == "wlan0" ]; then
    # does not work on GPRS etc
    NMAP_INFO=$(/usr/share/nmap-suid/bin/nmap --script broadcast-dhcp-discover -e "${NETW_DEV}" 2>/dev/null)
    for record in ${NMAP_INFO}; do
        if echo "${record}" | grep -q "Domain Name Server:"; then
            # remove leading/trailing spaces using xargs
            DNS=$(echo "${record}" | cut -f2 -d":" | xargs)
        fi
        if echo "${record}" | grep -q "Server Identifier:"; then
            DHCP=$(echo "${record}" | awk '{print $NF}')
        fi
        if echo "${record}" | grep -q "Broadcast Address:"; then
            BROADCAST=$(echo "${record}" | awk '{print $NF}')
        fi
        if echo "${record}" | grep -q "Domain Name:"; then
            DOMAIN=$(echo "${record}" | awk '{print $NF}')
        fi
        if echo "${record}" | grep -q "Subnet Mask:"; then
            SUBNET_MASK=$(echo "${record}" | awk '{print $NF}')
        fi
    done
fi

# return values
printf "%s;%s;%s;%s;%s;%s;%s;%s;%s" \
    "${NETW_DEV}" "${GATEWAY}" "${IP}" "${NETWORK_MASK}" "${DNS}" "${DHCP}" "${BROADCAST}" "${DOMAIN}" "${SUBNET_MASK}"
