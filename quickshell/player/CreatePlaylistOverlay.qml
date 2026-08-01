// CreatePlaylistOverlay.qml
import QtQuick
import QtQuick.Layouts
import "."
Rectangle {
    property alias inputItem: plInput
    color: "#0d0d0d"; radius: 12
    onVisibleChanged: if (visible) Qt.callLater(function() { plInput.forceActiveFocus() })
    ColumnLayout {
        anchors { fill: parent; margins: 24 }
        Text {
            text: PlayerState.createPlaylistAndMoveMode ? "NEW PLAYLIST + MOVE" : "NEW PLAYLIST"
            color: Settings.accentColor; font.pixelSize: 11; font.family: "monospace"; font.bold: true
        }
        Item { height: 12 }
        Rectangle {
            Layout.fillWidth: true; height: 36; color: "#141414"; radius: 6
            border.color: plInput.activeFocus ? Settings.accentColor : "#2a2a2a"
            TextInput {
                id: plInput
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 12; rightMargin: 12 }
                color: "#e0e0e0"; font.pixelSize: 13; font.family: "monospace"
                Keys.onReturnPressed: { PlayerState.confirmCreatePlaylist(text); text = "" }
                Keys.onEscapePressed: { PlayerState.cancelCreatePlaylist(); text = "" }
                Text { anchors.fill: parent; text: "playlist name…"; color: "#333"; font: parent.font; visible: parent.text === "" && !parent.activeFocus }
            }
        }
        Item { height: 8 }
        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 80; height: 28; radius: 4; color: "#1a1a1a"; border.color: "#2a2a2a"
                Text { anchors.centerIn: parent; text: "cancel"; color: "#555"; font.pixelSize: 10 }
                MouseArea { anchors.fill: parent; onClicked: { PlayerState.cancelCreatePlaylist(); plInput.text = "" } }
            }
            Item { width: 8 }
            Rectangle {
                width: 80; height: 28; radius: 4; color: Settings.accentColor
                Text { anchors.centerIn: parent; text: "create"; color: "#fff"; font.pixelSize: 10; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: { PlayerState.confirmCreatePlaylist(plInput.text); plInput.text = "" } }
            }
        }
        Item { Layout.fillHeight: true }
        Text { text: "[enter] create  [esc] cancel"; color: "#2a2a2a"; font.pixelSize: 9; font.family: "monospace" }
    }
}
