// ThumbStrip.qml
import QtQuick
import "."

Rectangle {
    property var playerWindowRef: null
    color: "#111"; clip: true

    Image {
        anchors.fill: parent; source: PlayerState.currentThumbnail
        fillMode: Image.PreserveAspectCrop; opacity: 0.75
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 60
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#0d0d0d" }
        }
    }
    Rectangle {
        anchors { left: parent.left; bottom: parent.bottom }
        height: 2
        width: PlayerState.duration > 0 ? (PlayerState.position / PlayerState.duration) * parent.width : 0
        color: Settings.accentColor
        Behavior on width { NumberAnimation { duration: 400 } }
    }
    Rectangle {
        anchors { top: parent.top; left: parent.left; margins: 10 }
        width: _mt.implicitWidth + 12; height: 18; radius: 3
        color: "#1a1a1a"; border.color: "#2a2a2a"
        Text {
            id: _mt; anchors.centerIn: parent
            text: ["LOCAL","PLAYLISTS","YOUTUBE","HISTORY"][PlayerState.mode] || "LOCAL"
            color: ["#4e9c6e","#7c9fff","#ff5555","#c89c5e"][PlayerState.mode] || "#4e9c6e"
            font.pixelSize: 9; font.family: "monospace"; font.bold: true
        }
    }
    Row {
        anchors { top: parent.top; right: parent.right; margins: 10 }
        spacing: 2
        Repeater {
            model: 5
            Text {
                text: "★"
                color: (index + 1) <= PlayerState.currentRating ? "#f5c518" : "#222"
                font.pixelSize: 13
                Behavior on color { ColorAnimation { duration: 120 } }
            }
        }
    }
    MouseArea {
        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
        onClicked: if (playerWindowRef) playerWindowRef.fullImageMode = true
    }
}
