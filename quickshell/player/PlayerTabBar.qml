import QtQuick
import QtQuick.Layouts
import "."

RowLayout {
    spacing: 0
    Repeater {
        model: ["LOCAL","PLAYLISTS","YOUTUBE","HISTORY"]
        Item {
            Layout.fillWidth: true; height: parent.height
            Rectangle {
                anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
                height: 2
                color: PlayerState.mode === index ? Settings.accentColor : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Text {
                anchors.centerIn: parent; text: modelData
                color: PlayerState.mode === index ? "#e0e0e0" : "#333"
                font.pixelSize: 10; font.family: "monospace"; font.bold: PlayerState.mode === index
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            MouseArea { anchors.fill: parent; onClicked: PlayerState.mode = index }
        }
    }
}
