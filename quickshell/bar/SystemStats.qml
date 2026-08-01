import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "."

PanelWindow {
    id: statsPanel

    property bool expanded: false
    property int panelHeight: 160

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: 0

    anchors { bottom: true; left: true; right: true }

    implicitHeight: triggerZone.height + (expanded ? panelHeight : 0)
    color: "transparent"

    Behavior on implicitHeight {
        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
    }

    Rectangle {
        id: triggerZone
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 4
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: statsPanel.expanded = true
        }
    }

    Rectangle {
        id: panel
        anchors { bottom: triggerZone.top; left: parent.left; right: parent.right }
        height: statsPanel.panelHeight
        color: "#241f31"
        border.color: "#724e7c"
        border.width: 1
        opacity: statsPanel.expanded ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: 180 }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: statsPanel.expanded = false
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 8

            StatBlock {
                label: "CPU"
                value: statsPanel.cpuPercent
                detail: statsPanel.cpuDetail
                color1: "#724e7c"
            }

            Rectangle { width: 1; height: 80; color: "#2d2640" }

            StatBlock {
                label: "RAM"
                value: statsPanel.ramPercent
                detail: statsPanel.ramDetail
                color1: "#9b5fa0"
            }

            Rectangle { width: 1; height: 80; color: "#2d2640" }

            StatBlock {
                label: "GPU"
                value: statsPanel.gpuPercent
                detail: statsPanel.gpuDetail
                color1: "#b06ab3"
            }

            Rectangle { width: 1; height: 80; color: "#2d2640" }

            StatBlock {
                label: "DISK"
                value: statsPanel.diskPercent
                detail: statsPanel.diskDetail
                color1: "#c47fc5"
            }
        }
    }

    // CPU — процент + частота
    property real cpuPercent: 0
    property string cpuDetail: "0%"

    Process {
        id: cpuProc
        property string output: ""
        command: ["bash", "-c",
            // Процент idle из /proc/stat — точнее чем top
            "read cpu a b c idle rest < /proc/stat; " +
            "sleep 0.3; " +
            "read cpu2 a2 b2 c2 idle2 rest2 < /proc/stat; " +
            "total=$((a2+b2+c2+idle2-a-b-c-idle)); " +
            "used=$((total-(idle2-idle))); " +
            "pct=$((used*100/total)); " +
            // Частота из /proc/cpuinfo (средняя)
            "freq=$(awk '/cpu MHz/{sum+=$4; cnt++} END{printf \"%.1f\", sum/cnt/1000}' /proc/cpuinfo); " +
            "echo \"$pct $freq\""
        ]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(" ")
                if (parts.length >= 2) {
                    statsPanel.cpuPercent = parseFloat(parts[0]) || 0
                    statsPanel.cpuDetail = parts[1] + " GHz"
                }
            }
        }
        onRunningChanged: { if (!running) cpuProc.output = "" }
    }

    Timer {
        id: cpuTimer
        interval: 2000
        running: statsPanel.expanded
        repeat: true
        triggeredOnStart: true
        onTriggered: { cpuProc.running = false; cpuProc.running = true }
    }

    // RAM — процент + использовано/всего GB
    property real ramPercent: 0
    property string ramDetail: "0 GB"

    Process {
        id: ramProc
        command: ["bash", "-c",
            "free -m | awk '/Mem/{printf \"%d %d %d\", $3*100/$2, $3, $2}'"
        ]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(" ")
                if (parts.length >= 3) {
                    statsPanel.ramPercent = parseFloat(parts[0]) || 0
                    var used = (parseFloat(parts[1]) / 1024).toFixed(1)
                    var total = (parseFloat(parts[2]) / 1024).toFixed(1)
                    statsPanel.ramDetail = used + "/" + total + " GB"
                }
            }
        }
        onRunningChanged: {}
    }

    Timer {
        id: ramTimer
        interval: 2000
        running: statsPanel.expanded
        repeat: true
        triggeredOnStart: true
        onTriggered: { ramProc.running = false; ramProc.running = true }
    }

    // GPU — процент + VRAM использовано/всего
    property real gpuPercent: 0
    property string gpuDetail: "N/A"

    Process {
        id: gpuProc
        command: ["bash", "-c",
            "nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total " +
            "--format=csv,noheader,nounits 2>/dev/null | " +
            "awk -F', ' '{printf \"%s %s %s\", $1, $2, $3}' || echo '0 0 0'"
        ]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(" ")
                if (parts.length >= 3) {
                    statsPanel.gpuPercent = parseFloat(parts[0]) || 0
                    var used = (parseFloat(parts[1]) / 1024).toFixed(1)
                    var total = (parseFloat(parts[2]) / 1024).toFixed(1)
                    statsPanel.gpuDetail = used + "/" + total + " GB"
                }
            }
        }
        onRunningChanged: {}
    }

    Timer {
        id: gpuTimer
        interval: 2000
        running: statsPanel.expanded
        repeat: true
        triggeredOnStart: true
        onTriggered: { gpuProc.running = false; gpuProc.running = true }
    }

    // DISK — процент + использовано/всего GB
    property real diskPercent: 0
    property string diskDetail: "0 GB"

    Process {
        id: diskProc
        command: ["bash", "-c",
            "df -BG / | awk 'NR==2{used=$3; total=$2; pct=$5; " +
            "gsub(/G/,\"\",used); gsub(/G/,\"\",total); gsub(/%/,\"\",pct); " +
            "printf \"%s %s %s\", pct, used, total}'"
        ]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(" ")
                if (parts.length >= 3) {
                    statsPanel.diskPercent = parseFloat(parts[0]) || 0
                    statsPanel.diskDetail = parts[1] + "/" + parts[2] + " GB"
                }
            }
        }
        onRunningChanged: {}
    }

    Timer {
        id: diskTimer
        interval: 5000
        running: statsPanel.expanded
        repeat: true
        triggeredOnStart: true
        onTriggered: { diskProc.running = false; diskProc.running = true }
    }
}
