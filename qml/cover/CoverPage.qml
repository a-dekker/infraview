import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 15
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.name
        }
        Image {
            source: "/usr/share/icons/hicolor/86x86/apps/harbour-infraview.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
