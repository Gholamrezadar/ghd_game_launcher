import QtQuick 6.0
import QtQuick.Layouts 6.0

Rectangle {
    id: delegateRoot
    height: 50
    color: sessionId % 2==0 ? mouseArea.containsMouse ? "#1a1a1a" : "#333" : mouseArea.containsMouse ? "#1a1a1a" : "#222"
    border.color: "transparent"
    border.width: 1
    radius: 3

    property int sessionId: 0
    property var sessionDateTime: null
    property int durationSeconds: 0
    property bool isOngoing: false

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20

        // Session ID
        Rectangle {
            width: 60
            height: 30
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: sessionId
                color: "white"
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Date and Time
        Text {
            text: formatDateTime(sessionDateTime)
            font.pixelSize: 13
            color: "white"
            Layout.fillWidth: true
        }

        // Formatted duration
        Rectangle {
            Layout.preferredWidth: 120
            height: 28
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: isOngoing ? "Ongoing" : formatDuration(durationSeconds)
                color: "white"
                font.pixelSize: 13
                // font.bold: true
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            console.log("Session clicked:", sessionId,
                       "Duration:", durationSeconds, "seconds")
        }
    }

    // Helper functions
    function formatDateTime(dateTime) {
        if (!dateTime || dateTime === null) return "N/A"

        var date = new Date(dateTime)
        var day = date.getDate().toString().padStart(2, '0')
        var month = (date.getMonth() + 1).toString().padStart(2, '0')
        var year = date.getFullYear()
        var hours = date.getHours().toString().padStart(2, '0')
        var minutes = date.getMinutes().toString().padStart(2, '0')

        return day + "/" + month + "/" + year + " " + hours + ":" + minutes
    }

    function formatDuration(seconds) {
        if (!seconds || seconds === 0) return " 0h  0m  0s"

        var hours = Math.floor(seconds / 3600)
        var minutes = Math.floor((seconds % 3600) / 60)
        var secs = seconds % 60

        // Pad each unit to fixed width
        var h = String(hours).padStart(2, " ")
        var m = String(minutes).padStart(2, " ")
        var s = String(secs).padStart(2, " ")

        return h + "h " + m + "m " + s + "s"
    }
}
