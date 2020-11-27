import QtQuick 2.5
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {
    id: deviceInfoPage

    property string ip: ""
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge
    property string osfamily: "Unknown"
    property string osname: "Unknown"
    property string vendor: "Unknown"
    property string lastboot: "Unknown"
    property string uptime: "Unknown"
    property string mac_addr: "Unknown"
    property string hostname: "Unknown"
    property string tcp_ports: "Unknown"

    Python {
        id: python

        Component.onCompleted: {
            scanningIndicator.running = true
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_nmap', function () {
                console.log('call_nmap module is now imported')
            })

            call('call_nmap.devinfo', [ip], function (result) {
                osfamily = result[0]
                osname = result[1]
                vendor = result[2]
                lastboot = result[3]
                uptime = result[4]
                mac_addr = result[5]
                hostname = result[6]
                tcp_ports = result[7]
                scanningIndicator.running = false
            })
        }

        onError: {
            console.log('Python ERROR: ' + traceback)
            Clipboard.text = traceback
        }
    }
    Item {
        id: busy
        anchors.fill: parent
        Label {
            id: busyLabel
            anchors.bottom: scanningIndicator.top
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
            height: Theme.itemSizeLarge
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Retrieving device info")
            verticalAlignment: Text.AlignVCenter
            visible: scanningIndicator.running
            width: parent.width
        }
        BusyIndicator {
            id: scanningIndicator
            anchors {
                centerIn: parent
            }
            running: false
            size: BusyIndicatorSize.Large
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        VerticalScrollDecorator {
        }

        Column {
            id: column

            width: deviceInfoPage.width
            spacing: largeScreen ? 50 : 7

            PageHeader {
                title: qsTr("Device info")
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width * 0.5
                    text: qsTr("IP address")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: ip
                    visible: !scanningIndicator.running
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
                    text: qsTr("MAC address")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: mac_addr
                    visible: !scanningIndicator.running
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
                    text: qsTr("Hostname")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: hostname === "" ? "Unknown" : hostname
                    visible: !scanningIndicator.running
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
                    text: qsTr("Vendor")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: vendor
                    visible: !scanningIndicator.running
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
                    text: qsTr("OS Family")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: osfamily
                    visible: !scanningIndicator.running
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
                    text: qsTr("OS Name")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: osname
                    visible: !scanningIndicator.running
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
                    text: qsTr("Last boot")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: lastboot
                    visible: !scanningIndicator.running
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
                    text: qsTr("Uptime")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: uptime
                    visible: !scanningIndicator.running
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
                    text: qsTr("Open TCP ports")
                    visible: !scanningIndicator.running
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: parent.width * 0.5
                    text: tcp_ports === "" ? qsTr("None") : tcp_ports
                    visible: !scanningIndicator.running
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
