import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    property bool largeScreen: screen.width > 540

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            SectionHeader {
                text: qsTr("Info")
                visible: isPortrait || (largeScreen && screen.width > 1080)
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || (largeScreen && screen.width > 1080)
            }
            Label {
                text: app.name
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: isLandscape ? (largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-infraview.png" : "/usr/share/icons/hicolor/86x86/apps/harbour-infraview.png") : (largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-infraview.png" : "/usr/share/icons/hicolor/128x128/apps/harbour-infraview.png")
            }
            Label {
                text: qsTr("Version") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("Device network information")
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                horizontalAlignment: Text.Center
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Author")
                visible: isPortrait || (largeScreen && screen.width > 1080)
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || (largeScreen && screen.width > 1080)
            }
            Label {
                text: "© Arno Dekker 2017-2018"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                x: Theme.paddingLarge
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeTiny
                text: qsTr("Using ") + "<a href=\"https://bitbucket.org/xael\">python-nmap</a>"
                      + ", " + "<a href=\"https://nmap.org/\">nmap</a>" + ", "
                      + "<a href=\"https://github.com/requests/requests\">requests</a>" + ", "
                      + "<a href=\"https://github.com/rthalley/dnspython\">dnspython</a>"
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
