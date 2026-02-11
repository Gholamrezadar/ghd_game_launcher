import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
    width: ListView.view.width
    height: 100
    color: "transparent"

    Rectangle {
        id: listCard
        anchors.fill: parent
        anchors.margins: 4
        color: "#2a2a2a"
        radius: 8

        // States for hover/press
        state: "default"

        states: [
            State {
                name: "default"
                PropertyChanges {
                    target: listCard
                    color: "#2a2a2a"
                }
            },
            State {
                name: "hovered"
                PropertyChanges {
                    target: listCard
                    color: "#333333"
                }
                PropertyChanges {
                    target: launchButton
                    color: "#4a9eff"
                }
            },
            State {
                name: "pressed"
                PropertyChanges {
                    target: listCard
                    color: "#3a3a3a"
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "*"
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        ]

        Row {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 16

            // Game poster/image on the left
            Rectangle {
                width: 76
                height: 76
                radius: 6
                color: "#1a1a1a"
                clip: true

                RoundedImage {
                    anchors.fill: parent
                    source: modelData.posterUrl ? "file:///" + modelData.posterUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    visible: modelData.posterUrl !== ""
                    radius: 6
                }

                // Fallback
                Text {
                    anchors.centerIn: parent
                    text: modelData.name.charAt(0).toUpperCase()
                    font.pixelSize: 32
                    font.bold: true
                    color: "#444"
                    visible: modelData.posterUrl === ""
                }
            }

            // Game info (name and metadata)
            Column {
                width: parent.width - 76 - 140 - 32 // Remaining space
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                // Game name
                Text {
                    width: parent.width
                    text: modelData.name
                    font.pixelSize: 18
                    font.bold: true
                    color: "white"
                    elide: Text.ElideRight
                }

                // Metadata row
                Row {
                    spacing: 16

                    // Playtime
                    Row {
                        spacing: 6

                        Text {
                            text: "⏱"
                            font.pixelSize: 12
                            color: "#888"
                        }
                        Text {
                            text: Utils.formatPlaytime(modelData.totalPlaytimeSec)
                            font.pixelSize: 13
                            color: "#aaa"
                        }
                    }

                    // Separator
                    Text {
                        text: "•"
                        font.pixelSize: 13
                        color: "#555"
                    }

                    // Last played
                    Row {
                        spacing: 6

                        Text {
                            text: "📅"
                            font.pixelSize: 12
                            color: "#888"
                        }
                        Text {
                            text: Utils.formatLastPlayed(modelData.lastPlayed)
                            font.pixelSize: 13
                            color: "#aaa"
                        }
                    }

                    // Separator
                    Text {
                        text: "•"
                        font.pixelSize: 13
                        color: "#555"
                    }

                    // Date added
                    // Text {
                    //     text: "Added " + Qt.formatDate(modelData.dateAdded,
                    //                                    "M/d/yyyy")
                    //     font.pixelSize: 13
                    //     color: "#aaa"
                    // }
                }
            }

            // Spacer to push button to the right
            Item {
                width: 1
                Layout.fillWidth: true
            }

            // Launch button
            Rectangle {
                id: launchButton
                width: 120
                height: 40
                radius: 6
                color: "#3d8aed"
                anchors.verticalCenter: parent.verticalCenter

                // Button states
                state: "default"

                states: [
                    State {
                        name: "default"
                        PropertyChanges {
                            target: launchButton
                            color: "#3d8aed"
                        }
                    },
                    State {
                        name: "hovered"
                        PropertyChanges {
                            target: launchButton
                            color: "#4a9eff"
                        }
                    },
                    State {
                        name: "pressed"
                        PropertyChanges {
                            target: launchButton
                            color: "#2d6abd"
                        }
                        PropertyChanges {
                            target: launchButton
                            scale: 0.96
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "*"
                        to: "*"
                        ColorAnimation {
                            duration: 150
                        }
                        NumberAnimation {
                            properties: "scale"
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                ]

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "▶"
                        font.pixelSize: 12
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Launch"
                        font.pixelSize: 14
                        font.bold: true
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: launchButton.state = "hovered"
                    onExited: launchButton.state = "default"
                    onPressed: launchButton.state = "pressed"
                    onReleased: launchButton.state = containsMouse ? "hovered" : "default"

                    onClicked: {
                        console.log("Launch game:", modelData.name)
                        gameManager.launchGame(modelData.name)
                    }
                }
            }
        }

        // Card hover detection
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

            onEntered: listCard.state = "hovered"
            onExited: listCard.state = "default"
            onPressed: mouse.accepted = false // Let button handle clicks

            onClicked: {
                console.log("Clicked row:", modelData.name)
                // Optional: Select/highlight row
            }
        }
    }
}
