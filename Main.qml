import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects


ApplicationWindow {
    width: 1000
    height: 700
    minimumWidth: 620 + 16
    visible: true
    title: "Filter + Sort Grid"
    // color: "#444"

    Universal.theme: Universal.Dark

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Control Bar (Search + Filter)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            z: 100
            color: "transparent"
            // gradient: Gradient {
            //     GradientStop {
            //         position: 0.0
            //         color: "#444"
            //     }
            //     GradientStop {
            //         position: 0.7
            //         color: "#444"
            //     }
            //     GradientStop {
            //         position: 1.0
            //         color: Qt.rgba(0, 0, 0, 0)
            //     } // transparent black
            // }

            // Black container around the search bar
            Rectangle {
                color: "#222"
                anchors.centerIn: parent
                width: 600
                height: content.implicitHeight + 8
                radius: 1000

                RowLayout {
                    id: content
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 0

                    TextField {
                        placeholderText: "Search ..."
                        Layout.fillHeight: true
                        Layout.fillWidth: true // fillWidth -> take the remaining space horizontally
                        background: null
                        color: "white"
                        placeholderTextColor: "gray"

                        onTextChanged: gameManager.setFilterText(text)
                    }

                    // Add Button
                    ToolButton {
                        // Layout.fillHeight: true // no fillWidth -> width: implicitWidth
                        checked: true
                        icon.name: "list"
                        icon.source: "qrc:/icons/icon_add.svg"
                        icon.color: "#888"
                        background: null
                        display: AbstractButton.IconOnly
                        checkable: true
                        icon.height:18
                        icon.width:18

                        onCheckedChanged: {
                            var component = Qt.createComponent("AddNewWindow.qml");
                            if (component.status === Component.Ready) {
                                var win = component.createObject(null, {
                                    "visible": true
                                });
                                win.show();
                            }
                        }

                        HoverHandler {
                            id: addHoverHandlerId
                            cursorShape: "PointingHandCursor"
                        }

                        TapHandler {
                            id: addTapHandlerId
                        }

                        // Circle around the button
                        Rectangle {
                            id: addRectId
                            color: "transparent"
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 1000

                            states: [
                                State {
                                    name: "pressed"
                                    when: addTapHandlerId.pressed
                                    PropertyChanges {
                                        target: addRectId
                                        color: "#272727"
                                    }
                                },
                                State {
                                    name: "hovered"
                                    when: addHoverHandlerId.hovered && !addTapHandlerId.pressed
                                    PropertyChanges {
                                        target: addRectId
                                        color: "#333"
                                    }
                                }
                            ]
                        }
                    }

                    // Sort Button
                    ToolButton {
                        // Layout.fillHeight: true // no fillWidth -> width: implicitWidth
                        checked: true
                        icon.name: "list"
                        icon.source: "qrc:/icons/icon_sort.svg"
                        icon.color: "#888"
                        background: null
                        display: AbstractButton.IconOnly
                        checkable: true
                        icon.height:18
                        icon.width:18

                        onCheckedChanged: gameManager.setAscending(checked)

                        HoverHandler {
                            id: sortHoverHandlerId
                            cursorShape: "PointingHandCursor"
                        }

                        TapHandler {
                            id: sortTapHandlerId
                        }

                        Rectangle {
                            id: sortRectId
                            color: "transparent"
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 1000

                            states: [
                                State {
                                    name: "pressed"
                                    when: sortTapHandlerId.pressed
                                    PropertyChanges {
                                        target: sortRectId
                                        color: "#272727"
                                    }
                                },
                                State {
                                    name: "hovered"
                                    when: sortHoverHandlerId.hovered && !sortTapHandlerId.pressed
                                    PropertyChanges {
                                        target: sortRectId
                                        color: "#333"
                                    }
                                }
                            ]
                        }
                    }

                    // Grid/List View Button
                    ToolButton {
                        // Layout.fillHeight: true // no fillWidth -> width: implicitWidth
                        icon.name: "list"
                        icon.source: viewLoader.sourceComponent === gridViewComponent ? "qrc:/icons/icon_list_view.svg" : "qrc:/icons/icon_grid_view_outline.svg"
                        icon.color: "#888"
                        background: null
                        display: AbstractButton.IconOnly
                        icon.height:18
                        icon.width:18

                        onClicked: {
                            viewLoader.sourceComponent = (viewLoader.sourceComponent === gridViewComponent) ? listViewComponent : gridViewComponent;
                        }

                        HoverHandler {
                            id: viewHoverHandlerId
                            cursorShape: "PointingHandCursor"
                        }

                        TapHandler {
                            id: viewTapHandlerId
                        }

                        Rectangle {
                            id: viewRectId
                            color: "transparent"
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 1000

                            states: [
                                State {
                                    name: "pressed"
                                    when: viewTapHandlerId.pressed
                                    PropertyChanges {
                                        target: viewRectId
                                        color: "#272727"
                                    }
                                },
                                State {
                                    name: "hovered"
                                    when: viewHoverHandlerId.hovered && !viewTapHandlerId.pressed
                                    PropertyChanges {
                                        target: viewRectId
                                        color: "#333"
                                    }
                                }
                            ]
                        }
                    }
                }
            }
        }

        // Card Grid/List wrapper
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            color: "transparent"

            // Switch between Grid View and List View
            Loader {
                id: viewLoader
                sourceComponent: gridViewComponent
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Grid View Component
            Component {
                id: gridViewComponent

                // Card Grid
                GridView {
                    id: gridId
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: 200
                    cellHeight: 300
                    clip: true

                    model: gameManager.displayGames

                    // center children horizontally
                    property int columns: Math.floor(width / cellWidth)
                    property real rowWidth: columns * cellWidth
                    property real horizontalPadding: Math.max(0, (width - rowWidth) / 2)
                    contentX: -horizontalPadding

                    // Helper function (add this outside the Component, in your main QML file)
                    function formatPlaytime(seconds) {
                        if (seconds === 0)
                            return "Not played";

                        var hours = Math.floor(seconds / 3600);
                        var minutes = Math.floor((seconds % 3600) / 60);

                        if (hours > 0) {
                            return hours + "h " + minutes + "m played";
                        } else {
                            return minutes + "m played";
                        }
                    }

                    // Grid Cell
                    delegate: Rectangle {

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
                                    text: modelData.playtimeMin + " Minutes  |  Played " + Qt.formatDate(modelData.lastPlayed, "M/d/yyyy")
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
                                    console.log("Clicked:", modelData.name);
                                    gameManager.launchGame(modelData.name);
                                }
                            }
                        }
                    }
                }
            }

            // List View Component
            Component {
                id: listViewComponent

                // Card List
                ListView {
                    boundsBehavior: Flickable.StopAtBounds
                    model: gameManager.displayGames
                    clip: true

                    // List View Delegate
                    delegate: Rectangle {
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
                                    PropertyChanges { target: listCard; color: "#2a2a2a" }
                                },
                                State {
                                    name: "hovered"
                                    PropertyChanges { target: listCard; color: "#333333" }
                                    PropertyChanges { target: launchButton; color: "#4a9eff" }
                                },
                                State {
                                    name: "pressed"
                                    PropertyChanges { target: listCard; color: "#3a3a3a" }
                                }
                            ]

                            transitions: [
                                Transition {
                                    from: "*"; to: "*"
                                    ColorAnimation { duration: 150; easing.type: Easing.OutQuad }
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
                                                text: modelData.playtimeMin + " min"
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
                                                text: modelData.lastPlayed.toString() !== ""
                                                      ? "Last played " + Qt.formatDate(modelData.lastPlayed, "MMM d")
                                                      : "Never played"
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
                                        Text {
                                            text: "Added " + Qt.formatDate(modelData.dateAdded, "M/d/yyyy")
                                            font.pixelSize: 13
                                            color: "#aaa"
                                        }
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
                                            PropertyChanges { target: launchButton; color: "#3d8aed" }
                                        },
                                        State {
                                            name: "hovered"
                                            PropertyChanges { target: launchButton; color: "#4a9eff" }
                                        },
                                        State {
                                            name: "pressed"
                                            PropertyChanges { target: launchButton; color: "#2d6abd" }
                                            PropertyChanges { target: launchButton; scale: 0.96 }
                                        }
                                    ]

                                    transitions: [
                                        Transition {
                                            from: "*"; to: "*"
                                            ColorAnimation { duration: 150 }
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
                                            // Launch game logic here
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
                }
            }
        }
    }
}
