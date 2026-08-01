import QtQuick
import QtQuick.Layouts
import "."

Item {
    RowLayout {
        anchors { fill: parent; leftMargin: 16; rightMargin: 16 }
        spacing: 0

        Item {
            width: 24; height: 24
            Text { anchors.centerIn: parent; text: "⇄"; font.pixelSize: 14
                color: PlayerState.shuffleEnabled ? Settings.accentColor : "#303030"
                Behavior on color { ColorAnimation { duration: 100 } }
            }
            MouseArea { anchors.fill: parent; onClicked: PlayerState.toggleShuffle() }
        }
        Item { Layout.fillWidth: true }
        Item {
            width: 28; height: 28
            Text { anchors.centerIn: parent; text: "⏮"; color: "#777"; font.pixelSize: 16 }
            MouseArea { anchors.fill: parent; onClicked: PlayerState.prevTrack() }
        }
        Item { width: 8 }
        Rectangle {
            width: 32; height: 32; radius: 16; color: Settings.accentColor
            Text {
                anchors.centerIn: parent; text: PlayerState.playing ? "⏸" : "▶"
                color: "#fff"; font.pixelSize: 14; leftPadding: PlayerState.playing ? 0 : 2
            }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: PlayerState.togglePlay() }
        }
        Item { width: 8 }
        Item {
            width: 28; height: 28
            Text { anchors.centerIn: parent; text: "⏭"; color: "#777"; font.pixelSize: 16 }
            MouseArea { anchors.fill: parent; onClicked: PlayerState.nextTrack() }
        }
        Item { Layout.fillWidth: true }
        Item {
            width: 24; height: 24
            Text { anchors.centerIn: parent; text: "↺"; font.pixelSize: 14
                color: PlayerState.loopEnabled ? Settings.accentColor : "#303030"
                Behavior on color { ColorAnimation { duration: 100 } }
            }
            MouseArea { anchors.fill: parent; onClicked: PlayerState.toggleLoop() }
        }
        Item { width: 8 }
        Text {
            text: PlayerState.muted ? "🔇" : "🔊"; color: "#444"; font.pixelSize: 11
            MouseArea { anchors.fill: parent; onClicked: PlayerState.toggleMute() }
        }
        Item { width: 4 }
        Text {
            text: (PlayerState.muted ? "0" : Math.round(PlayerState.volume * 100)) + "%"
            color: "#3a3a3a"; font.pixelSize: 9; font.family: "monospace"
            width: 28; horizontalAlignment: Text.AlignRight
        }
    }
}
