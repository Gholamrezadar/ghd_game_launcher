import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme"

ToolButton {
    id: root
    
    // Public properties
    property string iconSource: ""
    property bool isCheckable: false
    property bool isChecked: false
    
    // Signals
    signal buttonClicked()
    signal checkedChanged(bool checked)
    
    // ToolButton properties
    icon.source: iconSource
    icon.color: Theme.iconColor
    icon.height: Theme.iconSizeNormal
    icon.width: Theme.iconSizeNormal
    background: null
    display: AbstractButton.IconOnly
    checkable: isCheckable
    checked: isChecked
    
    onClicked: buttonClicked()
    onCheckedChanged: root.checkedChanged(checked)
    
    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
    
    TapHandler {
        id: tapHandler
    }
    
    // Circle background with hover/press states
    Rectangle {
        id: backgroundCircle
        color: "transparent"
        anchors.fill: parent
        anchors.margins: 1
        radius: Theme.radiusLarge
        
        states: [
            State {
                name: "pressed"
                when: tapHandler.pressed
                PropertyChanges {
                    target: backgroundCircle
                    color: Theme.cardBackgroundLight
                }
            },
            State {
                name: "hovered"
                when: hoverHandler.hovered && !tapHandler.pressed
                PropertyChanges {
                    target: backgroundCircle
                    color: Theme.surfaceColor
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
    }
}
