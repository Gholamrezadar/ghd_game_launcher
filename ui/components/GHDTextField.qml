import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Effects

TextField {
    id: root
    
    // Exposed properties
    property color backgroundColor: "#2c2c2c"
    property color backgroundColorFocused: "#333333"
    property color textColor: "#ffffff"
    property color placeholderColor: "#888888"
    property color borderColor: "#444444"
    property color borderColorFocused: "#3498db"
    property alias radius: backgroundRect.radius
    
    // Default values
    color: textColor
    placeholderTextColor: placeholderColor
    selectByMouse: true
    selectionColor: "#3498db"
    selectedTextColor: "#ffffff"
    
    padding: 12
    leftPadding: 16
    rightPadding: 16
    
    background: Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: root.backgroundColor
        radius: 6
        border.width: 1
        border.color: root.focus ? root.borderColorFocused : root.borderColor
        
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 1
            shadowBlur: 0.2
            shadowColor: "#20000000"
        }
        
        Behavior on border.color {
            ColorAnimation {
                duration: 150
            }
        }
        
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        
        states: [
            State {
                name: "focused"
                when: root.focus
                PropertyChanges {
                    target: backgroundRect
                    color: root.backgroundColorFocused
                }
            }
        ]
    }
}