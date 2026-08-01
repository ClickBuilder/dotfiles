import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "bar"
import "player"

ShellRoot {
    id: root

    Bar        { id: bar }
    Launcher   { id: launcher }
    Browser    { id: browser }
    SystemStats {}

    // ── Music Player ──
    Player {
        id: player
    }

    GlobalShortcut {
        name: "toggleBrowser"
        description: "Toggle Browser"
        onPressed: browser.toggle()
    }

    IpcHandler {
        target: "toggleBar"
        function onCalled() { bar.visible = !bar.visible }
    }
    IpcHandler {
        target: "toggleLauncher"
        function onCalled() { launcher.toggle() }
    }
    IpcHandler {
        target: "toggleBrowser"
        function onCalled() { browser.toggle() }
    }
    IpcHandler {
        target: "togglePlayer"
        function onCalled() { player.playerVisible = !player.playerVisible }
    }
}
