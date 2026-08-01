import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 3

    Repeater {
        model: 9
        delegate: Rectangle {
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: ws !== undefined
            visible: hasWindows || isActive
            width: 22
            height: 22
            radius: 0
            color: isActive ? "#724e7c" : "#241f31"
            border.color: isActive ? "#724e7c" : "#4a3d52"
            border.width: 1
            Text {
                anchors.centerIn: parent
                text: index + 1
                color: isActive ? "#f0e6f5" : "#9b8aa3"
                font.pixelSize: 11
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }

    // Отступ между воркспейсами и часами
    Item { width: 8 }

    // Часы
    Text {
        id: clock
        color: "#9b8aa3"
        font.pixelSize: 11
        font.bold: true

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
        Component.onCompleted: clock.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
    }
}
