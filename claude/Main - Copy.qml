import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 600
    height: 400
    visible: true
    title: "Simple Game Launcher"

    Column {
        anchors.fill: parent
        spacing: 8
        padding: 12

        Text {
            text: "Games"
            font.pixelSize: 22
        }

        Repeater {
            model: gameManager.gameNames.length

            Rectangle {
                width: parent.width
                height: 70
                color: "#2b2b2b"
                radius: 6

                Column {
                    anchors.fill: parent
                    anchors.margins: 8

                    Text {
                        text: gameManager.gameNames[index]
                        font.bold: true
                        color: "white"
                    }

                    Text {
                        text:
                            "Added: " + gameManager.gameStats[index].dateAdded +
                            " | Last played: " + gameManager.gameStats[index].lastPlayed +
                            " | Playtime: " + gameManager.gameStats[index].playtimeMin + " min"
                        font.pixelSize: 12
                        color: "#cccccc"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: gameManager.launchGame(index)
                }
            }
        }
    }
}
