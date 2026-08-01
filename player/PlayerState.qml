// PlayerState.qml
pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: root

    property var playerWindowRef: null

    property bool   playing:        false
    property bool   muted:          false
    property real   volume:         1.0
    property real   position:       0
    property real   duration:       0
    property bool   loopEnabled:    false
    property bool   shuffleEnabled: false

    property string currentTitle:     ""
    property string currentArtist:    ""
    property string currentThumbnail: ""
    property int    currentRating:    0
    property bool   currentIsYt:      false
    property string currentUrl:       ""

    property int    mode:            0
    property int    listIndex:       0
    property int    cursorIndex:     0
    property var    currentList:     []

    property bool   filterActive:    false
    property string filterText:      ""
    property bool   gotoActive:      false
    property bool   keybindsVisible: false
    property bool   playlistOverlayVisible: false
    property int    playlistPickerIndex: 0
    property string statusMessage:   "ready — press r to scan ~/Music"
    property int    ratingFilter:    0

    // overlays
    property bool   confirmDeleteVisible:     false
    property string confirmDeleteTitle:       ""
    property string confirmDeletePath:        ""
    property bool   createPlaylistVisible:    false
    property bool   createPlaylistAndMoveMode: false

    property var localTracks:  []
    property var playlists:    []
    property var ytHistory:    []
    property var localHistory: []

    // пути берём из Settings — там они настраиваемые
    property string musicDir: Settings.musicDir
    property string metaDir:  Settings.metaDir
    property string dataDir:  "/home/wex/.config/qs-player"

    property bool   downloading:      false
    property string downloadingTitle: ""
    property int    downloadProgress: 0

    // ─── INIT ───────────────────────────────
    Component.onCompleted: {
        mkdirProc.running = true
        Qt.callLater(function() { loadStep(0) })
    }

    Process {
        id: mkdirProc
        command: ["bash", "-c", "mkdir -p '" + root.dataDir + "' '" + root.metaDir + "'"]
        running: false
    }

    // ─── LOAD ───────────────────────────────
    property int    _loadStep: 0
    property string _readBuf:  ""

    function loadStep(step) {
        _loadStep = step
        _readBuf  = ""
        var files = [dataDir + "/library.json",
                     dataDir + "/playlists.json",
                     dataDir + "/history.json"]
        readProc.filePath = files[step]
        readProc.running  = true
    }

    Process {
        id: readProc
        property string filePath: ""
        command: ["bash", "-c", "cat '" + filePath + "' 2>/dev/null || echo 'null'"]
        running: false
        stdout: SplitParser {
            splitMarker: ""
            onRead: function(d) { root._readBuf += d }
        }
        onExited: {
            var raw = root._readBuf.trim()
            root._readBuf = ""
            var parsed = null
            try { if (raw && raw !== "null") parsed = JSON.parse(raw) } catch(e) {}
            if (root._loadStep === 0)      root.localTracks  = parsed || []
            else if (root._loadStep === 1) root.playlists    = parsed || []
            else if (root._loadStep === 2) {
                root.ytHistory    = (parsed && parsed.yt)    || []
                root.localHistory = (parsed && parsed.local) || []
            }
            if (root._loadStep < 2) {
                root.loadStep(root._loadStep + 1)
            } else {
                root.rebuildList()
                root.statusMessage = root.localTracks.length > 0
                    ? root.localTracks.length + " tracks — r to rescan"
                    : "ready — press r to scan ~/Music"
            }
        }
    }

    // ─── SAVE ───────────────────────────────
    Process {
        id: saveProc
        property string filePath: ""
        property string content: ""
        command: ["python3", "-c",
            "import sys; open(sys.argv[1],'w').write(sys.argv[2])",
            filePath, content]
        running: false
    }

    function saveLibrary()   {
        saveProc.filePath = dataDir + "/library.json"
        saveProc.content  = JSON.stringify(localTracks, null, 2)
        saveProc.running  = true
    }
    function savePlaylists() {
        saveProc.filePath = dataDir + "/playlists.json"
        saveProc.content  = JSON.stringify(playlists, null, 2)
        saveProc.running  = true
    }
    function saveHistory()   {
        saveProc.filePath = dataDir + "/history.json"
        saveProc.content  = JSON.stringify({ yt: ytHistory, local: localHistory }, null, 2)
        saveProc.running  = true
    }

    // ─── LIST ───────────────────────────────
    function rebuildList() {
        var list = []
        if (mode === 0) {
            list = localTracks.filter(function(t) {
                if (ratingFilter > 0 && (t.rating || 0) < ratingFilter) return false
                if (filterText && !t.title.toLowerCase().includes(filterText.toLowerCase())) return false
                return true
            })
        } else if (mode === 1) {
            list = playlists.map(function(p) {
                return { title: p.name, isPlaylist: true, tracks: p.tracks }
            })
        } else if (mode === 2) {
            list = ytResults
        } else if (mode === 3) {
            list = ytHistory.slice().reverse()
        }
        currentList = list
    }

    onModeChanged:         { closeAllOverlays(); rebuildList() }
    onFilterTextChanged:   rebuildList()
    onRatingFilterChanged: rebuildList()

    function closeAllOverlays() {
        keybindsVisible        = false
        playlistOverlayVisible = false
        filterActive           = false
        gotoActive             = false
        confirmDeleteVisible   = false
        createPlaylistVisible  = false
    }

    // ─── PLAY ────────────────────────────────
    function playAt(index) {
        if (index < 0 || index >= currentList.length) return
        cursorIndex = index
        listIndex   = index
        var track   = currentList[index]
        if (!track) return

        if (track.isPlaylist) {
            var pl = playlists.find(function(p) { return p.name === track.title })
            if (pl && pl.tracks.length > 0) {
                currentList = pl.tracks
                listIndex = 0; cursorIndex = 0
                playAt(0)
            }
            return
        }

        currentTitle     = track.title     || String(track)
        currentArtist    = track.artist    || ""
        currentThumbnail = track.thumbnail || ""
        currentRating    = track.rating    || 0
        currentIsYt      = !!track.isYt
        currentUrl       = track.url       || track.path || ""

        if (track.isYt) {
            mpvSend(["loadfile", track.url])
            addYtHistory(track)
        } else {
            mpvSend(["loadfile", track.path || String(track)])
        }
        playing = true
        if (!track.isYt) addLocalHistory(track)
        statusMessage = "▶ " + currentTitle
    }

    function nextTrack() {
        if (currentList.length === 0) return
        var next = (shuffleEnabled && !currentIsYt)
            ? Math.floor(Math.random() * currentList.length)
            : (listIndex + 1) % currentList.length
        playAt(next)
    }

    function prevTrack() {
        if (currentList.length === 0) return
        playAt((listIndex - 1 + currentList.length) % currentList.length)
    }

    function togglePlay() {
        if (playing) { mpvSend(["set_property", "pause", true]);  playing = false }
        else         { mpvSend(["set_property", "pause", false]); playing = true  }
    }
    function toggleMute()  { muted = !muted; mpvSend(["set_property", "mute", muted]) }
    function setVolume(v)  {
        volume = Math.max(0, Math.min(1, v))
        mpvSend(["set_property", "volume", Math.round(volume * 100)])
    }
    function toggleLoop()  {
        loopEnabled = !loopEnabled
        mpvSend(["set_property", "loop-file", loopEnabled ? "inf" : "no"])
        statusMessage = loopEnabled ? "↺ loop on" : "loop off"
    }
    function toggleShuffle() {
        shuffleEnabled = !shuffleEnabled
        statusMessage = shuffleEnabled ? "⇄ shuffle on" : "shuffle off"
    }
    function seek(secs)          { mpvSend(["seek", secs,  "absolute"]) }
    function seekRelative(delta) { mpvSend(["seek", delta, "relative"]) }

    // ─── NAVIGATION ─────────────────────────
    function cursorDown() {
        if (playlistOverlayVisible)
            playlistPickerIndex = Math.min(playlistPickerIndex + 1, playlists.length - 1)
        else
            cursorIndex = Math.min(cursorIndex + 1, currentList.length - 1)
    }
    function cursorUp() {
        if (playlistOverlayVisible)
            playlistPickerIndex = Math.max(playlistPickerIndex - 1, 0)
        else
            cursorIndex = Math.max(cursorIndex - 1, 0)
    }
    function activateCursor() {
        if (playlistOverlayVisible) confirmMoveToPlaylist(playlistPickerIndex)
        else playAt(cursorIndex)
    }
    function gotoTrack(index) {
        cursorIndex = Math.max(0, Math.min(index, currentList.length - 1))
    }

    // ─── PLAYLISTS ───────────────────────────
    function createPlaylist(name) {
        var pl = playlists.slice()
        pl.push({ name: name, tracks: [] })
        playlists = pl
        savePlaylists()
        rebuildList()
        statusMessage = "✓ playlist: " + name
    }

    function moveCurrentToPlaylist(plIndex) {
        if (plIndex < 0 || plIndex >= playlists.length) return
        var track = currentList[listIndex]
        if (!track) return
        playlistOverlayVisible = false
        if (track.isYt && !track.path) {
            downloadTrack(track, function(dt) {
                var pl = playlists.slice()
                pl[plIndex].tracks.push(dt)
                playlists = pl
                savePlaylists()
                statusMessage = "✓ moved to " + pl[plIndex].name
            })
        } else {
            var pl = playlists.slice()
            pl[plIndex].tracks.push(JSON.parse(JSON.stringify(track)))
            playlists = pl
            savePlaylists()
            statusMessage = "moved to " + playlists[plIndex].name
        }
    }

    function confirmMoveToPlaylist(index) { moveCurrentToPlaylist(index) }
    function showPlaylistPicker()  { playlistPickerIndex = 0; playlistOverlayVisible = true }
    function hidePlaylistPicker()  { playlistOverlayVisible = false }

    // ─── CREATE PLAYLIST OVERLAY ─────────────
    function showCreatePlaylist(andMove) {
        createPlaylistAndMoveMode = andMove || false
        createPlaylistVisible     = true
    }
    function confirmCreatePlaylist(name) {
        createPlaylistVisible = false
        if (!name || !name.trim()) return
        createPlaylist(name.trim())
        if (createPlaylistAndMoveMode) {
            moveCurrentToPlaylist(playlists.length - 1)
        }
    }
    function cancelCreatePlaylist() { createPlaylistVisible = false }

    // ─── DELETE ──────────────────────────────
    function requestDeleteCurrent() {
        var track = currentList[cursorIndex]
        if (!track || track.isYt || track.isPlaylist) {
            statusMessage = "can only delete local tracks"; return
        }
        confirmDeleteTitle   = track.title
        confirmDeletePath    = track.path
        confirmDeleteVisible = true
    }
    function confirmDelete() {
        confirmDeleteVisible = false
        var path  = confirmDeletePath
        var title = confirmDeleteTitle
        if (!path) return
        localTracks = localTracks.filter(function(t) { return t.path !== path })
        saveLibrary()
        deleteProc.trackPath = path
        deleteProc.running   = true
        if (currentUrl === path) {
            mpvSend(["stop"])
            playing = false
            currentTitle = ""; currentArtist = ""; currentThumbnail = ""
        }
        rebuildList()
        statusMessage = "🗑 deleted: " + title
    }
    function cancelDelete() { confirmDeleteVisible = false }

    Process {
        id: deleteProc
        property string trackPath: ""
        command: ["bash", "-c",
            "rm -f '" + trackPath + "'; " +
            "base=$(basename '" + trackPath + "' | sed 's/\\.[^.]*$//'); " +
            "rm -f '" + root.metaDir + "/$base.jpg' '" + root.metaDir + "/$base.png' " +
            "       '" + root.metaDir + "/$base.webp' '" + root.metaDir + "/$base.info.json'"]
        running: false
    }

    // ─── RATING ──────────────────────────────
    function rateCurrentTrack(stars) {
        if (!currentUrl) return
        currentRating = stars
        var tracks = localTracks.slice()
        for (var i = 0; i < tracks.length; i++) {
            if (tracks[i].path === currentUrl) { tracks[i].rating = stars; break }
        }
        localTracks = tracks
        if (mode === 0) rebuildList()
        saveLibrary()
        statusMessage = "rated: " + "★".repeat(stars) + "☆".repeat(5 - stars)
    }

    // ─── DOWNLOAD ────────────────────────────
    property var _downloadCallback: null

    function downloadCurrentTrack() {
        var track = currentList[listIndex]
        if (!track || !track.isYt) { statusMessage = "not a yt track"; return }
        downloadTrack(track, null)
    }

    function downloadTrack(track, callback) {
        if (downloading) { statusMessage = "already downloading…"; return }
        _downloadCallback = callback || null
        downloading       = true
        downloadingTitle  = track.title
        downloadProgress  = 0
        markerProc.running      = true
        downloadProc.trackUrl   = track.url
        downloadProc.trackTitle = track.title
        downloadProc.running    = true
        statusMessage = "⬇ " + track.title
    }

    Process {
        id: markerProc
        command: ["bash", "-c", "touch /tmp/.qs-dl-marker"]
        running: false
    }

    // ─── YOUTUBE SEARCH ─────────────────────
    property var ytResults: []

    function ytSearch(query) {
        if (!query) return
        ytResults    = []
        currentList  = []
        statusMessage = "searching…"
        ytSearchProc._buf    = ""
        ytSearchProc.query   = query
        ytSearchProc.running = false
        Qt.callLater(function() { ytSearchProc.running = true })
    }

    // ─── HISTORY ─────────────────────────────
    function addYtHistory(track) {
        var hist = ytHistory.filter(function(h) { return h.url !== track.url })
        hist.push({ title: track.title, url: track.url,
                    thumbnail: track.thumbnail || "", duration: track.duration || 0,
                    artist: track.artist || "", isYt: true, watchedAt: Date.now() })
        if (hist.length > 200) hist = hist.slice(-200)
        ytHistory = hist
        saveHistory()
        if (mode === 3) rebuildList()
    }
    function addLocalHistory(track) {
        if (!track || track.isYt) return
        var hist = localHistory.slice()
        hist.push({ title: track.title, path: track.path, playedAt: Date.now() })
        if (hist.length > 500) hist = hist.slice(-500)
        localHistory = hist
        saveHistory()
    }

    function formatTime(secs) {
        if (isNaN(secs) || secs < 0) return "0:00"
        var m = Math.floor(secs / 60), s = Math.floor(secs % 60)
        return m + ":" + (s < 10 ? "0" : "") + s
    }
    function takeScreenshot() { ssProc.running = true; statusMessage = "screenshot saved" }

    // ─── MPV ─────────────────────────────────
    function mpvSend(cmd) {
        mpvSendProc.data    = JSON.stringify({ command: cmd })
        mpvSendProc.running = true
    }

    Timer {
        id: pollTimer
        interval: 500
        repeat: true
        running: root.playing
        onTriggered: {
            mpvPosPollProc.running = true
            mpvEofProc.running = true
        }
    }

    Process {
        id: mpvDaemon
        command: ["mpv", "--no-video", "--idle=yes",
                  "--input-ipc-server=/tmp/qs-player-mpv.sock",
                  "--volume=100",
                  "--volume-max=200",
                  "--replaygain=track",
                  "--replaygain-fallback=+6",
                  "--af=loudnorm=I=-14:TP=-1:LRA=11"]
        running: true
        onExited: Qt.callLater(function() { running = true })
    }

    Process {
        id: mpvSendProc
        property string data: ""
        command: ["bash", "-c",
            "echo " + JSON.stringify(data) + " | socat - /tmp/qs-player-mpv.sock 2>/dev/null"]
        running: false
    }

    Process {
        id: mpvPosPollProc
        property bool _gotPos: false
        command: ["bash", "-c",
            "printf '{\"command\":[\"get_property\",\"time-pos\"]}\\n" +
            "{\"command\":[\"get_property\",\"duration\"]}\\n'" +
            " | socat - /tmp/qs-player-mpv.sock 2>/dev/null"]
        running: false
        stdout: SplitParser {
            onRead: function(line) {
                try {
                    var r = JSON.parse(line)
                    if (typeof r.data === "number") {
                        if (!mpvPosPollProc._gotPos) {
                            root.position = r.data
                            mpvPosPollProc._gotPos = true
                        } else {
                            root.duration = r.data
                            mpvPosPollProc._gotPos = false
                        }
                    }
                } catch(e) {}
            }
        }
        onExited: _gotPos = false
    }

    property bool _eofPending: false

    Process {
        id: mpvEofProc
        property string _buf: ""
        command: ["bash", "-c",
            "printf '{\"command\":[\"get_property\",\"idle-active\"]}\\n'" +
            " | socat - /tmp/qs-player-mpv.sock 2>/dev/null"]
        running: false
        stdout: SplitParser {
            onRead: function(line) {
                try {
                    var r = JSON.parse(line)
                    if (r.data === true && root.playing) {
                        root.playing = false
                        if (!root.loopEnabled) {
                            Qt.callLater(root.nextTrack)
                        } else {
                            Qt.callLater(function() { root.playAt(root.listIndex) })
                        }
                    }
                } catch(e) {}
            }
        }
    }

    // ── PROCESSES ───────────────────────────

    Process {
        id: downloadProc
        property string trackUrl:   ""
        property string trackTitle: ""
        command: ["yt-dlp",
            "--extract-audio",
            "--audio-format", "mp3",
            "--audio-quality", "0",
            "--embed-thumbnail",
            "--add-metadata",
            "--write-thumbnail",
            "--write-info-json",
            // mp3 идёт в ~/Music
            "--output", root.musicDir + "/%(title)s.%(ext)s",
            // обложка и info.json — в папку проекта/meta
            "--output", "thumbnail:" + root.metaDir + "/%(title)s.%(ext)s",
            "--output", "infojson:"  + root.metaDir + "/%(title)s.%(ext)s",
            "--newline",
            trackUrl]
        running: false
        stdout: SplitParser {
            onRead: function(line) {
                var m = line.trim().match(/\[download\]\s+([\d.]+)%/)
                if (m) {
                    root.downloadProgress = Math.round(parseFloat(m[1]))
                    root.statusMessage    = "⬇ " + root.downloadingTitle + " " + root.downloadProgress + "%"
                }
            }
        }
        onExited: function(code) {
            root.downloading      = false
            root.downloadProgress = 0
            if (code === 0) {
                findProc.searchTitle = trackTitle
                findProc.running     = true
            } else {
                root.statusMessage = "⚠ download failed (code " + code + "): " + trackTitle
            }
        }
    }

    // Ищем mp3 в musicDir и обложку/info.json в metaDir по маркеру времени
    Process {
        id: findProc
        property string searchTitle: ""
        property string _buf: ""
        command: ["bash", "-c",
            "mp3=$(find '" + root.musicDir + "' -maxdepth 1 -name '*.mp3' -newer /tmp/.qs-dl-marker 2>/dev/null | head -1); " +
            "thumb=$(find '" + root.metaDir + "' -maxdepth 1 \\( -name '*.jpg' -o -name '*.png' -o -name '*.webp' \\) -newer /tmp/.qs-dl-marker 2>/dev/null | head -1); " +
            "info=$(find '" + root.metaDir + "' -maxdepth 1 -name '*.info.json' -newer /tmp/.qs-dl-marker 2>/dev/null | head -1); " +
            "printf '%s\\n%s\\n%s\\n' \"$mp3\" \"$thumb\" \"$info\""]
        running: false
        stdout: SplitParser {
            splitMarker: ""
            onRead: function(d) { findProc._buf += d }
        }
        onExited: {
            var lines = _buf.trimEnd().split("\n"); _buf = ""
            var mp3Path   = (lines[0] || "").trim()
            var thumbPath = (lines[1] || "").trim()
            var infoPath  = (lines[2] || "").trim()
            if (mp3Path) {
                var track = { title: searchTitle, path: mp3Path,
                              thumbnail: thumbPath,
                              artist: "", rating: 0, isYt: false }
                metaReadProc._buf     = ""
                metaReadProc.infoPath = infoPath || "/dev/null"
                metaReadProc.trackRef = track
                metaReadProc.running  = true
                root.statusMessage = "✓ " + searchTitle
            } else {
                root.statusMessage = "⚠ file not found after download"
            }
        }
    }

    Process {
        id: metaReadProc
        property string infoPath: ""
        property var    trackRef: null
        property string _buf: ""
        command: ["bash", "-c", "cat '" + infoPath + "' 2>/dev/null || echo '{}'"]
        running: false
        stdout: SplitParser {
            splitMarker: ""
            onRead: function(d) { metaReadProc._buf += d }
        }
        onExited: {
            try {
                var info = JSON.parse(_buf)
                if (trackRef) trackRef.artist = info.artist || info.uploader || info.channel || ""
            } catch(e) {}
            _buf = ""
            if (trackRef) {
                root.localTracks = root.localTracks.concat([trackRef])
                root.saveLibrary()
                if (root.mode === 0) root.rebuildList()
                if (root._downloadCallback) { root._downloadCallback(trackRef); root._downloadCallback = null }
            }
            trackRef = null
        }
    }

    Process {
        id: ytSearchProc
        property string query: ""
        property string _buf:  ""
        command: ["bash", "-c",
            "yt-dlp --flat-playlist --dump-single-json 'ytsearch15:" +
            query.replace(/'/g, "") + "'"]
        running: false
        stdout: SplitParser {
            splitMarker: ""
            onRead: function(d) { ytSearchProc._buf += d }
        }
        onExited: {
            try {
                var data = JSON.parse(ytSearchProc._buf)
                var entries = data.entries || [data]
                var results = entries.map(function(e) {
                    return {
                        title:     e.title     || e.id,
                        url:       e.url       || ("https://www.youtube.com/watch?v=" + e.id),
                        thumbnail: e.thumbnail || ("https://i.ytimg.com/vi/" + e.id + "/mqdefault.jpg"),
                        duration:  e.duration  || 0,
                        artist:    e.uploader  || e.channel || "",
                        isYt:      true
                    }
                })
                root.ytResults   = results
                root.currentList = results
                root.statusMessage = results.length + " results"
            } catch(e) { root.statusMessage = "search error: " + e }
            ytSearchProc._buf = ""
        }
    }

    Process {
        id: scanProc
        command: ["bash", "-c",
            "find '" + root.musicDir + "' -maxdepth 1 -type f" +
            " \\( -name '*.mp3' -o -name '*.flac' -o -name '*.opus'" +
            " -o -name '*.ogg' -o -name '*.m4a' -o -name '*.wav' \\)" +
            " | while IFS= read -r f; do" +
            "   title=$(ffprobe -v quiet -show_entries format_tags=title -of default=nw=1:nk=1 \"$f\" 2>/dev/null);" +
            "   [ -z \"$title\" ] && title=$(basename \"$f\" | sed 's/\\.[^.]*$//');" +
            "   artist=$(ffprobe -v quiet -show_entries format_tags=artist -of default=nw=1:nk=1 \"$f\" 2>/dev/null || echo '');" +
            "   dur=$(ffprobe -v quiet -show_entries format=duration -of default=nw=1:nk=1 \"$f\" 2>/dev/null || echo 0);" +
            "   base=$(basename \"$f\" | sed 's/\\.[^.]*$//');" +
            "   thumb='';" +
            "   for ext in jpg png webp; do" +
            "     c=\"" + root.metaDir + "/$base.$ext\";" +
            "     [ -f \"$c\" ] && thumb=\"$c\" && break;" +
            "   done;" +
            "   printf '{\"title\":\"%s\",\"artist\":\"%s\",\"path\":\"%s\",\"duration\":%s,\"thumbnail\":\"%s\"}\\n'" +
            "     \"$(echo \"$title\"  | sed 's/\"/\\\\\"/g')\"" +
            "     \"$(echo \"$artist\" | sed 's/\"/\\\\\"/g')\"" +
            "     \"$f\" \"$dur\" \"$thumb\";" +
            " done"]
        running: false
        stdout: SplitParser {
            onRead: function(line) {
                line = line.trim(); if (!line) return
                try {
                    var t = JSON.parse(line)
                    var exists = root.localTracks.some(function(x) { return x.path === t.path })
                    if (!exists) { t.rating = 0; root.localTracks = root.localTracks.concat([t]) }
                } catch(e) {}
            }
        }
        onExited: {
            root.saveLibrary(); root.rebuildList()
            root.statusMessage = "scan done: " + root.localTracks.length + " tracks"
        }
    }

    function scanMusicDir() { statusMessage = "scanning ~/Music…"; scanProc.running = true }

    Process {
        id: ssProc
        command: ["bash", "-c",
            "mkdir -p ~/Pictures/qs-player && grim ~/Pictures/qs-player/$(date +%Y%m%d_%H%M%S).png"]
        running: false
    }
}
