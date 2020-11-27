import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.infraview.Launcher 1.0

Page {
    id: toolPage

    property bool groupsAvailable: true

    Component.onCompleted: {
        var in_net_raw_group = bar.launch(
                    'grep -e "net_raw:x:[0-9].*' + username + '*" /etc/group')
        if (in_net_raw_group === "") {
            groupsAvailable = false
        }
    }

    App {
        id: bar
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }

        VerticalScrollDecorator {
        }

        Column {
            id: column

            x: Theme.paddingMedium
            width: toolPage.width - 2 * x
            spacing: Theme.paddingLarge

            PageHeader {
                title: "InfraView"
            }
            SectionHeader {
                text: qsTr("Tools")
            }

            Button {
                x: (parent.width - width) / 2
                text: qsTr("DNS resolving")
                onClicked: pageStack.push(Qt.resolvedUrl('DnsPage.qml'))
            }
            Button {
                x: (parent.width - width) / 2
                text: qsTr("Traceroute")
                onClicked: pageStack.push(Qt.resolvedUrl('TraceroutePage.qml'))
                enabled: groupsAvailable
            }
            Button {
                x: (parent.width - width) / 2
                text: qsTr("Ping")
                onClicked: pageStack.push(Qt.resolvedUrl('PingPage.qml'))
                enabled: groupsAvailable
            }
            Rectangle {
                height: Theme.paddingLarge
                width: Theme.paddingLarge
                color: "transparent"
                visible: !groupsAvailable
            }
            Label {
                    color: Theme.primaryColor
                    x: Theme.paddingMedium
                    width: toolPage.width - 2 * x
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                    text: qsTr("* Some features are disabled: user ") + username + qsTr(" is not a member of group 'net_raw'")
                    visible: !groupsAvailable
            }
        }
    }
}
