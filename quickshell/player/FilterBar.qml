import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    property alias inputItem: filterInput
    color: "#141414"; radius: 6; border.color: Settings.accentColor; clip: true
    RowLayout {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        Text { text: "f"; color: Settings.accentColor; font.pixelSize: 11; font.family: "monospace" }
        TextInput {
            id: filterInput
            Layout.fillWidth: true; color: "#e0e0e0"; font.pixelSize: 11; font.family: "monospace"
            text: PlayerState.filterText
            onTextChanged: PlayerState.filterText = text
            Keys.onEscapePressed: { PlayerState.filterActive = false; PlayerState.filterText = "" }
        }
        Text {
            text: "×"; color: "#555"; font.pixelSize: 14
            MouseArea { anchors.fill: parent; onClicked: { PlayerState.filterActive = false; PlayerState.filterText = "" } }
        }
    }
}
