import sys
# import pyotherside
# We use a custom location
sys.path.append("/usr/share/harbour-infraview/python/")
import nmap
import subprocess
from uuid import getnode as get_mac

try:
    nm = nmap.PortScanner(nmap_search_path=('/usr/share/nmap-suid/bin/nmap', 'nmap', '/usr/bin/nmap', '/usr/local/bin/nmap', '/opt/local/bin/nmap'))
except nmap.PortScannerError:
    print('Nmap not found', sys.exc_info()[0])
    sys.exit(0)
except:
    print("Unexpected error:", sys.exc_info()[0])
    sys.exit(0)


def scan(network):
    myip_subnet = subprocess.getoutput("/sbin/ip -o -f inet addr show | awk '/scope global/ {print $4}'")
    nm.scan(hosts=myip_subnet, arguments='nmap -sn')
    iplist = []
    # add localhost
    iplist.append({'ip_addr': '127.0.0.1', 'host': 'localhost'})
    for host in nm.all_hosts():
        try:
            ip_a = (nm[host]['addresses']['ipv4'])
        except KeyError:
            ip_a = "[Unknown IP]"
        try:
            host_name = nm[host].hostname()
        except KeyError:
            host_name = "[Unknown hostname]"
        iplist.append({'ip_addr': ip_a, 'host': host_name})

    return iplist


def devinfo(ip):
    myip = subprocess.getoutput("/sbin/ip -o -f inet addr show | awk '/scope global/ {print $4}'|cut -f1 -d/")
    tcp_ports = ""
    nm.scan(ip, arguments="-O")
    try:
        osfamily = nm[ip]['osmatch'][0]['osclass'][0]['osfamily']
    except:
        osfamily = 'Unknown'
    try:
        osname = nm[ip]['osmatch'][0]['name']
    except:
        osname = 'Unknown'
    try:
        mac_addr = nm[ip]['addresses']['mac']
    except:
        if ip == myip:
            mac = get_mac()
            mac_addr = ':'.join(("%012X" % mac)[i:i+2] for i in range(0, 12, 2))
        elif ip == '127.0.0.1':
            mac_addr = '00:00:00:00:00:00'
        else:
            mac_addr = "Unknown"
    try:
        vendor = nm[ip]['vendor'][mac_addr]
    except:
        vendor = "Unknown"
    try:
        lastboot = nm[ip]['uptime']['lastboot']
    except:
        lastboot = "Unknown"
    try:
        uptime = nm[ip]['uptime']['seconds']
        time = int(uptime)
        day = time // (24 * 3600)
        time = time % (24 * 3600)
        hour = time // 3600
        time %= 3600
        minutes = time // 60
        time %= 60
        uptime = str(day) + ' days ' + str(hour) + ' hrs ' + str(minutes) + ' min '
    except:
        uptime = "Unknown"
    try:
        for port in nm[ip].all_tcp():
            tcp_ports = tcp_ports + str(port) + " (" + nm[ip]['tcp'][port]['name'] + ")\n"
    except:
        tcp_ports = "No found"
    try:
        hostname = nm[ip]['hostnames'][0]['name'].replace("'", "")
    except:
        hostname = "Unknown"

    # print(nm[ip])
    return osfamily, osname, vendor, lastboot, uptime, mac_addr, hostname, tcp_ports
