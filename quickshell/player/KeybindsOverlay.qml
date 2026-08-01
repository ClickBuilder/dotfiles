import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    color: "#f00d0d0d"; radius: 12
    Flickable {
        anchors { fill: parent; margins: 20 }
        contentHeight: kc.implicitHeight; clip: true
        ColumnLayout {
            id: kc; width: parent.width; spacing: 4
            Text { text: "KEYBINDS"; color: Settings.accentColor; font.pixelSize: 12; font.family: "monospace"; font.bold: true; bottomPadding: 8 }
            Repeater {
                model: [
                    [Settings.binds.play,            "pause / play"],
                    [Settings.binds.next,            "next track"],
                    [Settings.binds.prev,            "prev track"],
                    [Settings.binds.loop,            "loop toggle"],
                    ["s / s+1-5",                    "shuffle / rate"],
                    [Settings.binds.mute,            "mute"],
                    ["1–0",                          "volume 10–100%"],
                    [Settings.binds.seekBack+"/"+Settings.binds.seekFwd, "±10 sec"],
                    [Settings.binds.seekBack60+"/"+Settings.binds.seekFwd60, "±60 sec"],
                    ["j/k ↑↓",                      "navigate list"],
                    ["enter",                        "play selected"],
                    [Settings.binds.modeLocal,       "local tracks"],
                    [Settings.binds.modePlaylists,   "playlists"],
                    [Settings.binds.modeYoutube,     "youtube"],
                    [Settings.binds.modeHistory,     "history"],
                    [Settings.binds.download,        "download YT track"],
                    [Settings.binds.createPlaylist,  "create playlist"],
                    [Settings.binds.moveToPlaylist,  "move to playlist"],
                    ["tu",                           "new playlist + move"],
                    [Settings.binds.screenshot,      "screenshot"],
                    [Settings.binds.fullscreenThumb, "fullscreen thumb"],
                    [Settings.binds.filter,          "filter tracks"],
                    [Settings.binds.ratingFilter,    "filter by rating"],
                    [Settings.binds.gotoTrack,       "goto track #"],
                    [Settings.binds.deleteTrack,     "delete track"],
                    [Settings.binds.focusSearch,     "focus yt search"],
                    [Settings.binds.help,            "this help"],
                ]
                RowLayout {
                    Layout.fillWidth: true; spacing: 0
                    Text { text: modelData[0]; color: Settings.accentColor; font.pixelSize: 10; font.family: "monospace"; width: 130 }
                    Text { text: modelData[1]; color: "#555"; font.pixelSize: 10; font.family: "monospace" }
                }
            }
        }
    }
}
