// Settings.qml
pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property string dataDir: "/home/wex/.config/qs-player"
    property string cfgPath: dataDir + "/settings.json"

    // ── BINDS ──
    property var binds: ({
        play:           "space",
        next:           "n",
        prev:           "b",
        loop:           "l",
        shuffle:        "s",
        mute:           "m",
        download:       "i",
        createPlaylist: "u",
        moveToPlaylist: "t",
        filter:         "f",
        fullscreenThumb:"shift+f",
        screenshot:     "shift+s",
        help:           "e",
        settings:       "o",
        scan:           "r",
        deleteTrack:    "q",
        seekBack:       "left",
        seekFwd:        "right",
        seekBack60:     "shift+left",
        seekFwd60:      "shift+right",
        ratingPrefix:   "shift",
        modeLocal:      "ctrl+1",
        modePlaylists:  "ctrl+2",
        modeYoutube:    "ctrl+3",
        modeHistory:    "ctrl+4",
        gotoTrack:      "dt",
        ratingFilter:   "ds",
        focusSearch:    "d",
    })

    // ── PATHS ──
    property string musicDir: "/home/wex/Music"
    property string metaDir:  "/home/wex/.config/quickshell/player/qs-player/meta"

    // ── UI PREFS ──
    property int    panelWidth:  500
    property int    panelHeight: 700
    property string accentColor: "#724e7c"
    property bool   showArtistInList: true
    property bool   showDuration:     true
    property bool   showThumbnails:   true

    // ── STATE ──
    property bool settingsVisible: false

    // ─── LOAD ───────────────────────────────
    property string _buf: ""

    Component.onCompleted: { readProc.running = true }

    Process {
        id: readProc
        command: ["bash", "-c", "cat '" + root.cfgPath + "' 2>/dev/null || echo 'null'"]
        running: false
        stdout: SplitParser {
            splitMarker: ""
            onRead: function(d) { root._buf += d }
        }
        onExited: {
            try {
                var raw = root._buf.trim(); root._buf = ""
                if (raw && raw !== "null") {
                    var cfg = JSON.parse(raw)
                    if (cfg.binds)       root.binds       = Object.assign({}, root.binds, cfg.binds)
                    if (cfg.panelWidth)  root.panelWidth  = cfg.panelWidth
                    if (cfg.panelHeight) root.panelHeight = cfg.panelHeight
                    if (cfg.accentColor) root.accentColor = cfg.accentColor
                    if (cfg.musicDir)    root.musicDir    = cfg.musicDir
                    if (cfg.metaDir)     root.metaDir     = cfg.metaDir
                    if (cfg.showArtistInList !== undefined) root.showArtistInList = cfg.showArtistInList
                    if (cfg.showDuration     !== undefined) root.showDuration     = cfg.showDuration
                    if (cfg.showThumbnails   !== undefined) root.showThumbnails   = cfg.showThumbnails
                }
            } catch(e) {}
        }
    }

    // ─── SAVE ───────────────────────────────
    function save() {
        var cfg = {
            binds:            binds,
            panelWidth:       panelWidth,
            panelHeight:      panelHeight,
            accentColor:      accentColor,
            musicDir:         musicDir,
            metaDir:          metaDir,
            showArtistInList: showArtistInList,
            showDuration:     showDuration,
            showThumbnails:   showThumbnails,
        }
        saveProc.content = JSON.stringify(cfg, null, 2)
        saveProc.running = true
    }

    Process {
        id: saveProc
        property string content: ""
        command: ["python3", "-c",
            "import sys; open(sys.argv[1],'w').write(sys.argv[2])",
            root.cfgPath, content]
        running: false
    }

    // ─── BIND HELPERS ───────────────────────
    function matches(event, bindName) {
        var bind = binds[bindName]
        if (!bind) return false
        return _matchBind(event, bind)
    }

    function _matchBind(event, bind) {
        var parts  = bind.toLowerCase().split("+")
        var key    = parts[parts.length - 1]
        var shift  = parts.includes("shift")
        var ctrl   = parts.includes("ctrl")
        var alt    = parts.includes("alt")

        var evShift = !!(event.modifiers & Qt.ShiftModifier)
        var evCtrl  = !!(event.modifiers & Qt.ControlModifier)
        var evAlt   = !!(event.modifiers & Qt.AltModifier)

        if (shift !== evShift || ctrl !== evCtrl || alt !== evAlt) return false

        var evText = event.text.toLowerCase()
        var evKey  = _keyName(event.key).toLowerCase()
        return evText === key || evKey === key
    }

    function _keyName(k) {
        var map = {
            [Qt.Key_Space]:     "space",
            [Qt.Key_Left]:      "left",
            [Qt.Key_Right]:     "right",
            [Qt.Key_Up]:        "up",
            [Qt.Key_Down]:      "down",
            [Qt.Key_Return]:    "return",
            [Qt.Key_Enter]:     "enter",
            [Qt.Key_Escape]:    "escape",
            [Qt.Key_Tab]:       "tab",
            [Qt.Key_Delete]:    "delete",
            [Qt.Key_Backspace]: "backspace",
        }
        return map[k] || String.fromCharCode(k).toLowerCase()
    }

    function isSequenceStart(event, bindName) {
        var bind = binds[bindName]
        if (!bind || bind.length < 2) return false
        if (bind.includes("+")) return false
        var first = bind[0].toLowerCase()
        return event.text.toLowerCase() === first && !event.modifiers
    }

    function getSequenceSecond(bindName) {
        var bind = binds[bindName]
        if (!bind || bind.includes("+")) return ""
        return bind[bind.length - 1].toLowerCase()
    }
}
