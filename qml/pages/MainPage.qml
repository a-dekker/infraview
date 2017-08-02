import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.infraview.Launcher 1.0

Page {
    id: mainPage

    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge
    property string networkType: "Unknown"
    property string networkName: ""
    property string myNetDev: "-"
    property string myGateWay: "-"
    property string myIP: "-"
    property string myNetMask: "-"
    property string myDNS: "-"
    property string myDHCP: "-"
    property string myBroadcast: "-"
    property string myDomain: "-"
    property string mySubnetMask: "-"

    Component.onCompleted: {
        networkType = bar.launch(
                    "cat /run/state/providers/connman/Internet/NetworkType")
        var networkName = bar.launch(
                    "cat /run/state/providers/connman/Internet/NetworkName")
        var myIPInfo = bar.launch(
                    "/usr/share/harbour-infraview/qml/pages/get_ip_address.sh")
        myIPInfo = myIPInfo.split(';')
        myNetDev = myIPInfo[0]
        myGateWay = myIPInfo[1]
        myIP = myIPInfo[2]
        myNetMask = myIPInfo[3]
        myDNS = myIPInfo[4]
        myDHCP = myIPInfo[5]
        myBroadcast = myIPInfo[6]
        myDomain = myIPInfo[7]
        mySubnetMask = myIPInfo[8]
    }

    SilicaFlickable {
        anchors.fill: parent

        App {
            id: bar
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }
        contentHeight: column.height

        Column {
            id: column
            width: mainPage.width
            spacing: largeScreen ? 50 : 7

            PageHeader {
                id: header
                title: app.name
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("External IP info")
                onClicked: pageStack.push("LocationInfo.qml")
                width: parent.width * .75
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Devices in current network")
                onClicked: pageStack.push("DeviceList.qml")
                width: parent.width * .75
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("ARP cache table")
                onClicked: pageStack.push("Arp.qml")
                width: parent.width * .75
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Network port connections")
                onClicked: pageStack.push("Netstat.qml")
                width: parent.width * .75
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Network type")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: networkType + " " + networkName
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Network device")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myNetDev
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Subnet Mask")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: mySubnetMask !== "?" ? myNetMask + "\n(" + mySubnetMask + ")" : myNetMask
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Gateway")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myGateWay
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                visible: myBroadcast !== "?"
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Broadcast")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myBroadcast
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall
                visible: myDomain !== "?"

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Domain")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myDomain
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall
                visible: myDHCP !== "?"

                Label {
                    width: parent.width * 0.5
                    text: qsTr("DHCP")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myDHCP
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall
                visible: myDNS !== "?"

                Label {
                    width: parent.width * 0.5
                    text: qsTr("DNS")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myDNS.replace(/, /g, "\n")
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("IP address")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: myIP
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
