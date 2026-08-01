// SettingsOverlay.qml
import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    color: "#0d0d0d"; radius: 12

    property int activeTab: 0

    ColumnLayout {
        anchors.fill: parent; spacing: 0

        // ── заголовок + табы ─────────────────────────────
        Rectangle {
            Layout.fillWidth: true; height: 48
            color: "#0d0d0d"; radius: 12
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12; color: parent.color
            }
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16; anchors.rightMargin: 16
                Text {
                    text: "SETTINGS"
                    color: Settings.accentColor; font.pixelSize: 11
                    font.family: "monospace"; font.bold: true
                    Layout.fillWidth: true
                }
                Repeater {
                    model: ["appearance", "paths", "keybinds"]
                    Rectangle {
                        height: 26; width: tabLabel.implicitWidth + 20; radius: 4
                        color: activeTab === index ? Settings.accentColor : "#181818"
                        border.color: activeTab === index ? "transparent" : "#2a2a2a"
                        Text {
                            id: tabLabel
                            anchors.centerIn: parent
                            text: modelData
                            color: activeTab === index ? "#fff" : "#555"
                            font.pixelSize: 9; font.family: "monospace"
                            font.bold: activeTab === index
                        }
                        MouseArea { anchors.fill: parent; onClicked: activeTab = index }
                    }
                }
                Item { width: 8 }
                Rectangle {
                    width: 26; height: 26; radius: 4
                    color: "#181818"; border.color: "#2a2a2a"
                    Text { anchors.centerIn: parent; text: "✕"; color: "#555"; font.pixelSize: 11 }
                    MouseArea { anchors.fill: parent; onClicked: { Settings.save(); Settings.settingsVisible = false } }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#1a1a1a" }

        // ── содержимое ───────────────────────────────────
        Flickable {
            Layout.fillWidth: true; Layout.fillHeight: true
            contentHeight: tabContent.implicitHeight + 24
            clip: true

            ColumnLayout {
                id: tabContent
                width: parent.width - 32
                x: 16; y: 16
                spacing: 10

                // TAB 0 — APPEARANCE
                Loader { active: activeTab === 0; Layout.fillWidth: true; sourceComponent: appearanceComp }
                Component {
                    id: appearanceComp
                    ColumnLayout {
                        spacing: 10
                        width: parent ? parent.width : 0

                        Text { text: "PANEL"; color: "#555"; font.pixelSize: 9; font.family: "monospace" }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Width"; color: "#666"; font.pixelSize: 10; font.family: "monospace"; width: 110 }
                            Rectangle {
                                Layout.fillWidth: true; height: 28; color: "#141414"; radius: 4
                                border.color: wInput.activeFocus ? Settings.accentColor : "#2a2a2a"
                                TextInput {
                                    id: wInput
                                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8
                                    anchors.topMargin: 5; anchors.bottomMargin: 5
                                    color: "#e0e0e0"; font.pixelSize: 10; font.family: "monospace"
                                    text: String(Settings.panelWidth)
                                    onEditingFinished: { var n=parseInt(text); if(n>200){Settings.panelWidth=n;Settings.save()} }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Height"; color: "#666"; font.pixelSize: 10; font.family: "monospace"; width: 110 }
                            Rectangle {
                                Layout.fillWidth: true; height: 28; color: "#141414"; radius: 4
                                border.color: hInput.activeFocus ? Settings.accentColor : "#2a2a2a"
                                TextInput {
                                    id: hInput
                                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8
                                    anchors.topMargin: 5; anchors.bottomMargin: 5
                                    color: "#e0e0e0"; font.pixelSize: 10; font.family: "monospace"
                                    text: String(Settings.panelHeight)
                                    onEditingFinished: { var n=parseInt(text); if(n>200){Settings.panelHeight=n;Settings.save()} }
                                }
                            }
                        }

                        Text { text: "COLOR"; color: "#555"; font.pixelSize: 9; font.family: "monospace"; topPadding: 4 }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Accent color"; color: "#666"; font.pixelSize: 10; font.family: "monospace"; width: 110 }
                            Rectangle {
                                Layout.fillWidth: true; height: 28; color: "#141414"; radius: 4
                                border.color: accentInput.activeFocus ? Settings.accentColor : "#2a2a2a"
                                TextInput {
                                    id: accentInput
                                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8
                                    anchors.topMargin: 5; anchors.bottomMargin: 5
                                    color: "#e0e0e0"; font.pixelSize: 11; font.family: "monospace"
                                    text: Settings.accentColor
                                    onEditingFinished: { Settings.accentColor = text; Settings.save() }
                                }
                            }
                            Rectangle { width: 26; height: 26; radius: 4; color: Settings.accentColor }
                        }

                        RowLayout {
                            Layout.fillWidth: true; spacing: 6
                            Repeater {
                                model: ["#724e7c","#4e7c72","#7c6a4e","#4e627c","#7c4e4e","#5c7c4e"]
                                Rectangle {
                                    width: 26; height: 26; radius: 4; color: modelData
                                    border.color: Settings.accentColor === modelData ? "#fff" : "transparent"
                                    MouseArea { anchors.fill: parent; onClicked: { Settings.accentColor = modelData; Settings.save() } }
                                }
                            }
                        }

                        Text { text: "LIST"; color: "#555"; font.pixelSize: 9; font.family: "monospace"; topPadding: 4 }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Show thumbnails"; color: "#666"; font.pixelSize: 10; Layout.fillWidth: true }
                            Rectangle {
                                width: 36; height: 20; radius: 10
                                color: Settings.showThumbnails ? Settings.accentColor : "#2a2a2a"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                Rectangle {
                                    width: 14; height: 14; radius: 7; color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: Settings.showThumbnails ? parent.width - 17 : 3
                                    Behavior on x { NumberAnimation { duration: 150 } }
                                }
                                MouseArea { anchors.fill: parent; onClicked: { Settings.showThumbnails = !Settings.showThumbnails; Settings.save() } }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Show artist"; color: "#666"; font.pixelSize: 10; Layout.fillWidth: true }
                            Rectangle {
                                width: 36; height: 20; radius: 10
                                color: Settings.showArtistInList ? Settings.accentColor : "#2a2a2a"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                Rectangle {
                                    width: 14; height: 14; radius: 7; color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: Settings.showArtistInList ? parent.width - 17 : 3
                                    Behavior on x { NumberAnimation { duration: 150 } }
                                }
                                MouseArea { anchors.fill: parent; onClicked: { Settings.showArtistInList = !Settings.showArtistInList; Settings.save() } }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Show duration"; color: "#666"; font.pixelSize: 10; Layout.fillWidth: true }
                            Rectangle {
                                width: 36; height: 20; radius: 10
                                color: Settings.showDuration ? Settings.accentColor : "#2a2a2a"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                Rectangle {
                                    width: 14; height: 14; radius: 7; color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: Settings.showDuration ? parent.width - 17 : 3
                                    Behavior on x { NumberAnimation { duration: 150 } }
                                }
                                MouseArea { anchors.fill: parent; onClicked: { Settings.showDuration = !Settings.showDuration; Settings.save() } }
                            }
                        }
                    }
                }

                // TAB 1 — PATHS
                Loader { active: activeTab === 1; Layout.fillWidth: true; sourceComponent: pathsComp }
                Component {
                    id: pathsComp
                    ColumnLayout {
                        spacing: 10
                        width: parent ? parent.width : 0

                        Text { text: "DIRECTORIES"; color: "#555"; font.pixelSize: 9; font.family: "monospace" }
                        Text {
                            text: "Изменения вступают в силу после перезапуска"
                            color: "#444"; font.pixelSize: 9; font.family: "monospace"
                            Layout.fillWidth: true; wrapMode: Text.Wrap
                        }

                        Item { height: 4 }

                        Text { text: "Music folder"; color: "#555"; font.pixelSize: 9; font.family: "monospace" }
                        Text {
                            text: "mp3 скачиваются сюда, отсюда сканируется библиотека"
                            color: "#3a3a3a"; font.pixelSize: 9; font.family: "monospace"
                            Layout.fillWidth: true; wrapMode: Text.Wrap
                        }
                        Rectangle {
                            Layout.fillWidth: true; height: 34; color: "#141414"; radius: 6
                            border.color: musicInput.activeFocus ? Settings.accentColor : "#2a2a2a"
                            TextInput {
                                id: musicInput
                                anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10
                                anchors.topMargin: 8; anchors.bottomMargin: 8
                                color: "#e0e0e0"; font.pixelSize: 11; font.family: "monospace"
                                text: Settings.musicDir
                                onEditingFinished: { Settings.musicDir = text; Settings.save() }
                            }
                        }

                        Item { height: 4 }

                        Text { text: "Metadata folder"; color: "#555"; font.pixelSize: 9; font.family: "monospace" }
                        Text {
                            text: "Обложки и info.json от yt-dlp"
                            color: "#3a3a3a"; font.pixelSize: 9; font.family: "monospace"
                            Layout.fillWidth: true; wrapMode: Text.Wrap
                        }
                        Rectangle {
                            Layout.fillWidth: true; height: 34; color: "#141414"; radius: 6
                            border.color: metaInput.activeFocus ? Settings.accentColor : "#2a2a2a"
                            TextInput {
                                id: metaInput
                                anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10
                                anchors.topMargin: 8; anchors.bottomMargin: 8
                                color: "#e0e0e0"; font.pixelSize: 11; font.family: "monospace"
                                text: Settings.metaDir
                                onEditingFinished: { Settings.metaDir = text; Settings.save() }
                            }
                        }

                        Item { height: 8 }

                        Rectangle {
                            Layout.fillWidth: true; height: 32; radius: 4
                            color: "#1a2a1a"; border.color: "#2a4a2a"
                            RowLayout {
                                anchors.centerIn: parent; spacing: 6
                                Text { text: "↻"; color: "#4caf50"; font.pixelSize: 14 }
                                Text { text: "rescan music folder"; color: "#4caf50"; font.pixelSize: 10; font.family: "monospace" }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: { PlayerState.scanMusicDir(); Settings.settingsVisible = false }
                            }
                        }
                    }
                }

                // TAB 2 — KEYBINDS
                Loader { active: activeTab === 2; Layout.fillWidth: true; sourceComponent: keybindsComp }
                Component {
                    id: keybindsComp
                    ColumnLayout {
                        spacing: 6
                        width: parent ? parent.width : 0

                        Text { text: "PLAYBACK"; color: "#555"; font.pixelSize: 9; font.family: "monospace" }
                        BindRow { bindLabel: "Play / Pause";   bindKey: "play" }
                        BindRow { bindLabel: "Next track";     bindKey: "next" }
                        BindRow { bindLabel: "Previous track"; bindKey: "prev" }
                        BindRow { bindLabel: "Loop";           bindKey: "loop" }
                        BindRow { bindLabel: "Shuffle";        bindKey: "shuffle" }
                        BindRow { bindLabel: "Mute";           bindKey: "mute" }

                        Text { text: "SEEK"; color: "#555"; font.pixelSize: 9; font.family: "monospace"; topPadding: 4 }
                        BindRow { bindLabel: "Seek −10s"; bindKey: "seekBack" }
                        BindRow { bindLabel: "Seek +10s"; bindKey: "seekFwd" }
                        BindRow { bindLabel: "Seek −60s"; bindKey: "seekBack60" }
                        BindRow { bindLabel: "Seek +60s"; bindKey: "seekFwd60" }

                        Text { text: "LIBRARY"; color: "#555"; font.pixelSize: 9; font.family: "monospace"; topPadding: 4 }
                        BindRow { bindLabel: "Scan music folder"; bindKey: "scan" }
                        BindRow { bindLabel: "Filter list";       bindKey: "filter" }
                        BindRow { bindLabel: "Delete track";      bindKey: "deleteTrack" }
                        BindRow { bindLabel: "Download YT track"; bindKey: "download" }

                        Text { text: "PLAYLISTS"; color: "#555"; font.pixelSize: 9; font.family: "monospace"; topPadding: 4 }
                        BindRow { bindLabel: "Create playlist"; bindKey: "createPlaylist" }

                        Text { text: "UI"; color: "#555"; font.pixelSize: 9; font.family: "monospace"; topPadding: 4 }
                        BindRow { bindLabel: "Settings";         bindKey: "settings" }
                        BindRow { bindLabel: "Help / keybinds";  bindKey: "help" }
                        BindRow { bindLabel: "Fullscreen cover"; bindKey: "fullscreenThumb" }
                        BindRow { bindLabel: "Screenshot";       bindKey: "screenshot" }
                    }
                }
            }
        }

        // ── нижняя панель ─────────────────────────────────
        Rectangle {
            Layout.fillWidth: true; height: 44
            color: "#090909"; radius: 12
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12; color: parent.color
            }
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16
                Text {
                    text: "[esc] / [o] close"
                    color: "#2a2a2a"; font.pixelSize: 9; font.family: "monospace"
                    Layout.fillWidth: true
                }
                Rectangle {
                    width: 110; height: 28; radius: 4; color: Settings.accentColor
                    Text { anchors.centerIn: parent; text: "save & close"; color: "#fff"; font.pixelSize: 10; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: { Settings.save(); Settings.settingsVisible = false } }
                }
            }
        }
    }

    // ── BindRow — переиспользуемый компонент для биндов ──
    component BindRow: RowLayout {
        property string bindLabel: ""
        property string bindKey: ""
        Layout.fillWidth: true

        Text {
            text: bindLabel
            color: "#666"; font.pixelSize: 10; font.family: "monospace"
            width: 160
        }
        Rectangle {
            Layout.fillWidth: true; height: 24; color: "#141414"; radius: 4
            border.color: bindInput.activeFocus ? Settings.accentColor : "#2a2a2a"
            TextInput {
                id: bindInput
                anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8
                anchors.topMargin: 4; anchors.bottomMargin: 4
                color: "#e0e0e0"; font.pixelSize: 10; font.family: "monospace"
                text: Settings.binds[parent.parent.bindKey] || ""
                onEditingFinished: {
                    var b = Object.assign({}, Settings.binds)
                    b[parent.parent.bindKey] = text
                    Settings.binds = b
                    Settings.save()
                }
            }
        }
    }
}
