import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
    width: ListView.view.width
    height: Theme.listViewCardHeight + Theme.listViewCardBottomMargin + Theme.listViewCardTopMargin
    color: "transparent"

    Rectangle {
        id: card
        anchors.fill: parent
        anchors.leftMargin: Theme.listViewCardHorizontalMargin
        anchors.rightMargin: Theme.listViewCardHorizontalMargin
        anchors.bottomMargin: Theme.listViewCardBottomMargin
        anchors.topMargin: Theme.listViewCardTopMargin
        // color: isHovered? Theme.listViewCardColorHover : Theme.listViewCardColor
        color:"transparent"
        radius: Theme.listViewCardRadius
        border.color: Theme.searchBarBorderColorFocused
        border.width: Theme.searchBarBorderWidth
        state: "default"

        property bool isHovered: cardMouseArea.containsMouse || editButton.hovered || coverImageMouseArea.containsMouse

        Row {
            anchors.fill: parent

            // Game poster
            Rectangle {
                id: coverImage
                width: 200
                height: 300
                color: "#1a1a1a"

                RoundedImage {
                    anchors.fill: parent
                    source: modelData.posterUrl ? "file:///" + modelData.posterUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    visible: modelData.posterUrl !== ""
                    radius: Theme.listViewCardRadius
                }

                MouseArea {
                    id: coverImageMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    z: 55

                    onEntered: card.state = "hovered"
                    onExited: card.state = "default"
                    cursorShape: "PointingHandCursor"

                    onClicked: {
                        console.log("Clicked row:", modelData.name);
                        gameManager.launchGame(modelData.name)
                    }
                }

                // BG Bar 1
                // This bar is a hacky solution to make the right of the image and left of the info box not round!
                // I'm doing this because per corner radius is not supported in QML
                Rectangle {
                    width: Theme.listViewCardRadius
                    height: parent.height
                    color: card.isHovered? Theme.listViewCardColorHover : Theme.listViewCardColor
                    anchors.right: parent.right
                }
            }

            // Game info box
            Rectangle {
                id: infobox
                width: parent.width - coverImage.width //  + Theme.listViewCardRadius
                height: parent.height
                color: card.isHovered? Theme.listViewCardColorHover : Theme.listViewCardColor
                radius: Theme.listViewCardRadius

                // BG Bar 2
                // This bar is a hacky solution to make the right of the image and left of the info box not round!
                // I'm doing this because per corner radius is not supported in QML
                Rectangle {
                    width: Theme.listViewCardRadius
                    height: parent.height
                    color: card.isHovered? Theme.listViewCardColorHover : Theme.listViewCardColor
                    anchors.left: parent.left
                }

                // Edit Button
                GHDToolButton {
                    id: editButton
                    toolTipText: "Edit information"
                    iconSource: "qrc:/icons/icon_edit_2.svg"
                    z: 10000
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: Theme.listViewInfoboxPadding
                    anchors.rightMargin: Theme.listViewInfoboxPadding + Theme.listViewCardRadius
                    iconColor: Theme.toolButtonIconColor
                    iconColorPressed: Theme.toolButtonPressedColor
                    iconColorHovered: Theme.toolButtonHoveredColor

                    onClicked: {
                        var component = Qt.createComponent("../windows/AddGameWindow.qml"); // TODO: change to edit game window
                        if (component.status === Component.Ready) {
                            var win = component.createObject(null, {
                                "visible": true
                            });
                            win.show();
                        }
                    }
                }

                // Game Title and subtitle
                Column {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: Theme.listViewInfoboxPadding
                    anchors.leftMargin: Theme.listViewInfoboxPadding
                    Text {
                        text: modelData.name
                        font.pixelSize: Theme.listViewCardTitleSize
                        font.bold: false
                        color: Theme.listViewCardTitleColor
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                    }
                    Text {
                        text: Utils.formatPlaytime(modelData.totalPlaytimeSec)
                        font.pixelSize: Theme.listViewCardSubtitleSize
                        color: Theme.listViewCardSubtitleColor
                        elide: Text.ElideRight
                    }
                }

                // Extra Game info at the bottom left
                Text {
                    text: gameManager.getGameSessionCount(modelData.name) + " Sessions " + " | " + Utils.formatLastPlayed(modelData.lastPlayed) //+ " | " + Utils.formatDateAdded(modelData.dateAdded)
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.bottomMargin: Theme.listViewInfoboxPadding
                    anchors.leftMargin: Theme.listViewInfoboxPadding
                    color: Theme.listViewCardExtraInfoColor
                    font.pixelSize: 12
                }

                // Extra Game info at the bottom right
                Text {
                    text: Utils.formatDateAdded(modelData.dateAdded)
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: Theme.listViewInfoboxPadding
                    anchors.rightMargin: Theme.listViewInfoboxPadding + Theme.listViewCardRadius
                    color: Theme.listViewCardExtraInfoColor
                    font.pixelSize: 12
                }

                // Card hover detection
                MouseArea {
                    id: cardMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    z: 55

                    onEntered: card.state = "hovered"
                    onExited: card.state = "default"
                    cursorShape: "PointingHandCursor"

                    onClicked: {
                        console.log("Clicked row:", modelData.name);
                        gameManager.launchGame(modelData.name)
                    }
                }
            }
        }
    }
}
