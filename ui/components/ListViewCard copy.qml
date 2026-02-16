import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
    width: ListView.view.width
    height: Theme.listViewCardHeight+Theme.listViewCardVerticalMargin*2
    color: "transparent"

    Rectangle {
        id: listCard
        anchors.fill: parent
        anchors.leftMargin: Theme.listViewCardHorizontalMargin
        anchors.rightMargin: Theme.listViewCardHorizontalMargin
        anchors.bottomMargin: Theme.listViewCardVerticalMargin
        anchors.topMargin: Theme.listViewCardVerticalMargin
        color: Theme.listViewCardColor
        radius: Theme.listViewCardRadius
        border.color: Theme.searchBarBorderColorFocused
        border.width: Theme.searchBarBorderWidth

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowHorizontalOffset: 0
            shadowVerticalOffset: Theme.searchBarShadowOffset
            shadowBlur: Theme.searchBarShadowBlur
            shadowColor: Theme.searchBarShadowColor
        }

        // States for hover/press
        state: "default"

        states: [
            State {
                name: "default"
                PropertyChanges {
                    target: listCard
                    color: Theme.listViewCardColor
                }
            },
            State {
                name: "hovered"
                PropertyChanges {
                    target: listCard
                    color: Theme.listViewCardHoverBackgroundColor
                }
                PropertyChanges {
                    target: launchButton
                    color: "red"
                }
            },
            State {
                name: "pressed"
                PropertyChanges {
                    target: listCard
                    color: Theme.listViewCardColor
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
                width: 200
                height: 300
                radius: Theme.listViewCardRadius
                color: "#1a1a1a"
                clip: true

                RoundedImage {
                    anchors.fill: parent
                    source: modelData.posterUrl ? "file:///" + modelData.posterUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    visible: modelData.posterUrl !== ""
                    radius: Theme.listViewCardRadius
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
                width: parent.width - 200 - 140 - 32 // Remaining space
                anchors.top: parent.top
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
                width: Theme.listViewCardLaunchButtonWidth
                height: Theme.listViewCardLaunchButtonHeight
                radius: Theme.listViewCardLaunchButtonRadius
                color: Theme.listViewCardLaunchButtonColor
                anchors.verticalCenter: parent.verticalCenter
                z:103

                // Button states
                state: "default"

                states: [
                    State {
                        name: "default"
                        PropertyChanges {
                            target: launchButton
                            color: Theme.listViewCardLaunchButtonColor
                        }
                    },
                    State {
                        name: "hovered"
                        PropertyChanges {
                            target: launchButton
                            color: Theme.listViewCardLaunchButtonHoverColor
                        }
                    },
                    State {
                        name: "pressed"
                        PropertyChanges {
                            target: launchButton
                            color: Theme.listViewCardLaunchButtonPressedColor
                        }
                        PropertyChanges {
                            target: launchButton
                            scale: Theme.listViewCardLaunchButtonScale
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
                    z:104
                    cursorShape: Qt.PointingHandCursor

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
            hoverEnabled: false
            propagateComposedEvents: true
            z:55

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
