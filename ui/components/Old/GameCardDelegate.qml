import QtQuick 2.15
import QtQuick.Effects
import "../theme"

Rectangle {
    id: root
    
    // Public properties
    required property var modelData
    
    // Signals
    signal cardClicked(var game)
    
    // Styling
    color: "transparent"
    
    // The actual card
    Rectangle {
        id: card
        color: Theme.cardBackground
        radius: Theme.radiusMedium
        anchors.margins: Theme.spacingMedium
        anchors.fill: parent
        clip: true
        
        // Enable layer for mask effect
        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: maskContainer
        }
        
        // Mask shape
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
        
        // States for hover/press
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
                    opacity: Theme.overlayOpacity
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
                    opacity: Theme.overlayOpacityPressed
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
                    duration: Theme.durationSlow
                    easing.type: Easing.OutQuad
                }
            }
        ]
        
        // Game poster image
        Image {
            id: posterImage
            anchors.fill: parent
            source: root.modelData.posterUrl ? "file:///" + root.modelData.posterUrl : ""
            fillMode: Image.PreserveAspectCrop
            visible: root.modelData.posterUrl !== ""
        }
        
        // Fallback when no poster
        Rectangle {
            anchors.fill: parent
            color: Theme.cardBackgroundDark
            visible: root.modelData.posterUrl === ""
            
            Text {
                anchors.centerIn: parent
                text: root.modelData.name.charAt(0).toUpperCase()
                font.pixelSize: Theme.fontSizeDisplay
                font.bold: true
                color: Theme.textPlaceholder
            }
        }
        
        // Dark overlay (fades in on hover)
        Rectangle {
            id: overlay
            anchors.fill: parent
            color: Theme.overlayDark
            opacity: 0.0
            radius: Theme.radiusMedium
        }
        
        // Game information (fades in on hover)
        Column {
            id: gameInfo
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Theme.paddingMedium
            spacing: Theme.spacingTiny
            opacity: 0.0
            
            // Game name
            Text {
                width: parent.width
                text: root.modelData.name
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.textPrimary
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
            }
            
            // Playtime and date
            Text {
                width: parent.width
                text: root.modelData.playtimeMin + " Minutes  |  Added " + 
                      Qt.formatDate(root.modelData.dateAdded, "M/d/yyyy")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textSecondary
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
            
            onClicked: {
                root.cardClicked(root.modelData)
            }
        }
    }
}
