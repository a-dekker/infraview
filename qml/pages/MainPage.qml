import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.infraview.Launcher 1.0

Page {
    id: mainPage

    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge
    property string myNetDev: ""
    property string myGateWay: ""
    property string myDNS: ""
    property string myDHCP: ""
    property string myBroadcast: ""
    property string myDomain: ""
    property string mySubnetMask: ""

    Component.onCompleted: {
        getNetworkInfo()
    }

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            pageStack.pushAttached(Qt.resolvedUrl("ToolPage.qml"))
        }
    }

    function getNetworkInfo() {
        busy_sign.running = true
        app.networkType = bar.launch(
                    "cat /run/state/providers/connman/Internet/NetworkType")
        app.networkName = bar.launch(
                    "cat /run/state/providers/connman/Internet/NetworkName")
        bar.launch_async(
                    "/usr/share/harbour-infraview/qml/pages/get_ip_address.sh")
    }

    function setIpInfo(myIPInfo) {
        busy_sign.running = false
        myIPInfo = myIPInfo.split(';')
        myNetDev = myIPInfo[0]
        myGateWay = myIPInfo[1]
        app.myIP = myIPInfo[2]
        app.myNetMask = myIPInfo[3]
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
            onMessageChanged: setIpInfo(message)
        }

        PullDownMenu {
            id: menu
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    getNetworkInfo()
                }
            }
            busy: busy_sign.running
        }
        contentHeight: column.height

        VerticalScrollDecorator {
        }

        Column {
            id: column
            width: mainPage.width
            spacing: largeScreen ? 50 : 7

            PageHeader {
                id: header
                title: app.name

                BusyIndicator {
                    id: busy_sign
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    size: BusyIndicatorSize.Small
                    running: false
                }
            }

            Row {
                spacing: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("External IP info")
                    onClicked: pageStack.push("LocationInfo.qml")
                    width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
                }
                Button {
                    text: qsTr("Devices in current network")
                    onClicked: pageStack.push("DeviceList.qml")
                    width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
                    visible: isLandscape
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Devices in current network")
                onClicked: pageStack.push("DeviceList.qml")
                width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
                visible: isPortrait
            }
            Row {
                spacing: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("ARP cache table")
                    onClicked: pageStack.push("Arp.qml")
                    width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
                }
                Button {
                    text: qsTr("Network port connections")
                    onClicked: pageStack.push("Netstat.qml")
                    width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
                    visible: isLandscape
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Network port connections")
                onClicked: pageStack.push("Netstat.qml")
                width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
                visible: isPortrait
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("ConnMan connections")
                onClicked: pageStack.push("ConnmanNetServices.qml")
                width: isPortrait ? (column.width / 1) * 0.85 : (column.width / 2) * 0.85
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
                    text: app.networkType
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
                    text: qsTr("Network name")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: app.networkName
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall
                visible: myNetDev !== ""

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
                visible: mySubnetMask !== ""

                Label {
                    width: parent.width * 0.5
                    text: qsTr("Subnet Mask")
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }

                Label {
                    width: parent.width * 0.5
                    text: mySubnetMask !== "?" ? app.myNetMask + "\n(" + mySubnetMask
                                                 + ")" : app.myNetMask
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall
                visible: myGateWay !== ""

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
                width: parent.width
                spacing: Theme.paddingSmall
                visible: myBroadcast !== "" && app.networkType === "WLAN"

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
                visible: myDomain !== "" && app.networkType === "WLAN"

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
                visible: myDHCP !== "" && app.networkType === "WLAN"

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
                visible: myDNS !== "" && app.networkType === "WLAN"

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
                visible: app.myIP !== ""

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
                    text: app.myIP
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
