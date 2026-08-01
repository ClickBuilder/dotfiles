//StatusBar.qml
import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    color: "#090909"; clip: true
    Rectangle {
        visible: PlayerState.downloading
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        width: parent.width * (PlayerState.downloadProgress / 100)
        color: "#1a2a1a"
        Behavior on width { NumberAnimation { duration: 200 } }
    }
    RowLayout {
        anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
        Text {
            Layout.fillWidth: true; text: PlayerState.statusMessage
            color: PlayerState.downloading ? "#4caf50" : "#555"
            font.pixelSize: 9; font.family: "monospace"; elide: Text.ElideRight
        }
        Text {
            text: PlayerState.formatTime(PlayerState.position) + " / " + PlayerState.formatTime(PlayerState.duration)
            color: "#333"; font.pixelSize: 9; font.family: "monospace"
        }
    }
}
