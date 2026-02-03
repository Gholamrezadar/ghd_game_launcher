import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 1024
    height: 680
    visible: true
    title: "GHD Game Launcher (" + gameManager.games.length + ")"

    Column {
        anchors.fill: parent
        spacing: 8
        padding: 12

        Text {
            text: "Games"
            font.pixelSize: 22
        }

        Repeater {
            model: gameManager.games.length


            Rectangle {
                width: parent.width - 12 * 2
                height: 200
                color: "#2b2b2b"
                radius: 6

                Column {
                    anchors.fill: parent
                    anchors.margins: 8

                    Text {
                        text: gameManager.games[index].name
                        font.bold: true
                        color: "white"
                    }

                    Text {
                        text: "Added: " + gameManager.games[index].dateAdded
                        + " | Last played: " + gameManager.games[index].lastPlayed
                        + " | Playtime: " + gameManager.games[index].playtimeMin
                        + " min ";// + "Poster: " + gameManager.games[index].posterUrl
                        font.pixelSize: 12
                        color: "#cccccc"
                    }

                    Image {
                        id: cover
                        source: "file:///" + gameManager.games[index].posterUrl
                        width: 100
                        height: 150
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        print("launching", gameManager.games[index].name)
                        gameManager.launchGame(index)
                    }
                }
            }
        }
    }
}
