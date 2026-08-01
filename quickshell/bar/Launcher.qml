import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: launcher

    property bool shown: false
    property var suggestions: []
    property int selectedIndex: 0

    function show() {
        shown = true
        searchInput.text = ""
        searchInput.forceActiveFocus()
    }
    function hide() { shown = false }
    function toggle() { if (shown) hide(); else show() }

    visible: shown

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors { top: true; left: true; right: true; bottom: true }
    color: "transparent"

    MouseArea {
        anchors.fill: parent
        onClicked: launcher.hide()
    }

    readonly property var apps: [
        { name: "Telegram",       cmd: "Telegram",                                    icon: "TG", class: "org.telegram.desktop" },
        { name: "Firefox",        cmd: "firefox",                                     icon: "FF", class: "firefox" },
        { name: "Steam",          cmd: "steam",                                       icon: "ST", class: "steam" },
        { name: "Discord",        cmd: "discord",                                     icon: "DC", class: "discord" },
        { name: "Obsidian",       cmd: "obsidian",                                    icon: "OB", class: "obsidian" },
        { name: "Tor",            cmd: "dex ~/tor-browser/start-tor-browser.desktop", icon: "TR", class: "Tor Browser" },
        { name: "Mumble",         cmd: "mumble",                                      icon: "MB", class: "mumble" },
        //{ name: "Factorio",       cmd: "steam -applaunch 427520",                     icon: "FC", class: "factorio" },
        //{ name: "Dota 2",         cmd: "steam -applaunch 570",                        icon: "D2", class: "dota2" },
        //{ name: "Quake",          cmd: "steam -applaunch 2310",                       icon: "QU", class: "quake" },
        //{ name: "Quake Live",     cmd: "steam -applaunch 282440",                     icon: "QL", class: "quakelive" },
        //{ name: "Abiotic Factor", cmd: "steam -applaunch 427410",                     icon: "AF", class: "abioticfactor" },
    ]

    readonly property string mode: {
        var t = searchInput.text
        if (t.startsWith("@w ")) return "workspace"
        if (t.startsWith("@b ")) return "bind"
        if (t.startsWith("@")) return "system"
        if (t.startsWith("f ")) return "folder"
        if (t.startsWith("d ")) return "dragon"
        return "apps"
    }

    readonly property string query: {
        var t = searchInput.text
        if (mode === "workspace") return t.slice(3)
        if (mode === "bind") return t.slice(3)
        if (mode === "system") return t.slice(1)
        if (mode === "folder" || mode === "dragon") return t.slice(2)
        return t
    }

    readonly property var filteredApps: {
        if (mode !== "apps") return []
        var q = query.toLowerCase()
        if (q === "") return apps
        return apps.filter(function(a) { return a.name.toLowerCase().includes(q) })
    }

    onQueryChanged: {
        selectedIndex = 0
        updateSuggestions()
    }

    onModeChanged: {
        suggestions = []
        selectedIndex = 0
        if (mode === "folder") {
            runSearch("ls -d ~/*/ 2>/dev/null | head -20")
        } else if (mode === "dragon") {
            runSearch("ls ~/ 2>/dev/null | awk '{print \"~/\" $0}' | head -20")
        } else if (mode === "system") {
            loadDesktopApps("")
        } else if (mode === "workspace" || mode === "bind") {
            suggestions = apps.map(function(a) {
                return a.name + " | " + a.class + " | " + a.cmd
            })
        }
    }

    Process {
        id: searchProc
        property string output: ""
        stdout: SplitParser {
            onRead: function(line) { searchProc.output += line + "\n" }
        }
        onRunningChanged: {
            if (!running) {
                var lines = searchProc.output.trim().split("\n").filter(function(l) { return l.trim() !== "" })
                launcher.suggestions = lines.slice(0, 20)
                searchProc.output = ""
            }
        }
    }

    Process {
        id: desktopProc
        property string output: ""
        stdout: SplitParser {
            onRead: function(line) { desktopProc.output += line + "\n" }
        }
        onRunningChanged: {
            if (!running) {
                var lines = desktopProc.output.trim().split("\n").filter(function(l) { return l.trim() !== "" })
                launcher.suggestions = lines.slice(0, 30)
                desktopProc.output = ""
            }
        }
    }

    Process {
        id: proc
        command: ["bash", "-c", "echo"]
    }

    Process {
        id: confWriter
        command: ["bash", "-c", "echo"]
    }

    function runSearch(cmd) {
        searchProc.output = ""
        searchProc.command = ["bash", "-c", cmd]
        searchProc.running = false
        searchProc.running = true
    }

    function loadDesktopApps(filter) {
        var cmd = "find /usr/share/applications ~/.local/share/applications -name '*.desktop' 2>/dev/null | " +
                  "while read f; do " +
                  "  name=$(grep '^Name=' \"$f\" | head -1 | sed 's/^Name=//'); " +
                  "  [ -n \"$name\" ] && echo \"$name|$f\"; " +
                  "done | sort -u"
        if (filter !== "") {
            cmd += " | grep -i '" + filter + "'"
        }
        cmd += " | head -30"
        desktopProc.output = ""
        desktopProc.command = ["bash", "-c", cmd]
        desktopProc.running = false
        desktopProc.running = true
    }

    function updateSuggestions() {
        var q = query
        if (mode === "folder") {
            if (q === "") {
                runSearch("ls -d ~/*/ 2>/dev/null | head -20")
            } else if (q.startsWith("/")) {
                runSearch("compgen -d -- '" + q + "' 2>/dev/null | head -20")
            } else {
                runSearch("compgen -d -- ~/" + q + " 2>/dev/null | head -20")
            }
        } else if (mode === "dragon") {
            if (q === "") {
                runSearch("ls ~/ 2>/dev/null | awk '{print \"~/\" $0}' | head -20")
            } else if (q.startsWith("/")) {
                runSearch("compgen -f -- '" + q + "' 2>/dev/null | head -20")
            } else {
                runSearch("compgen -f -- ~/" + q + " 2>/dev/null | head -20")
            }
        } else if (mode === "system") {
            loadDesktopApps(q)
        } else if (mode === "workspace" || mode === "bind") {
            var q2 = q.trim().toLowerCase()
	   
	    var filtered = apps.filter(function(a) {
                return q2 === "" ||
                    a.name.toLowerCase().includes(q2) ||
                    a.class.toLowerCase().includes(q2)
            })
	  
	    if (filtered.length > 0) {
                suggestions = filtered.map(function(a) {
                    return a.name + " | " + a.class + " | " + a.cmd
                })
            } else {
                loadDesktopApps(q2)
            }
        }
    }

    function runCmd(cmd) {
        proc.command = ["bash", "-c", "setsid nohup " + cmd + " &>/dev/null &"]
        proc.running = false
        proc.running = true
    }

    function runConf(cmd) {
        confWriter.command = ["bash", "-c", cmd]
        confWriter.running = false
        confWriter.running = true
    }

    function launch(app) { runCmd(app.cmd); launcher.hide() }
    function launchCmd(cmd) { runCmd(cmd); launcher.hide() }

    function launchDesktopFile(path) {
        var desktopName = path.replace(/.*\//, "").replace(/\.desktop$/, "")
        var cmd = "gtk-launch '" + desktopName + "'"
        launchCmd(cmd)
    }

    function applySuggestion(text) {
        if (mode === "folder") {
            var clean = text.replace(/\/$/, "")
            searchInput.text = "f " + clean + "/"
            searchInput.cursorPosition = searchInput.text.length
            runSearch("compgen -d -- '" + clean + "/' 2>/dev/null | head -20")
        } else if (mode === "dragon") {
            searchInput.text = "d " + text
            searchInput.cursorPosition = searchInput.text.length
            suggestions = []
        }
        selectedIndex = 0
    }

    function addWindowRule(cls, ws) {
        var rule = "windowrule = workspace " + ws + " silent, match:class " + cls
        runConf("printf '\\n# added by launcher\\n" + rule + "\\n' >> ~/.config/hypr/hyprland.conf")
        launcher.hide()
    }

    function addBind(key, cmd) {
        var line = "bind = SUPER, " + key + ", exec, " + cmd
        runConf("printf '\\n# added by launcher\\n" + line + "\\n' >> ~/.config/hypr/hyprland.conf")
        launcher.hide()
    }

    function handleEnter() {
        var q = launcher.query.trim()

        if (mode === "apps") {
            if (filteredApps.length > 0)
                launch(filteredApps[selectedIndex])
            return
        }

        if (mode === "folder") {
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                applySuggestion(suggestions[selectedIndex])
            } else {
                launchCmd("thunar '" + q + "'")
            }
            return
        }

        if (mode === "dragon") {
            var sel = suggestions.length > 0 ? suggestions[selectedIndex] : q
            launchCmd("ripdrag '" + sel + "'")
            return
        }

        if (mode === "system") {
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                var parts = suggestions[selectedIndex].split("|")
                if (parts.length >= 2) {
                    launchDesktopFile(parts[1].trim())
                } else {
                    launchCmd(q)
                }
            } else {
                launchCmd(q)
            }
            return
        }

        if (mode === "workspace") {
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                var parts2 = suggestions[selectedIndex].split(" | ")
                var cls = parts2.length > 1 ? parts2[1] : parts2[0].toLowerCase()
                // Смотрим есть ли уже номер ws в запросе
                var words = q.trim().split(/\s+/)
                var ws = words[words.length - 1]
                if (words.length >= 2 && !isNaN(parseInt(ws))) {
                    addWindowRule(cls, ws)
                } else {
                    // Вставляем класс — ждём номер ws
                    searchInput.text = "@w " + cls + " "
                    searchInput.cursorPosition = searchInput.text.length
                    suggestions = []
                }
            } else {
                var p = q.trim().split(/\s+/)
                if (p.length >= 2) addWindowRule(p[0], p[1])
            }
            return
        }

        if (mode === "bind") {
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                var parts3 = suggestions[selectedIndex].split(" | ")
                var appCmd = parts3.length > 2 ? parts3[2] : parts3[0]
                var words2 = q.trim().split(/\s+/)
                var key = words2[0]
                if (words2.length >= 2) {
                    addBind(key, appCmd)
                } else {
                    // Вставляем команду — ждём клавишу
                    searchInput.text = "@b " + appCmd + " "
                    searchInput.cursorPosition = searchInput.text.length
                    suggestions = []
                }
            } else {
                var sp = q.indexOf(" ")
                if (sp > 0) addBind(q.slice(0, sp), q.slice(sp + 1))
            }
            return
        }
    }

    Rectangle {
        id: box
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.25

        width: 540
        height: Math.min(column.implicitHeight + 16, launcher.height * 0.65)
        color: "#241f31"
        border.color: "#724e7c"
        border.width: 1
        radius: 4
        clip: true

        MouseArea { anchors.fill: parent }

        ColumnLayout {
            id: column
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 8
            }
            spacing: 4

            Text {
                visible: launcher.mode !== "apps"
                text: {
                    switch(launcher.mode) {
                        case "system":    return "@ — Все приложения системы (Enter = запустить)"
                        case "folder":    return "f — Папки  (Tab/Enter = войти,  Enter на пустом = открыть в Thunar)"
                        case "dragon":    return "d — Файлы и папки  (Enter = dragon-drop)"
                        case "workspace": return "@w — Выбери приложение → Enter → введи номер ws → Enter"
                        case "bind":      return "@b — Выбери приложение → Enter → введи клавишу → Enter"
                        default: return ""
                    }
                }
                color: "#724e7c"
                font.pixelSize: 10
                font.bold: true
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 32
                color: "#1a1525"
                border.color: "#724e7c"
                border.width: 1
                radius: 2

                TextInput {
                    id: searchInput
                    anchors {
                        left: parent.left; right: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 8; rightMargin: 8
                    }
                    color: "#f0e6f5"
                    font.pixelSize: 13
                    font.bold: true
                    selectionColor: "#724e7c"

                    Text {
                        anchors.fill: parent
                        text: "apps  @system  f /path  d /file  @w class ws  @b Key cmd"
                        color: "#4a3d52"
                        font.pixelSize: 11
                        visible: searchInput.text === ""
                        verticalAlignment: Text.AlignVCenter
                    }

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Escape) {
                            if (launcher.suggestions.length > 0) launcher.suggestions = []
                            else launcher.hide()
                        } else if (event.key === Qt.Key_Return) {
                            handleEnter()
                        } else if (event.key === Qt.Key_Down) {
                            var max = (launcher.suggestions.length > 0
                                ? launcher.suggestions.length
                                : launcher.filteredApps.length) - 1
                            if (launcher.selectedIndex < max) launcher.selectedIndex++
                        } else if (event.key === Qt.Key_Up) {
                            if (launcher.selectedIndex > 0) launcher.selectedIndex--
                        } else if (event.key === Qt.Key_Tab) {
                            if (launcher.suggestions.length > 0)
                                applySuggestion(launcher.suggestions[launcher.selectedIndex])
                            event.accepted = true
                        }
                    }
                }
            }

            Repeater {
                model: launcher.mode === "apps" ? launcher.filteredApps : []
                Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    color: index === launcher.selectedIndex ? "#3a2d4a" : "transparent"
                    border.color: index === launcher.selectedIndex ? "#724e7c" : "transparent"
                    border.width: 1; radius: 2

                    RowLayout {
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 8 }
                        spacing: 8
                        Text {
                            text: modelData.icon
                            color: index === launcher.selectedIndex ? "#724e7c" : "#9b8aa3"
                            font.pixelSize: 11; font.bold: true; font.family: "monospace"
                        }
                        Text {
                            text: modelData.name
                            color: index === launcher.selectedIndex ? "#f0e6f5" : "#9b8aa3"
                            font.pixelSize: 12; font.bold: index === launcher.selectedIndex
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: modelData.cmd
                            color: "#4a3d52"; font.pixelSize: 10
                            elide: Text.ElideRight; Layout.maximumWidth: 200
                        }
                    }
                    MouseArea { anchors.fill: parent; onClicked: launcher.launch(modelData) }
                }
            }

            Repeater {
                model: launcher.mode !== "apps" ? launcher.suggestions : []
                Rectangle {
                    Layout.fillWidth: true
                    height: 26
                    color: index === launcher.selectedIndex ? "#3a2d4a" : "transparent"
                    border.color: index === launcher.selectedIndex ? "#724e7c" : "transparent"
                    border.width: 1; radius: 2

                    RowLayout {
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: 8 }
                        spacing: 8

                        Text {
                            text: {
                                if (launcher.mode === "folder") return "▸"
                                if (launcher.mode === "dragon") return modelData.endsWith("/") ? "▸" : "f"
                                return "▸"
                            }
                            font.pixelSize: 10
                            color: index === launcher.selectedIndex ? "#724e7c" : "#4a3d52"
                        }

                        Text {
                            text: {
                                if (launcher.mode === "system") return modelData.split("|")[0].trim()
                                if (launcher.mode === "workspace" || launcher.mode === "bind") {
                                    var p = modelData.split(" | ")
                                    return p[0] + (p[1] ? "  [" + p[1] + "]" : "")
                                }
                                return modelData
                            }
                            color: index === launcher.selectedIndex ? "#f0e6f5" : "#9b8aa3"
                            font.pixelSize: 11
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            launcher.selectedIndex = index
                            if (launcher.mode === "folder" || launcher.mode === "dragon") {
                                applySuggestion(modelData)
                            } else {
                                handleEnter()
                            }
                        }
                    }
                }
            }

            Text {
                visible: launcher.mode !== "apps"
                text: "↑↓ навигация   Tab автодополнение   Enter выбрать   Esc закрыть"
                color: "#4a3d52"
                font.pixelSize: 9
                Layout.fillWidth: true
            }
        }
    }
}
