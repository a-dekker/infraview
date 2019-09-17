import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: toolPage

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
            }
        }
    }
}
