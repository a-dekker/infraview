import sys
import re
import socket
sys.path.append("/usr/share/harbour-infraview/python/")
from dns.resolver import dns
from dns.reversename import dns


def is_valid_ipv4_address(address):
    """ Test for valid ip4"""
    try:
        socket.inet_pton(socket.AF_INET, address)
    except AttributeError:  # no inet_pton here, sorry
        try:
            socket.inet_aton(address)
        except socket.error:
            return False
        return address.count('.') == 3
    except socket.error:  # not a valid address
        return False

    return True


def is_valid_ipv6_address(address):
    """ Test for valid ip6"""
    try:
        socket.inet_pton(socket.AF_INET6, address)
    except socket.error:  # not a valid address
        return False
    return True


def is_valid_url(address):
    """ Test for valid hostname"""
    regex = re.compile(
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|'  # domain...
        r'localhost)'  # localhost...
        r'(?::\d+)?'   # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)
    return re.match(regex, address)


def show_ip_info(host_ip,record_type):
    """
        Resolve DNS name to IP
    """
    if is_valid_ipv4_address(host_ip) or is_valid_ipv6_address(host_ip):
        addr = dns.reversename.from_address(host_ip)
        response = dns.resolver.query(addr, "PTR")[0]
    elif is_valid_url(host_ip):
        name_server = '127.0.0.1'
        # name_server = '8.8.8.8'  # Google's DNS server
        ADDITIONAL_RDCLASS = 65535

        dns_rec_type = dns.rdatatype.from_text(record_type)
        request = dns.message.make_query(host_ip, dns_rec_type)
        request.flags |= dns.flags.AD
        request.find_rrset(request.additional, dns.name.root, ADDITIONAL_RDCLASS,
                           dns.rdatatype.OPT, create=True, force_unique=True)
        response = dns.query.udp(request, name_server)
    else:
        response = "Invalid input"

    return str(response)
