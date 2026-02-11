import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../utils"

Rectangle {

    width: gridId.cellWidth
    height: gridId.cellHeight
    color: "transparent"

    // Visible Card
    Rectangle {
        id: card
        color: "#333"
        radius: 8
        anchors.margins: 8
        anchors.fill: parent
        clip: true

        // 1. Enable Layer and MultiEffect
        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: maskContainer
        }

        // 2. Define the Mask Shape
        Item {
            id: maskContainer
            anchors.fill: parent
            visible: false
            Rectangle {
                anchors.fill: parent
                radius: card.radius
                color: "black"
            }
        }

        // States
        state: "default"

        states: [
            State {
                name: "default"
                PropertyChanges {
                    target: overlay
                    opacity: 0.0
                }
                PropertyChanges {
                    target: gameInfo
                    opacity: 0.0
                }
            },
            State {
                name: "hovered"
                PropertyChanges {
                    target: overlay
                    opacity: 0.7
                }
                PropertyChanges {
                    target: gameInfo
                    opacity: 1.0
                }
            },
            State {
                name: "pressed"
                PropertyChanges {
                    target: overlay
                    opacity: 0.8
                }
                PropertyChanges {
                    target: gameInfo
                    opacity: 1.0
                }
                PropertyChanges {
                    target: card
                    scale: 0.98
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                NumberAnimation {
                    properties: "opacity,scale"
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        ]

        // Full screen poster/image (always visible)
        RoundedImage {
            id: posterImage
            anchors.fill: parent
            source: "file:///" + modelData.posterUrl || ""
            fillMode: Image.PreserveAspectCrop
            visible: modelData.posterUrl !== ""
            radius: 8
        }

        // Fallback background when no poster
        Rectangle {
            anchors.fill: parent
            color: "#222"
            visible: modelData.posterUrl === ""

            Text {
                anchors.centerIn: parent
                text: modelData.name.charAt(0).toUpperCase()
                font.pixelSize: 64
                font.bold: true
                color: "#444"
            }
        }

        // Dark overlay (fades in on hover)
        Rectangle {
            id: overlay
            anchors.fill: parent
            color: "#000000"
            opacity: 0.0
            radius: 8
        }

        // Game information at bottom (fades in on hover)
        Column {
            id: gameInfo
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 12
            spacing: 4
            opacity: 0.0

            // Game name (larger font)
            Text {
                width: parent.width
                text: modelData.name
                font.pixelSize: 16
                font.bold: true
                color: "white"
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
            }

            // Playtime and date added (smaller font)
            Text {
                width: parent.width
                // text: modelData.playtimeMin + " Minutes  |  Played " + Qt.formatDate(
                //           modelData.lastPlayed, "M/d/yyyy")
                text: Utils.formatPlaytime(modelData.totalPlaytimeSec) + " | " + Utils.formatLastPlayed(modelData.lastPlayed)
                font.pixelSize: 11
                color: "#ccc"
                elide: Text.ElideRight
            }
        }

        // Mouse interaction
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: card.state = "hovered"
            onExited: card.state = "default"
            onPressed: card.state = "pressed"
            onReleased: card.state = containsMouse ? "hovered" : "default"
            cursorShape: "PointingHandCursor"

            onClicked: {
                // Handle card click - launch game, show details, etc.
                console.log("Clicked:", modelData.name)
                gameManager.launchGame(modelData.name)
            }
        }
    }
}
