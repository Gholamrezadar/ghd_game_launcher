import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 1024
    height: 680
    visible: true
    title: "GHD Game Launcher (" + gameManager.displayGames.length + ")"
    palette: 

    Column {
        anchors.fill: parent
        spacing: 8
        padding: 12

        Text {
            text: "Games"
            font.pixelSize: 22

        }

        Button {
            text: "sort"
            onClicked: gameManager.setAscending(false);
        }

        Repeater {
            model: gameManager.displayGames.length


            Rectangle {
                width: parent.width - 12 * 2
                height: 200
                color: "#2b2b2b"
                radius: 6

                Column {
                    anchors.fill: parent
                    anchors.margins: 8

                    Text {
                        text: gameManager.displayGames[index].name
                        font.bold: true
                        color: "white"
                    }

                    Text {
                        text: "Added: " + gameManager.displayGames[index].dateAdded
                        + " | Last played: " + gameManager.displayGames[index].lastPlayed
                        + " | Playtime: " + gameManager.displayGames[index].playtimeMin
                        + " min ";// + "Poster: " + gameManager.games[index].posterUrl
                        font.pixelSize: 12
                        color: "#cccccc"
                    }

                    Image {
                        id: cover
                        source: "file:///" + gameManager.displayGames[index].posterUrl
                        width: 100
                        height: 150
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        print("launching", gameManager.displayGames[index].name)
                        gameManager.launchGame(gameManager.displayGames[index].name)
                    }
                }
            }
        }
    }
}
