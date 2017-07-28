import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Page {
    id: arpPage

    Python {
        id: python

        Component.onCompleted: {
            scanningIndicator.running = true
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_arp', function () {
                console.log('call_arp module is now imported')
            })

            call('call_arp.show_table', [], function (result) {
                // Load the received data into the list model
                for (var i = 0; i < result.length; i++) {
                    // console.log(JSON.stringify(result[i]))
                    listarpModel.append(result[i])
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
            text: "Loading ARP cache"
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
            id: listarp
            width: parent.width
            height: parent.height
            // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
            header: PageHeader {
                width: listarp.width
                title: qsTr("ARP cache")
            }
            VerticalScrollDecorator {
            }
            model: ListModel {
                id: listarpModel
            }

            delegate: ListItem {
                id: listarpItem
                menu: contextMenu
                Item {
                    // background element with diagonal gradient
                    anchors.fill: parent
                    clip: true
                    Rectangle {
                        rotation: isPortrait ? 9 : 5
                        height: parent.height
                        x: -listarp.width
                        width: listarp.width * 2

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

                Label {
                    id: nameLabel
                    font.family: 'monospace'
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: name === '' ? ipaddress : ipaddress + ' [' + name + ']'
                    x: Theme.paddingMedium
                    width: parent.width - Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    font.family: 'monospace'
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: hwaddress + " [" + hwtype + "] on " + iface
                    x: Theme.paddingMedium
                    anchors.top: nameLabel.bottom
                    width: parent.width - Theme.paddingMedium
                    // enabled: false
                    // readOnly: true
                    color: Theme.highlightColor
                }
                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Copy IP address to clipboard")
                            onClicked: {
                                Clipboard.text = ipaddress
                            }
                        }
                        MenuItem {
                            text: qsTr("Copy MAC address to clipboard")
                            onClicked: {
                                Clipboard.text = hwaddress
                            }
                        }
                    }
                }
            }
        }
    }
}
