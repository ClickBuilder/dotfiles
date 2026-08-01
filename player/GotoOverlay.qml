import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    property alias inputItem: gotoInput
    color: "#141414"; radius: 6; border.color: Settings.accentColor; clip: true
    RowLayout {
        anchors { fill: parent; margins: 10 }
        Text { text: "go to:"; color: Settings.accentColor; font.pixelSize: 11; font.family: "monospace" }
        TextInput {
            id: gotoInput
            Layout.fillWidth: true; color: "#e0e0e0"; font.pixelSize: 12; font.family: "monospace"
            validator: IntValidator { bottom: 1 }
            Keys.onReturnPressed: { PlayerState.gotoTrack(parseInt(text)-1); PlayerState.gotoActive=false; text="" }
            Keys.onEscapePressed: { PlayerState.gotoActive=false; text="" }
        }
    }
}
