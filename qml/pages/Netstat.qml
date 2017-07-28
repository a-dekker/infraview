import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Page {
    id: netstatPage

    Python {
        id: python

        Component.onCompleted: {
            scanningIndicator.running = true
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_netstat', function () {
                console.log('call_netstat module is now imported')
            })

            call('call_netstat.show_connections', [], function (result) {
                // Load the received data into the list model
                for (var i = 0; i < result.length; i++) {
                    // console.log(JSON.stringify(result[i]))
                    if (result[i]["udp_tcp"] === "udp6"
                            || result[i]["udp_tcp"] === "tcp6") {
                        result[i]["localhost"] = compactIP(
                                    result[i]["localhost"])
                        result[i]["remotehost"] = compactIP(
                                    result[i]["remotehost"])
                    }
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
            text: "Collecting data..."
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

    function compactIP(ip) {
        // (       # Match and capture in backreference 1:
        //  (?:    #  Match this group:
        //   :0    #  :0
        //   \b    #  word boundary
        //  ){2,}  # twice or more
        // )       # End of capturing group 1
        // :?      # Match a : if present (not at the end of the address)
        // (?!     # Now assert that we can't match the following here:
        //  \S*    #  Any non-space character sequence
        //  \b     #  word boundary
        //  \1     #  the previous match
        //  :0     #  followed by another :0
        //  \b     #  word boundary
        // )       # End of lookahead. This ensures that there is not a longer
        // # sequence of ":0"s in this address.
        // (\S*)   # Capture the rest of the address in backreference 2.
        // # This is necessary to jump over any sequences of ":0"s
        // # that are of the same length as the first one.

        // and finally remove all leading zero's

        // var compressedString = ip.replace("((?:(?:^|:)0+\\b){2,}):?(?!\\S*\\b\\1:0+\\b)(\\S*)", "::$2")
        var compressedString = ip.replace(
                    /((?:(?:^|:)0+\b){2,}):?(?!\S*\b\1:0+\b)(\S*)/g,
                    "::$2").replace(/(:0{1,})/g, ":")
        return compressedString
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
                title: qsTr("Local connections")
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

                Label {
                    id: nameLabel
                    font.pixelSize: Theme.fontSizeSmall
                    x: Theme.paddingMedium
                    text: exe_name + " (" + UID + ", pid " + pid + ")"
                    width: parent.width - Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    text: "[" + udp_tcp + "] " + localhost + ":" + localport
                          + " " + remotehost + ":" + remoteport
                    x: Theme.paddingMedium
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
                                                   "NetstatInfo.qml"), {
                                                   uid: UID,
                                                   udp_tcp: udp_tcp,
                                                   localhost: localhost,
                                                   localport: localport,
                                                   exe_name: exe_name,
                                                   pid: pid,
                                                   conn_state: conn_state,
                                                   remotehost: remotehost,
                                                   remoteport: remoteport
                                               })
                            }
                        }
                    }
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NetstatInfo.qml"), {
                                       uid: UID,
                                       udp_tcp: udp_tcp,
                                       localhost: localhost,
                                       localport: localport,
                                       exe_name: exe_name,
                                       pid: pid,
                                       conn_state: conn_state,
                                       remotehost: remotehost,
                                       remoteport: remoteport
                                   })
                }
            }
        }
    }
}
