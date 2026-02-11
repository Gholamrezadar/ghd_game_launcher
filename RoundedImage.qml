import QtQuick
import QtQuick.Effects

Item {
    id: root

    // Alias for Image properties
    property alias source: img.source
    property alias fillMode: img.fillMode
    property alias asynchronous: img.asynchronous
    property alias cache: img.cache
    property alias mirror: img.mirror
    property alias sourceSize: img.sourceSize
    property alias status: img.status
    property alias progress: img.progress
    property alias paintedWidth: img.paintedWidth
    property alias paintedHeight: img.paintedHeight

    property real radius: 0

    implicitWidth: img.implicitWidth
    implicitHeight: img.implicitHeight

    // Source Image (Invisible)
    Image {
        id: img
        anchors.fill: parent
        visible: false
    }

    // RoundedImage
    MultiEffect {
        anchors.fill: img
        source: img
        maskEnabled: true
        maskSource: mask

        // To fix the aliasing (src: https://forum.qt.io/topic/145956/rounded-image-in-qt6/10?_=1770808919853)
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }

        Item {
            id: mask
            width: img.width
            height: img.height
            layer.enabled: true
            layer.samples: 16
            visible: false

            Rectangle {
                width: img.width
                height: img.height
                radius: root.radius
            }
        }
}
