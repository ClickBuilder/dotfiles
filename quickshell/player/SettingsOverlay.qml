// SettingsOverlay.qml
import QtQuick
import QtQuick.Layouts
import "."

Rectangle {
    color: "#0d0d0d"
radius: 12
    property int activeTab: 0

    // ── шапка ────────────────────────────────────────────
    Rectangle {
        id: header
        anchors { top: parent.top
left: parent.left
right: parent.right }
        height: 38
color: "#0a0a0a"
radius: 12
        Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 12
color: parent.color }
        RowLayout {
            anchors { fill: parent
leftMargin: 14
rightMargin: 10 }
spacing: 6
            Text { text: "SETTINGS"
color: Settings.accentColor
font.pixelSize: 10
font.family: "monospace"
font.bold: true
Layout.fillWidth: true }
            Repeater {
                model: ["appearance","paths","keybinds"]
                Rectangle {
                    height: 22
width: lbl.implicitWidth + 16
radius: 3
                    color: activeTab === index ? Settings.accentColor : "transparent"
                    border.color: activeTab === index ? "transparent" : "#252525"
                    Text { id: lbl
anchors.centerIn: parent
text: modelData
color: activeTab === index ? "#fff" : "#444"
font.pixelSize: 9
font.family: "monospace" }
                    MouseArea { anchors.fill: parent
onClicked: activeTab = index }
                }
            }
            Rectangle {
                width: 22
height: 22
radius: 3
color: "transparent"
border.color: "#252525"
                Text { anchors.centerIn: parent
text: "✕"
color: "#444"
font.pixelSize: 10 }
                MouseArea { anchors.fill: parent
onClicked: { Settings.save()
Settings.settingsVisible = false } }
            }
        }
    }

    Rectangle { id: divider
anchors { top: header.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }

    // ── содержимое ───────────────────────────────────────
    Flickable {
        anchors { top: divider.bottom
left: parent.left
right: parent.right
bottom: footer.top }
        contentHeight: col.implicitHeight + 20
        clip: true

        Column {
            id: col
            width: parent.width - 28
x: 14
y: 10
spacing: 0

            // ══ APPEARANCE ══════════════════════════════
            Column {
                width: parent.width
spacing: 0
                visible: activeTab === 0

                Row { // panel width
                    width: parent.width
height: 30
                    Text { width: 110
anchors.verticalCenter: parent.verticalCenter
text: "Panel width"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Rectangle { width: 120
height: 24
color: "#141414"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _pw.activeFocus ? Settings.accentColor : "#252525"
                        TextInput { id: _pw
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 4
bottomMargin: 4 }
color: "#e0e0e0"
font.pixelSize: 10
font.family: "monospace"
text: String(Settings.panelWidth)
onEditingFinished: { var n=parseInt(text)
if(n>100){Settings.panelWidth=n;Settings.save()} } }
                    }
                }
                Row { // panel height
                    width: parent.width
height: 30
                    Text { width: 110
anchors.verticalCenter: parent.verticalCenter
text: "Panel height"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Rectangle { width: 120
height: 24
color: "#141414"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _ph.activeFocus ? Settings.accentColor : "#252525"
                        TextInput { id: _ph
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 4
bottomMargin: 4 }
color: "#e0e0e0"
font.pixelSize: 10
font.family: "monospace"
text: String(Settings.panelHeight)
onEditingFinished: { var n=parseInt(text)
if(n>100){Settings.panelHeight=n;Settings.save()} } }
                    }
                }

                Item { width: parent.width
height: 26 // section label
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "COLOR"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }

                Row { // accent color
                    width: parent.width
height: 30
spacing: 6
                    Text { width: 110
anchors.verticalCenter: parent.verticalCenter
text: "Accent"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Rectangle { width: 140
height: 24
color: "#141414"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _ac.activeFocus ? Settings.accentColor : "#252525"
                        TextInput { id: _ac
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 4
bottomMargin: 4 }
color: "#e0e0e0"
font.pixelSize: 10
font.family: "monospace"
text: Settings.accentColor
onEditingFinished: { Settings.accentColor = text
Settings.save() } }
                    }
                    Rectangle { width: 24
height: 24
radius: 3
color: Settings.accentColor
anchors.verticalCenter: parent.verticalCenter }
                }
                Row { // presets
                    width: parent.width
height: 30
spacing: 4
                    Text { width: 110
anchors.verticalCenter: parent.verticalCenter
text: "Presets"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Repeater {
                        model: ["#724e7c","#4e7c72","#7c6a4e","#4e627c","#7c4e4e","#5c7c4e","#3a6b8a"]
                        Rectangle {
                            width: 22
height: 22
radius: 3
color: modelData
anchors.verticalCenter: parent ? parent.verticalCenter : undefined
                            border.color: Settings.accentColor === modelData ? "#fff" : "transparent"
border.width: 2
                            MouseArea { anchors.fill: parent
onClicked: { Settings.accentColor = modelData
Settings.save() } }
                        }
                    }
                }

                Item { width: parent.width
height: 26
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "LIST"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }

                Row { width: parent.width
height: 28
                    Text { width: parent.width - 40
anchors.verticalCenter: parent.verticalCenter
text: "Thumbnails"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Rectangle { width: 32
height: 18
radius: 9
anchors.verticalCenter: parent.verticalCenter
color: Settings.showThumbnails ? Settings.accentColor : "#1e1e1e"
border.color: Settings.showThumbnails ? "transparent" : "#2a2a2a"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Rectangle { width: 12
height: 12
radius: 6
color: "white"
anchors.verticalCenter: parent.verticalCenter
x: Settings.showThumbnails ? 18 : 2
Behavior on x { NumberAnimation { duration: 120 } } }
                        MouseArea { anchors.fill: parent
onClicked: { Settings.showThumbnails = !Settings.showThumbnails
Settings.save() } }
                    }
                }
                Row { width: parent.width
height: 28
                    Text { width: parent.width - 40
anchors.verticalCenter: parent.verticalCenter
text: "Artist"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Rectangle { width: 32
height: 18
radius: 9
anchors.verticalCenter: parent.verticalCenter
color: Settings.showArtistInList ? Settings.accentColor : "#1e1e1e"
border.color: Settings.showArtistInList ? "transparent" : "#2a2a2a"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Rectangle { width: 12
height: 12
radius: 6
color: "white"
anchors.verticalCenter: parent.verticalCenter
x: Settings.showArtistInList ? 18 : 2
Behavior on x { NumberAnimation { duration: 120 } } }
                        MouseArea { anchors.fill: parent
onClicked: { Settings.showArtistInList = !Settings.showArtistInList
Settings.save() } }
                    }
                }
                Row { width: parent.width
height: 28
                    Text { width: parent.width - 40
anchors.verticalCenter: parent.verticalCenter
text: "Duration"
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                    Rectangle { width: 32
height: 18
radius: 9
anchors.verticalCenter: parent.verticalCenter
color: Settings.showDuration ? Settings.accentColor : "#1e1e1e"
border.color: Settings.showDuration ? "transparent" : "#2a2a2a"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Rectangle { width: 12
height: 12
radius: 6
color: "white"
anchors.verticalCenter: parent.verticalCenter
x: Settings.showDuration ? 18 : 2
Behavior on x { NumberAnimation { duration: 120 } } }
                        MouseArea { anchors.fill: parent
onClicked: { Settings.showDuration = !Settings.showDuration
Settings.save() } }
                    }
                }
            }

            // ══ PATHS ════════════════════════════════════
            Column {
                width: parent.width
spacing: 0
                visible: activeTab === 1

                Item { width: parent.width
height: 26
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "MUSIC"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }
                Text { width: parent.width
text: "mp3 скачиваются сюда, отсюда сканируется библиотека"
color: "#333"
font.pixelSize: 9
font.family: "monospace"
wrapMode: Text.Wrap
topPadding: 4
bottomPadding: 4 }
                Rectangle { width: parent.width
height: 28
color: "#141414"
radius: 3
border.color: _md.activeFocus ? Settings.accentColor : "#252525"
                    TextInput { id: _md
anchors { fill: parent
leftMargin: 8
rightMargin: 8
topMargin: 5
bottomMargin: 5 }
color: "#e0e0e0"
font.pixelSize: 10
font.family: "monospace"
text: Settings.musicDir
onEditingFinished: { Settings.musicDir = text
Settings.save() } }
                }

               Item {
    width: parent.width
    height: 26

    Text {
        anchors {
            bottom: parent.bottom
	     
            bottomMargin: 4
        }

        text: "METADATA"
        color: "#333"

        font.pixelSize: 8
        font.family: "monospace"
        font.bold: true
        font.letterSpacing: 1
    }

    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: 1
        color: "#141414"
    }
}                Text { width: parent.width
text: "обложки и .info.json от yt-dlp"
color: "#333"
font.pixelSize: 9
font.family: "monospace"
wrapMode: Text.Wrap
topPadding: 4
bottomPadding: 4 }
                Rectangle { width: parent.width
height: 28
color: "#141414"
radius: 3
border.color: _meta.activeFocus ? Settings.accentColor : "#252525"
                    TextInput { id: _meta
anchors { fill: parent
leftMargin: 8
rightMargin: 8
topMargin: 5
bottomMargin: 5 }
color: "#e0e0e0"
font.pixelSize: 10
font.family: "monospace"
text: Settings.metaDir
onEditingFinished: { Settings.metaDir = text
Settings.save() } }
                }

                Item { height: 10
width: parent.width }
                Rectangle {
                    width: parent.width
height: 28
radius: 3
color: "#111"
border.color: "#1e2e1e"
                    Row { anchors.centerIn: parent
spacing: 6
                        Text { text: "↻"
color: "#4caf50"
font.pixelSize: 13
anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "rescan music folder"
color: "#4caf50"
font.pixelSize: 10
font.family: "monospace"
anchors.verticalCenter: parent.verticalCenter }
                    }
                    MouseArea { anchors.fill: parent
onClicked: { PlayerState.scanMusicDir()
Settings.settingsVisible = false } }
                }
            }

            // ══ KEYBINDS ═════════════════════════════════
            Column {
                width: parent.width
spacing: 0
                visible: activeTab === 2

                Item { width: parent.width
height: 26
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "PLAYBACK"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }
                Repeater {
                    model: [["play","Play / Pause"],["next","Next"],["prev","Previous"],["loop","Loop"],["shuffle","Shuffle"],["mute","Mute"]]
                    Row { width: parent.width
height: 26
                        Text { width: 130
anchors.verticalCenter: parent.verticalCenter
text: modelData[1]
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                        Rectangle { width: parent.width - 130
height: 22
color: "#111"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _bi.activeFocus ? Settings.accentColor : "#1e1e1e"
                            TextInput { id: _bi
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 3
bottomMargin: 3 }
color: "#aaa"
font.pixelSize: 10
font.family: "monospace"
text: Settings.binds[modelData[0]] || ""
                                onEditingFinished: { var b=Object.assign({},Settings.binds)
b[modelData[0]]=text
Settings.binds=b
Settings.save() }
                            }
                        }
                    }
                }

                Item { width: parent.width
height: 26
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "SEEK"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }
                Repeater {
                    model: [["seekBack","−10s"],["seekFwd","+10s"],["seekBack60","−60s"],["seekFwd60","+60s"]]
                    Row { width: parent.width
height: 26
                        Text { width: 130
anchors.verticalCenter: parent.verticalCenter
text: modelData[1]
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                        Rectangle { width: parent.width - 130
height: 22
color: "#111"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _bs.activeFocus ? Settings.accentColor : "#1e1e1e"
                            TextInput { id: _bs
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 3
bottomMargin: 3 }
color: "#aaa"
font.pixelSize: 10
font.family: "monospace"
text: Settings.binds[modelData[0]] || ""
                                onEditingFinished: { var b=Object.assign({},Settings.binds)
b[modelData[0]]=text
Settings.binds=b
Settings.save() }
                            }
                        }
                    }
                }

                Item { width: parent.width
height: 26
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "LIBRARY"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }
                Repeater {
                    model: [["scan","Scan"],["filter","Filter"],["deleteTrack","Delete track"],["download","Download YT"],["createPlaylist","Create playlist"]]
                    Row { width: parent.width
height: 26
                        Text { width: 130
anchors.verticalCenter: parent.verticalCenter
text: modelData[1]
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                        Rectangle { width: parent.width - 130
height: 22
color: "#111"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _bl.activeFocus ? Settings.accentColor : "#1e1e1e"
                            TextInput { id: _bl
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 3
bottomMargin: 3 }
color: "#aaa"
font.pixelSize: 10
font.family: "monospace"
text: Settings.binds[modelData[0]] || ""
                                onEditingFinished: { var b=Object.assign({},Settings.binds)
b[modelData[0]]=text
Settings.binds=b
Settings.save() }
                            }
                        }
                    }
                }

                Item { width: parent.width
height: 26
                    Text { anchors { bottom: parent.bottom
bottomMargin: 4 }
text: "UI"
color: "#333"
font.pixelSize: 8
font.family: "monospace"
font.bold: true
font.letterSpacing: 1 }
                    Rectangle { anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
height: 1
color: "#141414" }
                }
                Repeater {
                    model: [["settings","Settings"],["help","Help"],["fullscreenThumb","Fullscreen"],["screenshot","Screenshot"]]
                    Row { width: parent.width
height: 26
                        Text { width: 130
anchors.verticalCenter: parent.verticalCenter
text: modelData[1]
color: "#555"
font.pixelSize: 10
font.family: "monospace" }
                        Rectangle { width: parent.width - 130
height: 22
color: "#111"
radius: 3
anchors.verticalCenter: parent.verticalCenter
border.color: _bu.activeFocus ? Settings.accentColor : "#1e1e1e"
                            TextInput { id: _bu
anchors { fill: parent
leftMargin: 7
rightMargin: 7
topMargin: 3
bottomMargin: 3 }
color: "#aaa"
font.pixelSize: 10
font.family: "monospace"
text: Settings.binds[modelData[0]] || ""
                                onEditingFinished: { var b=Object.assign({},Settings.binds)
b[modelData[0]]=text
Settings.binds=b
Settings.save() }
                            }
                        }
                    }
                }
            }
        }
    }

    // ── подвал ───────────────────────────────────────────
    Rectangle {
        id: footer
        anchors { bottom: parent.bottom
left: parent.left
right: parent.right }
        height: 36
color: "#080808"
radius: 12
        Rectangle { anchors { top: parent.top
left: parent.left
right: parent.right }
height: 12
color: parent.color }
        RowLayout {
            anchors { fill: parent
leftMargin: 14
rightMargin: 10 }
            Text { text: "[o] / [esc] close"
color: "#252525"
font.pixelSize: 9
font.family: "monospace"
Layout.fillWidth: true }
            Rectangle {
                width: 90
height: 24
radius: 3
color: Settings.accentColor
                Text { anchors.centerIn: parent
text: "save & close"
color: "#fff"
font.pixelSize: 9
font.bold: true }
                MouseArea { anchors.fill: parent
onClicked: { Settings.save()
Settings.settingsVisible = false } }
            }
        }
    }
}
