// TrackInfo.qml
import QtQuick
import QtQuick.Layouts
import "."

Item {
    ColumnLayout {
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 16; rightMargin: 16 }
        spacing: 3
        Text {
            Layout.fillWidth: true; text: PlayerState.currentTitle || "— no track —"
            color: "#f0f0f0"; font.pixelSize: 14; font.bold: true; elide: Text.ElideRight
        }
        Text {
            Layout.fillWidth: true; text: PlayerState.currentArtist || ""
            color: "#555"; font.pixelSize: 11; font.family: "monospace"; elide: Text.ElideRight
        }
    }
}
