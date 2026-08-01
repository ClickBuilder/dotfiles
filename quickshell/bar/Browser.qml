import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

PanelWindow {
    id: browser
    property bool shown: false
    property bool firefoxShown: false

    function toggle() {
        if (shown) {
            // скрыть панель, Firefox остаётся
            shown = false
        } else {
            shown = true
            if (!firefoxShown) {
                // показать Firefox
                showFirefox()
            }
        }
    }

    function showFirefox() {
        firefoxShown = true
        runProc.command = ["bash", "-c",
            "hyprctl dispatch togglespecialworkspace browser"]
        runProc.running = false
        runProc.running = true
    }

    function openSite(url) {
        // если Firefox не показан — показать
        if (!firefoxShown) {
            firefoxShown = true
            runProc.command = ["bash", "-c",
                "hyprctl dispatch togglespecialworkspace browser; sleep 0.2; " +
                "firefox --new-tab '" + url + "' &"]
        } else {
            runProc.command = ["bash", "-c",
                "firefox --new-tab '" + url + "' &"]
        }
        runProc.running = false
        runProc.running = true
    }

    Process {
        id: runProc
        command: ["bash", "-c", "echo"]
        running: false
    }

    visible: shown

    // Горизонтальная панель — начинается после бара
    implicitWidth:  screen ? screen.width / 2 : 1080
    implicitHeight: 36

    anchors.left: true
    anchors.top:  true

    WlrLayershell.layer:          WlrLayer.Overlay
    WlrLayershell.exclusiveZone:  0
    WlrLayershell.keyboardFocus:  WlrKeyboardFocus.None
    WlrLayershell.margins.top:    32

    color: "#1a1525"

    property var sites: [
        { name: "YouTube",  url: "https://youtube.com"        },
        { name: "Reddit",   url: "https://reddit.com"         },
        { name: "Arch",     url: "https://wiki.archlinux.org" },
        { name: "Hyprland", url: "https://wiki.hyprland.org"  },
        { name: "ChatGPT",  url: "https://chatgpt.com"        },
        { name: "Claude",   url: "https://claude.ai"          },
        { name: "SteamDB",  url: "https://steamdb.info"       }
    ]

    // Нижняя полоска
    Rectangle {
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        height: 1
        color:  "#724e7c"
        opacity: 0.5
    }

    Row {
        anchors.fill:        parent
        anchors.leftMargin:  6
        anchors.rightMargin: 6
        spacing: 2

        Repeater {
            model: browser.sites
            Rectangle {
                width:  Math.max(60, nameText.implicitWidth + 16)
                height: parent.height
                color:  ma.containsMouse ? "#2a2035" : "transparent"
                radius: 3
                Behavior on color { ColorAnimation { duration: 80 } }

                Text {
                    id: nameText
                    anchors.centerIn: parent
                    text:  modelData.name
                    color: ma.containsMouse ? "#f0e6f5" : "#9b8aa3"
                    font.pixelSize: 10
                    font.bold:      ma.containsMouse
                    Behavior on color { ColorAnimation { duration: 80 } }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:  Qt.PointingHandCursor
                    onClicked:    browser.openSite(modelData.url)
                }
            }
        }
    }
}
