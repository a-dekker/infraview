#!/bin/bash
#
set -uo pipefail

# first determine active device
ROUTE_INFO=$(/sbin/ip route|head -1)

# get further info
NETW_DEV=$(echo ${ROUTE_INFO}|grep -oP "dev\s+\K\w+")
GATEWAY=$(echo ${ROUTE_INFO}|sed '/via/s/.*via \([^ ][^ ]*\)[ ]*.*/\1/')
IP=$(/sbin/ip -o -4 addr list ${NETW_DEV} | awk '{print $4}' | cut -d/ -f1)
dev eth0 proto kernel scope link 
NETWORK_MASK=$(/sbin/ip route|grep ${NETW_DEV}|grep "proto kernel"|cut -f1 -d" ")

# return values
printf "${NETW_DEV};${GATEWAY};${IP};${NETWORK_MASK}"
