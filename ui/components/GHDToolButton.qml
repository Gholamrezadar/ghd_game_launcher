import QtQuick 2.15
import QtQuick.Controls.Universal
ToolButton {
    id: root

    // Exposed properties
    property alias iconSource: root.icon.source
    property alias iconName: root.icon.name
    property alias iconColor: root.icon.color
    property alias iconWidth: root.icon.width
    property alias iconHeight: root.icon.height
    property alias toolTipText: tooltip.text

    property color iconColorPressed: "#272727"
    property color iconColorHovered: "#333"

    // Default values
    background: null
    display: AbstractButton.IconOnly
    icon.color: "#888"
    icon.height: 18
    icon.width: 18

    HoverHandler {
        id: hoverHandler
        cursorShape: "PointingHandCursor"
    }

    TapHandler {
        id: tapHandler
    }

    // Background Circle (that shows up on hover)
    Rectangle {
        id: backgroundRect
        color: "transparent"
        anchors.fill: parent
        anchors.margins: 0
        radius: 1000

        states: [
            State {
                name: "pressed"
                when: tapHandler.pressed
                PropertyChanges {
                    target: backgroundRect
                    color: iconColorPressed
                }
            },
            State {
                name: "hovered"
                when: hoverHandler.hovered && !tapHandler.pressed
                PropertyChanges {
                    target: backgroundRect
                    color: iconColorHovered
                }
            }
        ]
    }

    ToolTip{
        id: tooltip
        visible: toolTipText != "" ? hoverHandler.hovered : false
        y: -implicitHeight - 8
        delay: 500
        margins: 0
        leftPadding: 12
        rightPadding: 12
        bottomPadding: 2
        topPadding: 2
        font.pixelSize: 12
        background: Rectangle {
            color: Qt.rgba(.2, .2, .2, 1)
            radius: 9999
        }
    }
}
