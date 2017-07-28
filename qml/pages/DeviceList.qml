import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Page {
    id: devicePage

    Python {
        id: python

        Component.onCompleted: {
            scanningIndicator.running = true
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_nmap', function () {
                console.log('call_nmap module is now imported')
            })

            call('call_nmap.scan', ['192.168.1.0'], function (result) {
                // Load the received data into the list model
                for (var i = 0; i < result.length; i++) {
                    listDeviceModel.append(result[i])
                }
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
            text: "Scanning for devices"
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

        SilicaListView {
            id: listDevice
            width: parent.width
            height: parent.height
            // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
            header: PageHeader {
                width: listDevice.width
                title: qsTr("Devices")
            }
            VerticalScrollDecorator {
            }
            model: ListModel {
                id: listDeviceModel
            }

            delegate: ListItem {
                id: listDeviceItem
                menu: contextMenu
                Item {
                    // background element with diagonal gradient
                    anchors.fill: parent
                    clip: true
                    Rectangle {
                        rotation: isPortrait ? 9 : 5
                        height: parent.height
                        x: -listDevice.width
                        width: listDevice.width * 2

                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: Theme.rgba(Theme.primaryColor, 0)
                            }
                            GradientStop {
                                position: 1.0
                                color: Theme.rgba(Theme.primaryColor, 0.1)
                            }
                        }
                    }
                }
                IconButton {
                    id: computerIcon
                    icon.source: "image://theme/icon-m-computer"
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl(
                                                        "DeviceInfo.qml"), {
                                                        ip: ip_addr
                                                    })
                    }
                    opacity: listDeviceItem.highlighted ? 0.5 : 1.0
                }

                Label {
                    id: nameLabel
                    font.family: 'monospace'
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.left: computerIcon.right
                    text: ip_addr
                    truncationMode: TruncationMode.Fade
                }
                TextField {
                    id: passLabel
                    text: host === "" ? "Unknown device name" : host
                    anchors.top: nameLabel.bottom
                    font.pixelSize: Theme.fontSizeSmall
                    enabled: false
                    readOnly: true
                    textMargin: nameLabel.x
                    color: Theme.highlightColor
                }
                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Show more info")
                            onClicked: {
                                pageStack.push(Qt.resolvedUrl(
                                                   "DeviceInfo.qml"), {
                                                   ip: ip_addr
                                               })
                            }
                        }
                        MenuItem {
                            text: qsTr("Copy IP address to clipboard")
                            onClicked: {
                                Clipboard.text = ip_addr
                            }
                        }
                    }
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("DeviceInfo.qml"), {
                                       ip: ip_addr
                                   })
                }
            }
        }
    }
}
