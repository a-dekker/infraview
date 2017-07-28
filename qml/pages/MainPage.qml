import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: mainPage

    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }
        contentHeight: column.height

        Column {
            id: column
            width: mainPage.width
            spacing: largeScreen ? 50 : 7

            PageHeader {
                id: header
                title: app.name
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("External IP info")
                onClicked: pageStack.push("LocationInfo.qml")
                width: parent.width * .75
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Devices in current network")
                onClicked: pageStack.push("DeviceList.qml")
                width: parent.width * .75
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("ARP cache table")
                onClicked: pageStack.push("Arp.qml")
                width: parent.width * .75
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Network port connections")
                onClicked: pageStack.push("Netstat.qml")
                width: parent.width * .75
            }
        }
    }
}
