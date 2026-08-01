// Player.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "."

PanelWindow {
    id: playerWindow

    property bool playerVisible: false
    property bool fullImageMode: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: playerVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    anchors { left: true; right: true; top: true; bottom: true }
    color: "transparent"
    visible: playerVisible

    Rectangle {
        anchors.fill: parent; color: "#88000000"
        opacity: playerWindow.playerVisible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (fullImageMode) { fullImageMode = false; return }
                playerWindow.playerVisible = false
            }
        }
    }

    Rectangle {
        anchors.fill: parent; color: "#000"; visible: fullImageMode; z: 20
        Image {
            anchors.fill: parent; anchors.margins: 60
            source: PlayerState.currentThumbnail; fillMode: Image.PreserveAspectFit
        }
        Text { anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 32 }
               text: "shift+f / click to close"; color: "#444"; font.pixelSize: 11; font.family: "monospace" }
        MouseArea { anchors.fill: parent; onClicked: fullImageMode = false }
    }

    Rectangle {
        id: panel
        width: Settings.panelWidth; height: Settings.panelHeight
        anchors.centerIn: parent; visible: !fullImageMode
        color: "#0d0d0d"; radius: 12; clip: true
        border.color: "#2a1f2e"; border.width: 1
        scale:   playerWindow.playerVisible ? 1.0 : 0.94
        opacity: playerWindow.playerVisible ? 1.0 : 0.0
        Behavior on scale   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 180 } }

        ColumnLayout {
            anchors.fill: parent; spacing: 0

            ThumbStrip        { Layout.fillWidth: true; height: 100; playerWindowRef: playerWindow }
            TrackInfo         { Layout.fillWidth: true; height: 52 }
            ControlsBar       { Layout.fillWidth: true; height: 40 }
            Rectangle         { Layout.fillWidth: true; Layout.leftMargin: 16; Layout.rightMargin: 16; height: 1; color: "#181818" }
            PlayerTabBar      { Layout.fillWidth: true; height: 34 }
            PlayerTrackList   { Layout.fillWidth: true; Layout.fillHeight: true; Layout.topMargin: 2 }
            StatusBar         { id: statusBar; Layout.fillWidth: true; height: 24 }
        }

        // ── стандартные оверлеи ──────────────────────────
        PlaylistPickerOverlay  { anchors.fill: parent; visible: PlayerState.playlistOverlayVisible; z: 10 }
        KeybindsOverlay        { anchors.fill: parent; visible: PlayerState.keybindsVisible;        z: 10 }
        CreatePlaylistOverlay  { id: createPlOverlay; anchors.fill: parent; visible: PlayerState.createPlaylistVisible; z: 11 }
        DeleteConfirmOverlay   { anchors.fill: parent; visible: PlayerState.confirmDeleteVisible;   z: 11 }
        SettingsOverlay        { anchors.fill: parent; visible: Settings.settingsVisible;            z: 12 }

        // ── поисковые / фильтровые оверлеи ───────────────

        // YtSearchBar — прикреплён к верху, поверх списка
        Rectangle {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            // отступ сверху: ThumbStrip(100) + TrackInfo(52) + ControlsBar(40) + divider(1) + TabBar(34) = 227
            anchors.topMargin: 227
            height: PlayerState.mode === 2 ? 46 : 0
            visible: height > 0
            color: "#0d0d0d"
            z: 15
            clip: true
            Behavior on height { NumberAnimation { duration: 150 } }

            YtSearchBar {
                id: ytBar
                anchors { fill: parent; topMargin: 6; bottomMargin: 6; leftMargin: 12; rightMargin: 12 }
                onReturnFocusRequested: keybindFocusCatcher.forceActiveFocus()
            }
        }

        // FilterBar — прикреплён над StatusBar
        Rectangle {
            anchors { bottom: parent.bottom; bottomMargin: 24; left: parent.left; right: parent.right }
            height: PlayerState.filterActive ? 42 : 0
            visible: height > 0
            color: "#0d0d0d"
            z: 15
            clip: true
            Behavior on height { NumberAnimation { duration: 150 } }

            FilterBar {
                id: filterBar
                anchors { fill: parent; topMargin: 5; bottomMargin: 5; leftMargin: 12; rightMargin: 12 }
            }
        }

        // GotoOverlay — над StatusBar
        GotoOverlay {
            id: gotoOverlay
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right
                      margins: 12; bottomMargin: 32 }
            height: PlayerState.gotoActive ? 36 : 0
            visible: height > 0
            z: 15
            Behavior on height { NumberAnimation { duration: 150 } }
        }

        // ─────────────────────────────────────────────────

        KeybindHandler { id: keybindHandler }

        Item {
            id: keybindFocusCatcher
            anchors.fill: parent
            focus: true
            Keys.forwardTo: [keybindHandler]
        }
    }

    Connections {
        target: playerWindow
        function onPlayerVisibleChanged() {
            if (playerWindow.playerVisible) focusTimer.restart()
        }
    }
    Connections {
        target: PlayerState
        function onModeChanged() { Qt.callLater(playerWindow.autoFocus) }
    }

    Timer {
        id: focusTimer
        interval: 50
        repeat: false
        onTriggered: playerWindow.autoFocus()
    }

    function autoFocus()     { if (PlayerState.mode === 2) focusYtInput(); else keybindFocusCatcher.forceActiveFocus() }
    function focusYtInput()  { ytBar.inputItem.forceActiveFocus() }
    function focusFilter()   { filterBar.inputItem.forceActiveFocus() }
    function focusGoto()     { gotoOverlay.inputItem.forceActiveFocus() }
    function focusCreatePl() { createPlOverlay.inputItem.forceActiveFocus() }
    function returnFocus()   { keybindFocusCatcher.forceActiveFocus() }

    Component.onCompleted: { PlayerState.playerWindowRef = playerWindow }
}
