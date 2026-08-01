// KeybindHandler.qml
import QtQuick
import "."

Item {
    id: keybindHandler

    property string pendingKey: ""

    Timer {
        id: seqTimer; interval: 600
        onTriggered: pendingKey = ""
    }

    Keys.onPressed: function(event) {
        event.accepted = true
        var k    = event.key
        var txt  = event.text.toLowerCase()
        var ctrl = !!(event.modifiers & Qt.ControlModifier)
        var shift= !!(event.modifiers & Qt.ShiftModifier)

        // ── ESC — закрыть верхний оверлей ──
        if (k === Qt.Key_Escape) {
            if (Settings.settingsVisible)              { Settings.settingsVisible = false; return }
            if (PlayerState.confirmDeleteVisible)       { PlayerState.cancelDelete(); return }
            if (PlayerState.createPlaylistVisible)      { PlayerState.cancelCreatePlaylist(); return }
            if (PlayerState.keybindsVisible)            { PlayerState.keybindsVisible = false; return }
            if (PlayerState.playlistOverlayVisible)     { PlayerState.hidePlaylistPicker(); return }
            if (PlayerState.filterActive)               { PlayerState.filterActive = false; PlayerState.filterText = ""; return }
            if (PlayerState.gotoActive)                 { PlayerState.gotoActive = false; return }
        }

        // ── DELETE CONFIRM: enter = подтвердить ──
        if (PlayerState.confirmDeleteVisible) {
            if (k === Qt.Key_Return || k === Qt.Key_Enter) { PlayerState.confirmDelete(); return }
            event.accepted = false; return
        }

        // ── PLAYLIST OVERLAY ──
        if (PlayerState.playlistOverlayVisible) {
            if (k === Qt.Key_J || k === Qt.Key_Down)       { PlayerState.cursorDown(); return }
            if (k === Qt.Key_K || k === Qt.Key_Up)         { PlayerState.cursorUp();   return }
            if (k === Qt.Key_Return || k === Qt.Key_Enter) { PlayerState.activateCursor(); return }
            if (k >= Qt.Key_1 && k <= Qt.Key_5)           { PlayerState.confirmMoveToPlaylist(k - Qt.Key_1); return }
            if (txt === "u")                               { PlayerState.hidePlaylistPicker(); PlayerState.showCreatePlaylist(true); return }
            return
        }

        // ── CTRL+1-4 mode switch ──
        if (ctrl) {
            var modeMap = { [Qt.Key_1]: 0, [Qt.Key_2]: 1, [Qt.Key_3]: 2, [Qt.Key_4]: 3 }
            if (modeMap[k] !== undefined) {
                PlayerState.closeAllOverlays()
                Settings.settingsVisible = false
                PlayerState.mode = modeMap[k]
                return
            }
        }

        // ── PENDING SEQUENCES ──
        if (pendingKey === "d") {
            seqTimer.stop(); pendingKey = ""
            if (txt === "s") { _ratingFilterCycle(); return }
            if (txt === "t") { PlayerState.gotoActive = true; if (PlayerState.playerWindowRef) PlayerState.playerWindowRef.focusGoto(); return }
            if (PlayerState.mode === 2) { if (PlayerState.playerWindowRef) PlayerState.playerWindowRef.focusYtInput(); return }
        }
        if (pendingKey === "t") {
            seqTimer.stop(); pendingKey = ""
            if (txt === "u") { PlayerState.showCreatePlaylist(true); return }
            PlayerState.showPlaylistPicker(); return
        }

        // ── SEQUENCE STARTERS ──
        if (!ctrl && !shift) {
            if (txt === Settings.binds.focusSearch) {
                if (PlayerState.mode === 2) { if (PlayerState.playerWindowRef) PlayerState.playerWindowRef.focusYtInput(); return }
                pendingKey = "d"; seqTimer.restart(); return
            }
            if (txt === Settings.binds.moveToPlaylist) {
                pendingKey = "t"; seqTimer.restart(); return
            }
        }

        // ── s + 1-5 RATING ──
        if (pendingKey === "s") {
            seqTimer.stop(); pendingKey = ""
            if (k >= Qt.Key_1 && k <= Qt.Key_5) { PlayerState.rateCurrentTrack(k - Qt.Key_0); return }
            if (!shift) PlayerState.toggleShuffle()
            return
        }
        if (txt === "s" && !ctrl && !shift) {
            pendingKey = "s"; seqTimer.restart(); return
        }

        // ── SINGLE BINDS ──
        if (Settings.matches(event, "play"))          { PlayerState.togglePlay();    return }
        if (Settings.matches(event, "next"))          { PlayerState.nextTrack();     return }
        if (Settings.matches(event, "prev"))          { PlayerState.prevTrack();     return }
        if (Settings.matches(event, "loop"))          { PlayerState.toggleLoop();    return }
        if (Settings.matches(event, "mute"))          { PlayerState.toggleMute();    return }
        if (Settings.matches(event, "download"))      { PlayerState.downloadCurrentTrack(); return }
        if (Settings.matches(event, "scan"))          { PlayerState.scanMusicDir();  return }
        if (Settings.matches(event, "screenshot"))    { PlayerState.takeScreenshot(); return }
        if (Settings.matches(event, "deleteTrack"))   { PlayerState.requestDeleteCurrent(); return }

        if (Settings.matches(event, "settings")) {
            Settings.settingsVisible    = !Settings.settingsVisible
            PlayerState.keybindsVisible = false
            return
        }

        if (Settings.matches(event, "filter")) {
            PlayerState.filterActive = !PlayerState.filterActive
            if (PlayerState.filterActive && PlayerState.playerWindowRef) PlayerState.playerWindowRef.focusFilter()
            return
        }

        if (Settings.matches(event, "fullscreenThumb")) {
            if (PlayerState.playerWindowRef) PlayerState.playerWindowRef.fullImageMode = !PlayerState.playerWindowRef.fullImageMode
            return
        }

        if (Settings.matches(event, "help")) {
            PlayerState.keybindsVisible = !PlayerState.keybindsVisible
            Settings.settingsVisible    = false
            return
        }

        if (Settings.matches(event, "createPlaylist")) {
            PlayerState.showCreatePlaylist(false); return
        }

        // seek
        if (Settings.matches(event, "seekBack60")) { PlayerState.seekRelative(-60); return }
        if (Settings.matches(event, "seekFwd60"))  { PlayerState.seekRelative(60);  return }
        if (Settings.matches(event, "seekBack"))   { PlayerState.seekRelative(-10); return }
        if (Settings.matches(event, "seekFwd"))    { PlayerState.seekRelative(10);  return }

        // navigation
        if (k === Qt.Key_J || k === Qt.Key_Down)  { PlayerState.cursorDown(); return }
        if (k === Qt.Key_K || k === Qt.Key_Up)    { PlayerState.cursorUp();   return }
        if (k === Qt.Key_Return || k === Qt.Key_Enter) { PlayerState.activateCursor(); return }

        // volume 1-0
        if (!ctrl && k >= Qt.Key_1 && k <= Qt.Key_9) { PlayerState.setVolume((k - Qt.Key_0) * 0.1); return }
        if (!ctrl && k === Qt.Key_0) { PlayerState.setVolume(1.0); return }

        event.accepted = false
    }

    function _ratingFilterCycle() {
        var r = PlayerState.ratingFilter
        PlayerState.ratingFilter = (r >= 5) ? 0 : r + 1
        PlayerState.statusMessage = PlayerState.ratingFilter === 0
            ? "rating filter off"
            : "filter: ≥ " + PlayerState.ratingFilter + " ★"
    }
}
