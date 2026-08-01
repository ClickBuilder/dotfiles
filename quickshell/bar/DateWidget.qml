import QtQuick

Text {
    id: dateText

    readonly property var dayNames: ["ВС", "ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"]

    color: "#9b8aa3"
    font.pixelSize: 11
    font.bold: true

    function update() {
        var d = new Date()
        var day = dayNames[d.getDay()]
        dateText.text = Qt.formatDateTime(d, "MM.dd.yyyy") + "  " + day
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: dateText.update()
    }
    Component.onCompleted: dateText.update()
}
