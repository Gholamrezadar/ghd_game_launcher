import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Effects

Rectangle {
    width: ListView.view.width
    height: Theme.listViewCardHeight + Theme.listViewCardBottomMargin + Theme.listViewCardTopMargin
    color: "transparent"

    Rectangle {
        id: listCard
        anchors.fill: parent
        anchors.leftMargin: Theme.listViewCardHorizontalMargin
        anchors.rightMargin: Theme.listViewCardHorizontalMargin
        anchors.bottomMargin: Theme.listViewCardBottomMargin
        anchors.topMargin: Theme.listViewCardTopMargin
        color: Theme.listViewCardColor
        radius: Theme.listViewCardRadius
        border.color: Theme.searchBarBorderColorFocused
        border.width: Theme.searchBarBorderWidth
        state: "default"

        // layer.enabled: true
        // layer.effect: MultiEffect {
        //     shadowEnabled: true
        //     shadowHorizontalOffset: 0
        //     shadowVerticalOffset: Theme.searchBarShadowOffset
        //     shadowBlur: Theme.searchBarShadowBlur
        //     shadowColor: Theme.searchBarShadowColor
        // }

        

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

                // BG Bar 1
                // This bar is a hacky solution to make the right of the image and left of the info box not round!
                // I'm doing this because per corner radius is not supported in QML
                Rectangle {
                    width: Theme.listViewCardRadius
                    height: parent.height
                    color: Theme.listViewCardColor
                    anchors.right: parent.right
                }
            }

            

            // Game info box
            Rectangle {
                id: infobox
                width: parent.width - coverImage.width //  + Theme.listViewCardRadius
                height: parent.height
                // anchors.leftMargin: 300
                x: parent.x-30
                color: Theme.listViewCardColor
                radius: Theme.listViewCardRadius

                // BG Bar 2
                // This bar is a hacky solution to make the right of the image and left of the info box not round!
                // I'm doing this because per corner radius is not supported in QML
                Rectangle {
                    width: Theme.listViewCardRadius
                    height: parent.height
                    color: Theme.listViewCardColor
                    anchors.left: parent.left
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

