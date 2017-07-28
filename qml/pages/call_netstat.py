import subprocess
import ast


def show_connections():
    connections = subprocess.check_output("/usr/share/harbour-infraview/helper/infraview-helper python3 /usr/share/harbour-infraview/python/netstat.py", shell=True)
    dlist = []
    netstat_keys = ["udp_tcp", "ConnID", "UID", "localhost", "localport", "remotehost", "remoteport", "conn_state", "pid", "exe_name"]
    for line in connections.splitlines():
        x = ast.literal_eval(line.decode("utf-8"))
        key_value = zip(netstat_keys, x)
        key_value_dict = dict(key_value)
        dlist.append(dict(key_value_dict))

    return dlist
