import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Effects

Button {
    id: root

    // Exposed properties
    property color backgroundColor: "#3498db"
    property color backgroundColorHovered: "#2980b9"
    property color backgroundColorPressed: "#21618c"
    property color textColor: "#ffffff"
    property alias radius: backgroundRect.radius

    // Default values
    background: null
    contentItem: Text {
        text: root.text
        font: root.font
        color: root.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    padding: 12
    leftPadding: 20
    rightPadding: 20

    HoverHandler {
        id: hoverHandler
        cursorShape: "PointingHandCursor"
    }

    TapHandler {
        id: tapHandler
    }

    Rectangle {
        id: backgroundRect
        color: root.backgroundColor
        anchors.fill: parent
        radius: 4

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 2
            shadowBlur: 0.3
            shadowColor: "#30000000"
        }

        states: [
            State {
                name: "pressed"
                when: tapHandler.pressed
                PropertyChanges {
                    target: backgroundRect
                    color: root.backgroundColorPressed
                }
            },
            State {
                name: "hovered"
                when: hoverHandler.hovered && !tapHandler.pressed
                PropertyChanges {
                    target: backgroundRect
                    color: root.backgroundColorHovered
                }
            }
        ]
    }
}
