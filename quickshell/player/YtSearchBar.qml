// YtSearchBar.qml
import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    property alias inputItem: ytInput
    signal returnFocusRequested()
    color: "#141414"; radius: 6
    border.color: ytInput.activeFocus ? Settings.accentColor : "#1e1e1e"; clip: true

    MouseArea { anchors.fill: parent; onClicked: ytInput.forceActiveFocus() }

    RowLayout {
        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
        Text { text: "⌕"; color: ytInput.activeFocus ? Settings.accentColor : "#555"; font.pixelSize: 14 }
        TextInput {
            id: ytInput
            Layout.fillWidth: true; color: "#e0e0e0"; font.pixelSize: 11; font.family: "monospace"
            Keys.onReturnPressed: { PlayerState.ytSearch(text); returnFocusRequested() }
            Keys.onEscapePressed: returnFocusRequested()
            Text {
                anchors.fill: parent; text: "search / channel / url…"
                color: "#333"; font: parent.font
                visible: parent.text === "" && !parent.activeFocus
            }
        }
        Rectangle {
            width: 28; height: 22; radius: 4
            color: _sb.containsMouse ? "#2a1f2e" : "transparent"
            Text { anchors.centerIn: parent; text: "↵"; color: Settings.accentColor; font.pixelSize: 13 }
            MouseArea {
                id: _sb; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: { PlayerState.ytSearch(ytInput.text); returnFocusRequested() }
            }
        }
    }
}
