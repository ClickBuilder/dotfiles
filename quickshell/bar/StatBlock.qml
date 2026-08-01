import QtQuick
import QtQuick.Layouts

Item {
    id: block

    property string label: "CPU"
    property real value: 0
    property string unit: "%"
    property string detail: ""
    property color color1: "#724e7c"

    implicitWidth: 90
    implicitHeight: 130

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4

        Item {
            width: 64
            height: 64
            Layout.alignment: Qt.AlignHCenter

            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.beginPath()
                    ctx.arc(width/2, height/2, 26, 0, Math.PI * 2)
                    ctx.strokeStyle = "#2d2640"
                    ctx.lineWidth = 6
                    ctx.stroke()
                }
            }

            Canvas {
                id: progressCircle
                anchors.fill: parent
                property real progress: block.value / 100

                Behavior on progress {
                    NumberAnimation { duration: 600; easing.type: Easing.OutCubic }
                }
                onProgressChanged: requestPaint()
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    if (progress <= 0) return
                    ctx.beginPath()
                    var start = -Math.PI / 2
                    var end = start + progress * Math.PI * 2
                    ctx.arc(width/2, height/2, 26, start, end)
                    ctx.strokeStyle = block.color1
                    ctx.lineWidth = 6
                    ctx.lineCap = "round"
                    ctx.stroke()
                }
            }

            Text {
                anchors.centerIn: parent
                text: Math.round(block.value) + "%"
                color: "#f0e6f5"
                font.pixelSize: 12
                font.bold: true
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: block.label
            color: block.color1
            font.pixelSize: 10
            font.bold: true
            font.letterSpacing: 1.5
        }

        // Реальные цифры usage
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: block.detail
            color: "#9b8aa3"
            font.pixelSize: 10
            font.bold: true
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 64
            height: 2
            radius: 1
            color: "#2d2640"

            Rectangle {
                width: parent.width * (block.value / 100)
                height: parent.height
                radius: 1
                color: block.color1

                Behavior on width {
                    NumberAnimation { duration: 600; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}
