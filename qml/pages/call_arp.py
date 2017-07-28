import csv
import socket


def get_arp_table():
    """
        Get ARP table from /proc/net/arp
    """
    with open('/proc/net/arp') as arpt:
        names = [
            'IP address', 'HW type', 'Flags', 'HW address',
            'Mask', 'Device'
        ]  # arp 1.88, net-tools 1.60

        reader = csv.DictReader(
            arpt, fieldnames=names,
            skipinitialspace=True,
            delimiter=' ')

        next(reader)  # Skip header.

        return [block for block in reader]


def show_table():
    arpcache = get_arp_table()
    for index in range(len(arpcache)):
        # no spaces in names
        try:
            arpcache[index]['ipaddress'] = arpcache[index].pop('IP address')
            arpcache[index]['hwaddress'] = arpcache[index].pop('HW address')
            arpcache[index]['hwtype'] = arpcache[index].pop('HW type')
            arpcache[index]['iface'] = arpcache[index].pop('Device')
            arpcache[index]['Mask'] = arpcache[index].pop('name')
        except:
            continue
    for index in range(len(arpcache)):
        # translate to human readable
        if arpcache[index]['hwtype'] == '0x1':
            arpcache[index]['hwtype'] = 'ether'
    # hostnames not returned, let see if we can find them
    # and use the mask field for this
    for index in range(len(arpcache)):
        try:
            name = socket.gethostbyaddr(arpcache[index]['ipaddress'])
        except:
            name = ['']
        arpcache[index]['name'] = name[0]

    return arpcache
