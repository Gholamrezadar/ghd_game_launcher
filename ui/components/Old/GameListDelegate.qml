import QtQuick 2.15
import QtQuick.Effects
import "../theme"

Rectangle {
    id: root
    
    // Public properties
    required property var modelData
    
    // Signals
    signal launchClicked(var game)
    signal rowClicked(var game)
    
    // Styling
    width: ListView.view.width
    height: Theme.listItemHeight
    color: "transparent"
    
    Rectangle {
        id: listCard
        anchors.fill: parent
        anchors.margins: Theme.spacingTiny
        color: Theme.surfaceDark
        radius: Theme.radiusMedium
        
        // States for hover/press
        state: "default"
        
        states: [
            State {
                name: "default"
                PropertyChanges { 
                    target: listCard
                    color: Theme.surfaceDark 
                }
            },
            State {
                name: "hovered"
                PropertyChanges { 
                    target: listCard
                    color: Theme.surfaceHover 
                }
                PropertyChanges { 
                    target: launchButton
                    color: Theme.accentHover 
                }
            },
            State {
                name: "pressed"
                PropertyChanges { 
                    target: listCard
                    color: Theme.surfaceLight 
                }
            }
        ]
        
        transitions: [
            Transition {
                from: "*"
                to: "*"
                ColorAnimation { 
                    duration: Theme.durationNormal
                    easing.type: Easing.OutQuad 
                }
            }
        ]
        
        Row {
            anchors.fill: parent
            anchors.margins: Theme.paddingMedium
            spacing: Theme.spacingLarge
            
            // Game poster/thumbnail
            Rectangle {
                width: Theme.listImageSize
                height: Theme.listImageSize
                radius: Theme.radiusSmall
                color: Theme.cardBackgroundDark
                clip: true
                
                Image {
                    anchors.fill: parent
                    source: root.modelData.posterUrl ? "file:///" + root.modelData.posterUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    visible: root.modelData.posterUrl !== ""
                }
                
                // Fallback
                Text {
                    anchors.centerIn: parent
                    text: root.modelData.name.charAt(0).toUpperCase()
                    font.pixelSize: Theme.fontSizeHuge
                    font.bold: true
                    color: Theme.textPlaceholder
                    visible: root.modelData.posterUrl === ""
                }
            }
            
            // Game info (name and metadata)
            Column {
                width: parent.width - Theme.listImageSize - Theme.listButtonWidth - Theme.spacingLarge * 3
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.spacingMedium
                
                // Game name
                Text {
                    width: parent.width
                    text: root.modelData.name
                    font.pixelSize: Theme.fontSizeXLarge
                    font.bold: true
                    color: Theme.textPrimary
                    elide: Text.ElideRight
                }
                
                // Metadata row
                Row {
                    spacing: Theme.spacingLarge
                    
                    // Playtime
                    Row {
                        spacing: Theme.spacingSmall
                        
                        Text {
                            text: "⏱"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.textMuted
                        }
                        Text {
                            text: root.modelData.playtimeMin + " min"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.textTertiary
                        }
                    }
                    
                    // Separator
                    Text {
                        text: "•"
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.textDisabled
                    }
                    
                    // Last played
                    Row {
                        spacing: Theme.spacingSmall
                        
                        Text {
                            text: "📅"
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.textMuted
                        }
                        Text {
                            text: root.modelData.lastPlayed.toString() !== ""
                                  ? "Last played " + Qt.formatDate(root.modelData.lastPlayed, "MMM d")
                                  : "Never played"
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.textTertiary
                        }
                    }
                    
                    // Separator
                    Text {
                        text: "•"
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.textDisabled
                    }
                    
                    // Date added
                    Text {
                        text: "Added " + Qt.formatDate(root.modelData.dateAdded, "M/d/yyyy")
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.textTertiary
                    }
                }
            }
            
            // Spacer
            // Item {
            //     width: 1
            //     Layout.fillWidth: true
            // }
            
            // Launch button
            Rectangle {
                id: launchButton
                width: Theme.listButtonWidth
                height: Theme.listButtonHeight
                radius: Theme.radiusSmall
                color: Theme.accentPrimary
                anchors.verticalCenter: parent.verticalCenter
                
                // Button states
                state: "default"
                
                states: [
                    State {
                        name: "default"
                        PropertyChanges { 
                            target: launchButton
                            color: Theme.accentPrimary 
                        }
                    },
                    State {
                        name: "hovered"
                        PropertyChanges { 
                            target: launchButton
                            color: Theme.accentHover 
                        }
                    },
                    State {
                        name: "pressed"
                        PropertyChanges { 
                            target: launchButton
                            color: Theme.accentPressed 
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
                            duration: Theme.durationNormal 
                        }
                        NumberAnimation {
                            properties: "scale"
                            duration: Theme.durationFast
                            easing.type: Easing.OutQuad
                        }
                    }
                ]
                
                Row {
                    anchors.centerIn: parent
                    spacing: Theme.spacingSmall
                    
                    Text {
                        text: "▶"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textPrimary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: "Launch"
                        font.pixelSize: Theme.fontSizeNormal
                        font.bold: true
                        color: Theme.textPrimary
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
                        root.launchClicked(root.modelData)
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
                root.rowClicked(root.modelData)
            }
        }
    }
}
