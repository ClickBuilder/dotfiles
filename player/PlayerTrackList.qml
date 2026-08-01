// PlayerTrackList.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

ListView {
    id: tl
    clip: true
    model: PlayerState.currentList
    currentIndex: PlayerState.cursorIndex
    onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
        contentItem: Rectangle { implicitWidth: 3; color: "#2a2a2a"; radius: 2 }
        background: Rectangle { color: "transparent" }
    }

    delegate: Rectangle {
        width: tl.width; height: 34
        color: PlayerState.listIndex === index ? "#1c1424" : tl.currentIndex === index ? "#131313" : "transparent"

        Rectangle {
            width: 2; height: parent.height * 0.55
            anchors { left: parent.left; verticalCenter: parent.verticalCenter }
            color: Settings.accentColor; radius: 1
            visible: PlayerState.listIndex === index
        }

        RowLayout {
            anchors { fill: parent; leftMargin: 12; rightMargin: 10 }
            spacing: 8

            Text {
                text: index + 1
                color: PlayerState.listIndex === index ? Settings.accentColor : "#2e2e2e"
                font.pixelSize: 10; font.family: "monospace"; width: 26; horizontalAlignment: Text.AlignRight
            }
            Rectangle {
                width: (Settings.showThumbnails && modelData.thumbnail) ? 46 : 0
                height: 26; color: "#111"; radius: 2; clip: true
                visible: Settings.showThumbnails && !!modelData.thumbnail
                Image { anchors.fill: parent; source: modelData.thumbnail || ""; fillMode: Image.PreserveAspectCrop }
            }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 1
                Text {
                    Layout.fillWidth: true; text: modelData.title || String(modelData)
                    color: PlayerState.listIndex === index ? "#f0f0f0" : "#999"
                    font.pixelSize: 11; elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true; text: modelData.artist || ""
                    color: "#3a3a3a"; font.pixelSize: 9; font.family: "monospace"; elide: Text.ElideRight
                    visible: Settings.showArtistInList && !!modelData.artist
                }
            }
            Row {
                spacing: 2; visible: (modelData.rating || 0) > 0
                Repeater {
                    model: modelData.rating || 0
                    Rectangle { width: 4; height: 4; radius: 2; color: "#f5c518" }
                }
            }
            Rectangle {
                visible: !!modelData.isYt; width: 14; height: 14; radius: 2; color: "#cc2200"
                Text { anchors.centerIn: parent; text: "▶"; color: "white"; font.pixelSize: 7 }
            }
            Text {
                visible: Settings.showDuration && (modelData.duration || 0) > 0
                text: PlayerState.formatTime(modelData.duration || 0)
                color: "#2e2e2e"; font.pixelSize: 9; font.family: "monospace"
            }
        }
        MouseArea { anchors.fill: parent; onClicked: PlayerState.playAt(index) }
    }
}
