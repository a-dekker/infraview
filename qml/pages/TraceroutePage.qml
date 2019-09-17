import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.infraview.Launcher 1.0

Page {
    id: traceroutePage

    function getTracerouteInfo() {
        busy_sign.running = true
        bar.launch_async("/usr/bin/traceroute " + ip_url.text)
    }

    function showTraceRouteInfo(tracerouteInfo) {
        trace_result.text = trace_result.text + tracerouteInfo
    }

    Item {
        anchors.fill: parent
        BusyIndicator {
            id: busy_sign_center
            anchors {
                centerIn: parent
            }
            running: busy_sign.running
            size: BusyIndicatorSize.Large
        }
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        App {
            id: bar
            onMessageChanged: showTraceRouteInfo(message)
            onDoneChanged: {
                busy_sign.running = false
            }
        }

        VerticalScrollDecorator {
        }

        Column {
            id: column
            spacing: 10
            width: parent.width
            PageHeader {
                title: qsTr("Traceroute")

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
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                spacing: 0
                TextField {
                    id: ip_url
                    x: Theme.paddingLarge
                    y: Theme.paddingLarge
                    font.pixelSize: Theme.fontSizeMedium
                    placeholderText: qsTr('Enter IP or hostname for traceroute')
                    width: column.width - (2 * Theme.paddingLarge) - iconButton.width
                    EnterKey.highlighted: true
                    inputMethodHints: Qt.ImhUrlCharactersOnly
                    EnterKey.enabled: text.trim().length > 0
                    EnterKey.onClicked: {
                        trace_result.text = ""
                        ip_url.focus = false
                        getTracerouteInfo()
                    }
                }
                IconButton {
                    id: iconButton
                    icon.source: "image://theme/icon-m-clear"
                    enabled: !busy_sign.running
                    onClicked: {
                        ip_url.text = ""
                        trace_result.text = ""
                    }
                }
            }
            Rectangle {
                // some whitespace
                width: parent.width
                height: Theme.paddingLarge
                opacity: 0
            }
            Label {
                id: trace_result
                font.family: 'monospace'
                font.pixelSize: Theme.fontSizeExtraSmall
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                wrapMode: Text.Wrap
                width: parent.width - Theme.paddingLarge
                text: ""
            }
        }
    }
}
