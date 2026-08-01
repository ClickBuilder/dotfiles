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
    property string currentPath: "/"

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
        { name: "Telegram",  cmd: "Telegram",                                    icon: "TG" },
        { name: "Firefox",   cmd: "firefox",                                     icon: "FF" },
        { name: "Kitty",     cmd: "kitty -e bash -c 'fastfetch; exec bash'",     icon: "KT" },
        { name: "Thunar",    cmd: "thunar",                                      icon: "FD" },
        { name: "Steam",     cmd: "steam",                                       icon: "ST" },
        { name: "Discord",   cmd: "discord",                                     icon: "DC" },
        { name: "Obsidian",  cmd: "obsidian",                                    icon: "OB" },
        { name: "Tor",       cmd: "dex ~/tor-browser/start-tor-browser.desktop", icon: "TR" },
        { name: "Spotify",   cmd: "spotify",                                     icon: "SP" },
        { name: "Mumble",    cmd: "mumble",                                      icon: "MB" },
        { name: "Factorio",  cmd: "steam -applaunch 427520",                     icon: "FC" },
        { name: "Dota 2",    cmd: "steam -applaunch 570",                        icon: "D2" },
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
            loadDir(Qt.resolvedUrl("file://" + "/home/" + Qt.application.name).toString(), "~/")
            runSearch("ls -d ~/*/ ~/.[^.]*/  2>/dev/null | sed 's|/home/[^/]*/||' | head -20")
        } else if (mode === "dragon") {
            runSearch("ls ~/ 2>/dev/null | head -20")
        } else if (mode === "system") {
            loadDesktopApps("")
        } else if (mode === "workspace" || mode === "bind") {
            loadDesktopApps("")
        }
    }

    // Основной процесс поиска
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

    // Процесс для .desktop файлов
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
        var cmd = "grep -rh '^Name=' /usr/share/applications ~/.local/share/applications 2>/dev/null"
        if (filter !== "") cmd += " | grep -i '" + filter + "'"
        cmd += " | sed 's/^Name=//' | sort -u | head -30"
        desktopProc.output = ""
        desktopProc.command = ["bash", "-c", cmd]
        desktopProc.running = false
        desktopProc.running = true
    }

    function updateSuggestions() {
        var q = query
        if (mode === "folder") {
            if (q === "" || q === " ") {
                runSearch("ls -d ~/*/ ~/.* 2>/dev/null | head -20")
            } else if (q.startsWith("/")) {
                runSearch("compgen -d -- '" + q + "' 2>/dev/null | head -20")
            } else {
                runSearch("compgen -d -- ~/" + q + " 2>/dev/null | head -20")
            }
        } else if (mode === "dragon") {
            if (q === "" || q === " ") {
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
                return q2 === "" || a.name.toLowerCase().includes(q2) || a.cmd.toLowerCase().includes(q2)
            })
            // Добавляем все .desktop
            loadDesktopApps(q2)
            // Добавляем apps сверху
            var appSuggestions = filtered.map(function(a) { return a.name + " | " + a.cmd })
            suggestions = appSuggestions
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

    function launchDesktop(name) {
        // Находим .desktop файл по имени и запускаем
        var cmd = "f=$(grep -rl '^Name=" + name + "$' /usr/share/applications ~/.local/share/applications 2>/dev/null | head -1); " +
                  "[ -n \"$f\" ] && gtk-launch \"$(basename -s .desktop $f)\" || echo 'not found'"
        launchCmd(cmd)
    }

    function applySuggestion(text) {
        if (mode === "folder") {
            var clean = text.replace(/\/$/, "")
            searchInput.text = "f " + clean + "/"
            searchInput.cursorPosition = searchInput.text.length
            // Загружаем содержимое папки
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
            var path = q
            if (!path.startsWith("/")) path = path.replace("~", "/home/" + Qt.application.name)
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                applySuggestion(suggestions[selectedIndex])
            } else {
                launchCmd("thunar '" + q + "'")
            }
            return
        }

        if (mode === "dragon") {
            var sel = suggestions.length > 0 ? suggestions[selectedIndex] : q
            launchCmd("dragon-drop '" + sel + "'")
            return
        }

        if (mode === "system") {
            var appName = suggestions.length > 0 ? suggestions[selectedIndex] : q
            launchDesktop(appName)
            return
        }

        if (mode === "workspace") {
            // @w discord 4  или выбрать из подсказок
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                var parts = suggestions[selectedIndex].split(" | ")
                var cls = parts[0].toLowerCase()
                var ws = q.split(" ").pop()
                if (ws && !isNaN(ws)) {
                    addWindowRule(cls, ws)
                } else {
                    // Вставляем класс в поле
                    searchInput.text = "@w " + cls + " "
                    searchInput.cursorPosition = searchInput.text.length
                    suggestions = []
                }
            } else {
                var p = q.trim().split(" ")
                if (p.length >= 2) addWindowRule(p[0], p[1])
            }
            return
        }

        if (mode === "bind") {
            // @b F3 Telegram  или выбрать из подсказок
            if (suggestions.length > 0 && selectedIndex < suggestions.length) {
                var parts2 = suggestions[selectedIndex].split(" | ")
                var key = q.split(" ")[0]
                var cmd = parts2.length > 1 ? parts2[1] : parts2[0]
                if (key && key !== "") {
                    addBind(key, cmd)
                } else {
                    searchInput.text = "@b " + q.trim() + " "
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

        width: 520
        height: Math.min(column.implicitHeight + 16, launcher.height * 0.6)
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

            // Режим
            Text {
                visible: launcher.mode !== "apps"
                text: {
                    switch(launcher.mode) {
                        case "system":    return "@ — Все приложения системы"
                        case "folder":    return "f — Папки (Tab = войти, Enter = открыть в Thunar)"
                        case "dragon":    return "d — Файлы и папки (Enter = dragon-drop)"
                        case "workspace": return "@w — windowrule: @w <class> <ws>  (выбери из списка, потом введи номер ws)"
                        case "bind":      return "@b — keybind: @b <Key> <cmd>  (выбери из списка, потом введи клавишу)"
                        default: return ""
                    }
                }
                color: "#724e7c"
                font.pixelSize: 10
                font.bold: true
                Layout.fillWidth: true
            }

            // Поле ввода
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
                            var max = (launcher.suggestions.length > 0 ? launcher.suggestions.length : launcher.filteredApps.length) - 1
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

            // Приложения (режим apps)
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
                        Text { text: modelData.icon; color: index === launcher.selectedIndex ? "#724e7c" : "#9b8aa3"; font.pixelSize: 11; font.bold: true; font.family: "monospace" }
                        Text { text: modelData.name; color: index === launcher.selectedIndex ? "#f0e6f5" : "#9b8aa3"; font.pixelSize: 12; font.bold: index === launcher.selectedIndex }
                        Item { Layout.fillWidth: true }
                        Text { text: modelData.cmd; color: "#4a3d52"; font.pixelSize: 10; elide: Text.ElideRight; Layout.maximumWidth: 200 }
                    }
                    MouseArea { anchors.fill: parent; onClicked: launcher.launch(modelData) }
                }
            }

            // Подсказки (все остальные режимы)
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
                                if (launcher.mode === "folder") return "📁"
                                if (launcher.mode === "dragon") return modelData.endsWith("/") ? "📁" : "📄"
                                if (launcher.mode === "workspace" || launcher.mode === "bind") return "▸"
                                return "▸"
                            }
                            font.pixelSize: 11
                            color: index === launcher.selectedIndex ? "#724e7c" : "#4a3d52"
                        }

                        Text {
                            text: modelData
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

            // Хинт
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

