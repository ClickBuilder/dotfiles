import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../player" as Player

PanelWindow {
    id: bar
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: 32
    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: 32
    color: "transparent"

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name !== "openwindow") return
            var parts = event.data.split(",")
            if (parts.length < 3) return
            launchText.appName = parts[2] || "?"
            launchText.workspaceId = parts[1] || "?"
            launchText.visible = true
            progressBar.progress = 0
            progressTimer.restart()
            hideTimer.restart()
        }
    }

    Timer {
        id: progressTimer
        interval: 25
        repeat: true
        onTriggered: {
            progressBar.progress += 0.01
            if (progressBar.progress >= 1.0) {
                progressBar.progress = 1.0
                stop()
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 2500
        repeat: false
        onTriggered: {
            launchText.visible = false
            progressBar.progress = 0
        }
    }

    Rectangle {
        id: progressBar
        property real progress: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 2
        width: parent.width * progress
        color: "#724e7c"
        Behavior on width {
            NumberAnimation { duration: 25 }
        }
    }

    Workspaces {
        anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
        }
    }

    Text {
        id: launchText
        visible: false
        property string appName: ""
        property string workspaceId: ""
        anchors.centerIn: parent
        text: appName + " → ws " + workspaceId
        color: "#724e7c"
        font.pixelSize: 11
        font.bold: true
        opacity: visible ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    // ── now playing strip (right side of bar) ──
    // shifts left when player window is open to avoid overlap
    RowLayout {
        anchors {
            right: dateWidget.left
            rightMargin: 12
            verticalCenter: parent.verticalCenter
        }
        spacing: 6
        visible: Player.PlayerState.currentTitle !== ""

        // animated eq bars
        Row {
            spacing: 2
            visible: Player.PlayerState.playing
            Repeater {
                model: 3
                Rectangle {
                    width: 2
                    color: "#724e7c"
                    radius: 1
                    property real phase: index * 0.8
                    height: 6 + 6 * Math.abs(Math.sin(Date.now() / 300 + phase))
                    NumberAnimation on height {
                        from: 4; to: 14
                        duration: 400 + index * 120
                        loops: Animation.Infinite
                        running: Player.PlayerState.playing
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }

        Text {
            text: Player.PlayerState.playing ? "▶" : "⏸"
            color: "#724e7c"
            font.pixelSize: 9
            visible: !Player.PlayerState.playing
        }

        Text {
            text: Player.PlayerState.currentTitle
            color: "#aaa"
            font.pixelSize: 10
            font.family: "monospace"
            elide: Text.ElideRight
            maximumLineCount: 1
            // avoid overlapping with player window (shifts to the left of workspace area)
        }
    }

    DateWidget {
        id: dateWidget
        anchors {
            right: parent.right
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }
    }
}
