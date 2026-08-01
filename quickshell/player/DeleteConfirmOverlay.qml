// DeleteConfirmOverlay.qml
import QtQuick
import QtQuick.Layouts
import "."
Rectangle {
    color: "#0d0d0d"; radius: 12
    ColumnLayout {
        anchors { fill: parent; margins: 24 }
        Item { Layout.fillHeight: true }
        Text { text: "DELETE TRACK?"; color: "#cc3333"; font.pixelSize: 13; font.family: "monospace"; font.bold: true; Layout.alignment: Qt.AlignHCenter }
        Item { height: 8 }
        Text { Layout.fillWidth: true; text: PlayerState.confirmDeleteTitle; color: "#e0e0e0"; font.pixelSize: 12; wrapMode: Text.Wrap; horizontalAlignment: Text.AlignHCenter; Layout.alignment: Qt.AlignHCenter }
        Text { text: "file + metadata will be removed"; color: "#555"; font.pixelSize: 10; font.family: "monospace"; Layout.alignment: Qt.AlignHCenter }
        Item { height: 20 }
        RowLayout {
            Layout.fillWidth: true; Layout.alignment: Qt.AlignHCenter; spacing: 12
            Rectangle {
                width: 100; height: 32; radius: 6; color: "#1a1a1a"; border.color: "#2a2a2a"
                Text { anchors.centerIn: parent; text: "cancel"; color: "#777"; font.pixelSize: 11 }
                MouseArea { anchors.fill: parent; onClicked: PlayerState.cancelDelete() }
            }
            Rectangle {
                width: 100; height: 32; radius: 6; color: "#4a1515"; border.color: "#cc3333"
                Text { anchors.centerIn: parent; text: "delete"; color: "#ff6666"; font.pixelSize: 11; font.bold: true }
                MouseArea { anchors.fill: parent; onClicked: PlayerState.confirmDelete() }
            }
        }
        Item { Layout.fillHeight: true }
        Text { text: "[enter] confirm  [esc] cancel"; color: "#2a2a2a"; font.pixelSize: 9; font.family: "monospace"; Layout.alignment: Qt.AlignHCenter }
    }
}
