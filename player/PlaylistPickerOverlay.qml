// PlaylistPickerOverlay.qml
import QtQuick
import QtQuick.Layouts
import "."
Rectangle {
    color: "#0d0d0d"; radius: 12
    ColumnLayout {
        anchors { fill: parent; margins: 20 }
        Text { text: "MOVE TO PLAYLIST"; color: Settings.accentColor; font.pixelSize: 11; font.family: "monospace"; font.bold: true; bottomPadding: 8 }
        ListView {
            id: pp; Layout.fillWidth: true; Layout.fillHeight: true
            model: PlayerState.playlists; currentIndex: PlayerState.playlistPickerIndex; clip: true
            delegate: Rectangle {
                width: pp.width; height: 32; radius: 4
                color: pp.currentIndex === index ? "#1c1424" : "transparent"
                RowLayout { anchors { fill: parent; leftMargin: 8 }
                    Text { text: (index+1)+"."; color: "#555"; font.pixelSize: 10; font.family: "monospace"; width: 20 }
                    Text { Layout.fillWidth: true; text: modelData.name||String(modelData); color: pp.currentIndex===index?"#f0f0f0":"#777"; font.pixelSize: 11 }
                    Text { text: (modelData.tracks?modelData.tracks.length:0)+" tracks"; color: "#3a3a3a"; font.pixelSize: 9; font.family: "monospace"; rightPadding: 8 }
                }
            }
        }
        Text { text: "[1-5] quick select  [j/k] scroll  [enter] confirm  [esc] cancel  [u] new"; color: "#2e2e2e"; font.pixelSize: 9; font.family: "monospace"; wrapMode: Text.Wrap; Layout.fillWidth: true }
    }
}
