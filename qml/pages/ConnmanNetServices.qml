import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {
    id: netstatPage

    Python {
        id: python

        Component.onCompleted: {
            scanningIndicator.running = true
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_connman', function () {
                console.log('call_connman module is now imported')
            })

            call('call_connman.get_access_points', [], function (result) {
                // Load the received data into the list model
                for (var i = 0; i < result.length; i++) {
                    // console.log(JSON.stringify(result[i]))
                    listnetstatModel.append(result[i])
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
            text: qsTr("Collecting data...")
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
            id: listnetstat
            width: parent.width
            height: parent.height
            // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
            header: PageHeader {
                width: listnetstat.width
                title: qsTr("Known ConnMan connections")
            }
            VerticalScrollDecorator {
            }
            model: ListModel {
                id: listnetstatModel
            }

            delegate: ListItem {
                id: listnetstatItem
                menu: contextMenu
                Item {
                    // background element with diagonal gradient
                    anchors.fill: parent
                    clip: true
                    Rectangle {
                        rotation: isPortrait ? 9 : 5
                        height: parent.height
                        x: -listnetstat.width
                        width: listnetstat.width * 2

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
                    id: hotspotIcon
                    icon.source: Type === "wifi" ? "image://theme/icon-m-wlan" : "image://theme/icon-m-wlan-no-signal"
                    opacity: listnetstatItem.highlighted ? 0.5 : 1.0
                }
                Label {
                    id: nameLabel
                    font.pixelSize: Theme.fontSizeMedium
                    anchors.left: hotspotIcon.right
                    text: Name ? Name : qsTr("Hidden")
                    width: parent.width - hotspotIcon.width
                    truncationMode: TruncationMode.Fade
                    color: Theme.primaryColor
                }
                Label {
                    font.pixelSize: Theme.fontSizeMedium
                    text: Type === "wifi" ? Type + " " + Security : Type
                    anchors.left: hotspotIcon.right
                    anchors.top: nameLabel.bottom
                    width: parent.width - Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                    color: Theme.highlightColor
                }
                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Show more info")
                            onClicked: {
                                pageStack.push(Qt.resolvedUrl(
                                                   "ConnmanInfo.qml"), {
                                                   "con_name": Name,
                                                   "identifier": Identifier,
                                                   "autoConnect": AutoConnect,
                                                   "con_state": ConnState,
                                                   "defaultAccess": DefaultAccess,
                                                   "autoConnect": AutoConnect,
                                                   "ethernet": Ethernet,
                                                   "favorite": Favorite,
                                                   "con_hidden": ConnHidden,
                                                   "ipv4": IPv4,
                                                   "ipv4Configuration": IPv4_Configuration,
                                                   "ipv6": IPv6,
                                                   "ipv6Configuration": IPv6_Configuration,
                                                   "security": Security,
                                                   "con_type": Type,
                                                   "strength": Strength,
                                                   "bssid": BSSID,
                                                   "timeservers": Timeservers,
                                                   "nameservers": Nameservers,
                                                   "saved": Saved
                                               })
                            }
                        }
                    }
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ConnmanInfo.qml"), {
                                       "con_name": Name,
                                       "identifier": Identifier,
                                       "autoConnect": AutoConnect,
                                       "con_state": ConnState,
                                       "defaultAccess": DefaultAccess,
                                       "autoConnect": AutoConnect,
                                       "ethernet": Ethernet,
                                       "favorite": Favorite,
                                       "con_hidden": ConnHidden,
                                       "ipv4": IPv4,
                                       "ipv4Configuration": IPv4_Configuration,
                                       "ipv6": IPv6,
                                       "ipv6Configuration": IPv6_Configuration,
                                       "security": Security,
                                       "con_type": Type,
                                       "strength": Strength,
                                       "timeservers": Timeservers,
                                       "nameservers": Nameservers,
                                       "saved": Saved
                                   })
                }
            }
        }
    }
}
