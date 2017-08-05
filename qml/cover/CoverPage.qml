import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        width: parent.width
        spacing: Theme.paddingSmall
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 15
        Label {
            id: coverHeader
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.secondaryColor
            text: app.name
        }
        Separator {
            color: Theme.primaryColor
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Qt.AlignHCenter
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Network type")
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.networkType
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Network name")
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.networkName
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Subnet Mask")
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.myNetMask
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("IP address")
            font.pixelSize: Theme.fontSizeExtraSmall
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: app.myIP
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }
}
