import QtQuick 6.5
import QtQuick.Controls.Universal
import QtQuick.Layouts
import "../components"

ApplicationWindow {
    width: 620
    height: 620
    minimumWidth: 620 + 16
    visible: true
    title: "Session Viewer"
    color: Theme.backgroundColor

    Rectangle {
        id: root
        anchors.fill: parent
        color: Theme.backgroundColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Header
            Rectangle {
                Layout.fillWidth: true
                height: 60
                color: "transparent"
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15

                    Text {
                        text: gameManager.currentGame
                        font.pixelSize: 24
                        font.bold: false
                        color: "white"
                        Layout.fillWidth: true
                    }

                    Text {
                        text: sessionList.count + " Sessions"
                        font.pixelSize: 20
                        color: "#ecf0f1"
                    }
                }
            }

            // Table header
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: "transparent"
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 20

                    Text {
                        text: "#"
                        font.bold: true
                        color: "gray"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 60
                    }

                    Text {
                        text: "Date & Time"
                        font.bold: true
                        color: "gray"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignLeft
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Duration"
                        font.bold: true
                        color: "gray"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        Layout.preferredWidth: 120
                    }
                }
            }

            // Sessions list
            ListView {
                id: sessionList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 5
                model: gameManager.currentGameSessions

                delegate: SessionCard {
                    width: ListView.view.width
                    sessionId: sessionList.count - index
                    sessionDateTime: modelData["startTime"]
                    durationSeconds: modelData["durationSec"]
                    isOngoing: modelData["isOngoing"]
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                // Empty state
                Rectangle {
                    visible: sessionList.count === 0
                    anchors.centerIn: parent
                    width: 300
                    height: 200
                    color: "transparent"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 20

                        Text {
                            text: "No sessions found"
                            font.pixelSize: 16
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Play this game to record sessions"
                            font.pixelSize: 12
                            color: "gray"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }


        }

        // Helper function to format total time
        function formatTotalTime(seconds) {
            if (!seconds || seconds === 0) return "0 hours"
            var hours = Math.floor(seconds / 3600)
            var minutes = Math.floor((seconds % 3600) / 60)
            if (hours > 0) {
                return hours + " hour" + (hours > 1 ? "s" : "") +
                       (minutes > 0 ? " " + minutes + " min" : "")
            }
            return minutes + " minute" + (minutes > 1 ? "s" : "")
        }

        property int totalPlaytime: 0
        property string lastSessionDate: ""
    }
}
