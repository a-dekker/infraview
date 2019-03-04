import dbus


def extract_values(values):
    val = ""
    for key in values.keys():
        val += " " + key + "="
        if key in ["PrefixLength"]:
            val += "%s" % (int(values[key]))
        else:
            if key in ["Servers", "Excludes"]:
                val += extract_list(values[key])
            else:
                val += str(values[key])
    return val


def extract_list(list):
    val = ""
    for i in list:
        val += " " + str(i)
    return val


bus = dbus.SystemBus()

manager = dbus.Interface(
    bus.get_object("net.connman", "/"), "net.connman.Manager")


def get_access_points():
    access_points = []
    for path, properties in manager.GetServices():
        mydict = {}
        service = dbus.Interface(
            bus.get_object("net.connman", path), "net.connman.Service")
        identifier = path[path.rfind("/") + 1:]
        mydict['Identifier'] = identifier

        for key in properties.keys():
            if key in [
                    "IPv4", "IPv4.Configuration", "IPv6", "IPv6.Configuration",
                    "Proxy", "Proxy.Configuration", "Ethernet", "Provider"
            ]:
                val = extract_values(properties[key])
            elif key in [
                    "Nameservers", "Nameservers.Configuration", "Domains",
                    "Domains.Configuration", "Timeservers",
                    "Timeservers.Configuration", "Security"
            ]:
                val = extract_list(properties[key])
            elif key in [
                    "Favorite", "Immutable", "AutoConnect", "LoginRequired",
                    "PassphraseRequired"
            ]:
                if properties[key] == dbus.Boolean(1):
                    val = "true"
                else:
                    val = "false"
            elif key in ["Strength"]:
                val = int(properties[key])
            else:
                val = properties[key]
            # print("    %s = %s" % (key, val))
            if key == "State":
                key = "ConnState"
            if key == "Hidden":
                key = "ConnHidden"
            val = str(val).strip()
            if key not in ["Provider", "Security", "Name"]:
                val = val.replace(" ", "\n")
            mydict[str(key).replace(".", "_")] = val
        access_points.append(mydict)

    return access_points
