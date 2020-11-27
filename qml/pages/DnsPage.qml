import QtQuick 2.5
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {
    id: hostresolvePage
    property string recordType: 'A'

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'))
            importModule('call_ip', function () {
                console.log('call_ip module is now imported')
            })
        }

        onError: {
            console.log('Python ERROR: ' + traceback)
            // Clipboard.text = traceback
        }
    }

    function showResolveResult() {
        python.call('call_ip.show_ip_info', [ip_url.text, recordType],
                    function (result) {
                        // console.log(result)
                        found_hostname.text = result
                    })
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {
        }

        Column {
            id: column
            spacing: 10
            width: parent.width
            PageHeader {
                title: qsTr("DNS query")
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
                    placeholderText: qsTr('Enter IP or hostname to resolve')
                    width: column.width - (2 * Theme.paddingLarge) - iconButton.width
                    EnterKey.highlighted: true
                    inputMethodHints: Qt.ImhUrlCharactersOnly
                    EnterKey.enabled: text.trim().length > 0
                }
                IconButton {
                    id: iconButton
                    icon.source: "image://theme/icon-m-clear"
                    onClicked: {
                        ip_url.text = ""
                        found_hostname.text = ""
                    }
                }
            }
            Row {
                spacing: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("A")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'A'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("AAAA")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'AAAA'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("CAA")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'CAA'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("CNAME")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'CNAME'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("MX")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'MX'
                        showResolveResult()
                    }
                }
            }
            Row {
                spacing: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: qsTr("NS")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'NS'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("PTR")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'PTR'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("SOA")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'SOA'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("SRV")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'SRV'
                        showResolveResult()
                    }
                }
                Button {
                    text: qsTr("TXT")
                    width: column.width / 5.5
                    enabled: ip_url.text.trim().length > 0
                    onClicked: {
                        recordType = 'TXT'
                        showResolveResult()
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
                id: found_hostname
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
